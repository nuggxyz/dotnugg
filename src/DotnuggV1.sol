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

    function raw(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (File.Raw memory res) {
        res.metadata = Implementer(implementer).dotnuggV1ImplementerCallback(artifactId);

        res.metadata.artifactId = artifactId;
        res.metadata.implementer = implementer;

        res.file = getBatchFiles(implementer, res.metadata.ids);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1MetadataCallback(implementer, artifactId, res.metadata, data) returns (Metadata.Memory memory resp) {
                res.metadata = resp;
            } catch (bytes memory) {}
        }
    }

    function proc(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (File.Processed memory res) {
        File.Raw memory _raw = raw(implementer, artifactId, resolver, data);

        res.file = lib.process(_raw.file, _raw.metadata, 63);

        res.metadata = _raw.metadata;
    }

    function comp(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) public view override returns (File.Compressed memory res) {
        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        res.file = lib.compress(_proc.file, 0);

        res.metadata = _proc.metadata;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                complex proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dat(
        address implementer,
        uint256 artifactId,
        address resolver,
        string memory name,
        string memory desc,
        bool base64,
        bytes memory data
    ) external view override returns (string memory res) {
        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1JsonCallback(_proc, data) returns (string memory r) {
                return r;
            } catch (bytes memory) {}
        }

        res = string(
            lib.buildJson(
                _proc.metadata,
                name,
                desc, //
                string(lib.buildSvg(_proc.file, _proc.metadata, false, true, false, true)),
                base64
            )
        );
    }

    function img(
        address implementer,
        uint256 artifactId,
        address resolver,
        bool rekt,
        bool back,
        bool stats,
        bool base64,
        bytes memory data
    ) external view override returns (string memory res) {
        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1SvgCallback(_proc, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = string(lib.buildSvg(_proc.file, _proc.metadata, rekt, back, stats, base64));
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                basic proccessors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function byt(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (bytes memory res) {
        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1BytesCallback(_proc, data) returns (bytes memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = lib.buildSvg(_proc.file, _proc.metadata, false, false, false, true);
    }

    function str(
        address implementer,
        uint256 artifactId,
        address resolver,
        bytes memory data
    ) external view override returns (string memory res) {
        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1StringCallback(_proc, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        res = string(lib.buildSvg(_proc.file, _proc.metadata, false, false, false, false));
    }
}
