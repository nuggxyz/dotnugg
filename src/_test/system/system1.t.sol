// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

import "../main.t.sol";
import {data} from "../../_data/nuggs.data.sol";
import {DotnuggV1Lib} from "../../libraries/DotnuggV1Lib.sol";

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

    // Running 2 tests for src/_test/general/generate.t.sol:generalTest__generate
    // [PASS] test__trr() (gas: 4526)
    // [PASS] test__trr2() (gas: 26968)
    // Test result: ok. 2 passed; 0 failed; finished in 1.25ms

    // Running 2 tests for src/_test/general/Pixel.t.sol:generalTest__PixelType
    // [PASS] test__general__PixelType__a() (gas: 1202)
    // [PASS] test__general__PixelType__toHexString() (gas: 4040)
    // Test result: ok. 2 passed; 0 failed; finished in 1.40ms

    // Running 2 tests for src/_test/deploy/deploy.t.sol:t__deployment
    // [PASS] test__deployment() (gas: 15027961)
    // [PASS] test__general__PixelType__toHexString() (gas: 143)
    // Test result: ok. 2 passed; 0 failed; finished in 5.91ms

    // Running 3 tests for src/_test/general/mint.t.sol:systemTest__two
    // [PASS] test__gas__juke() (gas: 120)
    // [PASS] test__gas__mask() (gas: 165)
    // [PASS] test__structStoragePointer() (gas: 70220)
    // Test result: ok. 3 passed; 0 failed; finished in 6.35ms

    // Running 7 tests for src/_test/system/system1.t.sol:systemTest__one
    // [PASS] test__all() (gas: 127755011628)
    // [PASS] test__back__offset() (gas: 87228368)
    // [PASS] test__back__offset2() (gas: 82303141)
    // [PASS] test__gas__juke() (gas: 187)
    // [PASS] test__gas__mask() (gas: 165)
    // [PASS] test__something() (gas: 78324104)
    // [PASS] test__supersize() (gas: 4259246535)
    // Test result: ok. 7 passed; 0 failed; finished in 203.35s

    //     Running 2 tests for src/_test/general/Pixel.t.sol:generalTest__PixelType
    // [PASS] test__general__PixelType__a() (gas: 1202)
    // [PASS] test__general__PixelType__toHexString() (gas: 4040)
    // Test result: ok. 2 passed; 0 failed; finished in 1.33ms

    // Running 2 tests for src/_test/general/generate.t.sol:generalTest__generate
    // [PASS] test__trr() (gas: 4526)
    // [PASS] test__trr2() (gas: 26968)
    // Test result: ok. 2 passed; 0 failed; finished in 1.38ms

    // Running 2 tests for src/_test/deploy/deploy.t.sol:t__deployment
    // [PASS] test__deployment() (gas: 15228199)
    // [PASS] test__general__PixelType__toHexString() (gas: 143)
    // Test result: ok. 2 passed; 0 failed; finished in 5.93ms

    // Running 3 tests for src/_test/general/mint.t.sol:systemTest__two
    // [PASS] test__gas__juke() (gas: 120)
    // [PASS] test__gas__mask() (gas: 165)
    // [PASS] test__structStoragePointer() (gas: 70220)
    // Test result: ok. 3 passed; 0 failed; finished in 6.07ms

    // Running 7 tests for src/_test/system/system1.t.sol:systemTest__one
    // [PASS] test__all() (gas: 2919799108)
    // [PASS] test__back__offset() (gas: 12419179)
    // [PASS] test__back__offset2() (gas: 19188721)
    // [PASS] test__gas__juke() (gas: 187)
    // [PASS] test__gas__mask() (gas: 165)
    // [PASS] test__something() (gas: 1275024)
    // [PASS] test__supersize() (gas: 2622197584)
    // Test result: ok. 7 passed; 0 failed; finished in 3.37s

    //     127755011628
    //   2919799108 =0.02285467373
    function test__something() public {
        DotnuggV1Lib.lengthOf(address(proxy), 0);
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

        DotnuggV1Lib.randOf(address(proxy), 1, 0x1234444997373738);
    }

    function test__all() public {
        for (uint8 i = 0; i < 8; i++) {
            uint8 len = DotnuggV1Lib.lengthOf(address(proxy), i);

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
        // check[2] = proxy.read(0, 3);
        // check[1] = proxy.read(1, 2);
        // check[3] = proxy.read(2, 1);
        // check[4] = proxy.read(3, 9);
        // check[5] = proxy.read(4, 5);

        check[2] = proxy.read(0, 1);
        check[1] = proxy.read(1, 44);
        check[3] = proxy.read(2, 33);
        check[4] = proxy.read(3, 12);
        check[5] = proxy.read(4, 33);
        // check[6] = proxy.read(5, 9);
        // check[7] = proxy.read(7, 5);

        // check[3] = proxy.read(2, 87);

        ds.emit_log_string(proxy.combo(check, false));

        // for (uint8 j = 0; j < len; j++) {
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec(i, j + 1, false);
        //     proxy.exec([0, 0, 0, 0, 0, 0, 0, 0], false);
        // }
    }

    // function test__supersize() public {
    //     // for (uint8 i = 0; i < 8; i++) {
    //     // uint8 len = proxy.lengthOf(i);
    //     uint256[][][] memory arg = new uint256[][][](25);
    //     for (uint256 i = 0; i < arg.length; i++) {
    //         uint256[][] memory check = new uint256[][](8);

    //         // not OK
    //         // uint256[][] memory check = new uint256[][](4);

    //         // check[0] = proxy.read(0, 3);
    //         // check[1] = proxy.read(1, 5);
    //         // check[2] = proxy.read(2, 5);
    //         check[0] = proxy.read(0, 2);
    //         check[2] = proxy.read(5, 3);
    //         check[1] = proxy.read(1, 2);
    //         check[3] = proxy.read(2, 1);
    //         check[4] = proxy.read(3, 4);
    //         check[5] = proxy.read(4, 5);

    //         arg[i] = check;

    //         // check[3] = proxy.read(2, 87);
    //     }

    //     string[] memory ret = proxy.supersize(arg, true);

    //     for (uint256 i = 0; i < arg.length; i++) {
    //         // ds.emit_log_string(ret[i]);
    //     }
    // }
    // }

    // 3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00
    // 3D6020808080380380918539038082848153208351140290F300042000006900
}

// 0x00000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000007
// <svg viewBox="0 0 255 255" xmlns="http://www.w3.org/2000/svg"><g class="DN" transform="scale(6.86486) translate(111.000,109.000)" transform-origin="center center"><path class="E" stroke="#000000" d="M24 0h2M11 1h2M24 1h1M26 1h1M10 2h1M12 2h1M25 2h1M27 2h1M9 3h1M11 3h1M25 3h1M27 3h2M8 4h1M11 4h1M26 4h2M29 4h1M7 5h4M26 5h1M30 5h1M6 6h1M10 6h1M25 6h3M30 6h1M6 7h1M9 7h1M25 7h1M27 7h4M5 8h1M9 8h1M25 8h1M30 8h1M4 9h7M24 9h1M30 9h1M4 10h1M12 10h1M22 10h2M25 10h1M30 10h1M4 11h1M10 11h4M20 11h2M25 11h3M30 11h1M5 12h1M8 12h2M13 12h2M20 12h1M27 12h2M30 12h1M6 13h2M28 13h2M7 14h2M25 14h4M8 15h3"/><path class="E" stroke="#fffc96" d="M25 1h1M11 2h1M26 2h1M10 3h1M26 3h1M9 4h2M28 4h1M27 5h3M7 6h3M28 6h2M7 7h2M26 7h1M6 8h3M26 8h4M25 9h5M5 10h7M24 10h1M26 10h4M5 11h5M22 11h3M28 11h2M6 12h2M10 12h3M21 12h6M29 12h1M8 13h5M24 13h4M9 14h3M11 15h1"/><path class="D" stroke="#2f1b17" d="M13 5h1M17 5h1M1 6h1M14 6h1M17 6h1M20 6h1M24 6h1M1 7h2M11 7h2M15 7h1M17 7h1M19 7h2M23 7h2M2 8h1M12 8h2M15 8h4M21 8h2M1 9h2M11 9h13M2 10h2M13 10h9M3 11h1M14 11h6M4 12h1M15 12h5M0 13h1M5 13h1M13 13h6M20 13h2M0 14h1M14 14h1M17 14h1M21 14h1M24 14h1M29 14h1M0 15h2M6 15h2M17 15h1M26 15h5M2 16h7M10 16h2M16 16h2M4 17h5M10 17h1"/><path class="A" stroke="#f9b042" d="M19 13h1M12 14h2M19 14h2M16 15h1M12 16h4M18 16h3M22 16h1M24 16h1M11 17h1M17 17h2M23 17h2M11 18h1M16 18h3M24 18h1M10 19h3M15 19h5M22 19h3M11 20h14M10 21h15M10 22h15M10 23h15M11 24h14M12 25h13M11 26h1M13 26h11M12 27h3M17 27h1M20 27h4M13 28h1M16 28h2M21 28h1M14 29h2M21 29h1M10 30h1M13 30h1M15 30h2M19 30h1M22 30h1M11 31h1M14 31h2M19 31h1M15 32h1M17 32h1"/><path class="A" stroke="#eb8a12" d="M22 13h1M22 14h1M24 15h1M19 29h1M20 30h1M13 31h1M20 31h1M22 31h1M13 32h1M18 32h2"/><path class="A" stroke="#dc7e51" d="M23 13h1M25 17h1M9 18h1M9 24h1M25 24h1M10 27h1M24 27h1M11 28h1M22 28h1M11 29h1M12 30h1M12 31h1"/><path class="A" stroke="#f49f35" d="M15 14h2M15 15h1M18 15h1M23 15h1M17 30h2M16 31h2M16 32h1"/><path class="A" stroke="#f19325" d="M18 14h1M23 14h1M21 16h1M23 16h1M10 18h1M23 18h1M25 18h1M9 19h1M25 19h1M9 20h2M25 20h1M9 21h1M25 21h1M9 22h1M25 22h1M9 23h1M25 23h1M10 24h1M10 25h2M10 26h1M12 26h1M11 27h1M18 28h1M12 29h2M20 29h1M22 29h1M14 30h1M21 30h1M18 31h1"/><path class="B" stroke="#2f1b17" d="M12 15h3M19 15h4M12 17h1M15 17h2M19 17h1M22 17h1M12 18h1M14 18h2M19 18h1M21 18h2M13 19h2M20 19h2"/><path class="A" stroke="#a84b1e" d="M25 15h1M25 16h1M9 17h1M26 18h1M8 19h1M26 19h1M8 20h1M26 20h1M8 21h1M26 21h1M9 25h1M25 25h1M9 26h1M9 27h1M25 27h1M10 28h1M23 28h1M10 29h1M21 31h1M12 32h1M22 32h1M13 33h2M16 33h1M18 33h4"/><path class="A" stroke="#ac6526" d="M9 16h1M26 17h1M8 18h1M8 23h1M26 25h1M24 26h2M9 28h1M25 28h1M23 29h1M11 30h1M23 30h1M23 31h1M14 32h1M20 32h2M15 33h1M17 33h1"/><path class="D" stroke="#2f1b17" d="M26 16h7M27 17h1M31 17h2M5 18h3M27 18h1M4 19h4M27 19h2M3 20h5M27 20h4M2 21h1M4 21h4M27 21h1M30 21h3M3 22h5M27 22h1M32 22h1M3 23h5M27 23h1M29 23h1M2 24h2M5 24h4M27 24h4M1 25h1M5 25h4M27 25h2M30 25h1M4 26h5M26 26h3M3 27h3M7 27h2M26 27h3M2 28h2M5 28h4M26 28h4M2 29h1M4 29h4M9 29h1M25 29h6M1 30h2M4 30h6M24 30h6M1 31h1M3 31h6M10 31h1M24 31h2M27 31h3M1 32h1M3 32h6M10 32h1M23 32h8M3 33h6M10 33h1M22 33h8M31 33h2M2 34h2M5 34h6M22 34h11M2 35h2M5 35h6M22 35h2M25 35h8M1 36h8M10 36h1M22 36h4M27 36h6M1 37h2M4 37h1M6 37h5M22 37h7M31 37h2"/><path class="B" stroke="#add1ea" d="M13 17h1M20 17h1"/><path class="B" stroke="#306082" d="M14 17h1M21 17h1M13 18h1M20 18h1"/><path class="A" stroke="#8f563b" d="M8 22h1M26 22h1M26 23h1M26 24h1M24 28h1M24 29h1"/><path class="C" stroke="#824324" d="M15 27h2M18 27h2M14 28h2M19 28h2"/><path class="A" stroke="#eec39a" d="M12 28h1"/><path class="C" stroke="#852626" d="M16 29h3"/></g></svg>
