// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import {IDotnuggV1Safe} from "./interfaces/IDotnuggV1Safe.sol";

import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";

import {DotnuggV1Storage as Storage} from "./core/DotnuggV1Storage.sol";

import {ShiftLib} from "./libraries/ShiftLib.sol";

contract DotnuggV1Safe is IDotnuggV1Safe, DotnuggV1Resolver {
    address public immutable factory;

    constructor() {
        factory = address(this);
    }

    function init(bytes[] calldata input) external {
        require(msg.sender == factory, "C:0");

        write(input);
    }

    function exec(
        uint8[8] memory ids, //
        bool base64
    ) external view returns (string memory) {
        return this.combo(this.read(ids), base64);
    }

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) external view returns (string memory) {
        return this.combo(this.read(feature, pos), base64);
    }

    function write(bytes[] calldata data) internal {
        require(data.length == 8, "nope");
        for (uint8 i = 0; i < 8; i++) {
            if (data[i].length > 0) write(data[i], i);
        }
    }

    function write(bytes calldata data, uint8 feature) internal {
        require(feature < 8, "F:3");

        uint8 saved = Storage.save(data, feature);

        emit Write(feature, saved, msg.sender);
    }

    function lengthOf(uint8 feature) public view override returns (uint8 a) {
        a = Storage.length(feature);
    }

    function randOf(uint8 feature, uint256 seed) public view override returns (uint8 a) {
        return Storage.search(feature, seed);
    }

    function locationOf(uint8 feature) public view override returns (address res) {
        return address(Storage.location(feature));
    }

    function read(uint8[8] memory ids) public view returns (uint256[][] memory _reads) {
        _reads = new uint256[][](8);
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) {
                _reads[i] = read(i, ids[i]);
            }
        }
    }

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint8 feature, uint8 num) public view returns (uint256[] memory _read) {
        require(num <= Storage.length(feature), "F:1");

        // num = num - 1;

        _read = Storage.read(feature, num);

        return _read;
    }
}
