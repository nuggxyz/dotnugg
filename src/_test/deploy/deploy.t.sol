// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import "../main.t.sol";

import {DotnuggV1Deployer as Deployer} from "../../_deploy/DotnuggV1Deployer.sol";

contract t__deployment is t {
    function test__deployment() public {
        new Deployer();
    }

    function test__general__PixelType__toHexString() public {}
}
