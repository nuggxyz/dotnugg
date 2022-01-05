// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DotnuggV1Test} from '../DotnuggV1Test.sol';
import {IDotnuggV1Metadata} from '../../interfaces/IDotnuggV1Metadata.sol';

import {UserTarget} from '../utils/User.sol';

import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract ResolverTest is DotnuggV1Test {
    using UserTarget for address;

    BigMatrix0 _bigmatrix0;

    uint256[][] dummy2D;
    uint256[] dummy1D;

    uint256[] dummy1Dcompressed;

    IDotnuggV1Metadata.Memory testData;

    function setUp() public {
        reset();

        _bigmatrix0 = new BigMatrix0();

        dummy1D = _bigmatrix0.get();

        dummy1Dcompressed = processor.lib().compress(dummy1D, _bigmatrix0.beforeData());

        // testData.name = 'name';
        // testData.desc = 'desc';
        // testData.version = 1;
        testData.artifactId = 0;
        // testData.owner = address(0);
    }

    // function test__Resolver__resolvString__pass() public {
    //     string memory res = processor.str(dummy1Dcompressed, testData, '');

    //     // emit log_named_string('svg', res);
    // }
}
