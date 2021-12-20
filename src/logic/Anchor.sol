// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import '../types/Types.sol';
import './Matrix.sol';

library Anchor {
    using Matrix for Types.Matrix;
    using Version for Version.Memory;

    function convertReceiversToAnchors(Types.Mix memory mix) internal pure {
        Types.Coordinate[] memory anchors;
        uint8 stat = 0;
        uint8 cal = 0;

        for (uint8 i = 0; i < mix.version.staticReceivers.length; i++) {
            Types.Coordinate memory coordinate;
            if (mix.version.staticReceivers[i].exists) {
                stat++;
                coordinate = mix.version.staticReceivers[i];
                mix.receivers[i].coordinate.a = coordinate.b;
                mix.receivers[i].coordinate.b = coordinate.a;
                mix.receivers[i].coordinate.exists = true;
            } else if (mix.version.calculatedReceivers[i].exists) {
                // if (mix.feature != 0) continue;

                cal++;
                if (anchors.length == 0) anchors = getAnchors(mix.matrix);
                coordinate = calculateReceiverCoordinate(mix, mix.version.calculatedReceivers[i], anchors);
                fledgeOutTheRluds(mix, coordinate, i);
            }
        }
    }

    function fledgeOutTheRluds(
        Types.Mix memory mix,
        Types.Coordinate memory coordinate,
        uint8 index
    ) internal pure {
        Types.Rlud memory radii;

        while (coordinate.a < mix.matrix.width - 1 && mix.matrix.version.bigMatrixHasPixelAt(coordinate.a + (radii.r + 1), coordinate.b)) {
            radii.r++;
        }
        while (coordinate.a != 0 && coordinate.a >= (radii.l + 1) && mix.matrix.version.bigMatrixHasPixelAt(coordinate.a - (radii.l + 1), coordinate.b)) {
            radii.l++;
        }
        while (coordinate.b != 0 && coordinate.b >= (radii.u + 1) && mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b - (radii.u + 1))) {
            radii.u++;
        }
        while (coordinate.b < mix.matrix.height - 1 && mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b + (radii.d + 1))) {
            radii.d++;
        }

        if (!mix.receivers[index].coordinate.exists) {
            mix.receivers[index] = Types.Anchor({radii: radii, coordinate: coordinate});
        }
    }

    function calculateReceiverCoordinate(
        Types.Mix memory mix,
        Types.Coordinate memory calculatedReceiver,
        Types.Coordinate[] memory anchors
    ) internal pure returns (Types.Coordinate memory coordinate) {
        coordinate.a = anchors[calculatedReceiver.a].a;
        coordinate.b = anchors[calculatedReceiver.a].b;
        coordinate.exists = true;

        if (calculatedReceiver.b < 32) {
            coordinate.b = coordinate.b - calculatedReceiver.b;
        } else {
            coordinate.b = coordinate.b + (calculatedReceiver.b - 32);
        }

        while (!mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b)) {
            if (anchors[0].b > coordinate.b) {
                coordinate.b++;
            } else {
                coordinate.b--;
            }
        }
        return coordinate;
    }

    function getAnchors(Types.Matrix memory matrix) internal pure returns (Types.Coordinate[] memory anchors) {
        (uint8 topOffset, uint8 bottomOffset, Types.Coordinate memory center) = getBox(matrix);

        anchors = new Types.Coordinate[](5);

        anchors[0] = center; // center

        anchors[1] = Types.Coordinate({a: center.a, b: center.b - topOffset, exists: true}); // top

        uint8 upperOffset = topOffset;
        if (upperOffset % 2 != 0) {
            upperOffset++;
        }
        anchors[2] = Types.Coordinate({a: center.a, b: center.b - (upperOffset / 2), exists: true}); // inner top

        uint8 lowerOffset = bottomOffset;
        if (lowerOffset % 2 != 0) {
            lowerOffset++;
        }
        anchors[3] = Types.Coordinate({a: center.a, b: center.b + (lowerOffset / 2), exists: true}); // inner bottom

        anchors[4] = Types.Coordinate({a: center.a, b: center.b + bottomOffset, exists: true}); // bottom
    }

    function getBox(Types.Matrix memory matrix)
        internal
        pure
        returns (
            uint8 topOffset,
            uint8 bottomOffset,
            Types.Coordinate memory center
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
                    matrix.version.bigMatrixHasPixelAt(center.a - (sideOffset + 1), center.b - topOffset) &&
                    // potential top left
                    matrix.version.bigMatrixHasPixelAt(center.a + (sideOffset + 1), center.b - topOffset) &&
                    // potential top right
                    matrix.version.bigMatrixHasPixelAt(center.a - (sideOffset + 1), center.b + bottomOffset) &&
                    // potential bot left
                    matrix.version.bigMatrixHasPixelAt(center.a + (sideOffset + 1), center.b + bottomOffset)
                    // potential bot right
                ) {
                    sideOffset++;
                } else {
                    sideFound = true;
                }
            }
            if (!topFound) {
                if (
                    center.b - topOffset > 0 &&
                    matrix.version.bigMatrixHasPixelAt(center.a - sideOffset, center.b - (topOffset + 1)) &&
                    // potential top left
                    matrix.version.bigMatrixHasPixelAt(center.a + sideOffset, center.b - (topOffset + 1))
                    // potential top right
                ) {
                    topOffset++;
                } else {
                    topFound = true;
                }
            }
            if (!bottomFound) {
                if (
                    center.b + bottomOffset < matrix.height - 1 &&
                    matrix.version.bigMatrixHasPixelAt(center.a - sideOffset, center.b + (bottomOffset + 1)) &&
                    // potential bot left
                    matrix.version.bigMatrixHasPixelAt(center.a + sideOffset, center.b + (bottomOffset + 1))
                    // potenetial bot right
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
