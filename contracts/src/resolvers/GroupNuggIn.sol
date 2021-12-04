// SPDX-License-Identifier: MIT


// pragma solidity 0.8.4;

// import '.././interfaces/IDotNugg.sol';
// import '.././interfaces/INuggIn.sol';
// import '.././erc165/IERC165.sol';
// import '../../contracts/logic/Rgba.sol';
// import '../../contracts/logic/Matrix.sol';
// import '../../contracts/libraries/Uint.sol';

// // import '../erc165/ERC165.sol';

// // /**
// //  * @dev Bytes1 operations.
// //  */
// contract GroupNuggIn is IFileResolver {
//     using Rgba for IDotNugg.Rgba;
//     using Uint256 for uint256;

//     using Matrix for IDotNugg.Matrix;

//     function combineBros(uint8 n1, uint8 n2) internal view returns (bytes1 res) {
//         uint8 one = n1 << 4;
//         res = bytes1(one | n2);
//         // console.log(n1, n2);
//         // console.log(one, uint8(res));

//         // console.logBytes1(res);

//         // console.log('=============');
//     }

//     /**
//      * @dev See {IERC165-supportsInterface}.
//      */
//     function supportsInterface(bytes4 interfaceId) public view override(IFileResolver) returns (bool) {
//         return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
//     }

//     function resolveFile(IDotNugg.Matrix memory matrix, bytes memory) public view override returns (bytes memory res, string memory fileType) {
//         bytes memory rects = getSvgRects(matrix, 10);
//         return (rects, 'groups');
//     }

//     function getPixelIndex(IDotNugg.Pixel[] memory mapper, IDotNugg.Pixel memory pixel) internal view returns (uint8 res) {
//         if (pixel.rgba.a == 0) return 0;
//         for (uint8 i = 1; i < mapper.length; i++) {
//             if (mapper[i].rgba.equalssss(pixel.rgba)) {
//                 return i;
//             }
//             if (!mapper[i].exists) {
//                 //  mapper[i] = pixel;
//                 res = i;
//                 break;
//             }
//         }

//         mapper[res] = pixel;
//         mapper[res].exists = true;
//     }

//     function getSvgRects(IDotNugg.Matrix memory matrix, uint256) internal view returns (bytes memory res) {
//         IDotNugg.Pixel memory lastPixel;
//         uint8 lastX;

//         IDotNugg.Pixel[] memory mapper = new IDotNugg.Pixel[](50);

//         bytes memory tmp = new bytes(1000);

//         //   uint256 xtracker;

//         uint256 restracker = 0;
//         uint8 count = 1;
//         while (matrix.next()) {
//             if (lastPixel.rgba.equalssss(matrix.current().rgba) && count < 256) {
//                 //  lastPixel = matrix.current().rgba;
//                 count++;
//                 continue;
//             }
//             // if (lastPixel.rgba.a != 0) {
//             tmp[restracker++] = bytes1(getPixelIndex(mapper, lastPixel));
//             tmp[restracker++] = bytes1(count - 1);
//             // res = abi.encodePacked(res, combineBros(getPixelIndex(mapper, lastPixel), count));
//             // }
//             lastPixel = matrix.current();
//             lastX = matrix.currentUnsetX;
//             // xtracker = 0;
//             count = 1;
//         }

//         //   res = abi.encodePacked(res, combineBros(getPixelIndex(mapper, lastPixel), count));
//         tmp[restracker++] = bytes1(getPixelIndex(mapper, lastPixel));
//         tmp[restracker++] = bytes1(count - 1);

//         res = new bytes(restracker + 1);
//         for (uint256 i = 0; i < res.length; i++) {
//             res[i] = tmp[i];
//         }

//         //   while (!done) {
//         //       lastPix = matrix.current();
//         //       while (!done) {
//         //           if (!matrix.next()) {
//         //               done = true;
//         //               break;
//         //           }
//         //           if (!lastPix.rgba.equalssss(matrix.current().rgba)) break;

//         //           count++;
//         //           if (count == matrix.width - 1) break;
//         //       }
//         //       if (lastPix.rgba.a != 0) {
//         //           if (matrix.currentUnsetX < count) {
//         //               uint256 diff = count - matrix.currentUnsetX;
//         //               console.log(diff, count, matrix.currentUnsetX, matrix.currentUnsetY);
//         //               console.log(matrix.width);

//         //               res = abi.encodePacked(
//         //                   res,
//         //                   getRekt(lastPix.rgba, (matrix.width - diff) * pixelWidth, (matrix.currentUnsetY - 1) * pixelWidth, pixelWidth, diff * pixelWidth),
//         //                   getRekt(lastPix.rgba, 0, (matrix.currentUnsetY) * pixelWidth, pixelWidth, (count - diff) * pixelWidth)
//         //               );
//         //               //  res = abi.encodePacked(res, getRekt(lastPix.rgba, 0, (lastPix.currentUnsetY) * pixelWidth, pixelWidth, (count - diff) * pixelWidth));
//         //           } else {
//         //               res = abi.encodePacked(
//         //                   res,
//         //                   getRekt(lastPix.rgba, (matrix.width - count) * pixelWidth, (matrix.currentUnsetY - 1) * pixelWidth, pixelWidth, count * pixelWidth)
//         //               );
//         //           }
//         //       }
//         //   }
//     }

//     //  function getRekt(
//     //      IDotNugg.Rgba memory rgba,
//     //      uint256 x,
//     //      uint256 y,
//     //      uint256 xlen,
//     //      uint256 ylen
//     //  ) internal view returns (bytes memory res) {
//     //      if (rgba.a == 0) return '';
//     //      //   (rgba, ) = rgba.combine(IDotNugg.Rgba({r: 0, g: 255, b: 0, a: 99}));
//     //      res = abi.encodePacked(
//     //          "\t<rect fill='#",
//     //          rgba.toAscii(),
//     //          "' x='",
//     //          x.toString(),
//     //          "' y='",
//     //          y.toString(),
//     //          "' height='",
//     //          xlen.toString(),
//     //          "' width='",
//     //          ylen.toString(),
//     //          "'/>\n"
//     //      );
//     //  }
// }
