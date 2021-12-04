// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';

library PixelType {
    using ShiftLib for uint256;

    struct Memory {
        uint256 dat;
    }

    function pixel_rgba(uint256 input) internal view returns (uint256 res) {
        res = pixel_a_decompress(input).bit(32, 0);
    }

    function pixel_a_decompress(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 0, (pixel_a(input) * 255) / 10);
    }

    function pixel_r(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 24);
    }

    function pixel_r(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 24, update);
    }

    function pixel_g(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 16);
    }

    function pixel_g(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 16, update);
    }

    function pixel_b(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 8);
    }

    function pixel_b(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 8, update);
    }

    function pixel_a_compressed(uint256 input) internal view returns (uint256 res) {
        res = input.bit(4, 4);
    }

    function pixel_a_compressed(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 4, update);
    }

    function pixel_a(uint256 input) internal view returns (uint256 res) {
        res = pixel_a_decompress(input).bit(8, 0);
    }

    function pixel_a(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 4, (update * 10) / 255);
    }

    function pixel_zindex(uint256 input) internal view returns (uint256 res) {
        res = input.bit(3, 1);
    }

    function pixel_zindex(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(3, 1, update);
    }

    function pixel_exists(uint256 input) internal view returns (bool res) {
        res = input.bit1(0);
    }

    function pixel_exists(uint256 input, bool update) internal view returns (uint256 res) {
        res = input.bit1(0, update);
    }
}
