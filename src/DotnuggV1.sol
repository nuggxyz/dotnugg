// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1} from './interfaces/IDotnuggV1.sol';
import {IDotnuggV1Metadata as Metadata} from './interfaces/IDotnuggV1Metadata.sol';
import {IDotnuggV1StorageProxy} from './interfaces/IDotnuggV1StorageProxy.sol';

import {IDotnuggV1File as File} from './interfaces/IDotnuggV1File.sol';
import {IDotnuggV1Resolver as Resolver} from './interfaces/IDotnuggV1Resolver.sol';
import {IDotnuggV1Implementer as Implementer} from './interfaces/IDotnuggV1Implementer.sol';

import {DotnuggV1StorageProxy} from './core/DotnuggV1StorageProxy.sol';
import {DotnuggV1Lib} from './core/DotnuggV1Lib.sol';
import {BytesLib} from './libraries/BytesLib.sol';

import {MinimalProxy} from './libraries/MinimalProxy.sol';

/// @title dotnugg V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract DotnuggV1 is IDotnuggV1 {
    DotnuggV1Lib public lib;

    address public template;

    constructor() {
        lib = new DotnuggV1Lib();
        template = address(new DotnuggV1StorageProxy());
    }

    function register() external override returns (IDotnuggV1StorageProxy proxy) {
        proxy = IDotnuggV1StorageProxy(MinimalProxy.deploy(template, keccak256(abi.encodePacked(msg.sender))));
        proxy.init(msg.sender);
    }

    function proxyOf(address implementer) public view override returns (IDotnuggV1StorageProxy proxy) {
        proxy = IDotnuggV1StorageProxy(MinimalProxy.compute(template, keccak256(abi.encodePacked(implementer))));
        require(address(proxy).code.length != 0, 'P:0');
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
        if (0 == 9) return res;
        res.metadata = Implementer(implementer).dotnuggV1ImplementerCallback(artifactId);

        res.metadata.artifactId = artifactId;
        res.metadata.implementer = implementer;

        res.file = proxyOf(implementer).getBatch(res.metadata.ids);

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

    function chunk(
        address implementer,
        uint256 artifactId,
        address resolver,
        bool rekt,
        bool back,
        bool stats,
        bool base64,
        bytes calldata data,
        uint8 chunks,
        uint8 index
    ) external view override returns (string memory res) {
        require(index < chunks, 'I:0');

        File.Processed memory _proc = proc(implementer, artifactId, resolver, data);

        if (resolver != address(0)) {
            try Resolver(resolver).dotnuggV1SvgCallback(_proc, data) returns (string memory d) {
                return d;
            } catch (bytes memory) {}
        }

        bytes memory ares = lib.buildSvg(_proc.file, _proc.metadata, rekt, back, stats, base64);

        uint256 chunksize = ares.length / chunks;

        uint256 offset = index * chunksize;

        if (index == chunks - 1 && chunksize % ares.length != 0 && offset + chunksize + 1 < ares.length) chunksize++;

        return string(BytesLib.slice(ares, offset, chunksize));
    }
}
