// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;
import {ShiftLib} from './ShiftLib.sol';

library SafeCastLib {
    function safe252(uint256 x) internal pure returns (uint256 y) {
        require(x <= ShiftLib.mask(252), 'SC:252');
        return x;
    }

    function safe160(uint256 x) internal pure returns (uint160 y) {
        require(x <= type(uint160).max);
        y = uint160(x);
    }

    function safe96(uint256 x) internal pure returns (uint96 y) {
        require(x <= type(uint96).max);
        y = uint96(x);
    }

    function safe64(uint256 x) internal pure returns (uint64 y) {
        require(x <= type(uint64).max);
        y = uint64(x);
    }

    function safe32(uint256 x) internal pure returns (uint32 y) {
        require(x <= type(uint32).max);
        y = uint32(x);
    }

    function safe16(uint256 x) internal pure returns (uint16 y) {
        require(x <= type(uint16).max);
        y = uint16(x);
    }

    function safe8(uint256 x) internal pure returns (uint8 y) {
        require(x <= type(uint8).max);
        y = uint8(x);
    }

    function safe6(uint256 x) internal pure returns (uint8 y) {
        require(x <= 0xf7);
        y = uint8(x);
    }

    function safe4(uint256 x) internal pure returns (uint8 y) {
        require(x <= 0xf);
        y = uint8(x);
    }

    function safe3(uint256 x) internal pure returns (uint8 y) {
        require(x <= 0x7);
        y = uint8(x);
    }
}
