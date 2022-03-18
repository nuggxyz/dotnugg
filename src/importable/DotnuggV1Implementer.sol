// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {IDotnuggV1Safe} from "../interfaces/IDotnuggV1Safe.sol";

contract DotnuggV1Implementer {
    IDotnuggV1Safe immutable dotnuggv1Storage;

    constructor(IDotnuggV1Safe proxy) {
        dotnuggv1Storage = proxy;
    }
}
