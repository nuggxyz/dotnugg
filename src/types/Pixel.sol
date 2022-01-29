// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {SafeCastLib} from '../libraries/SafeCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';

library Pixel {
    using SafeCastLib for uint256;

    function safePack(
        uint256 _rgb,
        uint256 _a,
        uint256 _id,
        uint256 _zindex,
        uint256 _feature
    ) internal pure returns (uint256 res) {
        unchecked {
            res |= uint256(_feature.safe3()) << 39;
            res |= uint256(_zindex.safe4()) << 35;
            res |= uint256(_id.safe8()) << 27;
            res |= uint256(_rgb) << 3;
            res |= uint256(compressA(_a.safe8()));
        }
    }

    function unsafePack(
        uint256 _rgb,
        uint256 _a,
        uint256 _id,
        uint256 _zindex,
        uint256 _feature
    ) internal pure returns (uint256 res) {
        unchecked {
            res |= _feature << 39;
            res |= _zindex << 35;
            res |= _id << 27;
            res |= _rgb << 3;
            res |= compressA(uint8(_a));
        }
    }

    function rgba(uint256 input) internal pure returns (uint256 res) {
        return ((input << 5) & 0xffffff_00) | a(input);
    }

    function r(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 19) & 0xff;
    }

    function g(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 11) & 0xff;
    }

    function b(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 3) & 0xff;
    }

    // 3 bits
    function a(uint256 input) internal pure returns (uint256 res) {
        res = decompressA(uint8(input & 0x7));
    }

    // this is 1-8 so 3 bits
    function id(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 27) & 0xff;
    }

    // 18 3,3,4 && 8
    // this is 1-16 so 4 bits
    function z(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 35) & 0xf;
    }

    // this is 1-8 so 3 bits
    function f(uint256 input) internal pure returns (uint256 res) {
        res = (input >> 39) & 0x7;
    }

    /// @notice check for if a pixel exists
    /// @dev for a pixel to exist a must be > 0, so we can safely assume that if we see
    /// no data it is empty or a transparent pixel we do not need to process
    function e(uint256 input) internal pure returns (bool res) {
        res = input != 0x00;
    }

    /// @notice converts an 8 bit (0-255) value into a 3 bit value (0-7)
    /// @dev a compressed value of 7 is equivilent to 255, and a compressed 0 is 0
    function compressA(uint256 input) internal pure returns (uint256 res) {
        return input.safe8() / 36;
    }

    /// @notice converts an 8 bit value into a 3 bit value
    function decompressA(uint256 input) internal pure returns (uint256 res) {
        if (input == 7) return 255;
        else return input.safe3() * 36;
    }
}
