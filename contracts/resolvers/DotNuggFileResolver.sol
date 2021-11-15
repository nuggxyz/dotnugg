// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '.././interfaces/IDotNugg.sol';
import '.././interfaces/INuggIn.sol';
import '.././erc165/IERC165.sol';
import '../../contracts/logic/Rgba.sol';
import '../../contracts/logic/Matrix.sol';
import '../../contracts/libraries/Uint.sol';

contract DotNuggFileResolver is IFileResolver {
    using Rgba for IDotNugg.Rgba;
    using Uint256 for uint256;

    using Matrix for IDotNugg.Matrix;

    function combineBros(bytes1 n1, bytes1 n2) internal pure returns (bytes1 res) {
        return (n1 << 4) | n2;
        //   assembly {
        //       mstore(res, or(shl(mload(n1), 4), mload(n2)))
        //   }
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public pure override(IFileResolver) returns (bool) {
        return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function resolveFile(IDotNugg.Matrix memory matrix, bytes memory) public view override returns (bytes memory res, string memory fileType) {
        bytes memory rects = encode(matrix);
        return (rects, 'dotnugg');
    }

    function getPixelIndex(IDotNugg.Pixel[] memory pallet, IDotNugg.Pixel memory pixel) internal view returns (uint8 res, bool wasCached) {
        if (pixel.rgba.a == 0) return (0, true);
        for (uint8 i = 1; i < pallet.length; i++) {
            if (pallet[i].rgba.equalssss(pixel.rgba)) {
                return (i, true);
            }
            if (!pallet[i].exists) {
                //  pallet[i] = pixel;
                res = i;
                break;
            }
        }

        pallet[res] = pixel;
        pallet[res].exists = true;

        return (res, false);
    }

    function encode(IDotNugg.Matrix memory matrix) internal view returns (bytes memory res) {
        IDotNugg.Pixel memory lastPixel;

        IDotNugg.Pixel[] memory pallet = new IDotNugg.Pixel[](50);

        bytes memory colorKeys = new bytes(1000);
        bytes memory lengths = new bytes(1000);

        uint256 coltracker = 0;
        uint256 lentracker = 0;
        uint256 pallettracker = 1;

        uint8 count = 1;
        while (matrix.next()) {
            if (lastPixel.rgba.equalssss(matrix.current().rgba) && count < 16) {
                count++;
                continue;
            }
            (uint8 key_, bool cached_) = getPixelIndex(pallet, lastPixel);
            if (!cached_) pallettracker++;
            colorKeys[coltracker++] = bytes1(key_);
            lengths[lentracker++] = bytes1(count - 1);

            lastPixel = matrix.current();
            count = 1;
        }

        (uint8 key, bool cached) = getPixelIndex(pallet, lastPixel);
        if (!cached) pallettracker++;
        colorKeys[coltracker++] = bytes1(key);
        lengths[lentracker++] = bytes1(count - 1);

        res = new bytes(coltracker + pallettracker * 4 + lentracker / 2 + 12 + 1);

        uint256 index = 0;

        res[index++] = 0x64; // [0] - D
        res[index++] = 0x6f; // [1] - O
        res[index++] = 0x74; // [2] - T
        res[index++] = 0x6e; // [3] - N
        res[index++] = 0x75; // [4] - U
        res[index++] = 0x67; // [5] - G
        res[index++] = 0x67; // [6] - G

        res[index++] = 0; // [7] - FREE
        res[index++] = bytes1(matrix.width); // [8] - width

        uint256 colorKeysIndex = index + (pallettracker + 1) * 4;
        uint256 lengthIndex = colorKeysIndex + coltracker;

        res[index++] = bytes1(uint8(colorKeysIndex >> 8));
        res[index++] = bytes1(uint8(0xff & colorKeysIndex));

        res[index++] = bytes1(uint8(lengthIndex >> 8));
        res[index++] = bytes1(uint8(0xff & lengthIndex));

        for (uint256 i = 0; i < pallettracker; i++) {
            res[index++] = bytes1(pallet[i].rgba.r);
            res[index++] = bytes1(pallet[i].rgba.g);
            res[index++] = bytes1(pallet[i].rgba.b);
            res[index++] = bytes1(pallet[i].rgba.a);
        }

        for (uint256 i = 0; i < coltracker; i++) {
            res[index++] = colorKeys[i];
        }

        for (uint256 i = 0; i < lentracker; i += 2) {
            res[index++] = combineBros(lengths[i], lengths[i + 1]);
        }
    }

    //   assembly {
    //       mstore(colorKeysIndex0, shl(index, 8))
    //       mstore(add(colorKeysIndex0, 1), or(0xff, index))
    //   }

    //  function getRekt(
    //      IDotNugg.Rgba memory rgba,
    //      uint256 x,
    //      uint256 y,
    //      uint256 xlen,
    //      uint256 ylen
    //  ) internal pure returns (bytes memory res) {
    //      if (rgba.a == 0) return '';
    //      //   (rgba, ) = rgba.combine(IDotNugg.Rgba({r: 0, g: 255, b: 0, a: 99}));
    //      res = abi.encodePacked(
    //          "\t<rect fill='#",
    //          rgba.toAscii(),
    //          "' x='",
    //          x.toString(),
    //          "' y='",
    //          y.toString(),
    //          "' height='",
    //          xlen.toString(),
    //          "' width='",
    //          ylen.toString(),
    //          "'/>\n"
    //      );
    //  }
}
