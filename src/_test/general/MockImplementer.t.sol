// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';
import {IDotnuggV1Data} from '../../interfaces/IDotnuggV1Data.sol';
import {IDotnuggV1Implementer} from '../../interfaces/IDotnuggV1Implementer.sol';
import {MockDotnuggV1Implementer} from '../../_mock/MockDotnuggV1Implementer.sol';

import {UserTarget} from '../utils/User.sol';

import {DotnuggV1Lib} from '../../DotnuggV1Lib.sol';
import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract MockImplementerTest is NuggFatherFix {
    using UserTarget for address;

    function setUp() public {
        reset();
    }

    function test__MockImplementer__processorReceivedFiles__pass() public {
        IDotnuggV1Implementer impl = new MockDotnuggV1Implementer(processor);

        for (uint8 i = 0; i < 8; i++) {
            uint8 res = processor.totalStoredFiles(address(impl), i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
        }
        //76
        (, string memory res) = processor.dotnuggToString(address(impl), 72, address(processor), 63, 10);

        emit log_string(res);
    }
}
