// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';
import './Matrix.sol';

library Anchor {
    using Matrix for IDotNugg.Matrix;
    using Version for Version.Memory;

    /*
     * @notice AKA fuck
     * @dev this is where we implement the logic you wrote in go
     */

    function convertReceiversToAnchors(IDotNugg.Mix memory mix) internal pure {
        IDotNugg.Coordinate[] memory anchors;
        uint8 stat = 0;
        uint8 cal = 0;

        for (uint8 i = 0; i < mix.version.staticReceivers.length; i++) {
            IDotNugg.Coordinate memory coordinate;
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
    ) internal pure {
        IDotNugg.Rlud memory radii;

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
    ) internal pure returns (IDotNugg.Coordinate memory coordinate) {
        coordinate.a = anchors[calculatedReceiver.a].a;
        coordinate.b = anchors[calculatedReceiver.a].b;
        coordinate.exists = true;

        if (calculatedReceiver.b < 8) {
            coordinate.b = coordinate.b - calculatedReceiver.b;
        } else {
            coordinate.b = coordinate.b + (8 - calculatedReceiver.b);
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

    function getAnchors(IDotNugg.Matrix memory matrix) internal pure returns (IDotNugg.Coordinate[] memory anchors) {
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
        pure
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
// Whatcha gonna do with all that junk
// All that junk inside your trunk
// I'ma get get get get you drunk
// Get you love drunk off my hump
// My hump my hump my hump my hump my hump
// My hump my hump my hump my lovely little lumps
// Check it out
// I drive these brothers crazy
// I do it on the daily
// They treat me really nicely
// They buy me all these ice
// Dolce and Gabbana
// Fendi and Madonna
// Caring they be sharin'
// All their money got me wearing fly
// Whether I ain't askin'
// They say they love mah ass in
// Seven jeans
// True religion
// I say no
// But they keep givin'
// So I keep on takin'
// And no I ain't takin'
// We can keep on datin'
// Now keep on demonstratin'
// My love my love my love my love
// You love my lady lumps
// My hump my hump my hump
// My humps they got you
// She's got me spending
// Oh, spending all your money on me
// And spending time on me
// She's got me spending
// Oh, spending all your money on me
// Uh on me on me
// Whatcha gonna do with all that junk
// All that junk inside that trunk
// I'm a get get get get you drunk
// Get you love drunk off my hump
// Whatcha gonna do with all that ass
// All that ass inside your jeans
// I'm a make make make make you scream
// Make you scream make you scream
// 'Cause of my humps my hump my hump my hump
// My hump my hump my hump my lovely lady lumps
// Check it out
// I met a girl down at the disco
// She said hey hey hey ya lets go
// I can be ya baby, you could be my honey
// Let's spend time not money
// And mix your milk with my coco puff
// Milky milky coco
// Mix your milk with my coco puff
// Milky milky
// Right
// They say I'm really sexy
// The boys they wanna sex me
// They always standin' next to me
// Always dancin' next to me
// Tryin' a feel my hump hump
// Lookin' at my lump lump
// You can look but you can't touch it
// If you touch it
// I'm a start some drama
// You don't want no drama
// No no drama no no no no drama
// So don't pull on my hand boy
// You ain't my man boy
// I'm just tryin' a dance boy
// And move my hump
// My hump my hump my hump my hump
// My hump my hump my hump my hump my hump my hump
// My lovely lady lumps
// My lovely lady lumps my lovely lady lumps
// In the back and in the front
// My loving got you
// She's got me spending
// Oh, spending all your money on me
// And spending time on me
// She's got me spending
// Oh, spending all your money on me
// Uh on me on me
// Whatcha gonna do with all that junk
// All that junk inside that trunk
// I'm a get get get get you drunk
// Get you love drunk off my hump
// Whatcha gonna do with all that ass
// All that ass inside your jeans
// I'm a make make make make you scream
// Make you scream make you scream
// Whatcha gonna do with all that junk
// All that junk inside that trunk
// I'm a get get get get you drunk
// Get you love drunk off this hump
// Whatcha gonna do with all that breast
// All that breast inside that shirt
// I'm a make make make make you work
// Make you work work make you work
// She's got me spending
// Oh, spending all your money on me
// And spending time on me
// She's got me spending
// Oh, spending all your money on me
// Uh on me on me
