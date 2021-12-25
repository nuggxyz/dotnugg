// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {StringCastLib} from '../libraries/StringCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Pixel} from '../types/Pixel.sol';

import 'hardhat/console.sol';

library Svg {
    using StringCastLib for uint256;

    function getPixelAt(
        uint256[] memory file,
        uint256 x,
        uint256 y,
        uint256 width
    ) internal view returns (uint256 res) {
        uint256 index = x + (y * width);

        res = Pixel.rgba((file[index / 6] >> (42 * (index % 6))) & ShiftLib.mask(42));
    }

    function buildSvg(
        uint256[] memory file,
        uint256 width,
        uint256 height,
        uint8 zoom
    ) internal view returns (bytes memory res) {
        bytes memory header = abi.encodePacked(
            hex'3c7376672076696577426f783d2730203020', //"<svg Box='0 0 ",
            (zoom * width).toAsciiString(),
            hex'20', // ' ',
            (zoom * width).toAsciiString(),
            hex'20272077696474683d27', //"' width='",
            (zoom * width).toAsciiString(),
            hex'27206865696768743d27', //  "' height='",
            (zoom * width).toAsciiString(),
            hex'2720786d6c6e733d27687474703a2f2f7777772e77332e6f72672f323030302f7376672720786d6c6e733a786c696e6b3d27687474703a2f2f7777772e77332e6f72672f313939392f786c696e6b273e5c6e' // "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        );

        bytes memory footer = hex'3c2f7376673e';

        uint256 last = getPixelAt(file, 0, 0, width);
        uint256 count = 1;

        // bytes[] memory rects = new bytes[](35);
        bytes memory body;

        for (uint256 y = 0; y < height; y++) {
            for (uint256 x = 0; x < height; x++) {
                if (y == 0 && x == 0) x++;
                uint256 curr = getPixelAt(file, x, y, width);
                if (curr == last) {
                    count++;
                    continue;
                } else {
                    // curr.log('yup');
                    // rects[index++] = getRekt(last, x - count, y, count, 1);
                    body = abi.encodePacked(body, getRekt(last, (x - count) * zoom, y * zoom, 1 * zoom, count * zoom));
                    last = curr;
                    count = 1;
                }
            }

            // rects[index++] = getRekt(last, 33 - count, y, count, 1);
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
    ) internal view returns (bytes memory res) {
        if (pixel & 0xff == 0) return '';
        console.logBytes32(bytes32(pixel));
        res = abi.encodePacked(
            "\t<rect fill='#",
            pixel.toHexStringNoPrefix(4),
            hex'2720783d27',
            x.toAsciiString(),
            hex'2720793d27',
            y.toAsciiString(),
            hex'27206865696768743d27',
            xlen.toAsciiString(),
            hex'272077696474683d27',
            ylen.toAsciiString(),
            "'/>\n"
        );
    }
}
