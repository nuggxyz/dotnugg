// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import './Matrix.sol';
import './Decoder.sol';
import './Rgba.sol';
// import './Anchor.sol';

import '../types/PalletType.sol';
import '../types/MatrixType.sol';
import '../types/SudoArrayType.sol';
import '../types/ContentType.sol';
import '../types/CanvasType.sol';
import '../types/VersionType.sol';
import '../types/CollectionType.sol';
import '../types/AnchorType.sol';
import '../types/PixelType.sol';
import '../types/ReceiverType.sol';
import '../types/MixType.sol';

import '../../test/Event.sol';

library Calculator {
    using Event for uint256;

    using ShiftLib for uint256;

    using ShiftLib for uint256[];

    using PalletType for PalletType.Memory;
    using VersionType for VersionType.Memory;
    using CanvasType for CanvasType.Memory;
    using MixType for MixType.Memory;
    using Matrix for MatrixType.Memory;
    using MatrixType for MatrixType.Memory;

    using CollectionType for uint256;
    using PixelType for uint256;
    using AnchorType for uint256;
    using VersionType for uint256;
    using ReceiverType for uint256;
    using MatrixType for uint256;

    /**
     * @notice
     * @dev
     */
    function combine(
        uint256 numfeatures,
        uint256 width,
        uint256[][] memory inputs
    ) internal view returns (MatrixType.Memory memory resa) {
        CanvasType.Memory memory canvas;
        MixType.Memory memory mix;

        canvas.matrix = Matrix.create(width, width);

        uint256 initalAnchor;

        initalAnchor = initalAnchor.anchor_x(width / 2);
        initalAnchor.log('combine-initalAnchor-1');

        initalAnchor = initalAnchor.anchor_y(width / 2);
        initalAnchor.log('combine-initalAnchor-2');

        initalAnchor = initalAnchor.anchor_coordExists(true);
        initalAnchor.log('combine-initalAnchor-3');

        // IDotNugg.Coordinate memory coord;
        // coord.a = collection.width / 2;
        // coord.b = collection.width / 2;
        // coord.exists = true;
        // IDotNugg.Rlud memory r;
        for (uint256 i = 0; i < numfeatures; i++) {
            // canvas.rec(i, )= IDotNugg.Anchor({coordinate: coord, radii: r});
            numfeatures.log('how many?');

            canvas.canvas_receivers(i, initalAnchor);
        }

        // canvas.matrix.data = canvas.matrix.pixel(x, update);
        canvas.matrix.data = canvas.matrix.data.matrix_width(width).matrix_height(width);
        // canvas.matrix.height = collection.height;

        mix.canvas.matrix = Matrix.create(width, width);
        // mix.receivers = new IDotNugg.Anchor[](collection.numFeatures);
        // , numfeatures
        ItemType.Memory[] memory items = Decoder.parseItems(inputs);

        for (uint8 i = 0; i < items.length; i++) {
            if (items[i].versions.length > 0) {
                // console.log('start feature:', items[i].feature);
                // setMix(mix, items[i], pickVersionIndex(canvas, items[i]));
                setMix(mix, items[i], 0);

                // formatForCanvas(canvas, mix);

                postionForCanvas(canvas, mix);

                {
                    mergeToCanvas(canvas, mix);
                }

                // calculateReceivers(mix);

                updateReceivers(canvas, mix);
                // console.log('end feature:', items[i].feature);
            }
        }

        return canvas.matrix;
    }

    /**
     * @notice
     * @devg
     */
    function postionForCanvas(CanvasType.Memory memory canvas, MixType.Memory memory mix) internal view {
        uint256 receiver = canvas.canvas_receivers(mix.version.info.version_feature());
        uint256 anchor = canvas.canvas_receivers(mix.version.info.version_anchor());

        uint256 xoffset = receiver.anchor_x() - anchor.anchor_x();
        uint256 yoffset = receiver.anchor_y() - anchor.anchor_y();

        xoffset.log('xoffset');

        canvas.matrix.moveTo(xoffset, yoffset, mix.canvas.matrix.data.matrix_width(), mix.canvas.matrix.data.matrix_height());
        yoffset.log('yoffset');
    }

    // function checkRluds(IDotNugg.Rlud memory r1, IDotNugg.Rlud memory r2) internal view  returns (bool) {
    //     return (r1.r <= r2.r && r1.l <= r2.l) || (r1.u <= r2.u && r1.d <= r2.d);
    // }

    /**
     * @notice
     * @dev done
     * makes the sorts versions
     */
    function setMix(
        MixType.Memory memory res,
        ItemType.Memory memory item,
        uint256 versionIndex
    ) internal view {
        res.version = item.versions[versionIndex];
        res.canvas.matrix.set(res.version.content, item.pallet, res.version.info.version_width(), res.version.info.version_height());
    }

    /**
     * @notice done
     * @dev
     */
    function updateReceivers(CanvasType.Memory memory canvas, MixType.Memory memory mix) internal view {
        for (uint8 i = 0; i < 8; i++) {
            if (mix.canvas.canvas_receivers(i).anchor_coordExists()) {
                canvas.canvas_receivers(i, mix.canvas.canvas_receivers(i));
            }
        }
    }

    /**
     * @notice done
     * @dev
     */
    function mergeToCanvas(CanvasType.Memory memory canvas, MixType.Memory memory mix) internal view {
        while (canvas.matrix.next() && mix.canvas.matrix.next()) {
            uint256 mixActive = mix.canvas.matrix.matrix_active_pixel();
            uint256 canActive = canvas.matrix.matrix_active_pixel();
            if (mixActive.pixel_exists() && mixActive.pixel_zindex() >= canActive.pixel_zindex()) {
                uint256 combined = Rgba.combine(canActive, mixActive).pixel_zindex(mixActive.pixel_zindex());
                canvas.matrix.matrix_active_pixel(combined);
            }
        }
        canvas.matrix.resetIterator();
        mix.canvas.matrix.resetIterator();
    }

    // /**
    //  * @notice poop
    //  * @dev
    //  */
    // function calculateReceivers(MixType.Memory memory mix) internal view  {
    //     Anchor.convertReceiversToAnchors(mix);
    // }

    // you combine one by one, and as you combine, child refs get overridden

    // function add(Combinable comb, )
}

// /**
//  * @notice expansion
//  * @dev
//  */
// function formatForCanvas(CanvasType.Memory memory canvas, MixType.Memory memory mix) internal view  {
//     uint256 receiver = canvas.canvas_receivers(mix.version.version_feature());
//     uint256 anchor = canvas.canvas_receivers(mix.version.version_anchor());

//     if (mix.version.version_expanders().rlud_left() != 0 && anchor.radii.l != 0 && anchor.radii.l <= receiver.radii.l) {
//         uint8 amount = receiver.radii.l - anchor.radii.l;
//         mix.canvas.matrix.addColumnsAt(mix.version.version_expanders().rlud_left() - 1, amount);
//         anchor.coordinate.a += amount;
//         if (mix.version.version_expanders().rlud_right() > 0) mix.version.version_expanders().rlud_right() += amount; // TODO
//     }
//     if (mix.version.version_expanders().rlud_right() != 0 && anchor.rlud_right() != 0 && anchor.rlud_right() <= receiver.rlud_right()) {
//         mix.canvas.matrix.addColumnsAt(mix.version.version_expanders().rlud_right() - 1, receiver.rlud_right() - anchor.rlud_right());
//     }
//     if (mix.version.version_expanders().rlud_down() != 0 && anchor.radii.d != 0 && anchor.radii.d <= receiver.radii.d) {
//         uint8 amount = receiver.radii.d - anchor.radii.d;
//         mix.canvas.matrix.addRowsAt(mix.version.version_expanders().rlud_down(), amount);
//         anchor.coordinate.b += amount;
//         if (mix.version.version_expanders().rlud_down() > 0) mix.version.version_expanders().rlud_down() += amount; // TODO
//     }
//     if (mix.version.version_expanders().rlud_down() != 0 && anchor.radii.u != 0 && anchor.radii.u <= receiver.radii.u) {
//         mix.canvas.matrix.addRowsAt(mix.version.version_expanders().rlud_down(), receiver.radii.u - anchor.radii.u);
//     }
// }

// /**
//  * @notice
//  * @dev
//  * makes the sorts versions
//  */
// function pickVersionIndex(CanvasType.Memory memory canvas, ItemType.Memory memory item) internal view  returns (uint8) {
//     require(item.versions.length > 0, 'CALC:PVI:0');
//     if (item.versions.length == 1) {
//         return 0;
//     }
//     uint8 index = uint8(item.versions.length) - 1;

//     while (index > 0) {
//         if (checkRluds(item.versions[index].anchor.radii, canvas.receivers[item.feature].radii)) {
//             return index;
//         }
//         index = index - 1;
//     }

//     return 0;
// }
// add parent refs, if any - will use ***REMOVED***s algo only for the canvas
// the canvas will always be defined as the first, so if it isnt (will not happen for dotnugg), we define the center as all the child refs
//  pick best version
// figure out offset

// function merge(Canvas memory canvas, Matrix memory versionMatrix) internal view  {
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
