// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '.././interfaces/IResolver.sol';
import '../libraries/Base64.sol';
import '../libraries/Uint.sol';

// contract SvgPostProcessResolver is IPostProcessResolver {
//     // using Rgba for IDotNugg.Rgba;
//     using Uint256 for uint256;

//     // /**
//     //  * @dev See {IERC165-supportsInterface}.
//     //  */
//     function supportsInterface(bytes4 interfaceId) public pure override(IPostProcessResolver) returns (bool) {
//         return interfaceId == type(IPostProcessResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
//     }

//     function postProcess(bytes memory data) public pure override returns (bytes memory res) {
//         (, uint256 width, uint256 height, uint256[] memory file) = abi.decode(data, (uint256, uint256, uint256, uint256[]));
//         // // bytes memory rects = getSvgRects(matrix, 10);
//         // // '</svg>'
//         // res = Base64.encode(
//         //     bytes(
//         //         abi.encodePacked(
//         //             '{"name":"',
//         //             'NuggFT',
//         //             '","tokenId":"',
//         //             tokenId.toString(),
//         //             '","description":"',
//         //             'The Nuggiest FT',
//         //             '", "image": "',
//         //             Base64.encode(buildSvg(file, width, height), 'svg'),
//         //             '"}'
//         //         )
//         //     ),
//         //     'json'
//         // );

//         return Base64._encode(buildSvg(file, width, height));
//     }

// }
