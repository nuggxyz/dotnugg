// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';

library MultiSudoArrayType {
    using ShiftLib for uint256;

    struct Memory {
        uint256[] dat;
        uint256 len;
        uint256 pos;
        uint256 main;
    }

    function init(uint256 bits, uint256 length) internal pure returns (Memory memory m) {
        uint256 size = 256 / bits;
        m.len = (length / size) + 1;
        m.dat = new uint256[](m.len);
    }

    function select(Memory memory m, uint256 bits) internal pure returns (uint256 res) {
        res = m.main & ShiftLib.mask(bits);
        m.main = m.main >> bits;
        m.pos += bits;
        if (m.pos >= 128 && m.len > 0) {
            uint256 move = m.dat[0] & ShiftLib.mask(128);
            m.dat[0] >>= 128;
            move <<= 128;
            m.main & move;
        }
    }

    function pull(
        Memory memory m,
        uint256 bits, // 32
        uint256 index //
    ) internal pure returns (uint256 res) {
        require(256 % bits == 0, 'MSA:RES:0');
        uint256 size = 256 / bits;
        res = m.dat[(index / size)].bit(bits, (index % size) * bits);
    }

    function push(
        Memory memory m,
        uint256 bits, // 32
        uint256 index,
        uint256 update
    ) internal pure {
        require(256 % bits == 0, 'MSA:RES:0');
        uint256 size = 256 / bits;
        m.dat[(index / size)] = m.dat[(index / size)].bit(bits, (index % size) * bits, update);
    }
}
