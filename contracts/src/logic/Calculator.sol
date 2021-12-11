// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './Matrix.sol';
import './Rgba.sol';
import './Anchor.sol';

import '../types/Descriptor.sol';
import '../types/Version.sol';
import '../types/Pixel.sol';

import '../interfaces/IDotNugg.sol';

library Calculator {
    using Rgba for IDotNugg.Rgba;
    using Matrix for IDotNugg.Matrix;
    using Pixel for uint256;
    using Event for uint256;

    /**
     * @notice
     * @dev
     */
    function combine(
        uint256 featureLen,
        uint8 width,
        uint256 descriptor,
        Version.Memory[][] memory versions
    ) internal view returns (IDotNugg.Matrix memory resa) {
        IDotNugg.Canvas memory canvas;
        canvas.matrix = Matrix.create(width, width);
        canvas.receivers = new IDotNugg.Anchor[](featureLen);
        IDotNugg.Coordinate memory coord;
        coord.a = width / 2 + 1;
        coord.b = width / 2 + 1;
        coord.exists = true;
        IDotNugg.Rlud memory r;
        for (uint8 i = 0; i < featureLen; i++) {
            canvas.receivers[i] = IDotNugg.Anchor({coordinate: coord, radii: r});
        }
        canvas.matrix.width = width;
        canvas.matrix.height = width;

        IDotNugg.Mix memory mix;
        mix.matrix = Matrix.create(width, width);
        mix.receivers = new IDotNugg.Anchor[](featureLen);

        // IDotNugg.Item[] memory items = Decoder.parseItems(inputs, featureLen);

        for (uint8 i = 0; i < versions.length; i++) {
            if (versions[i].length > 0) {
                setMix(mix, versions[i], pickVersionIndex(canvas, versions[i]));

                formatForCanvas(canvas, mix);

                postionForCanvas(canvas, mix, descriptor);

                mergeToCanvas(canvas, mix);

                calculateReceivers(mix);

                updateReceivers(canvas, mix);
            }
        }

        return canvas.matrix;
    }

    /**
     * @notice
     * @devg
     */
    function postionForCanvas(
        IDotNugg.Canvas memory canvas,
        IDotNugg.Mix memory mix,
        uint256 descriptor
    ) internal view {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;

        (bool overExists, uint256 overX, uint256 overY) = Descriptor.receiverOverride(descriptor, mix.feature);

        if (overExists) {
            receiver.coordinate.a = uint8(overX);
            receiver.coordinate.b = uint8(overY);
        }

        uint256(mix.feature).log('mix.feature');

        uint256(anchor.coordinate.a).log(
            'anchor.coordinate.a',
            anchor.coordinate.b,
            'anchor.coordinate.b',
            receiver.coordinate.a,
            'receiver.coordinate.a',
            receiver.coordinate.b,
            'receiver.coordinate.b'
        );
        mix.xoffset = receiver.coordinate.a > anchor.coordinate.a ? receiver.coordinate.a - anchor.coordinate.a : 0;
        mix.yoffset = receiver.coordinate.b > anchor.coordinate.b ? receiver.coordinate.b - anchor.coordinate.b : 0;

        canvas.matrix.moveTo(mix.xoffset, mix.yoffset, mix.matrix.width, mix.matrix.height);
    }

    /**
     * @notice
     * @dev
     */
    function formatForCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;

        if (mix.version.expanders.l != 0 && anchor.radii.l != 0 && anchor.radii.l <= receiver.radii.l) {
            uint8 amount = receiver.radii.l - anchor.radii.l;
            mix.matrix.addColumnsAt(mix.version.expanders.l - 1, amount);
            anchor.coordinate.a += amount;
            if (mix.version.expanders.r > 0) mix.version.expanders.r += amount;
        }
        if (mix.version.expanders.r != 0 && anchor.radii.r != 0 && anchor.radii.r <= receiver.radii.r) {
            mix.matrix.addColumnsAt(mix.version.expanders.r - 1, receiver.radii.r - anchor.radii.r);
        }
        if (mix.version.expanders.d != 0 && anchor.radii.d != 0 && anchor.radii.d <= receiver.radii.d) {
            uint8 amount = receiver.radii.d - anchor.radii.d;
            mix.matrix.addRowsAt(mix.version.expanders.d, amount);
            anchor.coordinate.b += amount;
            if (mix.version.expanders.u > 0) mix.version.expanders.u += amount;
        }
        if (mix.version.expanders.u != 0 && anchor.radii.u != 0 && anchor.radii.u <= receiver.radii.u) {
            mix.matrix.addRowsAt(mix.version.expanders.u, receiver.radii.u - anchor.radii.u);
        }
    }

    /**
     * @notice
     * @dev
     * makes the sorts versions
     */
    function pickVersionIndex(IDotNugg.Canvas memory canvas, Version.Memory[] memory versions) internal pure returns (uint8) {
        require(versions.length > 0, 'CALC:PVI:0');
        if (versions.length == 1) {
            return 0;
        }
        uint8 index = uint8(versions.length) - 1;

        uint256 feature = (versions[0].data >> 75) & ShiftLib.mask(3);

        while (index > 0) {
            uint256 bits = (versions[index].data >> 27) & ShiftLib.mask(24);
            IDotNugg.Rlud memory anchorRadii = IDotNugg.Rlud({
                r: uint8((bits >> 18) & ShiftLib.mask(6)),
                l: uint8((bits >> 12) & ShiftLib.mask(6)),
                u: uint8((bits >> 6) & ShiftLib.mask(6)),
                d: uint8((bits) & ShiftLib.mask(6)),
                exists: true
            });

            if (checkRluds(anchorRadii, canvas.receivers[feature].radii)) {
                return index;
            }
            index = index - 1;
        }

        return 0;
    }

    function checkRluds(IDotNugg.Rlud memory r1, IDotNugg.Rlud memory r2) internal pure returns (bool) {
        return (r1.r <= r2.r && r1.l <= r2.l) || (r1.u <= r2.u && r1.d <= r2.d);
    }

    /**
     * @notice
     * @dev done
     * makes the sorts versions
     */
    function setMix(
        IDotNugg.Mix memory res,
        Version.Memory[] memory versions,
        uint8 versionIndex
    ) internal view {
        uint256 radiiBits = (versions[versionIndex].data >> 27) & ShiftLib.mask(24);
        uint256 expanderBits = (versions[versionIndex].data >> 3) & ShiftLib.mask(24);

        (uint256 x, uint256 y) = Version.getAnchor(versions[versionIndex]);

        (uint256 width, uint256 height) = Version.getWidth(versions[versionIndex]);

        res.version.width = uint8(width);
        res.version.height = uint8(height);
        res.version.anchor = IDotNugg.Anchor({
            radii: IDotNugg.Rlud({
                r: uint8((radiiBits >> 18) & ShiftLib.mask(6)),
                l: uint8((radiiBits >> 12) & ShiftLib.mask(6)),
                u: uint8((radiiBits >> 6) & ShiftLib.mask(6)),
                d: uint8((radiiBits >> 0) & ShiftLib.mask(6)),
                exists: true
            }),
            coordinate: IDotNugg.Coordinate({a: uint8(x), b: uint8(y), exists: true})
        });
        res.version.expanders = IDotNugg.Rlud({
            r: uint8((expanderBits >> 18) & ShiftLib.mask(6)),
            l: uint8((expanderBits >> 12) & ShiftLib.mask(6)),
            u: uint8((expanderBits >> 6) & ShiftLib.mask(6)),
            d: uint8((expanderBits >> 0) & ShiftLib.mask(6)),
            exists: true
        });
        res.version.calculatedReceivers = new IDotNugg.Coordinate[](8);

        res.version.staticReceivers = new IDotNugg.Coordinate[](8);

        for (uint256 i = 0; i < 8; i++) {
            (uint256 _x, uint256 _y, bool exists) = Version.getReceiverAt(versions[versionIndex], i, false);
            if (exists) {
                res.version.staticReceivers[i].a = uint8(_x);
                res.version.staticReceivers[i].b = uint8(_y);
                res.version.staticReceivers[i].exists = true;
            }
        }

        for (uint256 i = 0; i < 8; i++) {
            (uint256 _x, uint256 _y, bool exists) = Version.getReceiverAt(versions[versionIndex], i, true);
            if (exists) {
                res.version.calculatedReceivers[i].a = uint8(_x);
                res.version.calculatedReceivers[i].b = uint8(_y);
                res.version.calculatedReceivers[i].exists = true;
            }
        }

        // TODO - receivers?
        res.xoffset = 0;
        res.yoffset = 0;
        res.receivers = new IDotNugg.Anchor[](res.receivers.length);
        res.feature = uint8((versions[versionIndex].data >> 75) & ShiftLib.mask(3));
        res.matrix.set(versions[versionIndex], width, height);
    }

    /**
     * @notice done
     * @dev
     */
    function updateReceivers(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure {
        for (uint8 i = 0; i < mix.receivers.length; i++) {
            IDotNugg.Anchor memory m = mix.receivers[i];
            if (m.coordinate.exists) {
                m.coordinate.a += mix.xoffset;
                m.coordinate.b += mix.yoffset;
                canvas.receivers[i] = m;
            }
        }
    }

    /**
     * @notice done
     * @dev
     */
    function mergeToCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal view {
        // uint256 count;
        uint256 count;
        while (canvas.matrix.next() && mix.matrix.next()) {
            uint256 canvasPixel = canvas.matrix.current();
            uint256 mixPixel = mix.matrix.current();

            // if (mixPixel != 0 || canvasPixel != 0) {
            //     // assert(count++ < 100);
            //     // mixPixel.log('mixPixel', mixPixel.z(), 'mixPixel.z()', canvasPixel.z(), 'canvasPixel.z()');
            //     // canvasPixel.log('canvasPixel');
            // }
            // assert(mixPixel.e() && mixPixel.z() >= canvasPixel.z());

            if (mixPixel.e() && mixPixel.z() >= canvasPixel.z()) {
                // canvasPixel.z() = mixPixel.z();

                canvas.matrix.setCurrent(Rgba.combine(canvasPixel, mixPixel));
            }
        }
        canvas.matrix.moveBack();
        canvas.matrix.resetIterator();
        mix.matrix.resetIterator();
    }

    /**
     * @notice poop
     * @dev
     */
    function calculateReceivers(IDotNugg.Mix memory mix) internal pure {
        Anchor.convertReceiversToAnchors(mix);
    }

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
// Oh my god
// Becky, look at her butt
// Its so big
// She looks like one of those rap guys girlfriends
// Who understands those rap guys
// They only talk to her because she looks like a total prostitute
// I mean her butt
// It's just so big
// I can't believe it's so round
// It's just out there
// I mean, it's gross
// Look, she's just so black

// *rap*
// I like big butts and I can not lie
// You other brothers can't deny
// That when a girl walks in with an itty bitty waist
// And a round thing in your face
// You get sprung
// Wanna pull up tough
// Cuz you notice that butt was stuffed
// Deep in the jeans she's wearing
// I'm hooked and I can't stop staring
// Oh, baby I wanna get with ya
// And take your picture
// My homeboys tried to warn me
// But that butt you got
// Make Me so horney
// Ooh, rump of smooth skin
// You say you wanna get in my benz
// Well use me use me cuz you aint that average groupy

// I've seen them dancin'
// The hell with romancin'
// She's Sweat,Wet, got it goin like a turbo vette

// I'm tired of magazines
// Saying flat butts are the thing
// Take the average black man and ask him that
// She gotta pack much back

// So Fellas (yeah) Fellas(yeah)
// Has your girlfriend got the butt (hell yeah)
// Well shake it, shake it, shake it, shake it, shake that healthy butt
// Baby got back

// (LA face with Oakland booty)

// I like'em round and big
// And when I'm throwin a gig
// I just can't help myself
// I'm actin like an animal
// Now here's my scandal

// I wanna get you home
// And UH, double up UH UH
// I aint talkin bout playboy
// Cuz silicone parts were made for toys
// I wannem real thick and juicy
// So find that juicy double
// Mixalot's in trouble
// Beggin for a piece of that bubble
// So I'm lookin' at rock videos
// Knockin these bimbos walkin like hoes
// You can have them bimbos
// I'll keep my women like Flo Jo
// A word to the thick soul sistas
// I wanna get with ya
// I won't cus or hit ya
// But I gotta be straight when I say I wanna --
// Til the break of dawn
// Baby Got it goin on
// Alot of pimps won't like this song
// Cuz them punks lie to hit it and quit it
// But I'd rather stay and play
// Cuz I'm long and I'm strong
// And I'm down to get the friction on

// So ladies (yeah), Ladies (yeah)
// Do you wanna roll in my Mercedes (yeah)
// Then turn around
// Stick it out
// Even white boys got to shout
// Baby got back

// (LA face with the Oakland booty)

// Yeah baby
// When it comes to females
// Cosmo ain't got nothin to do with my selection
// 36-24-36
// Only if she's 5'3"

// So your girlfriend throws a Honda
// Playin workout tapes by Fonda
// But Fonda ain't got a motor in the back of her Honda
// My anaconda don't want none unless you've got buns hun
// You can do side bends or sit-ups, but please don't lose that butt
// Some brothers wanna play that hard role
// And tell you that the butt ain't gold
// So they toss it and leave it
// And I pull up quick to retrieve it
// So cosmo says you're fat
// Well I ain't down with that
// Cuz your waste is small and your curves are kickin
// And I'm thinkin bout stickin
// To the beanpole dames in the magazines
// You aint it miss thing
// Give me a sista I can't resist her
// Red beans and rice did miss her
// Some knucklehead tried to dis
// Cuz his girls were on my list
// He had game but he chose to hit 'em
// And pulled up quick to get with 'em
// So ladies if the butt is round
// And you wanna triple X throw down
// Dial 1-900-MIXALOT and kick them nasty thoughts
// Baby got back
// Baby got back
// Little in tha middle but she got much back x4
