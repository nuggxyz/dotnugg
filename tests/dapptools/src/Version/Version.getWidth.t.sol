pragma solidity 0.8.9;

import '../../lib/DSTest.sol';
import '../../../../contracts/src/types/Version.sol';

contract VersionTest_getWidth is DSTest {
    function setUp() public {}

    function test_getWidth_a() public {
        // uint256 pallet = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;
        Version.Memory memory m;
        m.data = 0x000000000000000000000000000000000000000000000430a288000000000000;

        (uint256 width, uint256 height) = Version.getWidth(m);
        assertEq(width, 33, 'width');
        assertEq(height, 33, 'height');
    }

    function test_getWidth_b() public {
        Version.Memory memory m;
        m.data = 0x0000000000000000000000000000000000000000000009658231248000c30000;

        (uint256 width, uint256 height) = Version.getWidth(m);
        assertEq(width, 11, 'width');
        assertEq(height, 11, 'height');
    }
}
