pragma solidity 0.8.4;

import '../libraries/ShiftLib.sol';

library SudoArrayType {
    using ShiftLib for uint256;

    struct Memory {
        uint256 dat;
    }

    function push(
        Memory memory m,
        uint256 bit,
        uint256 offset,
        uint256 index,
        uint256 val
    ) internal {
        m.dat = m.dat.bit(bit, offset + (bit * index), val);
    }

    function pull(
        Memory memory m,
        uint256 bit,
        uint256 offset,
        uint256 index
    ) internal returns (uint256 res) {
        res = m.dat.bit(bit, offset + (bit * index));
    }
}
