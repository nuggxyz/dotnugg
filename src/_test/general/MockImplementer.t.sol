// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DotnuggV1Test} from '../DotnuggV1Test.sol';
import {IDotnuggV1Implementer} from '../../interfaces/IDotnuggV1Implementer.sol';
import {MockDotnuggV1Implementer} from '../../_mock/MockDotnuggV1Implementer.sol';

import {UserTarget} from '../utils/User.sol';

import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract MockImplementerTest is DotnuggV1Test {
    using UserTarget for address;

    function setUp() public {
        reset();
    }

    function test__MockImplementer__processorReceivedFiles__pass() public {
        IDotnuggV1Implementer impl = new MockDotnuggV1Implementer(processor);

        for (uint8 i = 0; i < 8; i++) {
            uint8 res = processor.stored(address(impl), i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
        }
        //76

        for (uint256 i = 300; i < 301; i++) {
            (, string memory res) = processor.dotnuggToString(address(impl), i, address(processor), 63, 1);
            emit log_string(res);
        }
    }
}
