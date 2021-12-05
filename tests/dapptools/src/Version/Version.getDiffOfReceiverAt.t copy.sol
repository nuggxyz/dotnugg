import '../../lib/DSTest.sol';
import '../../../../contracts/src/types/Version.sol';

contract VersionTest_getDiffOfReceiverAt is DSTest {
    function setUp() public {}

    function test_getDiffOfReceiverAt_a() public {
        uint256 pallet = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;

        Version.Memory memory m;
        m.pallet = new uint256[](1);
        m.pallet[0] = pallet;

        (int256 x, int256 y) = Version.getDiffOfReceiverAt(m, m, 3);

        assertEq(x, -5, 'x');
        assertEq(y, 8, 'y');
    }
}
