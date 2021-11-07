// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../../lib/DSTest.sol';
import '../../../contracts/libraries/Bytes.sol';

contract BytesTest is DSTest {
    function test_toUint4() public {
        bytes memory _bytes = hex'2c';
        uint256 _start = 0;

        (uint8 res0, uint8 res1) = Bytes.toUint4(_bytes, _start);

        emit log_named_uint('res0', res0);
        emit log_named_uint('res1', res1);

        assertEq(res0, 2);
        assertEq(res1, 12);
    }

    function test_toInt8_0() public {
        bytes memory _bytes = hex'2c';
        uint256 _start = 0;

        int8 res0 = Bytes.toInt8(_bytes, _start);

        emit log_named_int('res0', res0);

        assertEq(res0, 44);
    }

    function test_toInt8_1() public {
        bytes memory _bytes = hex'f4';
        uint256 _start = 0;

        int8 res0 = Bytes.toInt8(_bytes, _start);

        emit log_named_int('res0', res0);

        assertEq(res0, -12);
    }

    function test_toInt8_2() public {
        bytes memory _bytes = hex'cd';
        uint256 _start = 0;

        int8 res0 = Bytes.toInt8(_bytes, _start);

        emit log_named_int('res0', res0);

        assertEq(res0, -51);
    }

    function test_toInt8_3() public {
        bytes memory _bytes = hex'00';
        uint256 _start = 0;

        int8 res0 = Bytes.toInt8(_bytes, _start);

        emit log_named_int('res0', res0);

        assertEq(res0, 0);
    }

    function test_toInt8_4() public {
        bytes memory _bytes = hex'ff';
        uint256 _start = 0;

        int8 res0 = Bytes.toInt8(_bytes, _start);

        emit log_named_int('res0', res0);

        assertEq(res0, -1);
    }
}
