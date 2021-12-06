// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '.././interfaces/IResolver.sol';
import '../libraries/Base64.sol';
import '../libraries/Uint.sol';

contract SvgPostProcessResolver is IPostProcessResolver {
    // using Rgba for IDotNugg.Rgba;
    using Uint256 for uint256;

    // /**
    //  * @dev See {IERC165-supportsInterface}.
    //  */
    function supportsInterface(bytes4 interfaceId) public pure override(IPostProcessResolver) returns (bool) {
        return interfaceId == type(IPostProcessResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function resolvePostProcess(
        uint256 tokenId,
        uint256 width,
        uint256 height,
        uint256[] memory file,
        bytes memory data
    ) public pure override returns (string memory res) {
        // // bytes memory rects = getSvgRects(matrix, 10);
        // // '</svg>'
        // res = Base64.encode(
        //     bytes(
        //         abi.encodePacked(
        //             '{"name":"',
        //             'NuggFT',
        //             '","tokenId":"',
        //             tokenId.toString(),
        //             '","description":"',
        //             'The Nuggiest FT',
        //             '", "image": "',
        //             Base64.encode(buildSvg(file, width, height), 'svg'),
        //             '"}'
        //         )
        //     ),
        //     'json'
        // );

        return Base64.encode(buildSvg(file, width, height), 'svg');
    }

    function getPixelAt(
        uint256[] memory file,
        uint256 x,
        uint256 y,
        uint256 width
    ) internal pure returns (uint256 res) {
        uint256 index = x + (y * width);

        res = (file[index / 8] >> (32 * (index % 8))) & 0xffffffff;
    }

    function buildSvg(
        uint256[] memory file,
        uint256 width,
        uint256 height
    ) internal pure returns (bytes memory res) {
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
        uint256 index = 0;

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
                    // rects[index++] = getRekt(last, x - count, y, count, 1);
                    body = abi.encodePacked(body, getRekt(last, (x - count) * 10, y * 10, 1 * 10, count * 10));
                    last = curr;
                    count = 1;
                }
            }
            // rects[index++] = getRekt(last, 33 - count, y, count, 1);
            body = abi.encodePacked(body, getRekt(last, (33 - count) * 10, y * 10, 1 * 10, count * 10));
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
            // hex'5c743c726563742066696c6c3d2723',
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
            // hex'272f3e5c6e'
            "'/>\n"
        );
    }
}

// res = abi.encodePacked(
//     hex'5c743c726563742066696c6c3d2723', // "\t<rect fill='#",
//     pixel.ascii(),
//     hex'2720783d27', // "' x='",
//     x.toString(),
//     hex'2720793d27', // "' y='",
//     y.toString(),
//     hex'27206865696768743d27', // "' height='",
//     xlen.toString(),
//     hex'272077696474683d27', // "' width='",
//     ylen.toString(),
//     hex'272f3e5c6e' // "'/>\n"
// );

// function getSvgRects(MatrixType.Memory memory matrix, uint256 pixelWidth) internal view returns (bytes memory res) {
//     uint256 lastX;
//     uint256 lastPixel;
//     //   uint256 xtracker;
//     uint256 count = 1;
//     while (matrix.next()) {
//         if ((lastPixel.equals(matrix.current().pixel_rgba()) && matrix.data.matrix_currentUnsetX() < matrix.data.matrix_width())) {
//             //  lastPixel = matrix.current().rgba;
//             count++;
//             continue;
//         }
//         if (lastPixel.pixel_a() != 0) {
//             res = abi.encodePacked(
//                 res,
//                 getRekt(lastPixel, lastX * pixelWidth, matrix.data.matrix_currentUnsetY() * pixelWidth, pixelWidth, count * pixelWidth)
//             );
//         }
//         lastPixel = matrix.current().pixel_rgba();
//         lastX = matrix.data.matrix_currentUnsetX();
//         // xtracker = 0;
//         count = 1;
//     }

//     res = abi.encodePacked(
//         res,
//         getRekt(matrix.current().pixel_rgba(), lastX * pixelWidth, matrix.data.matrix_currentUnsetY() * pixelWidth, pixelWidth, count * pixelWidth)
//     );
// }
