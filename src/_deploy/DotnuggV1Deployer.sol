// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import {DotnuggV1} from "../DotnuggV1.sol";
import {IDotnuggV1Safe} from "../DotnuggV1Safe.sol";
import {data} from "../_data/a.data.sol";

contract DotnuggV1Deployer {
    DotnuggV1 immutable dotnuggv1;

    // IDotnuggV1Safe immutable safe;

    constructor() {
        dotnuggv1 = new DotnuggV1();

        // safe = dotnuggv1.register(abi.decode(data, (bytes[])));
    }
}
