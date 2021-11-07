// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../lib/DSTest.sol';

import '../../contracts/interfaces/IDotNugg.sol';
import '../../contracts/logic/Matrix.sol';
import '../../contracts/logic/Rgba.sol';

contract MatrixHelperTest is DSTest {
    function test_matrix_create() public {
        uint8 width = 33;
        uint8 height = 33;
        IDotNugg.Matrix memory matrix = Matrix.create(width, height);

        assertEq(width, matrix.data[0].length);
        assertEq(height, matrix.data.length);
    }

    function test_matrix_set() public {
        // arguments
        uint8 width = 33;
        uint8 height = 33;
        bytes memory data = hex'051105110511';
        uint8 groupWidth = 9;
        IDotNugg.Pixel[] memory pallet = new IDotNugg.Pixel[](2);
        pallet[0] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 1, g: 1, b: 1, a: 255}), zindex: 2, exists: true});
        pallet[1] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 255, g: 255, b: 255, a: 27}), zindex: 3, exists: true});
        IDotNugg.Matrix memory matrix = Matrix.create(width, height);

        Matrix.set(matrix, data, pallet, groupWidth);

        uint256 count = 0;
        for (; Matrix.next(matrix); count++) {
            emit log_named_uint('x', matrix.currentUnsetX);
            emit log_named_uint('y', matrix.currentUnsetY);
            emit log_named_string('hex:', Rgba.toAscii(Matrix.current(matrix).rgba));
            emit log_string('-----------');

            assertTrue(Matrix.current(matrix).exists);
            assertEq(matrix.currentUnsetX, count % groupWidth);
            assertEq(matrix.currentUnsetY, count / groupWidth);
        }

        assertEq(count, 18);
    }
}
