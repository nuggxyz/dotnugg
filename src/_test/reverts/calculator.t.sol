// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';

contract revertTest__calculator is NuggFatherFix {
    function setUp() public {
        reset();
    }
}
