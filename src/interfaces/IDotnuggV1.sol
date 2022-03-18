// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {IDotnuggV1Safe} from "./IDotnuggV1Safe.sol";

interface IDotnuggV1 {
    function register(bytes[] calldata input) external returns (IDotnuggV1Safe proxy);
}
