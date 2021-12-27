// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';
import {IDotnuggV1Data} from '../../interfaces/IDotnuggV1Data.sol';

import {UserTarget} from '../utils/User.sol';

import {Version} from '../../types/Version.sol';
import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract ResolverTest is NuggFatherFix {
    using UserTarget for address;

    BigMatrix0 _bigmatrix0;

    uint256[][] dummy2D;
    uint256[] dummy1D;

    uint256[] dummy1Dcompressed;

    IDotnuggV1Data.Data testData;

    function setUp() public {
        reset();

        _bigmatrix0 = new BigMatrix0();

        dummy1D = _bigmatrix0.get();

        dummy1Dcompressed = Version.compressBigMatrix(dummy1D, _bigmatrix0.beforeData());

        testData.name = 'name';
        testData.desc = 'desc';
        testData.version = 1;
        testData.tokenId = 0;
        testData.proof = 0;
        testData.owner = address(0);
    }

    // function test__DotnuggV2Processor__dotnuggV1StoreFiles__pass() public {
    //     _implementer.shouldPass(frank, dotnuggV1StoreFiles(dummy2D, 0));
    // }

    function test__Resolver__resolvString__pass() public {
        string memory res = processor.resolveString(dummy1Dcompressed, testData, 10);

        emit log_named_string('svg', res);

        // assert(false);
    }
}
