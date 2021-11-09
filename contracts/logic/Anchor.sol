// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import './Matrix.sol';
import '../test/Console.sol';

library Anchor {
    using Matrix for IDotNugg.Matrix;

    /*
     * @notice AKA fuck
     * @dev this is where we implement the logic you wrote in go
     */

    function convertReceiversToAnchors(IDotNugg.Mix memory mix) internal view {
        IDotNugg.Coordinate[] memory anchors;
        uint8 stat = 0;
        uint8 cal = 0;


        for (uint8 i = 0; i < mix.version.calculatedReceivers.length; i++) {
            IDotNugg.Coordinate memory coordinate;
            if (mix.version.staticReceivers[i].exists) {
                stat++;
                coordinate = mix.version.staticReceivers[i];
            } else if (mix.version.calculatedReceivers[i].exists) {
                cal++;
                if (anchors.length == 0) anchors = getAnchors(mix.matrix);
                coordinate = calculateReceiverCoordinate(mix, mix.version.calculatedReceivers[i], anchors);
            }
            fledgeOutTheRluds(mix, coordinate, i);
        }

        // console.log("static receivers", stat);
        // console.log("calc receivers", cal);
    }
    // receiver := { feature: EYES, zindex: 2, yoffset: +2 }
    // receiver := { feature: EARS, zindex: 2, yoffset: +2 }
    // receiver := { feature: GLASSES, zindex: 2, yoffset: +2 }
    // receiver := { feature: MOUTH, zindex: 3, yoffset: +0 }
    // receiver := { feature: HAIR, zindex: 1, yoffset: +1 }
    // receiver := { feature: SAUCE, zindex: 4, yoffset: +0 }
    // receiver := { feature: HAT, zindex: 1, yoffset: +1 }
    // receiver := { feature: SPECIAL, zindex: 0, yoffset: +0 }

    function fledgeOutTheRluds(
        IDotNugg.Mix memory mix,
        IDotNugg.Coordinate memory coordinate,
        uint8 index
    ) internal view {
        IDotNugg.Rlud memory radii;
        while (mix.version.expanders.r != 0 && coordinate.a < mix.matrix.width - 1 && mix.matrix.data[coordinate.b][coordinate.a + (radii.r + 1)].exists) {
            radii.r++;
        }
        while (mix.version.expanders.l != 0 && coordinate.a != 0 && mix.matrix.data[coordinate.b][coordinate.a - (radii.l + 1)].exists) {
            radii.l++;
        }
        while (mix.version.expanders.u != 0 && coordinate.b != 0 && mix.matrix.data[coordinate.b - (radii.u + 1)][coordinate.a].exists) {
            radii.u++;
        }
        while (mix.version.expanders.d != 0 && coordinate.b < mix.matrix.height - 1 && mix.matrix.data[coordinate.b + (radii.d + 1)][coordinate.a].exists) {
            radii.d++;
        }

        if (!mix.receivers[index].coordinate.exists) {
            mix.receivers[index] = IDotNugg.Anchor({radii: radii, coordinate: coordinate});
        }
        // console.log("x:",coordinate.a, ", y:", coordinate.b);
        // console.log("radii");
        // console.log(radii.l, radii.r, radii.u, radii.d);
        // console.log("---------");
    }

    function calculateReceiverCoordinate(
        IDotNugg.Mix memory mix,
        IDotNugg.Coordinate memory calculatedReceiver,
        IDotNugg.Coordinate[] memory anchors
    ) internal view returns (IDotNugg.Coordinate memory coordinate) {
        coordinate.a = anchors[calculatedReceiver.a].a;
        coordinate.b = anchors[calculatedReceiver.a].b;
        coordinate.exists = true;

        if (calculatedReceiver.b < 8) {
            coordinate.b = coordinate.b - calculatedReceiver.b;
        } else {
            coordinate.b = coordinate.b + (8 - calculatedReceiver.b);
        }

        while (!mix.matrix.data[coordinate.b][coordinate.a].exists) {
            if (anchors[0].b > coordinate.b) {
                coordinate.b++;
            } else {
                coordinate.b--;
            }
        }
        return coordinate;
    }

    function getAnchors(IDotNugg.Matrix memory matrix) internal view returns (IDotNugg.Coordinate[] memory anchors) {
        (uint8 topOffset, uint8 bottomOffset, IDotNugg.Coordinate memory center) = getBox(matrix);

        anchors = new IDotNugg.Coordinate[](5);

        anchors[0] = center; // center

        anchors[1] = IDotNugg.Coordinate({a: center.a, b: center.b - topOffset, exists: true}); // top

        uint8 upperOffset = topOffset;
        if (upperOffset % 2 != 0) {
            upperOffset++;
        }
        anchors[2] = IDotNugg.Coordinate({a: center.a, b: center.b - (upperOffset / 2), exists: true}); // inner top

        uint8 lowerOffset = bottomOffset;
        if (lowerOffset % 2 != 0) {
            lowerOffset++;
        }
        anchors[3] = IDotNugg.Coordinate({a: center.a, b: center.b + (lowerOffset / 2), exists: true}); // inner bottom

        anchors[4] = IDotNugg.Coordinate({a: center.a, b: center.b + bottomOffset, exists: true}); // inner bottom
    }

    function getBox(IDotNugg.Matrix memory matrix)
        internal
        view
        returns (
            uint8 topOffset,
            uint8 bottomOffset,
            IDotNugg.Coordinate memory center
        )
    {
        center.a = (matrix.width) / 2;
        center.b = (matrix.height) / 2;
        center.exists = true;

        bool topFound = false;
        bool bottomFound = false;
        bool sideFound = false;
        bool shouldExpandSide = true;

        topOffset = 1;
        bottomOffset = 1;
        uint8 sideOffset = 1;

        bool allFound = false;

        while (!allFound) {
            if (shouldExpandSide = !shouldExpandSide && !sideFound) {
                if (
                    matrix.data[center.b - topOffset][center.a - (sideOffset + 1)].exists && // potential top left
                    matrix.data[center.b - topOffset][center.a + (sideOffset + 1)].exists && // potential top right
                    matrix.data[center.b + bottomOffset][center.a - (sideOffset + 1)].exists && // potential bot left
                    matrix.data[center.b + bottomOffset][center.a + (sideOffset + 1)].exists // potential bot right
                ) {
                    sideOffset++;
                } else {
                    sideFound = true;
                }
            }
            if (!topFound) {
                if (
                    center.b - topOffset > 0 &&
                    matrix.data[center.b - (topOffset + 1)][center.a - sideOffset].exists && // potential top left
                    matrix.data[center.b - (topOffset + 1)][center.a + sideOffset].exists // potential top right
                ) {
                    topOffset++;
                } else {
                    topFound = true;
                }
            }
            if (!bottomFound) {
                if (
                    center.b + bottomOffset < matrix.height - 1 &&
                    matrix.data[center.b + (bottomOffset + 1)][center.a - sideOffset].exists && // potential bot left
                    matrix.data[center.b + (bottomOffset + 1)][center.a + sideOffset].exists // potenetial bot right
                ) {
                    bottomOffset++;
                } else {
                    bottomFound = true;
                }
            }
            if (bottomFound && topFound && sideFound) allFound = true;
        }

        if (topOffset != bottomOffset) {
            uint8 newHeight = topOffset + bottomOffset + 1;
            uint8 relativeCenter = (newHeight % 2 == 0 ? newHeight : newHeight + 1) / 2;
            uint8 newCenter = relativeCenter + center.b - 1 - topOffset;
            if (newCenter > center.b) {
                uint8 diff = newCenter - center.b;
                topOffset += diff;
                bottomOffset > diff ? bottomOffset = bottomOffset - diff : bottomOffset = diff - bottomOffset;
            } else {
                uint8 diff = center.b - newCenter;
                topOffset > diff ? topOffset = topOffset - diff : topOffset = diff - topOffset;
                bottomOffset += diff;
            }
            center.b = newCenter;
        }
    }
}
