// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./DotnuggCore.sol";

contract DotnuggCoreTest is DSTest {
    DotnuggCore core;

    function setUp() public {
        core = new DotnuggCore();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
