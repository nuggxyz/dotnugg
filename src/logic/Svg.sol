// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import '../libraries/Uint.sol';
import '../../test/Event.sol';

library Svg {
    using Uint256 for uint256;
    using Event for uint256;

    function getPixelAt(
        uint256[] memory file,
        uint256 x,
        uint256 y,
        uint256 width
    ) internal pure returns (uint256 res) {
        uint256 index = x + (y * width);

        res = (file[index / 6] >> (40 * (index % 6))) & 0xffffffff;
    }

    function buildSvg(
        uint256[] memory file,
        uint256 width,
        uint256 height
    ) internal view returns (bytes memory res) {
        bytes memory header = abi.encodePacked(
            hex'3c7376672076696577426f783d2730203020', //"<svg Box='0 0 ",
            (10 * width).toString(),
            hex'20', // ' ',
            (10 * width).toString(),
            hex'20272077696474683d27', //"' width='",
            (10 * width).toString(),
            hex'27206865696768743d27', //  "' height='",
            (10 * width).toString(),
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
                    body = abi.encodePacked(body, getRekt(last, (x - count) * 10, y * 10, 1 * 10, count * 10));
                    last = curr;
                    count = 1;
                }
            }
            // rects[index++] = getRekt(last, 33 - count, y, count, 1);
            body = abi.encodePacked(body, getRekt(last, (width - count) * 10, y * 10, 1 * 10, count * 10));
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
            "\t<rect fill='#",
            pixel.toHexStringNoPrefix(4),
            hex'2720783d27',
            x.toAscii(),
            hex'2720793d27',
            y.toAscii(),
            hex'27206865696768743d27',
            xlen.toAscii(),
            hex'272077696474683d27',
            ylen.toAscii(),
            "'/>\n"
        );
    }
}
