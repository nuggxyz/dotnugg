// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {StringCastLib} from '../libraries/StringCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Pixel} from '../types/Pixel.sol';
import {Version} from '../types/Version.sol';

library Svg {
    using StringCastLib for uint256;
    using Pixel for uint256;

    function build(
        uint256[] memory file,
        uint256 width,
        uint256 height,
        uint8 zoom
    ) internal pure returns (bytes memory res) {
        bytes memory header = abi.encodePacked(
            "<svg Box='0 0 ", //"<svg Box='0 0 ",
            (zoom * width).toAsciiString(),
            hex'20', // ' ',
            (zoom * width).toAsciiString(),
            "' width='", //"' width='",
            (zoom * width).toAsciiString(),
            "' height='", //  "' height='",
            (zoom * width).toAsciiString(),
            "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>"
        );

        bytes memory footer = hex'3c2f7376673e';

        uint256 last = Version.getPixelAt(file, 0, 0, width).rgba();
        uint256 count = 1;

        // bytes[] memory rects = new bytes[](35);
        bytes memory body;

        for (uint256 y = 0; y < height; y++) {
            for (uint256 x = 0; x < height; x++) {
                if (y == 0 && x == 0) x++;
                uint256 curr = Version.getPixelAt(file, x, y, width);
                if (curr.rgba() == last) {
                    count++;
                    continue;
                } else {
                    body = abi.encodePacked(body, getRekt(last, (x - count) * zoom, y * zoom, 1 * zoom, count * zoom));
                    last = curr.rgba();
                    count = 1;
                }
            }

            body = abi.encodePacked(body, getRekt(last, (width - count) * zoom, y * zoom, 1 * zoom, count * zoom));
            last = 0;
            count = 0;
        }

        res = abi.encodePacked(header, body, footer);
    }

    function getRekt(
        uint256 pixel,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 ylen
    ) internal pure returns (bytes memory res) {
        if (pixel & 0xff == 0) return '';
        res = abi.encodePacked(
            "<rect fill='#",
            pixel.rgba().toHexStringNoPrefix(4),
            hex'2720783d27',
            x.toAsciiString(),
            hex'2720793d27',
            y.toAsciiString(),
            hex'27206865696768743d27',
            xlen.toAsciiString(),
            hex'272077696474683d27',
            ylen.toAsciiString(),
            "'/>"
        );
    }
}
