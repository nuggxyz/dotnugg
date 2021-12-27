// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DSTestPlus as t} from '../utils/DSTestPlus.sol';

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';

contract revertTest__version is t, NuggFatherFix {
    function setUp() public {
        reset();
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            [T:1] - addStakedShareFromMsgValue - "value of tx too low"
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
}
