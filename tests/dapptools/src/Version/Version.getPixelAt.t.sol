pragma solidity 0.8.4;

import '../../lib/DSTest.sol';
import '../../../../contracts/src/types/Version.sol';

contract VersionGetPixelAtTest is DSTest {
    function setUp() public {}

    function test_getPixelAt_a() public {
        Version.Memory memory m;

        m.minimatrix = new uint256[](18);
        m.minimatrix[0] = 0x0000000000000000000000000000000000000000000000000000000000000000;
        m.minimatrix[1] = 0x0000000000000000000000000000000000000000000000000000000000000000;
        m.minimatrix[2] = 0x0005555555555555500000000000000000000000000000000000000000000000;
        m.minimatrix[3] = 0x0000003332222223500000000000000005550003333222235500000000000000;
        m.minimatrix[4] = 0x5333222222223350000000000000000500033322222223350000000000000000;
        m.minimatrix[5] = 0x0332222223333500000000000000533333312222222335500000000000000500;
        m.minimatrix[6] = 0x3222223333350000000000000053333332222223333350000000000000053333;
        m.minimatrix[7] = 0x2222333335000000000000005333332222222311335000000000000005333333;
        m.minimatrix[8] = 0x2233333500000000000000533311222222333333500000000000000533331222;
        m.minimatrix[9] = 0x2333350000000000000053222222222223333350000000000000053333222222;
        m.minimatrix[10] = 0x3350000000000000005222222222223333335000000000000005222222222223;
        m.minimatrix[11] = 0x3000000000000000552222222221333335000000000000000522222222222113;
        m.minimatrix[12] = 0x5000000000000005000000001233334500000000000000005000002221133333;
        m.minimatrix[13] = 0x0000000000000544000022223304450000000000000000544000022223330450;
        m.minimatrix[14] = 0x0000000000000055555555555500000000000000000005544000022330555000;
        m.minimatrix[15] = 0x0000000000000000000000000000000000000000000000000000000000000000;
        m.minimatrix[16] = 0x0000000000000000000000000000000000000000000000000000000000000000;
        m.minimatrix[17] = 0x0000000000000000000000000000000000000000000000000000000000000000;

        m.pallet = new uint256[](1);
        m.pallet[0] = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;

        m.data = 0x000000000000000000000000000000000000000000000430a288000000000000;

        uint256 got_res = Version.getPixelAt(m, 4, 7);

        assertEq(got_res, 5, 'res');
    }

    function test_getPixelAt_b() public {
        // Version.Memory memory m;
        // m.pallet = new uint256[](2);
        // m.pallet[0] = pallet;
        // m.pallet[1] = pallet;
        // uint256 pallet = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;
        // (uint256 res, uint256 color, uint256 z) = Version.getPixelAt(m, 10);
        // assertEq(res, 0x5666662e5, 'res');
        // assertEq(color, 0x666662e5, 'color');
        // assertEq(z, 0x5, 'z');
    }
}
