// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Safe} from "./IDotnuggV1Safe.sol";

interface IDotnuggV1 {
    function register() external returns (IDotnuggV1Safe proxy);
}
