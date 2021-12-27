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

    function dotnuggV1Callback(uint256 tokenId) external pure override returns (IDotnuggV1Data.Data memory data) {
        data.name = 'name';
        data.desc = 'desc';
        data.version = 1;
        data.tokenId = 0;
        data.proof = 0;
        data.owner = address(0);

        data.ids = new uint8[](8);

        data.ids[0] = 1;
        data.ids[1] = 1;
        data.ids[2] = 1;
        data.ids[3] = 1;
    }

    function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external override {
        p.storeFiles(feature, data);
    }
}
