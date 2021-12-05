// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import '.././interfaces/IDotNugg.sol';
import '.././interfaces/INuggIn.sol';

// import '.././erc165/IERC165.sol';
// import '../logic/Rgba.sol';
// import '../logic/Matrix.sol';
// import '../libraries/Uint.sol';

// import '../erc165/ERC165.sol';

// /**
//  * @dev Bytes1 operations.
//  */
contract SvgFileResolver2 is IFileResolver {
    // using Rgba for IDotNugg.Rgba;
    // using Uint256 for uint256;
    // using Matrix for IDotNugg.Matrix;
    // /**
    //  * @dev See {IERC165-supportsInterface}.
    //  */
    function supportsInterface(bytes4 interfaceId) public view override(IFileResolver) returns (bool) {
        return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function resolveFile(IDotNugg.Matrix memory matrix, bytes memory data) public view override returns (bytes memory res, string memory fileType) {
        // uint256 svgWidth = uint256(matrix.width) * 10;
        // bytes memory header = abi.encodePacked(
        //     "<svg viewBox='0 0 ",
        //     svgWidth.toString(),
        //     ' ',
        //     svgWidth.toString(),
        //     "' width='",
        //     svgWidth.toString(),
        //     "' height='",
        //     svgWidth.toString(),
        //     "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        // );
        // bytes memory rects = getSvgRects(matrix, 10);
        return (abi.encodePacked('', '', '</svg>'), 'svg');
    }
    // function getSvgRects(IDotNugg.Matrix memory matrix, uint256 pixelWidth) internal view returns (bytes memory res) {
    //     IDotNugg.Rgba memory lastRgba;
    //     uint8 lastX;
    //     //   uint256 xtracker;
    //     uint256 count = 1;
    //     while (matrix.next()) {
    //         if ((lastRgba.equalssss(matrix.current().rgba) && matrix.currentUnsetX < matrix.data[matrix.currentUnsetY].length)) {
    //             //  lastRgba = matrix.current().rgba;
    //             count++;
    //             continue;
    //         }
    //         if (lastRgba.a != 0) {
    //             res = abi.encodePacked(res, getRekt(lastRgba, lastX * pixelWidth, matrix.currentUnsetY * pixelWidth, pixelWidth, count * pixelWidth));
    //         }
    //         lastRgba = matrix.current().rgba;
    //         lastX = matrix.currentUnsetX;
    //         // xtracker = 0;
    //         count = 1;
    //     }
    //     res = abi.encodePacked(res, getRekt(matrix.current().rgba, lastX * pixelWidth, matrix.currentUnsetY * pixelWidth, pixelWidth, count * pixelWidth));
    // }
    // function getRekt(
    //     IDotNugg.Rgba memory rgba,
    //     uint256 x,
    //     uint256 y,
    //     uint256 xlen,
    //     uint256 ylen
    // ) internal view returns (bytes memory res) {
    //     if (rgba.a == 0) return '';
    //     //   (rgba, ) = rgba.combine(IDotNugg.Rgba({r: 0, g: 255, b: 0, a: 99}));
    //     res = abi.encodePacked(
    //         "\t<rect fill='#",
    //         rgba.toAscii(),
    //         "' x='",
    //         x.toString(),
    //         "' y='",
    //         y.toString(),
    //         "' height='",
    //         xlen.toString(),
    //         "' width='",
    //         ylen.toString(),
    //         "'/>\n"
    //     );
    // }
}
