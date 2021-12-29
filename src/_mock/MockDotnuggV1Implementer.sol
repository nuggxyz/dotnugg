// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Processor} from './../interfaces/IDotnuggV1Processor.sol';
import {IDotnuggV1Implementer} from './../interfaces/IDotnuggV1Implementer.sol';
import {IDotnuggV1Data} from './../interfaces/IDotnuggV1Data.sol';
import {GeneratedDotnuggV1LocalUploader} from '../_generated/GeneratedDotnuggV1LocalUploader.sol';

contract MockDotnuggV1Implementer is IDotnuggV1Implementer, GeneratedDotnuggV1LocalUploader {
    IDotnuggV1Processor p;

    function dotnuggV1Callback(uint256 tokenId) external view override returns (IDotnuggV1Data.Data memory data) {
        data.name = 'name';
        data.desc = 'desc';
        data.version = 1;
        data.tokenId = tokenId;
        data.proof = 0;
        data.owner = address(0);

        data.ids = dotnuggV1CallbackHelper(tokenId, address(p));
    }

    function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external override {
        p.storeFiles(feature, data);
    }

    constructor(IDotnuggV1Processor processor) GeneratedDotnuggV1LocalUploader(address(processor)) {
        p = processor;
    }
}
