// [
//   [
//     BigNumber { _hex: '0x02', _isBigNumber: true },
//     BigNumber {
//       _hex: '0xe1f87e1f87e1f87e1fb4e1db4a9864a263419b0a98641a262ac066c2a6190691',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0x8a3019b069884206a3019b063942a0ec05ec92e220ec05ec13e2a4c05ec13e85',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0xb015b04fa16c056c204fa0ec056c20649a0ec056c24291685b015b0818847a0e',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0xc056c20e47a02a2c056c21645a0ec056c21645a0ec056c21e45a06c056c21621',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0x1e8b215b072449a2c066c1c911e8b019b063a445a0c066d1c819068321bb5601',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0x87e1f87e1f87e1f87e1f87f559042e041d0c2c080b080a080445154516451244',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0xaa68a30c26bffffff2d010100bca128aeb2f28d67fd0bca2593f12a84e554747',
//       _isBigNumber: true
//     }
//   ],
//   [
//     BigNumber { _hex: '0x10e111631011031231', _isBigNumber: true },
//     BigNumber {
//       _hex: '0x0e3123101103116110e2900e3800092400010e29a4cb732e100e158c4e554747',
//       _isBigNumber: true
//     }
//   ],
//   [
//     BigNumber {
//       _hex: '0x0190079003906100390610018621840061886101106100390610039007',
//       _isBigNumber: true
//     },
//     BigNumber {
//       _hex: '0x90091402920002480000438a7932061afb5cc83d73e17323cdbff5944e554747',
//       _isBigNumber: true
//     }
//   ],
//   [
//     BigNumber { _hex: '0x497e5f824388438248', _isBigNumber: true },
//     BigNumber {
//       _hex: '0x0e50c50364b83e478162301c304004105003143264cb932e1ea006094e554747',
//       _isBigNumber: true
//     }
//   ],
//   [
//     BigNumber {
//       _hex: '0x5004002004583c1841862940106084086ccb500ffff50d4e554747',
//       _isBigNumber: true
//     }
//   ],
//   [
//     BigNumber { _hex: '0xc038', _isBigNumber: true },
//     BigNumber {
//       _hex: '0x8640803884086038c1500c3000092400008c19640018015ffffff50a4e554747',
//       _isBigNumber: true
//     }
//   ]
// ]
pragma solidity 0.8.4;

import '../lib/DSTest.sol';

import '../../../contracts/src/DotNugg.sol';

// import '../../../contracts/src2/resolvers/SvgFileResolver.sol';

contract SystemTest is DSTest {
    uint256[][] items;

    DotNugg dotnugg;

    // SvgPostProcessResolver resolver;

    function setUp() public {
        dotnugg = new DotNugg();

        // resolver = new SvgPostProcessResolver();

        uint256[] memory a = new uint256[](9);
        a[1] = 0x02;
        a[2] = 0xe1f87e1f87e1f87e1fb4e1db4a9864a263419b0a98641a262ac066c2a6190691;
        a[3] = 0x8a3019b069884206a3019b063942a0ec05ec92e220ec05ec13e2a4c05ec13e85;
        a[4] = 0xb015b04fa16c056c204fa0ec056c20649a0ec056c24291685b015b0818847a0e;
        a[5] = 0xc056c20e47a02a2c056c21645a0ec056c21645a0ec056c21e45a06c056c21621;
        a[6] = 0x1e8b215b072449a2c066c1c911e8b019b063a445a0c066d1c819068321bb5601;
        a[7] = 0x87e1f87e1f87e1f87e1f87f559042e041d0c2c080b080a080445154516451244;
        a[8] = 0xaa68a30c26bffffff2d010100bca128aeb2f28d67fd0bca2593f12a84e554747;
        a[0] = 8;
        items.push(a);
    }

    function testSystem() public {
        // uint256 pallet = 0x00000000005616134e55636336e55666662e55666639e55666639e55656538e5;

        // Version.Memory memory m;
        // m.pallet = new uint256[](1);
        // m.pallet[0] = pallet;

        uint256[] memory res = dotnugg.nuggifyTest(33, items, address(this), '', '', 0, '');

        for (uint256 i = 0; i < res.length; i++) {
            emit log_named_uint('i', res[i]);
        }

        assertTrue(false);
    }
}
