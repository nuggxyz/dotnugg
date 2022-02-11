// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {StringCastLib} from "../libraries/StringCastLib.sol";

import {DotnuggV1Calculated} from "../interfaces/DotnuggV1Files.sol";

import {Parser} from "./Parser.sol";
import {Pixel} from "./Pixel.sol";

library DotnuggV1SvgLib {
    using StringCastLib for uint256;
    using StringCastLib for uint8;
    using StringCastLib for address;
    using Pixel for uint256;

    struct Memory {
        bytes data;
        uint256 color;
    }

    // function uint256.rgba( input) internal pure returns (uint256 res) {
    //     return ((input << 5) & 0xffffff_00) | ((input & 0x7) == 0x7 ? 255 : ((input & 0x7) * 36));
    // }

    // // this is 1-8 so 3 bits
    // function feature(uint256 input) internal pure returns (uint8 res) {
    //     assembly {
    //         res := and(shr(39, input), 0x7)
    //     }
    // }

    // function getPixelAt(
    //     uint256[] memory arr,
    //     uint256 x,
    //     uint256 y,
    //     uint256 width
    // ) internal pure returns (uint256 res, uint256 row) {
    //     uint256 index = x + (y * width);

    //     if (index / 6 >= arr.length) return (0, 0);

    //     row = (arr[index / 6] >> (42 * (index % 6)));

    //     // 2 ^ 42
    //     res = row & 0x3FFFFFFFFFF;
    // }

    function fledgeOutTheRekts(DotnuggV1Calculated memory file) public pure returns (bytes memory res) {
        (uint256 last, ) = Parser.getPixelAt(file.dat, 0, 0, 63);

        uint256 count = 1;

        Memory[] memory mapper = new Memory[](64);

        for (uint256 y = 0; y < 63; y++) {
            for (uint256 x = y == 0 ? 1 : 0; x < 63; x++) {
                // if (y == 0 && x == 0) x++;

                (uint256 curr, ) = Parser.getPixelAt(file.dat, x, y, 63);

                if (curr.rgba() == last.rgba()) {
                    count++;
                    continue;
                }

                setRektPath(mapper, last, (x - count), y, count);

                last = curr;
                count = 1;
            }

            setRektPath(mapper, last, (63 - count), y, count);

            last = 0;
            count = 0;
        }

        for (uint256 i = 1; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;

            res = abi.encodePacked(res, mapper[i].data, '"/>');
        }
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

        mapper[i].data = abi.encodePacked(
            "<path",
            // color.id().toAsciiString(),
            '" class="',
            uint8(color.f() + 65),
            '" stroke="#',
            colorStr,
            '" d="'
        );
    }

    function setRektPath(
        Memory[] memory mapper,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen
    ) internal pure {
        if (color == 0) return;

        uint256 index = getColorIndex(mapper, color);

        mapper[index].data = abi.encodePacked(
            mapper[index].data, //
            "M",
            (x).toAsciiString(),
            " ",
            (y).toAsciiString(),
            "h",
            (xlen).toAsciiString()
        );
    }
}
