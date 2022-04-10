// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import {IDotnuggV1Resolver} from "./interfaces/IDotnuggV1Resolver.sol";

import {DotnuggV1Svg as Svg} from "./core/DotnuggV1Svg.sol";
import {DotnuggV1MiddleOut as MiddleOut} from "./core/DotnuggV1MiddleOut.sol";

import {Base64} from "./libraries/Base64.sol";
import {StringCastLib} from "./libraries/StringCastLib.sol";

abstract contract DotnuggV1Resolver is IDotnuggV1Resolver, MiddleOut {
    function calc(uint256[][] memory reads) public pure returns (uint256[] memory) {
        return execute(reads);
    }

    function combo(uint256[][] memory reads, bool base64) public pure returns (string memory) {
        return svg(calc(reads), base64);
    }

    function svg(uint256[] memory calculated, bool base64) public pure override returns (string memory res) {
        bytes memory image = (
            abi.encodePacked(
                '<svg viewBox="0 0 63 63" xmlns="http://www.w3.org/2000/svg">',
                // '<style type="text/css"><![CDATA[.A.B.C.D.E.F.G.H]]></style>',
                Svg.fledgeOutTheRekts(calculated),
                "</svg>"
            )
        );

        return string(base64 ? encodeSvgAsBase64(image) : encodeSvgAsUtf8(image));
    }

    function encodeSvgAsBase64(bytes memory input) public pure override returns (bytes memory res) {
        res = abi.encodePacked("data:image/svg+xml;base64,", Base64._encode(input));
    }

    function encodeSvgAsUtf8(bytes memory input) public pure override returns (bytes memory res) {
        res = abi.encodePacked("data:image/svg+xml;charset=UTF-8,", input);
    }

    function encodeJsonAsBase64(bytes memory input) public pure override returns (bytes memory res) {
        res = abi.encodePacked("data:application/json;base64,", Base64._encode(input));
    }

    function encodeJsonAsUtf8(bytes memory input) public pure override returns (bytes memory res) {
        res = abi.encodePacked("data:application/json;charset=UTF-8,", input);
    }

    // function props(uint8[8] memory ids, string[8] memory labels) public pure returns (string memory) {
    //     bytes memory res;
    //     for (uint8 i = 0; i < 8; i++) {
    //         if (ids[i] == 0) continue;
    //         res = abi.encodePacked(
    //             res,
    //             i != 0 ? "," : "",
    //             '"',
    //             labels[i],
    //             '":"',
    //             StringCastLib.toAsciiString(ids[i]),
    //             '"'
    //         );
    //     }
    //     return string(abi.encodePacked("{", res, "}"));
    // }

    function props(uint8[8] memory ids, string[8] memory labels) public pure returns (string memory) {
        bytes memory res;

        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] == 0) continue;
            res = abi.encodePacked(
                res,
                i != 0 ? "," : "",
                '"',
                labels[i],
                '":"',
                StringCastLib.toAsciiString(uint8(ids[i])),
                '"'
            );
        }
        return string(abi.encodePacked("{", res, "}"));
    }

    // function parseItemIdAsString(uint16 itemId, string[8] memory labels) pure override returns (string memory) {
    //     return string.concat(labels[(itemId >> 8)], " ", StringCastLib.toAsciiString((itemId) & 0xff));
    // }
}
