// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import 'hardhat/console.sol';
import '../../src/libraries/ShiftLib.sol';
import './ItemType.sol';

library LengthType {
    using ShiftLib for uint256;

    function length(uint256 input, ItemType.Index index) internal returns (uint256 res) {
        res = input.bit(12, (12 * uint8(index)));
    }

    function length(
        uint256 input,
        ItemType.Index index,
        uint256 update
    ) internal returns (uint256 res) {
        res = input.bit(12, (12 * uint8(index)), update);
    }
}
