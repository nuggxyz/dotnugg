// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Test} from '../DotnuggV1Test.sol';
import {IDotnuggV1Implementer} from '../../interfaces/IDotnuggV1Implementer.sol';
import {MockDotnuggV1Implementer} from '../../_mock/MockDotnuggV1Implementer.sol';
import {IDotnuggV1Metadata} from '../../interfaces/IDotnuggV1Metadata.sol';

import {UserTarget} from '../utils/User.sol';

import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract MockImplementerTest is DotnuggV1Test {
    using UserTarget for address;

    function setUp() public {
        reset();
    }

    function test__MockImplementer__processorReceivedFiles__pass() public {
        // MockDotnuggV1Implementer impl = new MockDotnuggV1Implementer(processor);
        // impl.afterConstructor();
        for (uint8 i = 0; i < 8; i++) {
            uint8 res = implementer.dotnuggV1StorageProxy().stored(i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
        }
        //76

        for (uint256 i = 300; i < 301; i++) {
            string memory res = processor.img(address(implementer), i, address(processor), false, true, false, false, '');

            string memory resJson = processor.dat(address(implementer), i, address(processor), 'NuggftV1', 'Nugg Fungible Token V1', false, '');

            emit log_string(res);
            emit log_string(resJson);
        }
    }

    function test__MockImplementer__processorReceivedFiles__override() public {
        IDotnuggV1Metadata.Memory memory __custom;

        __custom.implementer = address(implementer);
        __custom.artifactId = 1;

        __custom.ids = new uint8[](8);
        __custom.xovers = new uint8[](8);
        __custom.yovers = new uint8[](8);
        __custom.labels = new string[](8);
        __custom.styles = new string[](8);

        __custom.ids[0] = 1;
        __custom.ids[1] = 71;
        __custom.ids[2] = 9;
        __custom.ids[3] = 40;
        __custom.ids[5] = 11;

        __custom.version = 1;

        for (uint8 i = 0; i < 8; i++) {
            uint8 res = implementer.dotnuggV1StorageProxy().stored(i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
            assertTrue(res >= __custom.ids[i]);
        }

        implementer.setMetadataOverride(__custom);

        for (uint256 i = 300; i < 301; i++) {
            string memory res = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 0);
            string memory res2 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 1);
            string memory res3 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 2);

            string memory res4 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 1, 0);

            // string memory resJson = processor.dat(address(implementer), i, address(processor), 'NuggftV1', 'Nugg Fungible Token V1', false, '');

            emit log_string(res);
            emit log_string(res2);
            emit log_string(res3);
            emit log_string(res4);

            // emit log_string(resJson);
        }
    }

    function test__MockImplementer__processorReceivedFiles__override2() public {
        IDotnuggV1Metadata.Memory memory __custom;

        __custom.implementer = address(implementer);
        __custom.artifactId = 1;

        __custom.ids = new uint8[](8);
        __custom.xovers = new uint8[](8);
        __custom.yovers = new uint8[](8);
        __custom.labels = new string[](8);
        __custom.styles = new string[](8);

        __custom.ids[0] = 0;
        __custom.ids[1] = 0;
        __custom.ids[2] = 0;
        __custom.ids[3] = 0;
        __custom.ids[5] = 1;

        __custom.version = 1;

        for (uint8 i = 0; i < 8; i++) {
            uint8 res = implementer.dotnuggV1StorageProxy().stored(i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
            assertTrue(res >= __custom.ids[i]);
        }

        implementer.setMetadataOverride(__custom);

        for (uint256 i = 300; i < 301; i++) {
            string memory res = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 0);
            string memory res2 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 1);
            string memory res3 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 2);

            string memory res4 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 1, 0);

            // string memory resJson = processor.dat(address(implementer), i, address(processor), 'NuggftV1', 'Nugg Fungible Token V1', false, '');

            emit log_string(res);
            emit log_string(res2);
            emit log_string(res3);
            emit log_string(res4);

            // emit log_string(resJson);
        }
    }

    function test__MockImplementer__processorReceivedFiles__override4() public {
        IDotnuggV1Metadata.Memory memory __custom;

        __custom.implementer = address(implementer);
        __custom.artifactId = 1;

        __custom.ids = new uint8[](8);
        __custom.xovers = new uint8[](8);
        __custom.yovers = new uint8[](8);
        __custom.labels = new string[](8);
        __custom.styles = new string[](8);

        // [2, 87, 24, 0, 33, 0, 7, 0]

        __custom.ids[0] = 2;
        __custom.ids[1] = 87;
        __custom.ids[2] = 24;
        __custom.ids[3] = 0;
        __custom.ids[4] = 33;

        __custom.ids[6] = 7;

        //         __custom.ids[0] = 2;
        // __custom.ids[1] = 74;
        // __custom.ids[2] = 58;
        // __custom.ids[3] = 21;
        // __custom.ids[6] = 7;

        __custom.version = 1;

        for (uint8 i = 0; i < 8; i++) {
            uint8 res = implementer.dotnuggV1StorageProxy().stored(i);
            emit log_named_uint('[i]', res);
            assertTrue(res > 0);
            assertTrue(res >= __custom.ids[i]);
        }

        implementer.setMetadataOverride(__custom);

        for (uint256 i = 300; i < 301; i++) {
            // string memory res = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 0);
            // string memory res2 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 1);
            // string memory res3 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 3, 2);

            string memory res4 = processor.chunk(address(implementer), i, address(processor), false, true, false, true, '', 1, 0);

            // string memory resJson = processor.dat(address(implementer), i, address(processor), 'NuggftV1', 'Nugg Fungible Token V1', false, '');

            emit log_string(res4);

            // emit log_string(resJson);
        }
    }
}
