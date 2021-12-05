import '../../lib/DSTest.sol';
import '../../../../contracts/src/types/Version.sol';

contract VersionGetPixelAtTest is DSTest {
    function setUp() public {}

    function test_getPixelAt_a() public {
        // uint256 pallet = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;
        // Version.Memory memory m;
        // m.pallet = new uint256[](1);
        // m.pallet[0] = pallet;
        // (uint256 res, uint256 color, uint256 z) = Version.getPixelAt(m, 3);
        // assertEq(res, 0x5666662e5, 'res');
        // assertEq(color, 0x666662e5, 'color');
        // assertEq(z, 0x5, 'z');
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
