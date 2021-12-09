pragma solidity 0.8.4;

import '../../lib/DSTest.sol';
import '../../../../contracts/src/v2/Merge.sol';

contract MergeTest_getFromSorter is DSTest {
    function setUp() public {}

    function test_getFromSorter_a() public {
        (bool exists, uint256 feature, uint256 z) = Merge.getFromSorter(0x1f3, 0);
        assertEq(feature, 0xf, 'feature');
        assertEq(exists ? 1 : 0, 1, 'reexistss');
        assertEq(z, 3, 'z');
    }

    function test_getFromSorter_b() public {
        (bool exists, uint256 feature, uint256 z) = Merge.getFromSorter((0x122 << 9) | 0x1f3, 1);
        assertEq(feature, 0x2, 'feature');
        assertEq(exists ? 1 : 0, 1, 'reexistss');
        assertEq(z, 2, 'z');
    }
}
