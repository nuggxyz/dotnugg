// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "../main.t.sol";

import {Pixel} from "../../core/Pixel.sol";

contract generalTest__PixelType is t {
    function test__general__PixelType__a() public {
        uint256 input = Pixel.safePack(0xaaaaaa, 0xff, 0xaa, 0xa, 0x2);

        assertEq(Pixel.a(input), 0xff);
        assertEq(Pixel.r(input), 0xaa);
        assertEq(Pixel.g(input), 0xaa);
        assertEq(Pixel.b(input), 0xaa);
        assertEq(Pixel.rgba(input), 0xaaaaaaff);
        assertEq(Pixel.f(input), 0x2);
        assertEq(Pixel.z(input), 0xa);
        assertEq(Pixel.id(input), 0xaa);
    }

    function test__general__PixelType__toHexString() public {
        uint256 input = Pixel.safePack(0xaaaaaa, 0xff, 0xaa, 0xa, 0x2);

        assertEq(strings.toHexStringNoPrefix(Pixel.rgba(input), 4), "aaaaaaff");
    }
}
