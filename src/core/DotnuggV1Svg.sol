// SPDX-License-Identifier: BUSL-1.1

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
        uint256 isaG;
    }
    uint256 constant TRANS_MUL = 1000;

    uint256 constant WIDTH = 255;
    uint256 constant WIDTH_SUB_1 = WIDTH - 1;
    uint256 constant WIDTH_MID = (WIDTH / 2) + 1;
    uint256 constant WIDTH_MID_10X = uint256(WIDTH_MID) * TRANS_MUL;

    function fledgeOutTheRekts(uint256[] memory calculated, uint256 dat) internal view returns (bytes memory res) {
        unchecked {
            uint256 count = 1;

            Execution memory exec = Execution({
                mapper: new Memory[](64),
                xEnd: 0,
                yEnd: 0,
                xStart: WIDTH_SUB_1,
                yStart: WIDTH_SUB_1,
                isaG: 0
            });

            (uint256 xStart, uint256 xEnd, uint256 yStart, uint256 yEnd) = buildDat(dat);

            (uint256 last, ) = Parser.getPixelAt(calculated, xStart, yStart, WIDTH);

            // yEnd++;

            exec.yStart = yStart;
            exec.xStart = xStart;
            exec.yEnd = yEnd;
            exec.xEnd = xEnd;

            for (uint256 y = yStart; y <= yEnd; y++) {
                for (uint256 x = y == yStart ? xStart + 1 : xStart; x <= xEnd; x++) {
                    (uint256 curr, ) = Parser.getPixelAt(calculated, x, y, WIDTH);

                    if (curr.rgba() == last.rgba()) {
                        count++;
                        continue;
                    }

                    setRektPath(exec, last, (x - count), y, count);

                    last = curr;
                    count = 1;
                }

                setRektPath(exec, last, (WIDTH - count), y, count);

                last = 0;
                count = 0;
            }

            require(xStart == exec.xStart, "X start off");
            require(yStart == exec.yStart, "Y start off");
            require(xEnd == exec.xEnd, "X End off");
            require(yEnd == exec.yEnd, "Y End off");
            exec.yEnd--;

            for (uint256 i = 1; i < exec.mapper.length; i++) {
                if (exec.mapper[i].color == 0) break;
                res = abi.encodePacked(res, exec.mapper[i].data, '"/>');
            }

            if (exec.isaG == 1) res = gWrap(exec, res);
        }
    }

    // function getStarts(uint256[] memory calced) internal view returns (uint8 resx, uint8 resy) {
    //     bool ok = false;
    //     for (uint256 y = 0; y < WIDTH; y++) {
    //         for (uint256 x = y == 0 ? 1 : 0; x < WIDTH; x++) {
    //             (uint256 curr, ) = Parser.getPixelAt(calced, x, y, WIDTH);
    //             if (curr == 0) continue;
    //             resy = uint8(y);
    //             ok = true;
    //             break;
    //         }
    //         if (ok) break;
    //     }
    //     ok = false;
    //     for (uint256 y = 0; y < WIDTH; y++) {
    //         for (uint256 x = y == 0 ? 1 : 0; x < WIDTH; x++) {
    //             (uint256 curr, ) = Parser.getPixelAt(calced, y, x, WIDTH);
    //             if (curr == 0) continue;
    //             resx = uint8(y);
    //             ok = true;
    //             break;
    //         }
    //         if (ok) break;
    //     }
    // }

    function buildDat(uint256 abc)
        internal
        view
        returns (
            uint256 a,
            uint256 b,
            uint256 c,
            uint256 d
        )
    {
        a = abc & type(uint64).max;
        b = (abc >> 64) & type(uint64).max;
        c = (abc >> 128) & type(uint64).max;
        d = (abc >> 192) & type(uint64).max;
    }

    // function getStarts(uint256 dat)
    //     internal
    //     view
    //     returns (
    //         uint8 resx,
    //         uint8 resy,
    //         uint8 resx,
    //         uint8 resy
    //     )
    // {}

    function gWrap(Execution memory exec, bytes memory children) internal view returns (bytes memory res) {
        {
            console.log(exec.xStart, exec.yStart, exec.xEnd, exec.yEnd);

            exec.xEnd -= exec.xStart;
            exec.yEnd -= exec.yStart;

            uint256 xTrans = ((exec.xEnd + 1) * TRANS_MUL) / 2 + (0) * TRANS_MUL;
            uint256 yTrans = ((exec.yEnd + 1) * TRANS_MUL) / 2 + (0) * TRANS_MUL;

            if (exec.xEnd == 0) exec.xEnd++;
            if (exec.yEnd == 0) exec.yEnd++;

            uint256 xScale = (uint256(WIDTH_SUB_1) * 100000) / exec.xEnd;
            uint256 yScale = (uint256(WIDTH_SUB_1) * 100000) / exec.yEnd;

            if (yScale < xScale) xScale = yScale;

            res = abi.encodePacked(
                '<g class="DN" transform="scale(',
                string((xScale).toAsciiBytes(5)),
                ") translate(",
                xTrans > WIDTH_MID_10X ? "-" : "",
                string((xTrans > WIDTH_MID_10X ? xTrans - WIDTH_MID_10X : WIDTH_MID_10X - xTrans).toAsciiBytes(3)),
                ",",
                yTrans > WIDTH_MID_10X ? "-" : "",
                string((yTrans > WIDTH_MID_10X ? yTrans - WIDTH_MID_10X : WIDTH_MID_10X - yTrans).toAsciiBytes(3)),
                ')" transform-origin="center center">',
                children,
                "</g>"
            );
        }
    }

    function getColorIndex(Memory[] memory mapper, uint256 color) internal view returns (uint256 i) {
        unchecked {
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
    }

    function setRektPath(
        Execution memory exec,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen
    ) internal view {
        unchecked {
            if (color == 0) return;

            exec.isaG = 1;
            if (x < exec.xStart) exec.xStart = x;
            if (y < exec.yStart) exec.yStart = y;
            if (x + xlen > exec.xEnd) exec.xEnd = (x + xlen);
            if (y > exec.yEnd) exec.yEnd = y;

            uint256 index = getColorIndex(exec.mapper, color);

            exec.mapper[index].data = abi.encodePacked(
                exec.mapper[index].data, //
                "M",
                (x - exec.xStart).toAsciiString(),
                " ",
                (y - exec.yStart).toAsciiString(),
                "h",
                (xlen).toAsciiString()
            );
        }
    }
}
