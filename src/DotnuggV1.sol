// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1} from './interfaces/IDotnuggV1.sol';
import {IDotnuggV1Metadata as Metadata} from './interfaces/IDotnuggV1Metadata.sol';
import {IDotnuggV1Resolver as Resolver} from './interfaces/IDotnuggV1Resolver.sol';
import {IDotnuggV1Implementer as Implementer} from './interfaces/IDotnuggV1Implementer.sol';

import {DotnuggV1Storage} from './core/DotnuggV1Storage.sol';
import {DotnuggV1Lib} from './core/DotnuggV1Lib.sol';

/// @title dotnugg V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract DotnuggV1 is IDotnuggV1, DotnuggV1Storage {
    DotnuggV1Lib public lib;

    mapping(address => mapping(uint256 => address)) _resolver;

    constructor() {
        lib = new DotnuggV1Lib();
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                     core
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToMetadata(
        address implementer, //
        uint256 id
    ) public view override returns (Metadata.Memory memory res) {
        res = Implementer(implementer).dotnuggV1Callback(id);
    }

    function dotnuggToRaw(
        address implementer, //
        uint256 id
    ) public view override returns (uint256[][] memory resp, Metadata.Memory memory data) {
        data = dotnuggToMetadata(implementer, id);
        resp = getBatchFiles(implementer, data.ids);
    }

    function dotnuggToProcessed(
        address implementer, //
        uint256 id
    ) public view override returns (uint256[] memory, Metadata.Memory memory) {
        (uint256[][] memory resp, Metadata.Memory memory data) = dotnuggToRaw(implementer, id);
        return (lib.process(resp, data, 63), data);
    }

    function dotnuggToCompressed(
        address implementer, //
        uint256 id
    ) public view override returns (uint256[] memory, Metadata.Memory memory) {
        (uint256[] memory resp, Metadata.Memory memory data) = dotnuggToProcessed(implementer, id);
        return (lib.compress(resp, 0), data);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                complex proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToJson(
        address implementer,
        uint256 id,
        address resolver,
        bytes memory data
    ) external view override returns (address resolvedBy, string memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, id);

        if (resolver == address(0)) {
            resolver = _resolver[implementer][id];
        }

        if (data.length == 0) {
            data = metadata.data;
        }

        if (resolver != address(0)) {
            try Resolver(resolver).resolveJson(file, metadata, data) returns (string memory d) {
                return (resolver, d);
            } catch (bytes memory) {}
        }

        return (address(this), resolveJson(file, metadata, data));
    }

    function dotnuggToSvg(
        address implementer,
        uint256 id,
        address resolver,
        bytes memory data
    ) external view override returns (address resolvedBy, string memory res) {
        if (resolver == address(0)) {
            resolver = _resolver[implementer][id];
        }

        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, id);

        if (data.length == 0) {
            data = metadata.data;
        }

        if (resolver != address(0)) {
            try Resolver(resolver).resolveSvg(file, metadata, data) returns (string memory d) {
                return (resolver, d);
            } catch (bytes memory) {}
        }

        return (address(this), resolveSvg(file, metadata, data));
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                basic proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToBytes(
        address implementer,
        uint256 id,
        address resolver,
        bytes memory data
    ) external view override returns (address resolvedBy, bytes memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, id);

        if (resolver == address(0)) {
            resolver = _resolver[implementer][id];
        }

        if (data.length == 0) {
            data = metadata.data;
        }

        if (resolver != address(0)) {
            try Resolver(resolver).resolveBytes(file, metadata, data) returns (bytes memory d) {
                return (resolver, d);
            } catch (bytes memory) {}
        }

        return (address(this), resolveBytes(file, metadata, data));
    }

    function dotnuggToString(
        address implementer,
        uint256 id,
        address resolver,
        bytes memory data
    ) external view override returns (address resolvedBy, string memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, id);

        if (resolver == address(0)) {
            resolver = _resolver[implementer][id];
        }

        if (data.length == 0) {
            data = metadata.data;
        }

        if (resolver != address(0)) {
            try Resolver(resolver).resolveString(file, metadata, data) returns (string memory d) {
                return (resolver, d);
            } catch (bytes memory) {}
        }

        return (address(this), resolveString(file, metadata, data));
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              complex [default] resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function resolveSvg(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) public view override returns (string memory res) {
        return string(lib.buildSvg(file, metadata, data));
    }

    function resolveJson(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) public view override returns (string memory res) {
        // return string(lib.buildJson(file, metadata, data));
        // bytes memory tmp = abi.encodePacked(
        //     '{"name":"',
        //     data.name,
        //     '","description":"',
        //     data.desc,
        //     '", "image": "',
        //     resolveString(file, data),
        //     '","id":"',
        //     lib.uintToAscii(data.id),
        //     '"}'
        // );
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                             basic [default] resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function resolveBytes(
        uint256[] memory file, //
        Metadata.Memory memory metadata,
        bytes memory
    ) public pure override returns (bytes memory res) {
        res = abi.encode(file, metadata);
    }

    function resolveString(
        uint256[] memory file, //
        Metadata.Memory memory metadata,
        bytes memory
    ) public view override returns (string memory res) {
        return resolveSvg(file, metadata, '');
    }
}
