// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';
import './MatrixType.sol';

library ContentType {
    struct Memory {
        uint256[] dat;
    }

    // function push(
    //     Memory memory m,
    //     uint256 bit,
    //     uint256 offset,
    //     uint256 index,
    //     uint256 val
    // ) internal pure {
    //     m.dat = m.dat.bit(bit, offset + (bit * index), val);
    // }

    // function pull(
    //     Memory memory m,
    //     uint256 bit,
    //     uint256 offset,
    //     uint256 index
    // ) internal pure returns (uint256 res) {
    //     res = m.dat.bit(bit, offset + (bit * index));
    // }
}
