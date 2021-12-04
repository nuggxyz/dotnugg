// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
import '../types/PixelType.sol';

library Rgba {
    using PixelType for uint256;

    function combine(uint256 base, uint256 mix) internal view returns (uint256 res) {
        if (mix.pixel_a() == 255 || base.pixel_a() == 0) {
            return mix;
        }

        unchecked {
            res = res
                .pixel_r((base.pixel_r() * (255 - mix.pixel_a()) + mix.pixel_r() * mix.pixel_a()) / 255)
                .pixel_g((base.pixel_g() * (255 - mix.pixel_a()) + mix.pixel_g() * mix.pixel_a()) / 255)
                .pixel_b((base.pixel_b() * (255 - mix.pixel_a()) + mix.pixel_b() * mix.pixel_a()) / 255)
                .pixel_a(255);
        }
    }

    function ascii(uint256 base) internal view returns (string memory res) {
        res = string(abi.encodePacked(base.pixel_rgba()));
    }

    function equals(uint256 base, uint256 next) internal view returns (bool res) {
        res = base.pixel_rgba() == next.pixel_rgba();
    }
}
