// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import '../libraries/Bytes.sol';
import '../logic/Rgba.sol';

import '../types/Version.sol';

library Matrix {
    using Bytes for bytes;
    using Rgba for IDotNugg.Rgba;

    function update(IDotNugg.Matrix memory matrix) internal view returns (Version.Memory memory m) {
        Version.initBigMatrix(m, matrix.width);

        for (uint256 index = 0; index < matrix.width * matrix.height; index++) {
            Matrix.next(matrix);
            IDotNugg.Pixel memory pix = Matrix.current(matrix);
            if (pix.rgba.a > 0) {
                uint256 color = pix.rgba.r << 24;
                color |= pix.rgba.g << 16;
                color |= pix.rgba.b << 8;
                color |= pix.rgba.a;
                Version.setBigMatrixPixelAt(m, color, index);
            }
        }
    }

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
        uint8 yoffset,
        uint8 width,
        uint8 height
    ) internal view {
        matrix.currentUnsetX = xoffset;
        matrix.currentUnsetY = yoffset;
        matrix.startX = xoffset;
        matrix.width = width + xoffset;
        matrix.height = height + yoffset;
    }

    function next(IDotNugg.Matrix memory matrix) internal view returns (bool res) {
        res = next(matrix, matrix.width);
    }

    function next(IDotNugg.Matrix memory matrix, uint8 width) internal view returns (bool res) {
        if (matrix.init) {
            if (width <= matrix.currentUnsetX + 1) {
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

    function moveBack(IDotNugg.Matrix memory matrix) internal view {
        matrix.width = uint8(matrix.data[0].length);
        matrix.height = uint8(matrix.data.length);
    }

    function reset(IDotNugg.Matrix memory matrix) internal view {
        for (; next(matrix); ) if (current(matrix).exists) delete matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
        matrix.width = 0;
        matrix.height = 0;
        resetIterator(matrix);
    }

    function set(
        IDotNugg.Matrix memory matrix,
        Version.Memory memory data,
        uint256 groupWidth,
        uint256 groupHeight
    ) internal view {
        uint256 totalLength = 0;
        matrix.height = uint8(groupHeight);
        for (uint256 y = 0; y < groupHeight; y++) {
            for (uint256 x = 0; x < groupHeight; x++) {
                next(matrix, uint8(groupWidth));

                (, uint256 color, uint256 zindex) = Version.getPalletColorAt(data, Version.getPixelAt(data, x, y));
                setCurrent(
                    matrix,
                    IDotNugg.Pixel({
                        rgba: IDotNugg.Rgba({
                            r: uint8(color >> 24) & 0xff,
                            g: uint8(color >> 16) & 0xff,
                            b: uint8(color >> 8) & 0xff,
                            a: uint8(color >> 0) & 0xff
                        }),
                        zindex: int8(uint8(zindex)) - 3,
                        exists: true
                    })
                );
            }
        }

        // require(totalLength % groupWidth == 0, 'MTRX:SET:0');
        // require(totalLength / groupWidth == groupHeight, 'MTRX:SET:1');

        // // matrix.width = uint256(groupWidth);
        // // matrix.height = uint8(totalLength / groupWidth);

        resetIterator(matrix);
    }

    function addRowsAt(
        IDotNugg.Matrix memory matrix,
        uint8 index,
        uint8 amount
    ) internal view {
        require(index < matrix.data.length, 'MAT:ARA:0');
        for (uint256 j = matrix.width; j > index; j--) {
            if (j < index) break;
            if (matrix.data[j].length > 0) matrix.data[j + amount] = matrix.data[j];
        }
        // "<=" is because this loop needs to run [amount] times
        for (uint256 j = index + 1; j <= index + amount; j++) {
            //
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
        for (uint256 i = 0; i < matrix.width; i++) {
            for (uint256 j = matrix.width; j > index; j--) {
                if (j < index) break;
                //  if (matrix.data[i][j].exists) @note - do not completly understand this.. but it fixes a bug
                matrix.data[i][j + amount] = matrix.data[i][j];
            }
            // "<=" is because this loop needs to run [amount] times
            for (uint256 j = index + 1; j <= index + amount; j++) {
                matrix.data[i][j] = matrix.data[i][index];
            }
        }
        matrix.width += amount;
    }
}
