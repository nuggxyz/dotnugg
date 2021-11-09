// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './interfaces/IDotNugg.sol';
import './interfaces/INuggIn.sol';
import './erc165/IERC165.sol';
import '../contracts/logic/Rgba.sol';
import '../contracts/logic/Matrix.sol';
import '../contracts/libraries/Uint.sol';

// import '../erc165/ERC165.sol';

// /**
//  * @dev Bytes1 operations.
//  */
contract SvgNuggIn is IFileResolver {
    using Rgba for IDotNugg.Rgba;
    using Uint256 for uint256;

    using Matrix for IDotNugg.Matrix;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(IFileResolver) returns (bool) {
        return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function resolveFile(IDotNugg.Matrix memory matrix, bytes memory data) public view override returns (bytes memory res, string memory fileType) {
        uint256 svgWidth = uint256(matrix.width) * 10;
        bytes memory header = abi.encodePacked(
            "<svg viewBox='0 0 ",
            svgWidth.toString(),
            ' ',
            svgWidth.toString(),
            "' width='",
            svgWidth.toString(),
            "' height='",
            svgWidth.toString(),
            "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        );
        bytes memory rects = getSvgRects(matrix, 10);
        return (abi.encodePacked(header, rects, '</svg>'), 'svg');
    }

    function getSvgRects(IDotNugg.Matrix memory matrix, uint256 pixelWidth) internal view returns (bytes memory res) {
        IDotNugg.Rgba memory lastRgba;
        uint8 lastX;

        //   uint256 xtracker;
        uint256 count = 1;
        while (matrix.next()) {
            if ((lastRgba.equalssss(matrix.current().rgba) && matrix.currentUnsetX < matrix.data[matrix.currentUnsetY].length)) {
                //  lastRgba = matrix.current().rgba;
                count++;
                continue;
            }
            if (lastRgba.a != 0) {
                res = abi.encodePacked(res, getRekt(lastRgba, lastX * pixelWidth, matrix.currentUnsetY * pixelWidth, count * pixelWidth, pixelWidth));
            }
            lastRgba = matrix.current().rgba;
            lastX = matrix.currentUnsetX;
            // xtracker = 0;
            count = 1;
        }

        res = abi.encodePacked(res, getRekt(matrix.current().rgba, lastX * pixelWidth, matrix.currentUnsetY * pixelWidth, count * pixelWidth, pixelWidth));

        //   while (!done) {
        //       lastPix = matrix.current();
        //       while (!done) {
        //           if (!matrix.next()) {
        //               done = true;
        //               break;
        //           }
        //           if (!lastPix.rgba.equalssss(matrix.current().rgba)) break;

        //           count++;
        //           if (count == matrix.width - 1) break;
        //       }
        //       if (lastPix.rgba.a != 0) {
        //           if (matrix.currentUnsetX < count) {
        //               uint256 diff = count - matrix.currentUnsetX;
        //               console.log(diff, count, matrix.currentUnsetX, matrix.currentUnsetY);
        //               console.log(matrix.width);

        //               res = abi.encodePacked(
        //                   res,
        //                   getRekt(lastPix.rgba, (matrix.width - diff) * pixelWidth, (matrix.currentUnsetY - 1) * pixelWidth, pixelWidth, diff * pixelWidth),
        //                   getRekt(lastPix.rgba, 0, (matrix.currentUnsetY) * pixelWidth, pixelWidth, (count - diff) * pixelWidth)
        //               );
        //               //  res = abi.encodePacked(res, getRekt(lastPix.rgba, 0, (lastPix.currentUnsetY) * pixelWidth, pixelWidth, (count - diff) * pixelWidth));
        //           } else {
        //               res = abi.encodePacked(
        //                   res,
        //                   getRekt(lastPix.rgba, (matrix.width - count) * pixelWidth, (matrix.currentUnsetY - 1) * pixelWidth, pixelWidth, count * pixelWidth)
        //               );
        //           }
        //       }
        //   }
    }

    function getRekt(
        IDotNugg.Rgba memory rgba,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 ylen
    ) internal view returns (bytes memory res) {
        if (rgba.a == 0) return '';
        //   (rgba, ) = rgba.combine(IDotNugg.Rgba({r: 0, g: 255, b: 0, a: 99}));
        res = abi.encodePacked(
            "\t<rect fill='#",
            rgba.toAscii(),
            "' x='",
            x.toString(),
            "' y='",
            y.toString(),
            "' height='",
            xlen.toString(),
            "' width='",
            ylen.toString(),
            "'/>\n"
        );
    }
}
