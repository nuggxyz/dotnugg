// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1} from './../interfaces/IDotnuggV1.sol';
import {IDotnuggV1Implementer} from './../interfaces/IDotnuggV1Implementer.sol';
import {IDotnuggV1Metadata} from './../interfaces/IDotnuggV1Metadata.sol';
import {GeneratedDotnuggV1LocalUploader} from '../_generated/GeneratedDotnuggV1LocalUploader.sol';

contract MockDotnuggV1Implementer is IDotnuggV1Implementer, GeneratedDotnuggV1LocalUploader {
    IDotnuggV1 p;

    function dotnuggV1Callback(uint256 tokenId) external view override returns (IDotnuggV1Metadata.Memory memory data) {
        data.name = 'name';
        data.desc = 'desc';
        data.version = 1;
        data.tokenId = tokenId;
        data.owner = address(0);

        data.ids = new uint8[](8);

        data.labels = new string[](8);

        data.labels[0] = 'BASE';
        data.labels[1] = 'EYES';
        data.labels[2] = 'MOUTH';
        data.labels[3] = 'HAIR';
        data.labels[4] = 'HAT';
        data.labels[5] = 'BACK';
        data.labels[6] = 'NECK';
        data.labels[7] = 'HOLD';

        // data.ids[0] = 3;
        //
        // for (uint8 i = 1; i < 8; i++) {
        // uint8 items = p.totalStoredFiles(address(this), i);
        // if (items > tokenId) {
        // data.ids[i] = uint8(tokenId);
        // break;
        // } else {
        // tokenId -= items;
        // }
        // }

        data.ids = dotnuggV1CallbackHelper(tokenId, address(p), 3);
    }

    function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external override {
        p.store(feature, data);
    }

    constructor(IDotnuggV1 processor) GeneratedDotnuggV1LocalUploader(address(processor)) {
        p = processor;
    }
}
