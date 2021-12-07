// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';

library Rgba {
    using Bytes for bytes;

    struct RGBA16 {
        uint16 r;
        uint16 g;
        uint16 b;
        uint16 a;
    }

    function combine(IDotNugg.Rgba memory base, IDotNugg.Rgba memory mix) internal pure {
        // if (mix.a == 255 || base.a == 0) {
        if (true) {
            base.r = mix.r;
            base.g = mix.g;
            base.b = mix.b;
            base.a = mix.a;
            return;
        }

        RGBA16 memory baseRGB = RGBA16({r: uint16(base.r), g: uint16(base.g), b: uint16(base.b), a: uint16(base.a)});
        RGBA16 memory mixRGB = RGBA16({r: uint16(mix.r), g: uint16(mix.g), b: uint16(mix.b), a: uint16(mix.a)});

        // uint8 alpha = uint8(255 - (((255 - baseRGB.a) * (255 - mixRGB.a)) / 255));
        base.r = uint8((baseRGB.r * (255 - mixRGB.a) + mixRGB.r * mixRGB.a) / 255);
        base.g = uint8((baseRGB.g * (255 - mixRGB.a) + mixRGB.g * mixRGB.a) / 255);
        base.b = uint8((baseRGB.b * (255 - mixRGB.a) + mixRGB.b * mixRGB.a) / 255);
        base.a = 255;
        //   return IDotNugg.Rgba({r: r, g: g, b: b, a: 255});
    }

    function toUint64(IDotNugg.Rgba memory base) internal pure returns (uint64 res) {
        bytes memory input = abi.encodePacked(base.r, base.g, base.b, base.a);
        return input.toUint64(0);
    }

    function toAscii(IDotNugg.Rgba memory base) internal pure returns (string memory res) {
        bytes memory input = abi.encodePacked(base.r, base.g, base.b, base.a);
        return input.toAscii();
    }

    function equalssss(IDotNugg.Rgba memory base, IDotNugg.Rgba memory next) internal pure returns (bool res) {
        res = base.a == next.a && base.r == next.r && base.g == next.g && base.b == next.b;
    }
}
