// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {IDotnuggV1Safe} from "./interfaces/IDotnuggV1Safe.sol";

import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";
import {DotnuggV1Lib} from "./libraries/DotnuggV1Lib.sol";
import {DotnuggV1Storage as Storage} from "./core/DotnuggV1Storage.sol";

contract DotnuggV1Safe is IDotnuggV1Safe, DotnuggV1Resolver {
    address public immutable factory;

    constructor() {
        factory = address(this);
    }

    function init(bytes[] memory input) public {
        require(msg.sender == factory, "C:0");

        write(input);
    }

    // function exec(uint256 proof, bool base64) external view returns (string memory) {
    //     return combo(read(decodeProofCore(proof)), base64);
    // }

    function exec(uint8[8] memory ids, bool base64) external view returns (string memory) {
        return combo(read(ids), base64);
    }

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) external view returns (string memory) {
        uint256[][] memory arr = new uint256[][](1);
        arr[0] = read(feature, pos);
        return combo(arr, base64);
    }

    function write(bytes[] memory data) public {
        require(data.length == 8, "nope");
        for (uint8 feature = 0; feature < 8; feature++) {
            if (data[feature].length > 0) {
                uint8 saved = Storage.save(data[feature], feature);

                emit Write(feature, saved, msg.sender);
            }
        }
    }

    function lengthOf(uint8 feature) public view override returns (uint8 a) {
        a = DotnuggV1Lib.size(DotnuggV1Lib.location(address(this), feature));
    }

    function randOf(uint8 feature, uint256 seed) public view override returns (uint8 a) {
        return DotnuggV1Lib.search(address(this), feature, seed);
    }

    function locationOf(uint8 feature) public view override returns (address res) {
        return address(DotnuggV1Lib.location(address(this), feature));
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
        _read = DotnuggV1Lib.read(address(this), feature, num);

        return _read;
    }
}
