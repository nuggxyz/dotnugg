// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import "../main.t.sol";
import {data} from "../../_data/a.data.sol";

contract systemTest__one is t {
    function setUp() public {
        reset();
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
        forge.vm.startPrank(users.frank);

        IDotnuggV1Safe proxy = factory.register(abi.decode(data, (bytes[])));

        forge.vm.stopPrank();

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

        // proxy.exec([1, 1, 1, 1, 1, 1, 1, 1], true);

        // proxy.exec([2, 2, 2, 2, 2, 2, 2, 2], false);

        // ds.emit_log_string(proxy.exec([1, 1, 1, 1, 1, 1, 1, 1], true));

        proxy.randOf(1, 0x1234444997373738);
    }

    // 3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00
    // 3D6020808080380380918539038082848153208351140290F300042000006900
}

// 0x00000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000007
