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

    function getColorIndex(
        Memory[] memory mapper,
        uint256 color,
        uint256 zoom
    ) internal pure returns (uint256 i) {
        color = color.rgba();
        if (color == 0) return 0;
        i++;
        for (; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;
            if (mapper[i].color == color) return i;
        }
        mapper[i].color = color;
        mapper[i].data = abi.encodePacked(
            zoom > 1 ? '<path fill="#' : '<path stroke="#',
            color & 0xff == 0xff ? (color >> 8).toHexStringNoPrefix(3) : color.toHexStringNoPrefix(4),
            '" d="'
        );
    }

    struct Memory {
        bytes data;
        uint256 color;
    }

    function setRektPath(
        Memory[] memory mapper,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 zoom
    ) internal pure {
        if (color == 0) return;

        uint256 index = getColorIndex(mapper, color, zoom);

        mapper[index].data = abi.encodePacked(
            mapper[index].data,
            'M',
            (x * zoom).toAsciiString(),
            ' ',
            (y * zoom).toAsciiString(),
            'h',
            (xlen * zoom).toAsciiString()
        );

        if (zoom > 1) {
            mapper[index].data = abi.encodePacked(
                mapper[index].data,
                'v',
                (zoom).toAsciiString(),
                'L',
                (x * zoom).toAsciiString(),
                ' ',
                (y * zoom + zoom).toAsciiString()
            );
        }
    }

    function build(
        IDotnuggV1Metadata.Memory memory data,
        uint256[] memory file,
        uint256 width,
        uint256 height,
        uint256 zoom
    ) internal pure returns (bytes memory res) {
        if (zoom == 0) zoom = 1;

        (uint256 last, ) = Version.getPixelAt(file, 0, 0, width);

        uint256 count = 1;

        Memory[] memory mapper = new Memory[](64);

        for (uint256 y = 0; y < height; y++) {
            for (uint256 x = 0; x < width; x++) {
                if (y == 0 && x == 0) x++;

                (uint256 curr, ) = Version.getPixelAt(file, x, y, width);

                if (curr.rgba() == last.rgba()) {
                    count++;
                    continue;
                }

                setRektPath(mapper, last, (x - count), y, count, zoom);

                last = curr;
                count = 1;
            }

            setRektPath(mapper, last, (width - count), y, count, zoom);

            last = 0;
            count = 0;
        }

        bytes memory body;

        for (uint256 i = 1; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;
            body = abi.encodePacked(body, mapper[i].data, '"/>');
        }

        string memory __s = (63 * zoom).toAsciiString();

        res = abi.encodePacked(
            '<?xml version="1.0" encoding="utf-8"?><svg viewbox="0 0 ',
            __s,
            ' ',
            __s,
            '" height="',
            __s,
            '" width="',
            __s,
            '" version="1.2" baseProfile="tiny" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" overflow="visible" xml:space="preserve">',
            body,
            hex'3c2f7376673e'
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
