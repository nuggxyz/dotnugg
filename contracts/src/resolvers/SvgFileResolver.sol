// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '.././interfaces/IResolver.sol';
import '.././erc165/IERC165.sol';
import '../logic/Rgba.sol';

import '../logic/Matrix.sol';

import '../types/MatrixType.sol';
import '../libraries/Uint.sol';

// import '../erc165/ERC165.sol';

// /**
//  * @dev Bytes1 operations.
//  */
contract SvgFileResolver is IFileResolver {
    using Uint256 for uint256;
    using Matrix for MatrixType.Memory;

    using MatrixType for MatrixType.Memory;
    using MatrixType for uint256;
    using PixelType for uint256;
    using Rgba for uint256;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view override(IFileResolver) returns (bool) {
        return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function resolveFile(MatrixType.Memory memory matrix, bytes memory data) public override returns (bytes memory res, string memory fileType) {
        uint256 svgWidth = uint256(matrix.data.matrix_width()) * 10;

        bytes memory header = abi.encodePacked(
            hex'3c7376672076696577426f783d2730203020', //"<svg Box='0 0 ",
            svgWidth.toString(),
            hex'20', // ' ',
            svgWidth.toString(),
            hex'20272077696474683d27', //"' width='",
            svgWidth.toString(),
            hex'27206865696768743d27', //  "' height='",
            svgWidth.toString(),
            hex'2720786d6c6e733d27687474703a2f2f7777772e77332e6f72672f323030302f7376672720786d6c6e733a786c696e6b3d27687474703a2f2f7777772e77332e6f72672f313939392f786c696e6b273e5c6e' // "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        );
        bytes memory rects = getSvgRects(matrix, 10);
        // '</svg>'
        return (abi.encodePacked(header, rects, hex'3c2f7376673e'), 'svg');
    }

    function getSvgRects(MatrixType.Memory memory matrix, uint256 pixelWidth) internal returns (bytes memory res) {
        uint256 lastX;
        uint256 lastPixel;
        //   uint256 xtracker;
        uint256 count = 1;
        while (matrix.next()) {
            if ((lastPixel.equals(matrix.current().pixel_rgba()) && matrix.data.matrix_currentUnsetX() < matrix.data.matrix_width())) {
                //  lastPixel = matrix.current().rgba;
                count++;
                continue;
            }
            if (lastPixel.pixel_a() != 0) {
                res = abi.encodePacked(
                    res,
                    getRekt(lastPixel, lastX * pixelWidth, matrix.data.matrix_currentUnsetY() * pixelWidth, pixelWidth, count * pixelWidth)
                );
            }
            lastPixel = matrix.current().pixel_rgba();
            lastX = matrix.data.matrix_currentUnsetX();
            // xtracker = 0;
            count = 1;
        }

        res = abi.encodePacked(
            res,
            getRekt(matrix.current().pixel_rgba(), lastX * pixelWidth, matrix.data.matrix_currentUnsetY() * pixelWidth, pixelWidth, count * pixelWidth)
        );
    }

    function getRekt(
        uint256 pixel,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 ylen
    ) internal returns (bytes memory res) {
        if (pixel.pixel_a() == 0) return '';
        res = abi.encodePacked(
            hex'5c743c726563742066696c6c3d2723', // "\t<rect fill='#",
            pixel.ascii(),
            hex'2720783d27', // "' x='",
            x.toString(),
            hex'2720793d27', // "' y='",
            y.toString(),
            hex'27206865696768743d27', // "' height='",
            xlen.toString(),
            hex'272077696474683d27', // "' width='",
            ylen.toString(),
            hex'272f3e5c6e' // "'/>\n"
        );
    }
}
