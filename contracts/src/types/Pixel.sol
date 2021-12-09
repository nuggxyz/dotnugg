// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

library Pixel {
    function r(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 24) & 0xff;
    }

    function g(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 16) & 0xff;
    }

    function b(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 8) & 0xff;
    }

    function a(uint256 input) internal pure returns (uint256 res) {
        res = input & 0xff;
    }

    function z(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 32) & 0xf;
    }

    function f(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 36) & 0xf;
    }

    function e(uint256 input) internal pure returns (bool res) {
        res = input != 0x00;
    }
}
