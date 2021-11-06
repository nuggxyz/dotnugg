// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';

library Colors {
    using Bytes for bytes;

    struct RGBA16 {
        uint16 r;
        uint16 g;
        uint16 b;
        uint16 a;
    }

    function combine(IDotNugg.Rgba memory base, IDotNugg.Rgba memory mix) internal pure returns (IDotNugg.Rgba memory res, bool) {
        if (mix.a == 255) {
            return (mix, false);
        }

        RGBA16 memory baseRGB = RGBA16({r: uint16(base.r), g: uint16(base.g), b: uint16(base.b), a: uint16(base.a)});
        RGBA16 memory mixRGB = RGBA16({r: uint16(mix.r), g: uint16(mix.g), b: uint16(mix.b), a: uint16(mix.a)});

        // uint8 alpha = uint8(255 - (((255 - baseRGB.a) * (255 - mixRGB.a)) / 255));
        uint8 red = uint8((baseRGB.r * (255 - mixRGB.a) + mixRGB.r * mixRGB.a) / 255);
        uint8 green = uint8((baseRGB.g * (255 - mixRGB.a) + mixRGB.g * mixRGB.a) / 255);
        uint8 blue = uint8((baseRGB.b * (255 - mixRGB.a) + mixRGB.b * mixRGB.a) / 255);

        return (IDotNugg.Rgba({r: red, g: green, b: blue, a: 255}), true);
    }

    function toUint64(IDotNugg.Rgba memory base) internal pure returns (uint64 res) {
        bytes memory input = abi.encodePacked(base.r, base.g, base.b, base.a);
        return input.toUint64(0);
    }

    function toAscii(IDotNugg.Rgba memory base) internal pure returns (string memory res) {
        bytes memory input = abi.encodePacked(base.r, base.g, base.b, base.a);
        return input.toAscii();
    }

    function combine(bytes memory base, bytes memory mix) internal pure returns (IDotNugg.Rgba memory res, bool) {
        IDotNugg.Rgba memory baseRGB = IDotNugg.Rgba({
            r: base.toUint8(0),
            g: base.toUint8(1),
            b: base.toUint8(2),
            a: base.length > 3 ? base.toUint8(3) : uint8(225)
        });
        IDotNugg.Rgba memory mixRGB = IDotNugg.Rgba({r: mix.toUint8(0), g: mix.toUint8(1), b: mix.toUint8(2), a: mix.length > 3 ? mix.toUint8(3) : uint8(225)});

        return combine(baseRGB, mixRGB);
    }
}
