// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";
import {DotnuggV1Calculated, DotnuggV1Read} from "./interfaces/DotnuggV1Files.sol";

import {ShiftLib} from "./libraries/ShiftLib.sol";
import {DotnuggV1FileStorage} from "./core/DotnuggV1FileStorage.sol";

import "./_test/utils/forge.sol";

contract DotnuggV1Storage is IDotnuggV1Storage, DotnuggV1Resolver {
    address public immutable factory;

    address public trusted;

    constructor() {
        factory = address(this);
        trusted = address(this);
    }

    function init(address _trusted) external {
        require(trusted == address(0) && msg.sender == factory, "C:0");

        trusted = _trusted;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                WRITE TO STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function write(bytes[] calldata data) external {
        require(data.length == 8, "nope");
        for (uint8 i = 0; i < 8; i++) {
            if (data[i].length > 0) write(i, data[i]);
        }
    }

    function write(uint8 feature, bytes calldata data) public override {
        require(trusted == msg.sender, "C:0");

        require(feature < 8, "F:3");

        uint8 saved = DotnuggV1FileStorage.save(data, feature);

        emit Write(feature, saved, msg.sender);
    }

    function updateTrusted(address _trusted) external {
        require(trusted == msg.sender, "C:0");

        trusted = _trusted;
    }

    function lengthOf(uint8 feature) public view override returns (uint8 a) {
        a = DotnuggV1FileStorage.length(feature);
    }

    function locationOf(uint8 feature) public view override returns (address res) {
        return address(DotnuggV1FileStorage.location(feature));
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                  write
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function exec(
        uint8[8] memory ids, //
        bool base64
    ) public view returns (string memory) {
        return svg(calc(read(ids)), base64);
    }

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) public view returns (string memory) {
        return svg(calc(read(feature, pos)), base64);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                READ FROM STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function read(uint8[8] memory ids) public view returns (DotnuggV1Read[8] memory res) {
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) {
                res[i] = read(i, ids[i]);
            }
        }
    }

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint8 feature, uint8 num) public view returns (DotnuggV1Read memory res) {
        require(num != 0 && num <= DotnuggV1FileStorage.length(feature), "F:1");

        num = num - 1;

        res.dat = DotnuggV1FileStorage.fetch(feature, num);

        return res;
    }
}
