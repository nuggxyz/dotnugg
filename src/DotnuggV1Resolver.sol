// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Resolver} from "./interfaces/IDotnuggV1Resolver.sol";

import {DotnuggV1Calculated, DotnuggV1Read} from "./interfaces/DotnuggV1Files.sol";

import {DotnuggV1Svg as Svg} from "./core/DotnuggV1Svg.sol";
import {DotnuggV1MiddleOut as MiddleOut} from "./core/DotnuggV1MiddleOut.sol";

import {Base64} from "./libraries/Base64.sol";
import {StringCastLib} from "./libraries/StringCastLib.sol";

abstract contract DotnuggV1Resolver is IDotnuggV1Resolver {
    function calc(DotnuggV1Read[8] memory inputs) public pure returns (DotnuggV1Calculated memory) {
        return MiddleOut.combine(inputs);
    }

    function calc(DotnuggV1Read memory input) public pure returns (DotnuggV1Calculated memory) {
        DotnuggV1Read[8] memory blank;
        blank[0] = input;
        return MiddleOut.combine(blank);
    }

    function svg(DotnuggV1Calculated memory file, bool base64) public pure override returns (string memory) {
        bytes memory res = abi.encodePacked(
            '<svg viewBox="0 0 63 63" xmlns="http://www.w3.org/2000/svg">',
            '<style type="text/css"><![CDATA[.A.B.C.D.E.F.G.H]]></style>',
            Svg.fledgeOutTheRekts(file),
            "</svg>"
        );

        res = base64
            ? abi.encodePacked("data:image/svg+xml;base64,", Base64._encode(res))
            : abi.encodePacked("data:image/svg+xml;charset=UTF-8,", res);

        return string(res);
    }

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
                StringCastLib.toAsciiString(ids[i]),
                '"'
            );
        }
        return string(abi.encodePacked("{", res, "}"));
    }
}
