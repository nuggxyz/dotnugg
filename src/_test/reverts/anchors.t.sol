// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';
import {SafeCast} from '../fixtures/NuggFather.fix.sol';

contract revertTest__anchors is NuggFatherFix {
    using SafeCast for uint96;

    function setUp() public {
        reset();
    }
}
