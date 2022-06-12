// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.14;

import {IDotnuggV1} from "./IDotnuggV1.sol";

import {DotnuggV1Storage} from "./core/DotnuggV1Storage.sol";
import {DotnuggV1MiddleOut} from "./core/DotnuggV1MiddleOut.sol";
import {DotnuggV1Svg} from "./core/DotnuggV1Svg.sol";

import {DotnuggV1Lib, IDotnuggV1} from "./DotnuggV1Lib.sol";

import {Base64} from "./libraries/Base64.sol";

import {data as nuggs} from "./_data/nuggs.data.sol";

contract DotnuggV1 is IDotnuggV1 {
    address public immutable factory;

    constructor() {
        factory = address(this);

        write(abi.decode(nuggs, (bytes[])));
    }

    function register(bytes[] calldata input) external override returns (IDotnuggV1 proxy) {
        require(address(this) == factory, "O");

        proxy = clone();

        proxy.protectedInit(input);
    }

    function protectedInit(bytes[] memory input) external override {
        require(msg.sender == factory, "C:0");

        write(input);
    }

    function clone() internal returns (DotnuggV1 instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(96, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73))
            mstore(add(ptr, 0x14), shl(0x60, address()))
            mstore(add(ptr, 0x28), shl(136, 0x5af43d82803e903d91602b57fd5bf3))
            instance := create(0, ptr, 0x37)
        }
        require(address(instance) != address(0), "E");
    }

    function exec(uint8[8] memory ids, bool base64) public view returns (string memory) {
        return combo(read(ids), base64);
    }

    // prettier-ignore
    function exec(uint8 feature, uint8 pos, bool base64) external view returns (string memory) {
        uint256[][] memory arr = new uint256[][](1);
        arr[0] = read(feature, pos);
        return combo(arr, base64);
    }

    function write(bytes[] memory data) internal {
        require(data.length == 8, "nope");
        for (uint8 feature = 0; feature < 8; feature++) {
            if (data[feature].length > 0) {
                uint8 saved = DotnuggV1Storage.save(data[feature], feature);

                emit Write(feature, saved, msg.sender);
            }
        }
    }

    function read(uint8[8] memory ids) public view returns (uint256[][] memory _reads) {
        _reads = new uint256[][](8);
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) {
                _reads[i] = DotnuggV1Lib.read(this, i, ids[i]);
            }
        }
    }

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint8 feature, uint8 num) public view returns (uint256[] memory _read) {
        _read = DotnuggV1Lib.read(this, feature, num);

        return _read;
    }

    function calc(uint256[][] memory reads) public pure returns (uint256[] memory, uint256) {
        return DotnuggV1MiddleOut.execute(reads);
    }

    function combo(uint256[][] memory reads, bool base64) public pure returns (string memory) {
        (uint256[] memory calced, uint256 sizes) = calc(reads);
        return svg(calced, sizes, base64);
    }

    // prettier-ignore
    function svg(uint256[] memory calculated, uint256 dat, bool base64) public pure returns (string memory res) {
        bytes memory image = (
            abi.encodePacked(
                '<svg viewBox="0 0 255 255" xmlns="http://www.w3.org/2000/svg">',
                DotnuggV1Svg.fledgeOutTheRekts(calculated, dat),
                "</svg>"
            )
        );

        return string(encodeSvg(image, base64));
    }

    function encodeSvg(bytes memory input, bool base64) internal pure returns (bytes memory res) {
        res = abi.encodePacked(
            base64 ? "data:image/svg+xml;base64," : "data:image/svg+xml;charset=UTF-8,",
            base64 ? Base64._encode(input) : input
        );
    }

    function encodeJson(bytes memory input, bool base64) public pure returns (bytes memory res) {
        res = abi.encodePacked(
            base64 ? "data:application/json;base64," : "data:application/json;charset=UTF-8,",
            base64 ? Base64._encode(input) : input
        );
    }
}
