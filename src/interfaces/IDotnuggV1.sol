// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata} from './IDotnuggV1Metadata.sol';

import {IDotnuggV1Resolver} from './IDotnuggV1Resolver.sol';
import {IDotnuggV1Storage} from './IDotnuggV1Storage.sol';

interface IDotnuggV1 is IDotnuggV1Resolver, IDotnuggV1Storage {
    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                core processors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    function dotnuggToMetadata(
        address implementer, //
        uint256 id
    ) external view returns (IDotnuggV1Metadata.Memory memory res);

    function dotnuggToRaw(
        address implementer, //
        uint256 id
    ) external view returns (uint256[][] memory res, IDotnuggV1Metadata.Memory memory data);

    function dotnuggToProcessed(
        address implementer, //
        uint256 id
    ) external view returns (uint256[] memory res, IDotnuggV1Metadata.Memory memory data);

    function dotnuggToCompressed(
        address implementer, //
        uint256 id
    ) external view returns (uint256[] memory res, IDotnuggV1Metadata.Memory memory data);

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                            basic resolved processors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    function dotnuggToBytes(
        address implementer,
        uint256 id,
        address resolver,
        bytes calldata data
    ) external view returns (address resolvedBy, bytes memory res);

    function dotnuggToString(
        address implementer,
        uint256 id,
        address resolver,
        bytes calldata data
    ) external view returns (address resolvedBy, string memory res);

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                            complex resolved processors
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    function dotnuggToJson(
        address implementer,
        uint256 id,
        address resolver,
        bytes calldata data
    ) external view returns (address resolvedBy, string memory res);

    function dotnuggToSvg(
        address implementer,
        uint256 id,
        address resolver,
        bytes calldata data
    ) external view returns (address resolvedBy, string memory res);
}
