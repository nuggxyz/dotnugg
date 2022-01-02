// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {StringCastLib} from '../libraries/StringCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Pixel} from '../types/Pixel.sol';
import {Version} from '../types/Version.sol';

import {IDotnuggV1Metadata} from '../interfaces/IDotnuggV1Metadata.sol';

library DotnuggV1SvgLib {
    using StringCastLib for uint256;
    using StringCastLib for uint8;

    using StringCastLib for address;

    using Pixel for uint256;

    function getColorIndex(uint256[] memory mapper, uint256 color) internal pure returns (uint256 i) {
        for (; i < mapper.length; i++) {
            if (mapper[i] == color) return i;
        }

        mapper[i] = color;
    }

    function build(
        IDotnuggV1Metadata.Memory memory data,
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

        (uint256 last, ) = Version.getPixelAt(file, 0, 0, width);
        uint256 count = 1;

        // bytes[] memory rects = new bytes[](35);
        bytes memory body;

        for (uint256 y = 0; y < height; y++) {
            for (uint256 x = 0; x < width; x++) {
                if (y == 0 && x == 0) x++;
                (uint256 curr, ) = Version.getPixelAt(file, x, y, width);
                if (curr.rgba() == last.rgba()) {
                    count++;
                    continue;
                } else {
                    body = abi.encodePacked(body, getRekt(last, (x - count) * zoom, y * zoom, 1 * zoom, count * zoom));
                    last = curr;
                    count = 1;
                }
            }

            body = abi.encodePacked(body, getRekt(last, (width - count) * zoom, y * zoom, 1 * zoom, count * zoom));
            last = 0;
            count = 0;
        }

        res = abi.encodePacked(header, body, footer);
    }

    // function convertLine(
    //     x1,
    //     y1,
    //     x2,
    //     y2
    // ) {
    //     if (parseFloat(x1, 10) < 0 || parseFloat(y1, 10) < 0 || parseFloat(x2, 10) < 0 || parseFloat(y2, 10) < 0) {
    //         return '';
    //     }

    //     return 'M' + x1 + ',' + y1 + 'L' + x2 + ',' + y2;
    // }

    function getRekt2(
        uint256 pixel,
        uint256 x,
        uint256 y,
        uint256,
        uint256 xlen
    ) internal pure returns (bytes memory res) {
        if (pixel.a() == 0) return '';

        // if (parseFloat(x1, 10) < 0 || parseFloat(y1, 10) < 0 || parseFloat(x2, 10) < 0 || parseFloat(y2, 10) < 0) {
        //     return '';
        // }

        string memory yy = y.toAsciiString();

        res = abi.encodePacked(
            '<path stroke="#',
            pixel.rgba().toHexStringNoPrefix(4),
            '" d="M',
            // ',' + y1 + 'L' + x2 + ',' + y2,
            x.toAsciiString(),
            ',',
            y.toAsciiString(),
            'L',
            (x + xlen).toAsciiString(),
            ',',
            (y).toAsciiString(),
            '"/>'
        );
    }

    function getRekt(
        uint256 pixel,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 ylen
    ) internal pure returns (bytes memory res) {
        if (pixel.a() == 0) return '';
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

    function getMetadata(IDotnuggV1Metadata.Memory memory data) internal pure returns (bytes memory res) {
        res = abi.encodePacked(
            '<text x="10" y="20" font-family="monospace" font-size="20px" style="fill:black;">Metadata:',
            getTspan(45, 0, 'name', data.name),
            getTspan(75, 0, 'description', data.desc),
            getTspan(105, 0, 'id', data.tokenId.toAsciiString()),
            getTspan(135, 0, 'owner', data.owner.toHexString()),
            getTspan(165, 0, 'items', '')
        );

        for (uint256 i = 0; i < 8; i++) {
            if (data.ids[i] > 0) {
                res = abi.encodePacked(res, getTspan(195 + i * 30, 20, data.labels[i], data.ids[i].toAsciiString()));
            }
        }

        res = abi.encodePacked(res, '</text>');
    }

    function getTspan(
        uint256 y,
        uint256 xoffset,
        string memory label,
        string memory data
    ) internal pure returns (bytes memory res) {
        res = abi.encodePacked(
            '<tspan x="',
            (10 + xoffset).toAsciiString(),
            '" y="',
            y.toAsciiString(),
            '">',
            '<tspan style="font-weight:bold;">',
            label,
            ':</tspan> ',
            data,
            '</tspan>'
        );
    }
}
