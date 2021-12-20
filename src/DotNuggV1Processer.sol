// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import './interfaces/IdotnuggV1.sol';

import './logic/Calculator.sol';
import './logic/Matrix.sol';
import './logic/Svg.sol';

import './libraries/Base64.sol';

import './types/Version.sol';

/// @title dotnugg Processor V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract dotnuggV1Processer is IdotnuggV1Processer {
    function process(
        address implementer,
        uint256 tokenId,
        uint8 width
    ) public view override returns (uint256[] memory resp, IdotnuggV1Data.Data memory dat) {
        (uint256[][] memory files, IdotnuggV1Data.Data memory data) = IdotnuggV1Implementer(implementer).prepareFiles(tokenId);

        require(data.version == 1, 'V1');

        require(width < 64 && width % 2 == 0, 'V1:SIZE');

        Version.Memory[][] memory versions = Version.parse(files, data.xovers, data.yovers);

        Types.Matrix memory old = Calculator.combine(8, width, versions);

        resp = Version.bigMatrixWithData(old.version);
        dat = data;
    }

    function resolveRaw(
        uint256[] memory file,
        IdotnuggV1Data.Data memory,
        uint8
    ) public pure override returns (uint256[] memory res) {
        res = file;
    }

    function resolveBytes(
        uint256[] memory file,
        IdotnuggV1Data.Data memory data,
        uint8
    ) public pure override returns (bytes memory res) {
        res = abi.encode(file, data);
    }

    function resolveData(
        uint256[] memory,
        IdotnuggV1Data.Data memory data,
        uint8
    ) public pure override returns (IdotnuggV1Data.Data memory res) {
        res = data;
    }

    function resolveString(
        uint256[] memory file,
        IdotnuggV1Data.Data memory data,
        uint8 zoom
    ) public pure override returns (string memory) {
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
                        '","dotnuggVersion":"',
                        Uint256.toString(data.version),
                        '","tokenId":"',
                        Uint256.toString(data.tokenId),
                        '","proof":"',
                        Uint256.toHexString(data.proof, 32),
                        '","owner":"',
                        Uint256.toHexString(uint160(data.owner), 20),
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
        (uint256[] memory file, IdotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        if (resolver != address(0)) {
            res = IdotnuggV1Processer(resolver).resolveRaw(res, data, zoom);
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
        (uint256[] memory file, IdotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IdotnuggV1Processer(resolver).resolveBytes(file, data, zoom);
    }

    function dotnuggToString(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (string memory res) {
        (uint256[] memory file, IdotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IdotnuggV1Processer(resolver).resolveString(file, data, zoom);
    }

    function dotnuggToData(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (IdotnuggV1Data.Data memory res) {
        (uint256[] memory file, IdotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        res = IdotnuggV1Processer(resolver).resolveData(file, data, zoom);
    }
}
