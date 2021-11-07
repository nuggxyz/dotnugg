// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "../lib/DSTest.sol";

import "./MatrixHelper.sol";
import '../../contracts/interfaces/IDotNugg.sol';

contract MatrixHelperTest is DSTest {
    MatrixHelper matrixHelper;

    function setUp() public {
        matrixHelper = new MatrixHelper();
    }

    function test_create() public {
        uint8 width = 33;
        uint8 height = 33;
        IDotNugg.Matrix memory matrix = matrixHelper.create(width, height);

        assertEq(width, matrix.data[0].length);
        assertEq(height, matrix.data.length);
    }
}
