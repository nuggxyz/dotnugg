// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import {IDotnuggV1Resolver} from "./interfaces/IDotnuggV1Resolver.sol";

import {DotnuggV1Svg as Svg} from "./core/DotnuggV1Svg.sol";
import {DotnuggV1MiddleOut as MiddleOut} from "./core/DotnuggV1MiddleOut.sol";

import {Base64} from "./libraries/Base64.sol";
import {StringCastLib} from "./libraries/StringCastLib.sol";

abstract contract DotnuggV1Resolver is IDotnuggV1Resolver, MiddleOut {
    function calc(uint256[][] calldata reads) public pure returns (uint256[] memory, uint256) {
        return execute(reads);
    }

    function combo(uint256[][] calldata reads, bool base64) public pure returns (string memory) {
        (uint256[] memory calced, uint256 sizes) = calc(reads);
        return svg(calced, sizes, base64);
    }

    function svg(
        uint256[] memory calculated,
        uint256 dat,
        bool base64
    ) internal pure returns (string memory res) {
        bytes memory image = (
            abi.encodePacked(
                '<svg viewBox="0 0 255 255" xmlns="http://www.w3.org/2000/svg">',
                Svg.fledgeOutTheRekts(calculated, dat),
                "</svg>"
            )
        );

        return string(base64 ? encodeSvgAsBase64(image) : encodeSvgAsUtf8(image));
    }

    function encodeSvgAsBase64(bytes memory input) internal pure returns (bytes memory res) {
        res = abi.encodePacked("data:image/svg+xml;base64,", Base64._encode(input));
    }

    function encodeSvgAsUtf8(bytes memory input) internal pure returns (bytes memory res) {
        res = abi.encodePacked("data:image/svg+xml;charset=UTF-8,", input);
    }

    function encodeJsonAsBase64(bytes memory input) internal pure returns (bytes memory res) {
        res = abi.encodePacked("data:application/json;base64,", Base64._encode(input));
    }

    function encodeJsonAsUtf8(bytes memory input) internal pure returns (bytes memory res) {
        res = abi.encodePacked("data:application/json;charset=UTF-8,", input);
    }
}
