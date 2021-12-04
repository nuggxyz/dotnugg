// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import 'hardhat/console.sol';
import '../../src/libraries/ShiftLib.sol';
import './ItemType.sol';

library LengthType {
    using ShiftLib for uint256;

    function length(uint256 input, uint256 index) internal pure returns (uint256 res) {
        res = input.bit(12, (12 * uint256(index)));
    }

    function length(
        uint256 input,
        uint256 index,
        uint256 update
    ) internal pure returns (uint256 res) {
        res = input.bit(12, (12 * uint256(index)), update);
    }
}