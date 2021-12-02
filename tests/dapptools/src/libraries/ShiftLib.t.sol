// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../../lib/DSTest.sol';

import '../../../../contracts/libraries/ShiftLib.sol';

contract ShiftLibTest is DSTest {
    using ShiftLib for uint256;

    function test_bit() public {
        uint256 a = 0x444f544e5547472109000d00456e6e6e6e7567672ab3020010001a0026000000;

        assertEq(a.rbit(8, 16), 0x33);

        // assertEq(swap_sample5.eth(), , 'swap_sample5');
    }
}
