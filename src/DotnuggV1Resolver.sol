// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {IDotnuggV1Resolver} from "./interfaces/IDotnuggV1Resolver.sol";

import {DotnuggV1Svg as Svg} from "./core/DotnuggV1Svg.sol";
import {DotnuggV1MiddleOut as MiddleOut} from "./core/DotnuggV1MiddleOut.sol";

import {Base64} from "./libraries/Base64.sol";
import {StringCastLib} from "./libraries/StringCastLib.sol";

abstract contract DotnuggV1Resolver is IDotnuggV1Resolver {
    function calc(uint256[][] memory reads) public pure returns (uint256[] memory) {
        return MiddleOut.combine(reads);
    }

    function calc(uint256[] memory read) public pure returns (uint256[] memory) {
        uint256[][] memory reads = new uint256[][](1);
        reads[0] = read;
        return MiddleOut.combine(reads);
    }

    function combo(uint256[][] memory reads, bool base64) public pure returns (string memory) {
        return svg(calc(reads), base64);
    }

    function combo(uint256[] memory reads, bool base64) public pure returns (string memory) {
        return svg(calc(reads), base64);
    }

    function svg(uint256[] memory calculated) public pure override returns (string memory) {
        bytes memory res = abi.encodePacked(
            '<svg viewBox="0 0 63 63" xmlns="http://www.w3.org/2000/svg">',
            '<style type="text/css"><![CDATA[.A.B.C.D.E.F.G.H]]></style>',
            Svg.fledgeOutTheRekts(calculated),
            "</svg>"
        );

        return string(res);
    }

    function svg(uint256[] memory calculated, bool base64) public pure override returns (string memory) {
        bytes memory image = bytes(svg(calculated));

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

    function props(uint256 proof, string[8] memory labels) public pure returns (string memory) {
        bytes memory res;

        uint16[16] memory ids = decodeProof(proof);

        bool[8] memory seen;

        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] == 0 || seen[ids[i] >> 8]) continue;
            res = abi.encodePacked(
                res,
                i != 0 ? "," : "",
                '"',
                labels[i],
                '":"',
                StringCastLib.toAsciiString(uint8(ids[i])),
                '"'
            );
            seen[ids[i] >> 8] = true;
        }
        return string(abi.encodePacked("{", res, "}"));
    }

    function decodeProof(uint256 input) public pure returns (uint16[16] memory res) {
        for (uint256 i = 0; i < 16; i++) {
            res[i] = uint16(input);
            input >>= 16;
        }
    }

    function decodeProofCore(uint256 proof) public pure returns (uint8[8] memory res) {
        for (uint256 i = 0; i < 8; i++) {
            (uint8 feature, uint8 pos) = parseItemId(uint16(proof));
            if (res[feature] == 0) res[feature] = pos;
            proof >>= 16;
        }
    }

    function encodeProof(uint8[8] memory ids) external pure returns (uint256 proof) {
        for (uint256 i = 0; i < 8; i++) proof |= ((i << 8) | uint256(ids[i])) << (i << 3);
    }

    function encodeProof(uint16[16] memory ids) external pure returns (uint256 proof) {
        for (uint256 i = 0; i < 16; i++) proof |= uint256(ids[i]) << (i << 4);
    }

    /// @notice parses the external itemId into a feautre and position
    /// @dev this follows dotnugg v1 specification
    /// @param itemId -> the external itemId
    /// @return feat -> the feautre of the item
    /// @return pos -> the file storage position of the item
    function parseItemId(uint16 itemId) internal pure returns (uint8 feat, uint8 pos) {
        feat = uint8(itemId >> 8);
        pos = uint8(itemId);
    }
}
