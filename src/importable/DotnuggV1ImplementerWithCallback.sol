// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Implementer} from "./DotnuggV1Implementer.sol";
import {IDotnuggV1ImplementerWithCallback} from "../interfaces/IDotnuggV1Implementer.sol";

abstract contract DotnuggV1ImplementerWithCallback is IDotnuggV1ImplementerWithCallback, DotnuggV1Implementer {
    constructor(
        address factory,
        address trusted,
        string[8] memory labels
    ) DotnuggV1Implementer(factory, trusted, labels) {}

    function dotnuggV1Callback(uint256 artifactId) external virtual returns (uint8[8] memory res);
}
