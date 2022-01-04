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

    function dotnuggToRaw(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (uint256[][] memory raw, Metadata.Memory memory metadata) {
        metadata = Implementer(implementer).dotnuggV1ImplementerCallback(artifactId);

        raw = getBatchFiles(implementer, data.ids);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1MetadataCallback(implementer, artifactId, metadata, data) returns (Metadata.Memory memory resp) {
                metadata = resp;
            } catch (bytes memory) {}
        }
    }

    function dotnuggToProcessed(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (uint256[] memory processed, Metadata.Memory memory metadata) {
        uint256[][] memory raw;

        (raw, metadata) = dotnuggToRaw(implementer, artifactId, resolver, data);

        processed = lib.process(raw, metadata, 63);
    }

    function dotnuggToCompressed(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (uint256[] memory compressed, Metadata.Memory memory metadata) {
        (compressed, metadata) = dotnuggToProcessed(implementer, id);

        compressed = lib.compress(resp, 0);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                complex proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToJson(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (string memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0) && resolver != address(this)) {
            try Resolver(resolver).dotnuggV1JsonCallback(file, metadata, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = lib.buildJson(file, metadata, data);
    }

    function dotnuggToSvg(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (string memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0) && resolver != address(this)) {
            try Resolver(resolver).dotnuggV1SvgCallback(file, metadata, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = lib.buildSvg(file, metadata, data);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                basic proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggToBytes(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (bytes memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0) && resolver != address(this)) {
            try Resolver(resolver).dotnuggV1BytesCallback(file, metadata, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = abi.encode(file, metadata);
    }

    function dotnuggToString(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (string memory res) {
        (uint256[] memory file, Metadata.Memory memory metadata) = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0) && resolver != address(this)) {
            try Resolver(resolver).dotnuggV1StringCallback(file, metadata, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = string(abi.encod);
    }
}
