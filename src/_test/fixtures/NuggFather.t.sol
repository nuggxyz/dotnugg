// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DSTestPlus as t} from '../utils/DSTestPlus.sol';

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';

contract fixtureTest__NuggFatherFix is t, NuggFatherFix {
    function setUp() public {
        reset();
    }
}
