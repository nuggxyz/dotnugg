// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';

library ReceiverType {
    using ShiftLib for uint256;

    function receiver_yoffset(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 0);
    }

    function receiver_yoffset(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 0, update);
    }

    function receiver_preset(uint256 input) internal view returns (uint256 res) {
        res = input.bit(6, 6);
    }

    function receiver_preset(uint256 input, uint256 update) internal view returns (uint256 res) {
        res = input.bit(6, 6, update);
    }

    function receiver_exists(uint256 input) internal view returns (bool res) {
        res = input.bit1(12);
    }

    function receiver_exists(uint256 input, bool update) internal view returns (uint256 res) {
        res = input.bit1(12, update);
    }
}
