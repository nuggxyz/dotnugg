// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import './MultiSudoArrayType.sol';

library PalletType {
    using MultiSudoArrayType for MultiSudoArrayType.Memory;
    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);
    uint256 constant BYTE_LEN = 32;

    struct Memory {
        MultiSudoArrayType.Memory dat;
    }

    function load(uint256 l) internal returns (Memory memory m) {
        m.dat = MultiSudoArrayType.init(BYTE_LEN, l);
        // emit log_named_uint('AAYYYYYEEEEEE', l);
    }

    function pixel(Memory memory m, uint256 x) internal returns (uint256 pix) {
        pix = m.dat.pull(BYTE_LEN, x);
    }

    function pixel(
        Memory memory m,
        uint256 x,
        uint256 update
    ) internal {
        m.dat.push(BYTE_LEN, x, update);
    }
}

//     function load(uint256 l) internal  returns (uint256[] memory m) {
//     m = new uint256[]((l / 8) + 1);
// }

// function pixel(
//     uint256[] memory m,
//     uint256 x //
// ) internal  returns (uint256 pix) {
//     pix = m[(x / 8)].bit32((x % 8) * 32);
// }

// function pixel(
//     uint256[] memory m,
//     uint256 x,
//     // uint256 y,
//     uint256 update
// ) internal  {
//     require(update <= 0xfffffff, 'MT:PS:0');
//     m[(x / 8)] = m[(x / 8)].bit32((x % 8) * 32, update);
// }
