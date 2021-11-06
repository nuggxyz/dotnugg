// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';

library Matrix {
    function create(uint8 width, uint8 height) internal pure returns (IDotNugg.Matrix memory res) {
        require(width % 2 == 1 && height % 2 == 1, 'ML:C:0');

        res = IDotNugg.Matrix({data: new IDotNugg.Pixel[][](height), width: width, height: height, currentUnsetX: 0, currentUnsetY: 0, init: false});

        for (uint8 i = 0; i < height; i++) {
            res.data[i] = new IDotNugg.Pixel[](width);
        }
    }

    function at(
        IDotNugg.Matrix memory m,
        int8 x,
        int8 y
    ) internal pure returns (IDotNugg.Pixel memory res) {
        res = m.data[uint8(y + int8(m.height) / 2)][uint8(x + int8(m.width) / 2)];
    }

    function next(IDotNugg.Matrix memory matrix) internal pure returns (bool res) {
        if (!matrix.init) {
            if (matrix.width == matrix.currentUnsetX + 1) {
                if (matrix.height == matrix.currentUnsetY + 1) {
                    return false;
                }
                matrix.currentUnsetX = 0;
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

    function reset(IDotNugg.Matrix memory matrix) internal pure {
        matrix.currentUnsetX = 0;
        matrix.currentUnsetY = 0;
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
