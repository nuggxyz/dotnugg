// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Processor} from './interfaces/IDotnuggV1Processor.sol';
import {IDotnuggV1Data} from './interfaces/IDotnuggV1Data.sol';
import {IDotnuggV1Implementer} from './interfaces/IDotnuggV1Implementer.sol';

import {Calculator} from './logic/Calculator.sol';
import {Matrix} from './logic/Matrix.sol';
import {Svg} from './logic/Svg.sol';

import {ShiftLib} from './libraries/ShiftLib.sol';
import {Base64} from './libraries/Base64.sol';

import {Version} from './types/Version.sol';
import {Types} from './types/Types.sol';
import {DotnuggV1Storage} from './logic/DotnuggV1Storage.sol';
import {StringCastLib} from './libraries/StringCastLib.sol';

/// @title dotnugg Processor V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract DotnuggV1Processor is IDotnuggV1Processor, DotnuggV1Storage {
    using StringCastLib for uint256;

    function process(
        address implementer,
        uint256 tokenId,
        uint8 width
    ) public view override returns (uint256[] memory resp, IDotnuggV1Data.Data memory dat) {
        (, IDotnuggV1Data.Data memory data) = IDotnuggV1Implementer(implementer).prepareFiles(tokenId);

        uint256[][] memory files = getBatchFiles(implementer, data.ids);

        dat = data;

        resp = processCore(files, data, width);
    }

    function processCore(
        uint256[][] memory files,
        IDotnuggV1Data.Data memory data,
        uint8 width
    ) public view override returns (uint256[] memory resp) {
        require(data.version == 1, 'V1');

        require(width <= 64 && width > 4, 'V1:SIZE');

        if (width % 2 == 0) width--;

        Version.Memory[][] memory versions = Version.parse(files, data.xovers, data.yovers);

        Types.Matrix memory old = Calculator.combine(8, width, versions);

        resp = Version.bigMatrixWithData(old.version);
    }

    function resolveRaw(
        uint256[] memory file,
        IDotnuggV1Data.Data memory,
        uint8
    ) public pure override returns (uint256[] memory res) {
        res = file;
    }

    function resolveBytes(
        uint256[] memory file,
        IDotnuggV1Data.Data memory data,
        uint8
    ) public pure override returns (bytes memory res) {
        res = abi.encode(file, data);
    }

    function resolveData(
        uint256[] memory,
        IDotnuggV1Data.Data memory data,
        uint8
    ) public pure override returns (IDotnuggV1Data.Data memory res) {
        res = data;
    }

    function resolveString(
        uint256[] memory file,
        IDotnuggV1Data.Data memory data,
        uint8 zoom
    ) public view override returns (string memory) {
        uint256 width = (file[file.length - 1] >> 63) & ShiftLib.mask(6);
        uint256 height = (file[file.length - 1] >> 69) & ShiftLib.mask(6);

        bytes memory working = Svg.buildSvg(file, width, height, zoom);

        working = Base64._encode(working);

        working = abi.encodePacked(
            Base64.PREFIX_JSON,
            Base64._encode(
                bytes(
                    abi.encodePacked(
                        '{"name":"',
                        data.name,
                        '","description":"',
                        data.desc,
                        '","DotnuggVersion":"',
                        StringCastLib.toAsciiString(data.version),
                        '","tokenId":"',
                        StringCastLib.toAsciiString(data.tokenId),
                        '","proof":"',
                        StringCastLib.toHexString(data.proof, 32),
                        '","owner":"',
                        StringCastLib.toHexString(uint160(data.owner), 20),
                        '", "image": "',
                        Base64.PREFIX_SVG,
                        working,
                        '"}'
                    )
                )
            )
        );

        return string(working);
    }

    function dotnuggToRaw(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (uint256[] memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        if (resolver != address(0)) {
            res = IDotnuggV1Processor(resolver).resolveRaw(res, data, zoom);
        } else {
            res = file;
        }
    }

    function dotnuggToBytes(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (bytes memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IDotnuggV1Processor(resolver).resolveBytes(file, data, zoom);
    }

    function dotnuggToString(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (string memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IDotnuggV1Processor(resolver).resolveString(file, data, zoom);
    }

    function dotnuggToData(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (IDotnuggV1Data.Data memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IDotnuggV1Processor(resolver).resolveData(file, data, zoom);
    }
}
