// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

library Pixel {
    // function safePack(
    //     uint256 _rgb,
    //     uint256 _a,
    //     uint256 _id,
    //     uint256 _zindex,
    //     uint256 _feature
    // ) internal pure returns (uint256 res) {
    //     unchecked {
    //         res |= uint256(_feature.safe3()) << 39;
    //         res |= uint256(_zindex.safe4()) << 35;
    //         res |= uint256(_id.safe8()) << 27;
    //         res |= uint256(_rgb) << 3;
    //         res |= uint256(compressA(_a.safe8()));
    //     }
    // }

    function unsafePack(
        uint256 _rgb,
        uint256 _a,
        uint256 _id,
        uint256 _zindex,
        uint256 _feature
    ) internal pure returns (uint256 res) {
        unchecked {
            res |= (_feature & 0x7) << 39;
            res |= (_zindex & 0xf) << 35;
            res |= (_id & 0xff) << 27;
            res |= _rgb << 3;
            res |= compressA(_a & 0xff);
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
        res = ((input & 0x7) == 0x7 ? 255 : ((input & 0x7) * 36));
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
        return input / 36;
    }

    function combine(uint256 base, uint256 mix) internal pure returns (uint256 res) {
        return mix;
        // if (mix.a() == 255 || base.a() == 0) {
        //     res = mix;
        //     return res;
        // }
        // // FIXME - i am pretty sure there is a bug here that causes the non-color pixel data to be deleted
        // res |= uint256((base.r() * (255 - mix.a()) + mix.r() * mix.a()) / 255) << 19;
        // res |= uint256((base.g() * (255 - mix.a()) + mix.g() * mix.a()) / 255) << 11;
        // res |= uint256((base.b() * (255 - mix.a()) + mix.b() * mix.a()) / 255) << 3;
        // res |= 0x7;
    }
}
