// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {Types} from '../types/Types.sol';

import '../libraries/Bytes.sol';
import '../types/Pixel.sol';

library Rgba {
    using Pixel for uint256;

    function combine(uint32 base, uint32 mix) internal pure returns (uint32 res) {
        // if (mix.a == 255 || base.a == 0) {
        if (true) {
            res = mix;
            return res;
        }

        // RGBA16 memory baseRGB = RGBA16({r: uint16(base.r()), g: uint16(base.g), b: uint16(base.b), a: uint16(base.a)});
        // RGBA16 memory mixRGB = RGBA16({r: uint16(mix.r()), g: uint16(mix.g), b: uint16(mix.b), a: uint16(mix.a)});

        // uint8 alpha = uint8(255 - (((255 - baseRGB.a) * (255 - mixRGB.a)) / 255));

        base.r = uint8((base.r() * (255 - mix.a()) + mix.r() * mix.a()) / 255);
        base.g = uint8((base.g() * (255 - mix.a()) + mix.g() * mix.a()) / 255);
        base.b = uint8((base.b() * (255 - mix.a()) + mix.b() * mix.a()) / 255);
        base.a = 255;

        return Types.Rgba({r: r, g: g, b: b, a: 255});
    }
}
