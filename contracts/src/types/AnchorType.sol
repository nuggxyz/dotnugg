// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';

library AnchorType {
    using ShiftLib for uint256;
    using PalletType for uint256[];

    struct Memory {
        uint256 dat;
    }

    function rlud_right(uint256 input) internal view returns (uint256 res) {
        res = input.bit(4, 26);
    }

    function rlud_right(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 26, update);
    }

    function rlud_left(uint256 input) internal view returns (uint256 res) {
        res = input.bit(4, 22);
    }

    function rlud_left(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 22, update);
    }

    function rlud_up(uint256 input) internal view returns (uint256 res) {
        res = input.bit(4, 18);
    }

    function rlud_up(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 18, update);
    }

    function rlud_down(uint256 input) internal view returns (uint256 res) {
        res = input.bit(4, 14);
    }

    function rlud_down(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(4, 14, update);
    }

    function anchor_x(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 8);
    }

    function anchor_x(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 8, update);
    }

    function anchor_y(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 2);
    }

    function anchor_y(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 2, update);
    }

    function anchor_anchorId(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 8);
    }

    function anchor_anchorId(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 8, update);
    }

    function anchor_yOffset(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 2);
    }

    function anchor_yOffset(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 2, update);
    }

    function anchor_rludExists(uint256 input) internal view returns (bool res) {
        res = input.bit1(1);
    }

    function anchor_rludExists(uint256 input, bool update) internal view returns (uint256 res) {
        res = input.bit1(1, update);
    }

    function anchor_coordExists(uint256 input) internal view returns (bool res) {
        res = input.bit1(0);
    }

    function anchor_coordExists(uint256 input, bool update) internal view returns (uint256 res) {
        res = input.bit1(0, update);
    }
}
