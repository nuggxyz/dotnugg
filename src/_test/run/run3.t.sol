// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.12;

contract ImplementerRun {
    // function run() public returns (uint256 res) {
    //     assembly {
    //         res := caller()
    //         mstore(0x00, res)
    //         res := keccak256(0x00, 0x20)
    //         res := shl(0x44, res)
    //         res := shr(0x96, res)
    //         mstore(0x00, res)
    //     }
    //     res = 0x45 * res;
    //     res >> 0x04;
    //     res << 0x99;
    //     return res;
    // }
}

// res := and(res, sub(shl(160, 1), 1))
