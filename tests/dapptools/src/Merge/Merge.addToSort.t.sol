pragma solidity 0.8.4;

import '../../lib/DSTest.sol';
import '../../../../contracts/src/logic/Merge.sol';

contract MergeTest_addToSort is DSTest {
    function setUp() public {}

    function test_addToSort_a() public {
        assertEq(Merge.addToSort(0, 15, 3), 0x1f3, 'res');
        assertEq(Merge.addToSort(0x1f3, 2, 2), (0x122 << 9) | 0x1f3, 'res');
    }
}
