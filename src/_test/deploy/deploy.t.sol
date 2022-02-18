// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import "../main.t.sol";

import {DotnuggV1Deployer as Deployer} from "../../_deploy/DotnuggV1Deployer.sol";

contract t__deployment is t {
    function test__deployment() public {
        new Deployer();
    }

    function test__general__PixelType__toHexString() public {}
}
