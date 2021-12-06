// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/ShiftLib.sol';

library BitReader {
    using ShiftLib for uint256;
    using Event for uint256;
    using Uint256 for uint256;

    struct Memory {
        uint256[] dat;
        uint256 moves;
        uint256 pos;
    }

    function init(uint256[] memory input) internal pure returns (Memory memory m) {
        m.dat = input;

        m.moves = 2;

        m.dat = new uint256[](input[0]);

        for (uint256 i = 1; i < input[0] + 1; i++) {
            m.dat[input[0] - i] = input[i];
        }
    }

    function peek(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);
    }

    function select(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);

        m.dat[0] = m.dat[0] >> bits;

        m.pos += bits;

        if (m.pos >= 128) {
            uint256 ptr = (m.moves / 2);
            if (ptr < m.dat.length) {
                m.dat[0] <<= m.pos - 128;
                uint256 move = m.dat[ptr] & ShiftLib.mask(128);
                m.dat[ptr] >>= 128;
                m.dat[0] |= (move << 128);
                m.dat[0] >>= (m.pos - 128);
                m.moves++;
                m.pos -= 128;
            }
        }
    }
}
