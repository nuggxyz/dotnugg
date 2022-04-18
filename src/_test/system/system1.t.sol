// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import "../main.t.sol";
import {data} from "../../_data/nuggs.data.sol";

contract systemTest__one is t {
    IDotnuggV1Safe proxy;

    function setUp() public {
        reset();
        forge.vm.startPrank(users.frank);

        proxy = factory.register(abi.decode(data, (bytes[])));

        forge.vm.stopPrank();
    }

    function test__gas__mask() public pure {
        assembly {
            let res := 0x81026004808483603a01903982513d8452809180519086801b90

            res := shr(96, shl(44, res))
        }
    }

    function test__gas__juke() public pure {
        assembly {
            let res := 0x81026004808483603a01903982513d8452809180519086801b90

            res := and(res, sub(shl(44, 1), 1))
        }
    }

    function test__something() public {
        proxy.lengthOf(0);

        // uint256[] memory a = new uint256[](7);
        // a[0] = 1;
        // a[1] = 2;
        // a[2] = 3;
        // a[3] = 4;
        // a[4] = 5;
        // a[5] = 6;
        // a[6] = 7;

        // assembly {
        //     log1(a, mul(8, 32), a)
        // }

        // proxy.exec(0, 1, false);

        // proxy.exec([1, 1, 1, 1, 1, 0, 0, 0], true);

        // proxy.exec([1, 16, 16], false);

        // ds.emit_log_string(proxy.exec([2, 47, 23, 0, 25, 0, 0, 15], false));
        // ds.emit_log_string(proxy.exec([3, 47, 23, 21, 0, 0, 0, 0], false));
        // ds.emit_log_string(proxy.exec([2, 0, 0, 18, 0, 0, 0, 0], false));
        // ds.emit_log_string(proxy.exec(3, 48, false));
        // proxy.exec([0, 0, 0, 0, 0, 0, 0, 0], false);
        ds.emit_log_string(proxy.exec(2, 66, false));

        proxy.randOf(1, 0x1234444997373738);
    }

    function test__all() public {
        for (uint8 i = 0; i < 8; i++) {
            uint8 len = proxy.lengthOf(i);

            for (uint8 j = 0; j < len; j++) {
                proxy.exec(i, j + 1, false);
                proxy.exec(i, j + 1, false);
                proxy.exec([0, 0, 0, 0, 0, 0, 0, 0], false);
            }
        }
    }

    function test__back__offset() public {
        // for (uint8 i = 0; i < 8; i++) {
        // uint8 len = proxy.lengthOf(i);

        /// OK
        uint256[][] memory check = new uint256[][](4);

        // not OK
        // uint256[][] memory check = new uint256[][](4);

        // check[0] = proxy.read(0, 3);
        // check[1] = proxy.read(1, 5);
        // check[2] = proxy.read(2, 5);
        check[3] = proxy.read(5, 3);

        // check[3] = proxy.read(2, 87);

        ds.emit_log_string(proxy.combo(check, false));

        // for (uint8 j = 0; j < len; j++) {
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec([0, 0, 0, 0, 0, 0, 0, 0], false);
        // }
    }

    function test__back__offset2() public {
        // for (uint8 i = 0; i < 8; i++) {
        // uint8 len = proxy.lengthOf(i);

        /// OK
        uint256[][] memory check = new uint256[][](16);

        // not OK
        // uint256[][] memory check = new uint256[][](4);

        // check[0] = proxy.read(0, 3);
        // check[1] = proxy.read(1, 5);
        // check[2] = proxy.read(2, 5);
        check[2] = proxy.read(0, 3);
        check[1] = proxy.read(1, 2);
        check[3] = proxy.read(2, 1);
        check[4] = proxy.read(3, 9);
        check[5] = proxy.read(4, 5);

        // check[3] = proxy.read(2, 87);

        ds.emit_log_string(proxy.combo(check, false));

        // for (uint8 j = 0; j < len; j++) {
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec([0, 0, 0, 0, 0, 0, 0, 0], false);
        // }
    }

    function test__supersize() public {
        // for (uint8 i = 0; i < 8; i++) {
        // uint8 len = proxy.lengthOf(i);
        uint256[][][] memory arg = new uint256[][][](25);
        for (uint256 i = 0; i < arg.length; i++) {
            uint256[][] memory check = new uint256[][](8);

            // not OK
            // uint256[][] memory check = new uint256[][](4);

            // check[0] = proxy.read(0, 3);
            // check[1] = proxy.read(1, 5);
            // check[2] = proxy.read(2, 5);
            check[0] = proxy.read(0, 2);
            check[2] = proxy.read(5, 3);
            check[1] = proxy.read(1, 2);
            check[3] = proxy.read(2, 1);
            check[4] = proxy.read(3, 4);
            check[5] = proxy.read(4, 5);

            arg[i] = check;

            // check[3] = proxy.read(2, 87);
        }

        string[] memory ret = proxy.supersize(arg, true);

        for (uint256 i = 0; i < arg.length; i++) {
            // ds.emit_log_string(ret[i]);
        }
    }
    // }

    // 3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00
    // 3D6020808080380380918539038082848153208351140290F300042000006900
}

// 0x00000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000007
