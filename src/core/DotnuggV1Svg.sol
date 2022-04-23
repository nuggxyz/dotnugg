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

    function fledgeOutTheRekts(uint256[] memory calculated, uint256 dat) internal pure returns (bytes memory res) {
        unchecked {
            uint256 count = 1;

            Execution memory exec;

            exec.mapper = new Memory[](64);

            exec.xStart = uint64(dat);
            exec.xEnd = uint64(dat >>= 64);
            exec.yStart = uint64(dat >>= 64);
            exec.yEnd = uint64(dat >>= 64);

            (uint256 last, ) = Parser.getPixelAt(calculated, exec.xStart, exec.yStart, WIDTH);

            for (uint256 y = exec.yStart; y <= exec.yEnd; y++) {
                for (uint256 x = y == exec.yStart ? exec.xStart + 1 : exec.xStart; x <= exec.xEnd; x++) {
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

            for (uint256 i = 1; i < exec.mapper.length; i++) {
                if (exec.mapper[i].color == 0) break;
                res = abi.encodePacked(res, exec.mapper[i].data, '"/>');
            }

            if (exec.isaG == 1) res = gWrap(exec, res);
        }
    }

    function buildDat(uint256 abc)
        internal
        pure
        returns (
            uint64 a,
            uint64 b,
            uint64 c,
            uint64 d
        )
    {
        a = uint64(abc);
        b = uint64(abc >>= 64);
        c = uint64(abc >>= 64);
        d = uint64(abc >>= 64);
    }

    function gWrap(Execution memory exec, bytes memory children) internal pure returns (bytes memory res) {
        {
            // console.log(exec.xStart, exec.yStart, exec.xEnd, exec.yEnd);
            exec.yEnd--;

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

    function getColorIndex(Memory[] memory mapper, uint256 color) internal pure returns (uint256 i) {
        unchecked {
            if (color == 0) return 0;

            uint256 rgba = color.rgba();

            i++;

            for (; i < mapper.length; i++) {
                if (mapper[i].color == 0) break;
                if (mapper[i].color == rgba) return i;
            }

            mapper[i].color = rgba;

            uint256 rgb = rgba >> 8;
            uint256 a = rgba & 0xff;

            string memory colorStr = a == 0xff
                ? rgb == 0xffffff ? "FFF" : rgb == 0 ? "000" : rgb.toHexStringNoPrefix(3)
                : rgba.toHexStringNoPrefix(4);

            mapper[i].data = abi.encodePacked('<path stroke="#', colorStr, '" d="');
        }
    }

    function setRektPath(
        Execution memory exec,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen
    ) internal pure {
        unchecked {
            if (color == 0) return;

            exec.isaG = 1;
            // if (x < exec.xStart) exec.xStart = x;
            // if (y < exec.yStart) exec.yStart = y;
            // if (x + xlen > exec.xEnd) exec.xEnd = (x + xlen);
            // if (y > exec.yEnd) exec.yEnd = y;

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
