// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Parser as Parser} from "./DotnuggV1Parser.sol";

library DotnuggV1Matrix {
    using Parser for Parser.Memory;

    struct Memory {
        uint8 width;
        uint8 height;
        Parser.Memory version;
        uint8 currentUnsetX;
        uint8 currentUnsetY;
        bool init;
        uint8 startX;
    }

    function create(uint8 width, uint8 height) internal pure returns (Memory memory res) {
        require(width % 2 == 1 && height % 2 == 1, "ML:C:0");

        Parser.initBigMatrix(res.version, width);
        res.version.setWidth(width, height);
    }

    function moveTo(
        Memory memory matrix,
        uint8 xoffset,
        uint8 yoffset,
        uint8 width,
        uint8 height
    ) internal pure {
        matrix.currentUnsetX = xoffset;
        matrix.currentUnsetY = yoffset;
        matrix.startX = xoffset;
        matrix.width = width + xoffset;
        matrix.height = height + yoffset;
    }

    function next(Memory memory matrix) internal pure returns (bool res) {
        res = next(matrix, matrix.width);
    }

    function next(Memory memory matrix, uint8 width) internal pure returns (bool res) {
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

    function current(Memory memory matrix) internal pure returns (uint256 res) {
        res = matrix.version.getBigMatrixPixelAt(matrix.currentUnsetX, matrix.currentUnsetY);
    }

    function setCurrent(Memory memory matrix, uint256 pixel) internal pure {
        matrix.version.setBigMatrixPixelAt(matrix.currentUnsetX, matrix.currentUnsetY, pixel);
    }

    function resetIterator(Memory memory matrix) internal pure {
        matrix.currentUnsetX = 0;
        matrix.currentUnsetY = 0;
        matrix.startX = 0;
        matrix.init = false;
    }

    function moveBack(Memory memory matrix) internal pure {
        (uint256 width, uint256 height) = matrix.version.getWidth();
        matrix.width = uint8(width);
        matrix.height = uint8(height);
    }

    function set(
        Memory memory matrix,
        Parser.Memory memory data,
        uint256 groupWidth,
        uint256 groupHeight
    ) internal pure {
        matrix.height = uint8(groupHeight);

        for (uint256 y = 0; y < groupHeight; y++) {
            for (uint256 x = 0; x < groupWidth; x++) {
                next(matrix, uint8(groupWidth));
                uint256 col = Parser.getPixelAt(data, x, y);
                if (col != 0) {
                    (uint256 yo, , ) = Parser.getPalletColorAt(data, col);

                    setCurrent(matrix, yo);
                } else {
                    setCurrent(matrix, 0x0000000000);
                }
            }
        }

        matrix.width = uint8(groupWidth);

        resetIterator(matrix);
    }

    function addRowsAt(
        Memory memory matrix,
        uint8 index,
        uint8 amount
    ) internal pure {
        for (uint256 i = 0; i < matrix.height; i++) {
            for (uint256 j = matrix.height; j > index; j--) {
                if (j < index) break;
                matrix.version.setBigMatrixPixelAt(i, j + amount, matrix.version.getBigMatrixPixelAt(i, j));
            }
            // "<=" is because this loop needs to run [amount] times
            for (uint256 j = index + 1; j <= index + amount; j++) {
                matrix.version.setBigMatrixPixelAt(i, j, matrix.version.getBigMatrixPixelAt(i, index));
            }
        }
        matrix.height += amount;
    }

    function addColumnsAt(
        Memory memory matrix,
        uint8 index,
        uint8 amount
    ) internal pure {
        // require(index < matrix.data[0].length, 'MAT:ACA:0');
        for (uint256 i = 0; i < matrix.width; i++) {
            for (uint256 j = matrix.width; j > index; j--) {
                if (j < index) break;
                matrix.version.setBigMatrixPixelAt(j + amount, i, matrix.version.getBigMatrixPixelAt(j, i));
            }
            // "<=" is because this loop needs to run [amount] times
            for (uint256 j = index + 1; j <= index + amount; j++) {
                matrix.version.setBigMatrixPixelAt(j, i, matrix.version.getBigMatrixPixelAt(index, i));
            }
        }
        matrix.width += amount;
    }
}
