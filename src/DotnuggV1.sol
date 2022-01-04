// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1} from './interfaces/IDotnuggV1.sol';
import {IDotnuggV1Metadata as Metadata} from './interfaces/IDotnuggV1Metadata.sol';
import {IDotnuggV1File as File} from './interfaces/IDotnuggV1File.sol';
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
    ) public view override returns (File.Raw memory res) {
        res.metadata = Metadata.Memory({
            implementer: implementer,
            artifactId: artifactId,
            ids: new uint8[](8),
            xovers: new uint8[](8),
            yovers: new uint8[](8),
            version: 1,
            labels: new string[](8),
            jsonKeys: new string[](8),
            jsonValues: new string[](8),
            styles: new string[](8),
            globalStyle: '',
            data: ''
        });

        res.metadata = Implementer(implementer).dotnuggV1ImplementerCallback(res.metadata);

        res.file = getBatchFiles(implementer, res.metadata.ids);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1MetadataCallback(implementer, artifactId, res.metadata, data) returns (Metadata.Memory memory resp) {
                res.metadata = resp;
            } catch (bytes memory) {}
        }
    }

    function dotnuggToProcessed(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (File.Processed memory res) {
        File.Raw memory raw = dotnuggToRaw(implementer, artifactId, resolver, data);

        res.file = lib.process(raw.file, raw.metadata, 63);

        res.metadata = raw.metadata;
    }

    function dotnuggToCompressed(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (File.Compressed memory res) {
        File.Processed memory resp = dotnuggToProcessed(implementer, artifactId, resolver, data);

        res.file = lib.compress(resp.file, 0);

        res.metadata = resp.metadata;
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
        File.Processed memory proc = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1JsonCallback(proc, data) returns (string memory r) {
                return r;
            } catch (bytes memory) {}
        }

        res = string(lib.buildJson(proc.file, proc.metadata));
    }

    function dotnuggToSvg(
        address implementer,
        uint256 artifactId,
        address resolver,
        uint8 zoom,
        bool rekt,
        bool stats,
        bool base64,
        bytes memory data
    ) external view override returns (string memory res) {
        File.Processed memory proc = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1SvgCallback(proc, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = string(lib.buildSvg(proc.file, proc.metadata, zoom, rekt, stats, base64));
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
        File.Processed memory proc = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1BytesCallback(proc, data) returns (bytes memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = lib.buildSvg(proc.file, proc.metadata, 10, false, false, true);
    }

    function dotnuggToString(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (string memory res) {
        File.Processed memory proc = dotnuggToProcessed(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1StringCallback(proc, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = string(lib.buildSvg(proc.file, proc.metadata, 10, true, false, false));
    }
}
