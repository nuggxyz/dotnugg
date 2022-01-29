// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Test} from '../DotnuggV1Test.sol';

import {StringCastLib} from '../../libraries/StringCastLib.sol';

contract generalTest__StringCastLib is DotnuggV1Test {
    function test__general__StringCastLib__a() public {
        assertEq(StringCastLib.toHexStringNoPrefix(0xffffff_00, 4), 'ffffff00');
    }
}
