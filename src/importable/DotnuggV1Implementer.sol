// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Factory} from "../interfaces/IDotnuggV1Factory.sol";
import {IDotnuggV1Storage} from "../interfaces/IDotnuggV1Storage.sol";

contract DotnuggV1Implementer {
    IDotnuggV1Storage immutable dotnuggv1Storage;
    IDotnuggV1Factory immutable dotnuggv1Factory;

    constructor(
        address factory,
        address trusted,
        string[8] memory labels
    ) {
        dotnuggv1Storage = IDotnuggV1Factory(factory).register(trusted, labels);
        dotnuggv1Factory = IDotnuggV1Factory(factory);
    }
}
