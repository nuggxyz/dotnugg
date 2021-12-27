// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {NuggFatherFix} from '../fixtures/NuggFather.fix.sol';

import {UserTarget} from '../utils/User.sol';

import {Version} from '../../types/Version.sol';
import {BigMatrix0} from '../objects/BigMatrix0.sol';

contract VersionTarget {
    function decompressBigMatrix(uint256[] memory input) external pure returns (uint256[] memory res) {
        return Version.decompressBigMatrix(input);
    }

    function compressBigMatrix(uint256[] memory input, uint256 data) external pure returns (uint256[] memory res) {
        return Version.compressBigMatrix(input, data);
    }
}

contract VersionTest is NuggFatherFix {
    using UserTarget for address;

    BigMatrix0 _bigmatrix0;

    uint256[][] dummy2D;
    uint256[] dummy1D;

    uint256[] dummy1Dcompressed;

    VersionTarget target;

    function setUp() public {
        reset();

        target = new VersionTarget();

        _bigmatrix0 = new BigMatrix0();

        dummy1D = _bigmatrix0.get();

        dummy1Dcompressed = Version.compressBigMatrix(dummy1D, 0);

        emit log_named_bytes32('compreseed last', bytes32(dummy1Dcompressed[dummy1Dcompressed.length - 1]));

        dummy2D.push(dummy1D);
        dummy2D.push(dummy1D);
        dummy2D.push(dummy1D);
    }

    // function test__DotnuggV2Processor__dotnuggV1StoreFiles__pass() public {
    //     _implementer.shouldPass(frank, dotnuggV1StoreFiles(dummy2D, 0));
    // }

    function test__Version__compressBigMatrix__pass() public {
        uint256 data = 0;
        uint256[] memory compressed = target.compressBigMatrix(dummy1D, data);
        uint256[] memory decompressed = target.decompressBigMatrix(compressed);

        dummy1D.push(data | ((dummy1D.length + 1) << 236));

        assertArrayEq(decompressed, dummy1D);
    }
}
