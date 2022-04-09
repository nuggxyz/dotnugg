// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {StringCastLib} from "../libraries/StringCastLib.sol";

import {DotnuggV1Parser as Parser} from "./DotnuggV1Parser.sol";
import {DotnuggV1Pixel as Pixel} from "./DotnuggV1Pixel.sol";

import "../_test/utils/forge.sol";

library DotnuggV1Svg {
    using StringCastLib for uint256;
    using StringCastLib for uint8;
    using StringCastLib for address;
    using Pixel for uint256;

    struct Memory {
        bytes data;
        uint256 color;
    }

    struct Execution {
        Memory[] mapper;
        uint256 xEnd;
        uint256 yEnd;
        uint256 xStart;
        uint256 yStart;
    }

    function fledgeOutTheRekts(uint256[] memory calculated) internal pure returns (bytes memory res) {
        (uint256 last, ) = Parser.getPixelAt(calculated, 0, 0, 63);

        uint256 count = 1;

        Execution memory exec = Execution({mapper: new Memory[](64), xEnd: 0, yEnd: 0, xStart: 62, yStart: 62});

        for (uint256 y = 0; y < 63; y++) {
            for (uint256 x = y == 0 ? 1 : 0; x < 63; x++) {
                (uint256 curr, ) = Parser.getPixelAt(calculated, x, y, 63);

                if (curr.rgba() == last.rgba()) {
                    count++;
                    continue;
                }

                setRektPath(exec, last, (x - count), y, count);

                last = curr;
                count = 1;
            }

            setRektPath(exec, last, (63 - count), y, count);

            last = 0;
            count = 0;
        }

        for (uint256 i = 1; i < exec.mapper.length; i++) {
            if (exec.mapper[i].color == 0) break;
            res = abi.encodePacked(res, exec.mapper[i].data, '"/>');
        }

        res = gWrap(exec, res);
    }

    function gWrap(Execution memory exec, bytes memory children) internal pure returns (bytes memory res) {
        exec.xEnd -= exec.xStart;
        exec.yEnd -= exec.yStart;

        uint256 xTrans = ((exec.xEnd + 1) * 10) / 2 + (exec.xStart) * 10;
        uint256 yTrans = ((exec.yEnd + 1) * 10) / 2 + (exec.yStart) * 10;

        uint256 xScale = (6200000) / exec.xEnd;
        uint256 yScale = (6200000) / exec.yEnd;

        if (yScale < xScale) xScale = yScale;

        res = abi.encodePacked(
            '<g class="DN" transform="scale(',
            string((xScale).toAsciiBytes(5)),
            ") translate(",
            xTrans > 320 ? "-" : "",
            string((xTrans > 320 ? xTrans - 320 : 320 - xTrans).toAsciiBytes(1)),
            ",",
            yTrans > 320 ? "-" : "",
            string((yTrans > 320 ? yTrans - 320 : 320 - yTrans).toAsciiBytes(1)),
            ')" transform-origin="center center">',
            children,
            "</g>"
        );
    }

    function getColorIndex(Memory[] memory mapper, uint256 color) internal pure returns (uint256 i) {
        if (color.rgba() == 0) return 0;
        i++;
        for (; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;
            if (mapper[i].color == color) return i;
        }

        mapper[i].color = color;

        string memory colorStr = color.rgba() & 0xff == 0xff
            ? (color.rgba() >> 8).toHexStringNoPrefix(3)
            : color.rgba().toHexStringNoPrefix(4);

        mapper[i].data = abi.encodePacked('<path class="', uint8(color.f() + 65), '" stroke="#', colorStr, '" d="');
    }

    function setRektPath(
        Execution memory exec,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen
    ) internal pure {
        if (color == 0) return;

        if (x < exec.xStart) exec.xStart = x;
        if (y < exec.yStart) exec.yStart = y;
        if (x + xlen > exec.xEnd) exec.xEnd = x + xlen;
        if (y > exec.yEnd) exec.yEnd = y;

        uint256 index = getColorIndex(exec.mapper, color);

        exec.mapper[index].data = abi.encodePacked(
            exec.mapper[index].data, //
            "M",
            (x).toAsciiString(),
            " ",
            (y).toAsciiString(),
            "h",
            (xlen).toAsciiString()
        );
    }
}
