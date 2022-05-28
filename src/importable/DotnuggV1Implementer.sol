// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.14;

import {IDotnuggV1Safe} from "../interfaces/IDotnuggV1Safe.sol";

contract DotnuggV1Implementer {
    IDotnuggV1Safe immutable dotnuggv1Storage;

    constructor(IDotnuggV1Safe proxy) {
        dotnuggv1Storage = proxy;
    }
}
