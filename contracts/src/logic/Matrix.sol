// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../types/MatrixType.sol';

import '../logic/Rgba.sol';

import '../../test/Event.sol';

library Matrix {
    using Event for uint256;

    using Bytes for bytes;
    using ShiftLib for uint256;
    using ShiftLib for uint256[];

    using MatrixType for MatrixType.Memory;

    using PalletType for PalletType.Memory;

    using PixelType for uint256;
    using PalletType for uint256[];
    using MatrixType for uint256;

    function create(uint256 width, uint256 height) internal returns (MatrixType.Memory memory res) {
        require(width % 2 == 1 && height % 2 == 1, 'ML:C:0');
        // emit log_named_uint('HERE333333333', width);

        res = MatrixType.matrix_load(width, height);
        width.log('Matrix.create: width');
        // emit log_named_uint('HERE44444444', width);
    }

    function moveTo(
        MatrixType.Memory memory m,
        uint256 xoffset,
        uint256 yoffset,
        uint256 width,
        uint256 height
    ) internal {
        m.data = m.data.matrix_currentUnsetX(xoffset).matrix_currentUnsetY(yoffset).matrix_startX(xoffset).matrix_width(width + xoffset).matrix_height(
            height + yoffset
        );
    }

    function next(MatrixType.Memory memory m) internal returns (bool res) {
        res = next(m, m.data.matrix_width());
    }

    function next(MatrixType.Memory memory m, uint256 width) internal returns (bool res) {
        require(width <= 0xff, 'M2:N:0');

        uint256 data = m.data;

        if (data.matrix_init()) {
            if (width <= data.matrix_currentUnsetX() + 1) {
                if (data.matrix_height() == data.matrix_currentUnsetY() + 1) {
                    return false;
                }
                data = data.matrix_currentUnsetX(data.matrix_startX()).matrix_currentUnsetY(data.matrix_currentUnsetY() + 1); // 0 by default
            } else {
                data = data.matrix_currentUnsetX(data.matrix_currentUnsetX() + 1);
            }
        } else {
            data = data.matrix_init(true);
        }

        res = true;
        m.data = data;
    }

    function current(MatrixType.Memory memory m) internal returns (uint256 res) {
        //   console.log('OVERFLOW?', matrix.currentUnsetY, matrix.currentUnsetX);
        //   console.log('MATRIXX', matrix.height, matrix.width);
        res = m.matrix_pixel(m.data.matrix_currentUnsetX(), m.data.matrix_currentUnsetY());
    }

    function setCurrent(MatrixType.Memory memory m, uint256 pix) internal {
        m.matrix_pixel(m.data.matrix_currentUnsetX(), m.data.matrix_currentUnsetY(), pix);
    }

    function resetIterator(MatrixType.Memory memory m) internal {
        m.data = m.data.matrix_currentUnsetX(0).matrix_currentUnsetY(0).matrix_startX(0).matrix_init(false);
    }

    function moveBack(MatrixType.Memory memory matrix) internal {
        //       matrix.width = uint8(matrix.data[0].length);
        // matrix.height = uint8(matrix.data.length);
        // matrix.data = .width = uint256(matrix.data[0].length); // TODO
        // matrix.data = .height = uint256(matrix.data.matrix_length);

        matrix.data = matrix.data.matrix_width(matrix.data.matrix_og_width()).matrix_height(matrix.data.matrix_og_height());
    }

    // function reset(IDotNugg.Matrix memory matrix) internal  {
    //     for (; next(matrix); ) if (current(matrix).exists()) delete matrix.data[matrix.currentUnsetY][matrix.currentUnsetX];
    //     matrix.width = 0;
    //     matrix.height = 0;
    //     resetIterator(matrix);
    // }

    function set(
        MatrixType.Memory memory m,
        bytes memory data,
        PalletType.Memory memory pallet,
        uint256 groupWidth,
        uint256 groupHeight
    ) internal {
        uint256 totalLength = 0;
        uint256 matrixData = m.data;
        // uint256 data =
        matrixData = matrixData.matrix_height(groupHeight).matrix_og_height(groupHeight);

        for (uint256 i = 0; i < data.length; i++) {
            (uint8 colorKey, uint8 len) = data.toUint4(i);
            // if (len == 0) break;
            uint256(len).log('len');
            uint256(colorKey).log('colorKey');
            len++;
            totalLength += len;
            // groupHeight++;
            for (uint256 j = 0; j < len; j++) {
                next(m, groupWidth);
                setCurrent(m, pallet.pixel(colorKey));
            }
        }

        totalLength.log('totalLength');
        groupWidth.log('groupWidth');

        require(totalLength % groupWidth == 0, 'MTRX:SET:0');

        require(totalLength / groupWidth == groupHeight, 'MTRX:SET:1');

        matrixData = matrixData.matrix_width(groupWidth).matrix_og_width(groupWidth);

        m.data = matrixData;

        // MIGHT NEED THIS
        // matrix.height = uint256(totalLength / groupWidth);

        resetIterator(m);
    }

    // function addRowsAt(
    //     MatrixType.Memory memory m,
    //     uint256 index,
    //     uint256 amount
    // ) internal  {
    //     uint256 matrixData = m.data;

    //     require(index < m.pixels.length, 'MAT:ARA:0');

    //     for (uint256 j = matrixData.matrix_width(); j > index; j--) {
    //         if (j < index) break;
    //         if (m.pixels[j].dat.dat.length > 0) m.pixels[j + amount] = m.pixels[j];
    //     }
    //     // "<=" is because this loop needs to run [amount] times
    //     for (uint256 j = index + 1; j <= index + amount; j++) {
    //         //
    //         m.pixels[j] = m.pixels[index];
    //     }
    //     matrixData = matrixData.height(matrixData.height() + amount);

    //     m.data = matrixData;
    // }

    // function addColumnsAt(
    //     MatrixType.Memory memory m, /// cowboy hat
    //     uint256 index,
    //     uint256 amount
    // ) internal  {
    //     require(index < m.pixels[0].length, 'MAT:ACA:0');

    //     for (uint256 i = 0; i < m.data.matrix_width(); i++) {
    //         for (uint256 j = m.data.matrix_width(); j > index; j--) {
    //             if (j < index) break;
    //             //  if (matrix.data[i][j].exists) @note - do not completly understand this.. but it fixes a bug
    //             // matrix.data[i][j + amount] = matrix.data[i][j];

    //             m.pixel(j + amount, i, m.pixel(j, i));
    //         }
    //         // "<=" is because this loop needs to run [amount] times
    //         for (uint256 j = index + 1; j <= index + amount; j++) {
    //             // matrix.data[i][j] = matrix.data[i][index];

    //             m.pixel(j, i, m.pixel(index, i));
    //         }
    //     }
    //     // matrix.width += amount;

    //     m.data = m.data.matrix_width(m.data.matrix_width() + amount);
    // }
}
