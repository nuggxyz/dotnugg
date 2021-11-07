// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';

contract PlainTest {
    /**
     * @notice done
     * @dev
     */
    function tfizzle()
        external
        pure
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    // uint256
    {
        uint256 d;
        uint256 d3;
        uint256 d4;
        //   uint256 d5;
        //   uint256 d6;

        uint256 v;

        IDotNugg.Coordinate memory fake;
        IDotNugg.Coordinate memory fake3;

        IDotNugg.Coordinate memory fake4;
        //   IDotNugg.Coordinate memory fake5;
        //   IDotNugg.Coordinate memory fake6;

        IDotNugg.Coordinate memory fake2 = IDotNugg.Coordinate({a: 0, b: 0});

        assembly {
            d := mload(add(fake, 2))
            d3 := mload(add(fake3, 2))
            d4 := mload(add(fake4, 2))
            // d := fake5
            // d := fake6

            v := mload(add(fake2, 2))
            // v := iszero(v)
            // fakeV := eq(fake, 0)
            // fake2V := eq(fake2, 0)
        }

        //   require(fakeV == 0 && fake2V != 0, 'WE FUCKED UP');

        return (d, d3, d4, v);
    }

    //   canvas.matrix.resetIterator();
    //   mix.matrix.resetIterator();

    // you combine one by one, and as you combine, child refs get overridden

    // function add(Combinable comb, )
}
// add parent refs, if any - will use ***REMOVED***s algo only for the canvas
// the canvas will always be defined as the first, so if it isnt (will not happen for dotnugg), we define the center as all the child refs
//  pick best version
// figure out offset

// function merge(Canvas memory canvas, Matrix memory versionMatrix) internal pure {
//     for (int8 y = (canvas.matrix.data.length / 2) * -1; y <= canvas.matrix.data.length / 2; y++) {
//         for (int8 x = (canvas.matrix.width / 2) * -1; x <= canvas.matrix[j].width / 2; x++) {
//             Pixel memory canvas = canvas.matrix.at(x, y);
//             Pixel memory addr = combinable.matrix.at(x, y);

//             if (addr != 0 && addr.layer > canvas.layer) {
//                 canvas.layer = addr.layer;
//                 canvas.rgba = Colors.combine(canvas.rgba, add.rgba);
//             }
//         }
//     }
// }
