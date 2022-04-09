// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import "./utils/forge.sol";

import "../DotnuggV1.sol";

contract t is ForgeTest {
    DotnuggV1 factory;

    constructor() {
        ds.setDsTest(address(this));
    }

    function reset() internal {
        factory = new DotnuggV1();
    }
}
