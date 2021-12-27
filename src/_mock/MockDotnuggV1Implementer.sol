// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Processor} from './../interfaces/IDotnuggV1Processor.sol';
import {IDotnuggV1Implementer} from './../interfaces/IDotnuggV1Implementer.sol';
import {IDotnuggV1Data} from './../interfaces/IDotnuggV1Data.sol';

contract MockDotnuggV1Implementer is IDotnuggV1Implementer {
    IDotnuggV1Processor p;

    constructor(IDotnuggV1Processor processor) {
        p = processor;
    }

    function dotnuggV1Callback(uint256 tokenId) external view override returns (IDotnuggV1Data.Data memory data) {}

    function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external override {
        p.storeFiles(feature, data);
    }
}
