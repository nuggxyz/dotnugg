pragma solidity 0.8.4;

import '../../lib/DSTest.sol';
import '../../../../contracts/src/libraries/ShiftLib.sol';

contract VersionTest_fullsubmask is DSTest {
    function setUp() public {}

    function test_a() public {
        // Version.Memory memory m;
        // m.pallet = new uint256[](1);
        // m.pallet[0] = pallet;

        assertEq(bytes32(ShiftLib.fullsubmask(4, 8)), bytes32(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0ff), 'x');
    }
}
