// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {ShiftLib} from "../libraries/ShiftLib.sol";

library DotnuggV1Reader {
    using ShiftLib for uint256;

    struct Memory {
        uint256[] dat;
        uint256 moves;
        uint256 pos;
    }

    function init(uint256[] memory input) internal pure returns (bool err, Memory memory m) {
        if (input.length == 0) return (true, m);

        m.dat = input;

        m.moves = 2;

        m.dat = new uint256[](input.length);

        for (uint256 i = input.length; i > 0; i--) {
            m.dat[i - 1] = input[input.length - i];
        }
    }

    function peek(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);
    }

    function select(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
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
