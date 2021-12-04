// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';

library MatrixType {
    using ShiftLib for uint256;
    using PalletType for PalletType.Memory;

    struct Memory {
        PalletType.Memory[] pixels;
        uint256 data;
    }

    function matrix_load(uint256 w, uint256 h) internal view returns (Memory memory m) {
        m.pixels = new PalletType.Memory[](h);
        for (uint256 i = 0; i < w; i++) {
            // emit log_named_uint('GOTTEM', h);

            m.pixels[i] = PalletType.load(w);
            // h--;
        }
    }

    function matrix_pixel(
        Memory memory m,
        uint256 x,
        uint256 y
    ) internal view returns (uint256 pix) {
        pix = m.pixels[y].pixel(x);
    }

    function matrix_pixel(
        Memory memory m,
        uint256 x,
        uint256 y,
        uint256 update
    ) internal view {
        m.pixels[y].pixel(x, update);
    }

    function matrix_active_pixel(Memory memory m) internal view returns (uint256 pix) {
        pix = m.pixels[matrix_currentUnsetY(m.data)].pixel(matrix_currentUnsetX(m.data));
    }

    function matrix_active_pixel(Memory memory m, uint256 update) internal view {
        m.pixels[matrix_currentUnsetY(m.data)].pixel(matrix_currentUnsetX(m.data), update);
    }

    function matrix_width(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 0);
    }

    function matrix_width(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 0, update);
    }

    function matrix_height(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 16);
    }

    function matrix_height(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 16, update);
    }

    function matrix_currentUnsetX(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 24);
    }

    function matrix_currentUnsetX(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 24, update);
    }

    function matrix_currentUnsetY(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 32);
    }

    function matrix_currentUnsetY(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 32, update);
    }

    function matrix_startX(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 40);
    }

    function matrix_startX(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 40, update);
    }

    function matrix_init(uint256 input) internal view returns (bool res) {
        res = input.bit1(48);
    }

    function matrix_init(uint256 input, bool update) internal view returns (uint256 res) {
        res = input.bit1(48, update);
    }

    function matrix_og_width(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 49);
    }

    function matrix_og_width(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 49, update);
    }

    function matrix_og_height(uint256 input) internal view returns (uint256 res) {
        res = input.bit(8, 57);
    }

    function matrix_og_height(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(8, 57, update);
    }
}
