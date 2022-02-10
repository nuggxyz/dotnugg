// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Factory} from "../interfaces/IDotnuggV1Factory.sol";
import {IDotnuggV1Storage} from "../interfaces/IDotnuggV1Storage.sol";

contract DotnuggV1Implementer {
    IDotnuggV1Storage immutable dotnuggv1Storage;

    constructor(IDotnuggV1Storage proxy) {
        dotnuggv1Storage = proxy;
    }
}
