pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';

library MultiSudoArrayType {
    using ShiftLib for uint256;

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    struct Memory {
        uint256[] dat;
    }

    function init(uint256 bits, uint256 length) internal returns (Memory memory m) {
        uint256 size = 256 / bits;
        // emit log_named_uint('SIZE', size);
        m.dat = new uint256[]((length / size) + 1);
    }

    function pull(
        Memory memory m,
        uint256 bits, // 32
        uint256 index //
    ) internal returns (uint256 res) {
        require(256 % bits == 0, 'MSA:RES:0');
        uint256 size = 256 / bits;
        res = m.dat[(index / size)].bit(bits, (index % size) * bits);
    }

    function push(
        Memory memory m,
        uint256 bits, // 32
        uint256 index,
        uint256 update
    ) internal {
        require(256 % bits == 0, 'MSA:RES:0');
        uint256 size = 256 / bits;
        m.dat[(index / size)] = m.dat[(index / size)].bit(bits, (index % size) * bits, update);
    }
}
