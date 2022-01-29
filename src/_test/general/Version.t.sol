// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Test} from '../DotnuggV1Test.sol';

import {UserTarget} from '../utils/User.sol';

import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract VersionTest is DotnuggV1Test {
    using UserTarget for address;

    BigMatrix0 _bigmatrix0;

    uint256[][] dummy2D;
    uint256[] dummy1D;

    uint256[] dummy1Dcompressed;

    function setUp() public {
        reset();

        _bigmatrix0 = new BigMatrix0();

        dummy1D = _bigmatrix0.get();

        dummy1Dcompressed = processor.lib().compress(dummy1D, 0);

        emit log_named_bytes32('compreseed last', bytes32(dummy1Dcompressed[dummy1Dcompressed.length - 1]));

        dummy2D.push(dummy1D);
        dummy2D.push(dummy1D);
        dummy2D.push(dummy1D);
    }

    // function test__DotnuggV2Processor__dotnuggV1StoreFiles__pass() public {
    //     _implementer.shouldPass(frank, dotnuggV1StoreFiles(dummy2D, 0));
    // }

    function test__Version__compress__pass() public {
        uint256 data = 0;
        uint256[] memory compressed = processor.lib().compress(dummy1D, data);
        uint256[] memory decompressed = processor.lib().decompress(compressed);

        dummy1D.push(data | ((dummy1D.length + 1) << 236));

        assertArrayEq(decompressed, dummy1D);
    }

    // function test__Version__findMinRightPadding__pass() public {
    //     (uint8 l, uint8 r) = processor.lib().findMinRightPadding(dummy1D);

    //     emit log_named_uint('l', l);
    //     emit log_named_uint('r', r);
    // }
}
