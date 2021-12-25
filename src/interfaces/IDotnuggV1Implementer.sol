// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Data} from './IDotnuggV1Data.sol';

interface IDotnuggV1Implementer {
    function setResolver(uint256 tokenId, address to) external;

    function resolverOf(uint256 tokenId) external view returns (address resolver);

    function prepareFiles(uint256 tokenId) external view returns (uint256[][] memory file, IDotnuggV1Data.Data memory data);
}
