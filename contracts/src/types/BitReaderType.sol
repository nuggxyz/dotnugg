// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';

library BitReaderType {
    using ShiftLib for uint256;

    struct Memory {
        uint256[] dat;
        uint256 moves;
        uint256 pos;
        // uint256 main;
    }

    function init(uint256[] memory input) internal pure returns (Memory memory m) {
        m.dat = input;
        m.moves = 1;
        m.dat = input;
    }

    function peek(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);
    }

    function select(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);
        m.dat[0] = m.dat[0] >> bits;
        m.pos += bits;
        if (m.pos >= 128) {
            uint256 ptr = m.moves / 2;
            uint256 move = m.dat[ptr] & ShiftLib.mask(128);
            m.dat[0] >>= 128;
            move <<= 128;
            m.dat[0] & move;
            m.moves++;
            m.pos = 0;
        }
    }
}
