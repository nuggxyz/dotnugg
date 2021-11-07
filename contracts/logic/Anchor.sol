// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import './Matrix.sol';

library Anchor {

    using Matrix for IDotNugg.Matrix;
    /*
     * @notice AKA fuck
     * @dev this is where we implement the logic you wrote in go
     */

     function convertCalculatedReceiversToAnchors(IDotNugg.Mix memory mix) internal pure {
        IDotNugg.Coordinate[] memory anchors = getAnchors(mix.matrix);

        for (uint8 i = 0; i < mix.version.calculatedReceivers.length; i++) {
            calculateReceiver(mix, mix.version.calculatedReceivers[i], anchors, i);
        }
     }

     function calculateReceiver(IDotNugg.Mix memory mix, IDotNugg.Coordinate memory calculatedReceiver, IDotNugg.Coordinate[] memory anchors, uint8 index) internal pure {
         IDotNugg.Rlud memory radii;
         IDotNugg.Coordinate memory coordinate;
         coordinate.a = anchors[calculatedReceiver.a].a;
         coordinate.b = anchors[calculatedReceiver.a].b;

        if (calculatedReceiver.b < 8) {
            coordinate.b = coordinate.b - calculatedReceiver.b;
        } else {
            coordinate.b = coordinate.b + (8 - calculatedReceiver.b);
        }

        while (mix.matrix.data[coordinate.b][coordinate.a+radii.r].exists) {
            radii.r++;
        }
        while (mix.matrix.data[coordinate.b][coordinate.a-radii.l].exists) {
            radii.l++;
        }
        while (mix.matrix.data[coordinate.b-radii.u][coordinate.a].exists) {
            radii.u++;
        }
        while (mix.matrix.data[coordinate.b+radii.d][coordinate.a].exists) {
            radii.d++;
        }

        if (!mix.receivers[index].coordinate.exists) {
            mix.receivers[index] = IDotNugg.Anchor({
                radii: radii,
                coordinate: coordinate
            });
        }
     }


    function getAnchors(IDotNugg.Matrix memory matrix) internal pure returns (IDotNugg.Coordinate[] memory anchors) {
        (uint8 topOffset, uint8 bottomOffset, IDotNugg.Coordinate memory center) = getBox(matrix);

        anchors[0] = center; // center

        anchors[1] = IDotNugg.Coordinate({a: center.a, b: center.b - topOffset, exists: true}); // top

        uint8 upperOffset = center.b - topOffset;
        if (upperOffset % 2 != 0) {
            upperOffset++;
        }
        anchors[2] = IDotNugg.Coordinate({a: center.a, b: upperOffset / 2, exists: true}); // inner top

        uint8 lowerOffset = center.b - bottomOffset;
        if (lowerOffset % 2 != 0) {
            lowerOffset++;
        }
        anchors[2] = IDotNugg.Coordinate({a: center.a, b: lowerOffset / 2, exists: true}); // inner bottom

        anchors[3] = IDotNugg.Coordinate({a: center.a, b: center.b - bottomOffset, exists: true}); // inner bottom

    }

    function getBox (IDotNugg.Matrix memory matrix) internal pure returns (uint8 topOffset, uint8 bottomOffset, IDotNugg.Coordinate memory center) {
        center.a = (matrix.width + 1) / 2;
        center.b =(matrix.height + 1) / 2;
        center.exists = true;

        bool topFound;
        bool bottomFound;
        bool shouldExpandSide = true;

        topOffset = 6;
        bottomOffset = 6;
        uint8 sideOffset = 4;

        while (!topFound && !bottomFound) {
            if (shouldExpandSide = !shouldExpandSide) {
                sideOffset++;
            }

            if (!topFound) {
                if (matrix.data[center.b-sideOffset][center.a+topOffset].exists
                && matrix.data[center.b+sideOffset][center.a+topOffset].exists) {
                    bottomOffset++;
                } else {
                    topFound = true;
                }
            }
            if (!bottomFound) {
                if (matrix.data[center.b-sideOffset][center.a-bottomOffset].exists
                && matrix.data[center.b+sideOffset][center.a-bottomOffset].exists) {
                    bottomOffset++;
                } else {
                    bottomFound = true;
                }
            }
        }

        if (topOffset != bottomOffset) {
            center.b = (topOffset+bottomOffset+1) / 2;
        }
    }
}
