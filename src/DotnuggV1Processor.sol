// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Processor} from './interfaces/IDotnuggV1Processor.sol';
import {IDotnuggV1Data} from './interfaces/IDotnuggV1Data.sol';
import {IDotnuggV1Resolver} from './interfaces/IDotnuggV1Resolver.sol';
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

contract DotnuggV1Helper {
    function processCore(
        uint256[][] memory files,
        IDotnuggV1Data.Data memory data,
        uint8 width
    ) public pure returns (uint256[] memory resp) {
        require(data.version == 1, 'V1');

        require(width <= 64 && width > 4, 'V1:SIZE');

        if (width % 2 == 0) width--;

        Version.Memory[][] memory versions = Version.parse(files, data.xovers, data.yovers);

        Types.Matrix memory old = Calculator.combine(8, width, versions);

        resp = Version.compressBigMatrix(old.version.bigmatrix, old.version.data);
    }
}

/// @title dotnugg Processor V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract DotnuggV1Processor is IDotnuggV1Processor, DotnuggV1Storage {
    using StringCastLib for uint256;

    address immutable helper;

    constructor() {
        helper = address(new DotnuggV1Helper());
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                     core
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function process(
        address implementer,
        uint256 tokenId,
        uint8 width
    ) public view override returns (uint256[] memory resp, IDotnuggV1Data.Data memory dat) {
        IDotnuggV1Data.Data memory data = IDotnuggV1Implementer(implementer).dotnuggV1Callback(tokenId);

        uint256[][] memory files = getBatchFiles(implementer, data.ids);

        dat = data;

        resp = processCore(files, data, width);
    }

    function processCore(
        uint256[][] memory files,
        IDotnuggV1Data.Data memory data,
        uint8 width
    ) public view override returns (uint256[] memory resp) {
        return DotnuggV1Helper(helper).processCore(files, data, width);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

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
        IDotnuggV1Data.Data memory,
        uint8 zoom
    ) external pure override returns (string memory) {
        file = Version.decompressBigMatrix(file);

        uint256 width = (file[file.length - 1] >> 63) & ShiftLib.mask(6);
        uint256 height = (file[file.length - 1] >> 69) & ShiftLib.mask(6);

        bytes memory working = Svg.buildSvg(file, width, height, zoom);

        working = Base64._encode(working);

        return string(working);
    }

    function resolveUri(
        uint256[] memory file,
        IDotnuggV1Data.Data memory data,
        uint8 zoom
    ) external pure override returns (string memory res) {
        file = Version.decompressBigMatrix(file);

        uint256 width = (file[file.length - 1] >> 63) & ShiftLib.mask(6);
        uint256 height = (file[file.length - 1] >> 69) & ShiftLib.mask(6);

        bytes memory working = Svg.buildSvg(file, width, height, zoom);

        working = Base64._encode(working);

        res = string(
            abi.encodePacked(
                Base64.PREFIX_JSON,
                Base64._encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            data.name,
                            '","description":"',
                            data.desc,
                            '", "image": "',
                            res,
                            '","DotnuggVersion":"',
                            StringCastLib.toAsciiString(data.version),
                            '","tokenId":"',
                            StringCastLib.toAsciiString(data.tokenId),
                            '","proof":"',
                            StringCastLib.toHexString(data.proof, 32),
                            '","owner":"',
                            StringCastLib.toHexString(uint160(data.owner), 20),
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                full processors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToUri(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) external view override returns (address resolvedBy, string memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        try IDotnuggV1Resolver(resolver).resolveUri(file, data, zoom) returns (string memory d) {
            res = d;
            resolvedBy = resolver;
        } catch (bytes memory) {
            res = this.resolveUri(file, data, zoom);
            resolvedBy = address(this);
        }
    }

    function dotnuggToRaw(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (address resolvedBy, uint256[] memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        try IDotnuggV1Resolver(resolver).resolveRaw(file, data, zoom) returns (uint256[] memory d) {
            res = d;
            resolvedBy = resolver;
        } catch (bytes memory) {
            res = this.resolveRaw(file, data, zoom);
            resolvedBy = address(this);
        }
    }

    function dotnuggToBytes(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (address resolvedBy, bytes memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        try IDotnuggV1Resolver(resolver).resolveBytes(file, data, zoom) returns (bytes memory d) {
            res = d;
            resolvedBy = resolver;
        } catch (bytes memory) {
            res = this.resolveBytes(file, data, zoom);
            resolvedBy = address(this);
        }
    }

    function dotnuggToString(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (address resolvedBy, string memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        try IDotnuggV1Resolver(resolver).resolveString(file, data, zoom) returns (string memory d) {
            res = d;
            resolvedBy = resolver;
        } catch (bytes memory) {
            res = this.resolveString(file, data, zoom);
            resolvedBy = address(this);
        }
    }

    function dotnuggToData(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) public view override returns (address resolvedBy, IDotnuggV1Data.Data memory res) {
        (uint256[] memory file, IDotnuggV1Data.Data memory data) = process(implementer, tokenId, width);

        try IDotnuggV1Resolver(resolver).resolveData(file, data, zoom) returns (IDotnuggV1Data.Data memory d) {
            res = d;
            resolvedBy = resolver;
        } catch (bytes memory) {
            res = this.resolveData(file, data, zoom);
            resolvedBy = address(this);
        }
    }
}
