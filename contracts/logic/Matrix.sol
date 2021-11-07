// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import '../libraries/Bytes.sol';

library Matrix {
    using Bytes for bytes;

    function create(uint8 width, uint8 height) internal pure returns (IDotNugg.Matrix memory res) {
        require(width % 2 == 1 && height % 2 == 1, 'ML:C:0');

        res.data = new IDotNugg.Pixel[][](height);
        res.width = width;
        res.height = height;

        for (uint8 i = 0; i < height; i++) {
            res.data[i] = new IDotNugg.Pixel[](width);
        }
    }

    //  function at(
    //      IDotNugg.Matrix memory m,
    //      int8 x,
    //      int8 y
    //  ) internal pure returns (IDotNugg.Pixel memory res) {
    //      res = m.data[uint8(y + int8(m.height) / 2)][uint8(x + int8(m.width) / 2)];
    //  }

    function moveTo(
        IDotNugg.Matrix memory matrix,
        uint8 xoffset,
        uint8 yoffset
    ) internal pure {
        matrix.currentUnsetX = xoffset;
        matrix.currentUnsetY = yoffset;
        matrix.startX = xoffset;
    }

    function next(IDotNugg.Matrix memory matrix) internal pure returns (bool res) {
        res = next(matrix, fakeWidth(matrix));
    }

    function next(IDotNugg.Matrix memory matrix, uint8 width) internal pure returns (bool res) {
        if (!matrix.init) {
            if (width == matrix.currentUnsetX + 1) {
                if (fakeHeight(matrix) == matrix.currentUnsetY + 1) {
                    return false;
                }
                matrix.currentUnsetX = matrix.startX; // 0 by default
                matrix.currentUnsetY++;
            } else {
                matrix.currentUnsetX++;
            }
        } else {
            matrix.init = true;
        }
        res = true;
    }

    function current(IDotNugg.Matrix memory matrix) internal pure returns (IDotNugg.Pixel memory res) {
        res = matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
    }

    function setCurrent(IDotNugg.Matrix memory matrix, IDotNugg.Pixel memory pix) internal pure {
        matrix.data[matrix.currentUnsetY][matrix.currentUnsetX] = pix;
    }

    function deleteCurrent(IDotNugg.Matrix memory matrix) internal pure {
        delete matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
    }

    function resetIterator(IDotNugg.Matrix memory matrix) internal pure {
        matrix.currentUnsetX = 0;
        matrix.currentUnsetY = 0;
        matrix.startX = 0;
    }

    function reset(IDotNugg.Matrix memory matrix) internal pure {
        for (; next(matrix); ) delete matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
    }

    function fakeHeight(IDotNugg.Matrix memory matrix) internal pure returns (uint8 res) {
        for (uint256 i = 0; i < (res = uint8(matrix.data.length)); i++) {
            if (!matrix.data[i][0].exists) return uint8(i + 1);
        }
        //   res = uint8(matrix.data.length);
    }

    function fakeWidth(IDotNugg.Matrix memory matrix) internal pure returns (uint8 res) {
        for (uint256 i = 0; i < (res = uint8(matrix.data[0].length)); i++) {
            if (!matrix.data[0][i].exists) return uint8(i) + 1;
        }
        //   res = uint8(matrix.data[0].length);
    }

    function set(
        IDotNugg.Matrix memory matrix,
        bytes memory data,
        IDotNugg.Pixel[] memory pallet,
        uint8 groupWidth
    ) internal pure {
        for (uint256 i = 0; i < data.length; i++) {
            (uint8 colorKey, uint8 len) = data.toUint4(i);
            for (uint256 j = 0; j < len; j++) {
                setCurrent(matrix, pallet[colorKey]);
                next(matrix, groupWidth);
            }
        }

        resetIterator(matrix);
    }

    function addRowsAt(
        IDotNugg.Matrix memory matrix,
        uint8 index,
        uint8 amount
    ) internal pure {
        require(index < matrix.height, 'MAT:ARA:0');

        for (uint256 j = matrix.height - amount - 1; j > index; j--) {
            if (j < index) break;
            if (matrix.data[j].length > 0) matrix.data[j + amount] = matrix.data[j];
        }
        for (uint256 j = index + 1; j < index + amount; j++) {
            matrix.data[j] = matrix.data[index];
        }
    }

    function addColumnsAt(
        IDotNugg.Matrix memory matrix, /// cowboy hat
        uint8 index,
        uint8 amount
    ) internal pure {
        require(index < matrix.width, 'MAT:ACA:0');
        for (uint256 i = 0; i < matrix.height; i++) {
            for (uint256 j = matrix.width - amount - 1; j > index; j--) {
                if (j < index) break;
                if (matrix.data[i][j].exists) matrix.data[i][j + amount] = matrix.data[i][j];
            }
            for (uint256 j = index + 1; j < index + amount; j++) {
                matrix.data[i][j] = matrix.data[i][index];
            }
        }
    }
    // function currentX() internal pure returns (int8 res) {
    //     res = int8(matrix.currentUnsetX) - int8(m.height) / 2;
    // }

    // function currentY() internal pure returns (int8 res) {
    //     res = int8(matrix.currentUnsetY) - int8(m.height) / 2;
    // }
    // function currentX(IDotNugg.Matrix memory matrix) internal pure returns (bool res) {
    //     res = matrix.
    // }

    // function currentUnsetY(IDotNugg.Matrix memory matrix) internal pure returns (bool res) {
    //     res =
    // }
}
