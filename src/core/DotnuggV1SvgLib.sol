// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {StringCastLib} from '../libraries/StringCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Pixel} from '../types/Pixel.sol';
import {Version} from '../types/Version.sol';
import {Base64} from '../libraries/Base64.sol';

import {IDotnuggV1Metadata} from '../interfaces/IDotnuggV1Metadata.sol';

contract DotnuggV1SvgLib {
    using StringCastLib for uint256;
    using StringCastLib for uint8;

    using StringCastLib for address;

    using Pixel for uint256;

    struct Memory {
        bytes data;
        uint256 color;
    }

    function svgBase64(bytes memory input) public pure returns (bytes memory res) {
        res = abi.encodePacked(Base64.PREFIX_SVG, Base64._encode(input));
    }

    function svgUtf8(bytes memory input) public pure returns (bytes memory res) {
        res = abi.encodePacked('data:image/svg+xml;charset=UTF-8,', input);
    }

    function buildSvg(
        uint256[] memory file,
        IDotnuggV1Metadata.Memory memory metadata,
        // uint256 zoom,
        bool rekt,
        bool background,
        bool,
        bool base64
    ) external pure returns (bytes memory res) {
        // styles[0] = '{filter: drop-shadow( 3px 3px 2px rgba(0, 0, 0, .7));}';

        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                    header
           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

        string memory __63 = uint256(63).toAsciiString();

        bytes memory header = abi.encodePacked(
            '<svg',
            ' viewBox="0 0 ',
            __63,
            ' ',
            __63,
            // '" height="',
            // __63,
            // '" width="',
            '" xmlns="http://www.w3.org/2000/svg"'
        );

        if (background) {
            header = abi.encodePacked(
                header, //
                ' style="background-color:',
                bytes(metadata.background).length > 0 ? metadata.background : '#FFF',
                '"'
            );
        }

        /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                        body
           ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

        // if (zoom == 0) zoom = 1;

        Memory[] memory mapper = fletchOutTheRects(file, rekt);

        bytes memory body;

        for (uint256 i = 1; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;

            body = abi.encodePacked(
                body, //
                mapper[i].data,
                '"/>'
            );
        }

        if (rekt) {
            bytes memory stylee = abi.encodePacked('<style type="text/css" ><![CDATA[');

            for (uint256 i = 0; i < 8; i++) {
                if (metadata.styles.length > i && bytes(metadata.styles[i]).length == 0) continue;
                stylee = abi.encodePacked(stylee, '.', i + 65, metadata.styles[i]);
            }

            body = abi.encodePacked(stylee, ']]></style>', body);
        }

        // if (stats) {
        //     body = abi.encodePacked(body, getMetadata(metadata));
        // }

        res = abi.encodePacked(header, '>', body, hex'3c2f7376673e');

        if (base64) res = svgBase64(res);
        else res = svgUtf8(res);
    }

    function fletchOutTheRects(uint256[] memory file, bool rekt) internal pure returns (Memory[] memory mapper) {
        (uint256 last, ) = Version.getPixelAt(file, 0, 0, 63);

        uint256 count = 1;

        mapper = new Memory[](64);

        for (uint256 y = 0; y < 63; y++) {
            for (uint256 x = y == 0 ? 1 : 0; x < 63; x++) {
                // if (y == 0 && x == 0) x++;

                (uint256 curr, ) = Version.getPixelAt(file, x, y, 63);

                if (curr.rgba() == last.rgba()) {
                    count++;
                    continue;
                }

                setRektPath(mapper, last, (x - count), y, count, rekt);

                last = curr;
                count = 1;
            }

            setRektPath(mapper, last, (63 - count), y, count, rekt);

            last = 0;
            count = 0;
        }
    }

    function getColorIndex(
        Memory[] memory mapper,
        uint256 color,
        bool rekt
    ) internal pure returns (uint256 i) {
        if (color.rgba() == 0) return 0;
        i++;
        for (; i < mapper.length; i++) {
            if (mapper[i].color == 0) break;
            if (mapper[i].color == color) return i;
        }

        mapper[i].color = color;

        string memory colorStr = color.a() == 0xff ? (color.rgba() >> 8).toHexStringNoPrefix(3) : color.rgba().toHexStringNoPrefix(4);

        if (rekt) {
            mapper[i].data = abi.encodePacked('<path fill="#', colorStr, '" class="', color.f() + 65, '" d="');
        } else {
            mapper[i].data = abi.encodePacked('<path stroke="#', colorStr, '" d="');
        }
    }

    function setRektPath(
        Memory[] memory mapper,
        uint256 color,
        uint256 x,
        uint256 y,
        uint256 xlen,
        bool rekt
    ) internal pure {
        if (color == 0) return;

        uint256 index = getColorIndex(mapper, color, rekt);

        mapper[index].data = abi.encodePacked(
            mapper[index].data, //
            'M',
            (x).toAsciiString(),
            ' ',
            (y).toAsciiString(),
            'h',
            (xlen).toAsciiString()
        );

        if (rekt) {
            mapper[index].data = abi.encodePacked(
                mapper[index].data, //
                'v',
                uint256(1).toAsciiString(),
                'L',
                (x).toAsciiString(),
                ' ',
                (y + 1).toAsciiString()
            );
        }
    }

    // function getMetadata(IDotnuggV1Metadata.Memory memory data) internal pure returns (bytes memory res) {
    //     res = abi.encodePacked(
    //         '<text x="10" y="20" font-family="monospace" font-size="20px" style="fill:black;">Metadata:',
    //         // getTspan(45, 0, 'name', data.name),
    //         // getTspan(75, 0, 'description', data.desc),
    //         // getTspan(105, 0, 'id', data.tokenId.toAsciiString()),
    //         // getTspan(135, 0, 'owner', data.owner.toHexString()),
    //         getTspan(165, 0, 'items', '')
    //     );

    //     for (uint256 i = 0; i < 8; i++) {
    //         if (data.ids[i] > 0) {
    //             res = abi.encodePacked(res, getTspan(195 + i * 30, 20, data.labels[i], data.ids[i].toAsciiString()));
    //         }
    //     }

    //     res = abi.encodePacked(res, '</text>');
    // }

    // function getTspan(
    //     uint256 y,
    //     uint256 xoffset,
    //     string memory label,
    //     string memory data
    // ) internal pure returns (bytes memory res) {
    //     res = abi.encodePacked(
    //         '<tspan x="',
    //         (10 + xoffset).toAsciiString(),
    //         '" y="',
    //         y.toAsciiString(),
    //         '">',
    //         '<tspan style="font-weight:bold;">',
    //         label,
    //         ':</tspan> ',
    //         data,
    //         '</tspan>'
    //     );
    // }
}
