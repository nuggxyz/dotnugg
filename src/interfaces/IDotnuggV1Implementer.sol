// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Data} from './IDotnuggV1Data.sol';

interface IDotnuggV1Implementer {
    event DotnuggV1ResolverUpdated(uint256 tokenId, address to);

    function setDotnuggV1Resolver(uint256 tokenId, address to) external;

    function dotnuggV1ResolverOf(uint256 tokenId) external view returns (address resolver);

    function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external;

    function dotnuggV1Callback(uint256 tokenId) external view returns (IDotnuggV1Data.Data memory data);

    function dotnuggV1Processor() external returns (address);

    function dotnuggV1DefaultWidth() external returns (uint8);

    function dotnuggV1DefaultZoom() external returns (uint8);
}
