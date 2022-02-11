// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {ShiftLib} from "./ShiftLib.sol";

library BitReader {
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
    //   77471890985702889308711372626335381168072159716100854356054307418634965127169
    //   2873592145

    //     function init2(bytes memory input) internal pure returns (bool err, Memory memory m) {
    //         if (input.length == 0) return (true, m);

    //         m.dat2 = input;
    //     }

    //     function peek2(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
    //         console.log("-----", m.dat2.length, bits);

    //         // uint256 overflow = 68 - ((m.pos + bits) % 68) + (256 - bits);
    //         // console.log(overflow);

    //         res = ShiftLib.select256B(m.dat2, uint64((m.dat2.length) - m.pos));

    //         console.log(res);
    //         res = (res >> (256 - bits)) & ShiftLib.mask(bits);

    //         console.log(res);
    //     }

    //     function select2(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
    //         res = peek2(m, bits);
    //         // bytes memory a = m.dat2;
    //         // assembly {
    //         //     mstore(a, sub(mload(a), bits))
    //         // }
    //         m.pos += (bits % 16);
    //     }
}
