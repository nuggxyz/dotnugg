// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import '../libraries/Bytes.sol';
import '../logic/Rgba.sol';

import '../test/Console.sol';

library Matrix {
    using Bytes for bytes;
    using Rgba for IDotNugg.Rgba;

    function create(uint8 width, uint8 height) internal view returns (IDotNugg.Matrix memory res) {
        require(width % 2 == 1 && height % 2 == 1, 'ML:C:0');

        res.data = new IDotNugg.Pixel[][](height);
        for (uint8 i = 0; i < height; i++) {
            res.data[i] = new IDotNugg.Pixel[](width);
        }
    }

    function moveTo(
        IDotNugg.Matrix memory matrix,
        uint8 xoffset,
        uint8 yoffset
    ) internal view {
        matrix.currentUnsetX = xoffset;
        matrix.currentUnsetY = yoffset;
        matrix.startX = xoffset;
    }

    function next(IDotNugg.Matrix memory matrix) internal view returns (bool res) {
        res = next(matrix, matrix.width);
    }

    function next(IDotNugg.Matrix memory matrix, uint8 width) internal view returns (bool res) {
        if (matrix.init) {
            if (width == matrix.currentUnsetX + 1) {
                if (matrix.height == matrix.currentUnsetY + 1) {
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

    function current(IDotNugg.Matrix memory matrix) internal view returns (IDotNugg.Pixel memory res) {
        res = matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
    }

    function setCurrent(IDotNugg.Matrix memory matrix, IDotNugg.Pixel memory pix) internal view {
        matrix.data[matrix.currentUnsetY][matrix.currentUnsetX] = pix;
    }

    function resetIterator(IDotNugg.Matrix memory matrix) internal view {
        matrix.currentUnsetX = 0;
        matrix.currentUnsetY = 0;
        matrix.startX = 0;
        matrix.init = false;
    }

    function reset(IDotNugg.Matrix memory matrix) internal view {
        for (; next(matrix); ) if (current(matrix).exists) delete matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
        matrix.width = 0;
        matrix.height = 0;
        resetIterator(matrix);
    }

    function set(
        IDotNugg.Matrix memory matrix,
        bytes memory data,
        IDotNugg.Pixel[] memory pallet,
        uint8 groupWidth
    ) internal view {
        uint256 totalLength = 0;
        for (uint256 i = 0; i < data.length; i++) {
            (uint8 colorKey, uint8 len) = data.toUint4(i);
            len++;
            totalLength += len;
            for (uint256 j = 0; j < len; j++) {
                next(matrix, groupWidth);
                setCurrent(matrix, pallet[colorKey]);
                console.log('yo', current(matrix).rgba.toAscii());
            }
        }

        require(totalLength % groupWidth == 0, 'MTRX:SET:0');

        matrix.width = groupWidth;
        matrix.height = uint8(totalLength / groupWidth);

        resetIterator(matrix);
    }

    function addRowsAt(
        IDotNugg.Matrix memory matrix,
        uint8 index,
        uint8 amount
    ) internal view {
        require(index < matrix.data.length, 'MAT:ARA:0');
        for (uint256 j = matrix.data.length - amount - 1; j > index; j--) {
            if (j < index) break;
            if (matrix.data[j].length > 0) matrix.data[j + amount] = matrix.data[j];
        }
        for (uint256 j = index + 1; j < index + amount; j++) {
            matrix.data[j] = matrix.data[index];
        }
        matrix.height += amount;
    }

    function addColumnsAt(
        IDotNugg.Matrix memory matrix, /// cowboy hat
        uint8 index,
        uint8 amount
    ) internal view {
        require(index < matrix.data[0].length, 'MAT:ACA:0');
        for (uint256 i = 0; i < matrix.height; i++) {
            for (uint256 j = matrix.data[0].length - amount - 1; j > index; j--) {
                if (j < index) break;
                if (matrix.data[i][j].exists) matrix.data[i][j + amount] = matrix.data[i][j];
            }
            for (uint256 j = index + 1; j < index + amount; j++) {
                matrix.data[i][j] = matrix.data[i][index];
            }
        }
        matrix.width += amount;
    }
}
