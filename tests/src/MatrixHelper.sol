// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../../contracts/interfaces/IDotNugg.sol';
import '../../contracts/logic/Matrix.sol';

contract MatrixHelper {
    function create(uint8 width, uint8 height) public pure returns (IDotNugg.Matrix memory res) {
        res = Matrix.create(width, height);
    }
}
