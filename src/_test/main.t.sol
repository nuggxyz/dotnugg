// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity 0.8.12;

import "./utils/forge.sol";

import "../DotnuggV1.sol";

contract t is ForgeTest {
    DotnuggV1 factory;

    function reset() internal {
        factory = new DotnuggV1();
    }
}
