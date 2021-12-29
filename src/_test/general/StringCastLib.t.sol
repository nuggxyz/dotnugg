// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';

import {StringCastLib} from '../../libraries/StringCastLib.sol';

contract generalTest__StringCastLib is NuggFatherFix {
    function test__general__StringCastLib__a() public {
        assertEq(StringCastLib.toHexStringNoPrefix(0xffffff_00, 4), 'ffffff00');
    }
}
