// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "./utils/forge.sol";

import "../DotnuggV1Factory.sol";

contract t is ForgeTest {
    DotnuggV1Factory factory;

    function reset() internal {
        factory = new DotnuggV1Factory();
    }
}
