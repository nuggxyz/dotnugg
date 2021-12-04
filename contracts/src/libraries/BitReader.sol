// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/ShiftLib.sol';
import '../libraries/Uint.sol';

import '../../test/Event.sol';

library BitReader {
    using ShiftLib for uint256;
    using Event for uint256;
    using Uint256 for uint256;

    struct Memory {
        uint256[] dat;
        uint256 moves;
        uint256 pos;
    }

    function init(uint256[] memory input) internal view returns (Memory memory m) {
        m.dat = input;
        m.moves = 2;
        input.length.log('input.length');

        m.dat = new uint256[](input[0]);
        console.log('m.data.length', m.dat.length, input[0]);
        for (uint256 i = 1; i < input[0] + 1; i++) {
            input[i].log('input[i]');
            m.dat[input[0] - i] = input[i];
            m.dat[input[0] - i].log('m.dat[input[0] - i - 1]');
        }
    }

    function peek(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.dat[0] & ShiftLib.mask(bits);
    }

    function select(
        Memory memory m,
        uint256 bits,
        string memory name,
        uint256 id
    ) internal view returns (uint256 res) {
        // m.dat[0].log('m.dat[0]');
        res = m.dat[0] & ShiftLib.mask(bits);

        m.dat[0] = m.dat[0] >> bits;
        m.pos += bits;
        if (m.pos >= 128) {
            uint256 ptr = (m.moves / 2);

            if (ptr < m.dat.length) {
                m.dat[0] <<= m.pos - 128;
                // console.log('ptr', ptr);
                uint256 move = m.dat[ptr] & ShiftLib.mask(128);
                m.dat[ptr] >>= 128;
                m.dat[0] |= (move << 128);
                m.dat[0] >>= (m.pos - 128);
                m.moves++;
                m.pos -= 128;
            }
        }
        // console.log(res.toHexString(), m.pos, bits, name);
    }
}

// 01b0fc3f0fc3f0fc3f0fd630fd5440324d0160
