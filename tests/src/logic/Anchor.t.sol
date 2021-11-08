// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../../lib/DSTest.sol';
import '../../../contracts/interfaces/IDotNugg.sol';
import '../../../contracts/logic/Matrix.sol';


contract AnchorTest is DSTest {
    using Matrix for IDotNugg.Matrix;

    function test_getAnchors() public {

    }

    // function test_getBox() public {
    //     IDotNugg.Pixel[] memory pallet = new IDotNugg.Pixel[](2);
    //     pallet[0] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 1, g: 1, b: 1, a: 255}), zindex: 2, exists: true});
    //     pallet[1] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 255, g: 255, b: 255, a: 27}), zindex: 3, exists: true});

    //     IDotNugg.Matrix memory want = Matrix.create(33, 33);

    //     want.data[2][4] = pallet[0];
    //     want.data[2][5] = pallet[0];
    //     want.data[2][6] = pallet[0];
    //     want.data[2][7] = pallet[0];
    //     want.data[2][8] = pallet[0];
    //     want.data[2][9] = pallet[0];
    //     want.data[2][10] = pallet[0];
    //     want.data[2][11] = pallet[0];
    //     want.data[2][12] = pallet[0];
    //     want.data[2][13] = pallet[0];
    //     want.data[2][14] = pallet[0];
    //     want.data[2][15] = pallet[0];
    //     want.data[2][16] = pallet[0];
    // }
}
