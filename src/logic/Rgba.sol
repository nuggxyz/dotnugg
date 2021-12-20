// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {Types} from '../types/Types.sol';

import '../types/Pixel.sol';

library Rgba {
    using Pixel for uint256;

    function combine(uint256 base, uint256 mix) internal pure returns (uint256 res) {
        if (mix.a() == 255 || base.a() == 0) {
            res = mix;
            return res;
        }

        res |= uint256((base.r() * (255 - mix.a()) + mix.r() * mix.a()) / 255) << 24;
        res |= uint256((base.g() * (255 - mix.a()) + mix.g() * mix.a()) / 255) << 16;
        res |= uint256((base.b() * (255 - mix.a()) + mix.b() * mix.a()) / 255) << 8;
        res |= 255;
    }
}
