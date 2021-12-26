// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Data} from './IDotnuggV1Data.sol';
import {IDotnuggV1Resolver} from './IDotnuggV1Resolver.sol';

interface IDotnuggV1Processor is IDotnuggV1Resolver {
    function dotnuggToBytes(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) external view returns (bytes memory res);

    function dotnuggToRaw(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) external view returns (uint256[] memory res);

    function dotnuggToData(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) external view returns (IDotnuggV1Data.Data memory res);

    function dotnuggToString(
        address implementer,
        uint256 tokenId,
        address resolver,
        uint8 width,
        uint8 zoom
    ) external view returns (string memory res);

    function process(
        address implementer,
        uint256 tokenId,
        uint8 width
    ) external view returns (uint256[] memory file, IDotnuggV1Data.Data memory dat);

    function processCore(
        uint256[][] memory files,
        IDotnuggV1Data.Data memory data,
        uint8 width
    ) external view returns (uint256[] memory file);
}