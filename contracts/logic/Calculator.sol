// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './Matrix.sol';
import './Decoder.sol';
import './Rgba.sol';
import './Anchor.sol';

import '../interfaces/IDotNugg.sol';

library Calculator {
    using Rgba for IDotNugg.Rgba;
    using Matrix for IDotNugg.Matrix;

    /**
     * @notice
     * @dev
     */
    function combine(IDotNugg.Collection memory collection, bytes[] memory inputs) internal view returns (IDotNugg.Matrix memory resa) {
        IDotNugg.Canvas memory canvas;
        canvas.matrix = Matrix.create(collection.width, collection.height);
        canvas.receivers = new IDotNugg.Anchor[](collection.numFeatures);
        IDotNugg.Coordinate memory coord;
        coord.a = collection.width / 2;
        coord.b = collection.width / 2;
        coord.exists = true;
        IDotNugg.Rlud memory r;
        for (uint8 i = 0; i < collection.numFeatures; i++) {
            canvas.receivers[i] = IDotNugg.Anchor({coordinate: coord, radii: r});
        }
        canvas.matrix.width = collection.width;
        canvas.matrix.height = collection.height;

        IDotNugg.Mix memory mix;
        mix.matrix = Matrix.create(collection.width, collection.height);
        mix.receivers = new IDotNugg.Anchor[](collection.numFeatures);

        IDotNugg.Item[] memory items = Decoder.parseItems(inputs, collection.numFeatures);

        for (uint8 i = 0; i < items.length; i++) {
            if (items[i].versions.length > 0) {
                console.log('start feature:', items[i].feature);
                setMix(mix, items[i], pickVersionIndex(canvas, items[i]));

                formatForCanvas(canvas, mix);

                postionForCanvas(canvas, mix);

                mergeToCanvas(canvas, mix);

                calculateReceivers(mix);

                updateReceivers(canvas, mix);
                console.log('end feature:', items[i].feature);
            }
        }

        return canvas.matrix;
    }

    /**
     * @notice
     * @devg
     */
    function postionForCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal view {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;

        uint8 xoffset = receiver.coordinate.a - anchor.coordinate.a;
        uint8 yoffset = receiver.coordinate.b - anchor.coordinate.b;
        console.log(xoffset, yoffset);
        canvas.matrix.moveTo(xoffset, yoffset, mix.matrix.width, mix.matrix.height);
    }

    /**
     * @notice
     * @dev
     */
    function formatForCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal view {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;
        console.log('BEFORE x:', anchor.coordinate.a, ', y:', anchor.coordinate.b);
        console.log('BEFORE w:', mix.matrix.width, ', h:', mix.matrix.height);
        console.log('radii.r anchor: ', anchor.radii.r, 'receiver: ', receiver.radii.r);
        console.log('radii.l anchor: ', anchor.radii.l, 'receiver: ', receiver.radii.l);
        console.log('radii.u anchor: ', anchor.radii.u, 'receiver: ', receiver.radii.u);
        console.log('radii.d anchor: ', anchor.radii.l, 'receiver: ', receiver.radii.d);

        console.log('mix.version.expanders.r: ', mix.version.expanders.r);
        console.log('mix.version.expanders.l: ', mix.version.expanders.l);
        console.log('mix.version.expanders.u: ', mix.version.expanders.u);
        console.log('mix.version.expanders.d: ', mix.version.expanders.d);
        if (mix.version.expanders.l != 0 && anchor.radii.l != 0 && anchor.radii.l <= receiver.radii.l) {
            uint8 amount = receiver.radii.l - anchor.radii.l;
            mix.matrix.addColumnsAt(mix.version.expanders.l, amount); // FIXME - i removed adding and subtracting here... maybe we need to add back
            anchor.coordinate.a += amount;
            if (mix.version.expanders.r > 0) mix.version.expanders.r += amount;
        }
        if (mix.version.expanders.r != 0 && anchor.radii.r != 0 && anchor.radii.r <= receiver.radii.r) {
            mix.matrix.addColumnsAt(mix.version.expanders.r, receiver.radii.r - anchor.radii.r);
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

        console.log('AFTER x:', anchor.coordinate.a, ', y:', anchor.coordinate.b);
        console.log('AFTER w:', mix.matrix.width, ', h:', mix.matrix.height);
    }

    /**
     * @notice
     * @dev
     * makes the sorts versions
     */
    function pickVersionIndex(IDotNugg.Canvas memory canvas, IDotNugg.Item memory item) internal view returns (uint8) {
        require(item.versions.length > 0, 'CALC:PVI:0');
        if (item.versions.length == 1) {
            return 0;
        }
        uint8 index = uint8(item.versions.length) - 1;

        while (index > 0) {
            if (checkRluds(item.versions[index].anchor.radii, canvas.receivers[item.feature].radii)) {
                return index;
            }
            index = index - 1;
        }

        return 0;
    }

    function checkRluds(IDotNugg.Rlud memory r1, IDotNugg.Rlud memory r2) internal view returns (bool) {
        return (r1.r <= r2.r && r1.l <= r2.l) || (r1.u <= r2.u && r1.d <= r2.d);
    }

    /**
     * @notice
     * @dev done
     * makes the sorts versions
     */
    function setMix(
        IDotNugg.Mix memory res,
        IDotNugg.Item memory item,
        uint8 versionIndex
    ) internal view {
        res.version = item.versions[versionIndex];
        res.feature = item.feature;
        res.receivers = new IDotNugg.Anchor[](res.receivers.length);

        res.matrix.set(res.version.data, item.pallet, res.version.width, res.version.height);
    }

    /**
     * @notice done
     * @dev
     */
    function updateReceivers(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal view {
        for (uint8 i = 0; i < mix.receivers.length; i++) {
            IDotNugg.Anchor memory m = mix.receivers[i];
            if (m.coordinate.exists) {
                canvas.receivers[i] = m;
            }
        }
        // for (uint8 i = 0 ; i < canvas.receivers.length; i++) {
        //     console.log("CANVAS", i);
        //     console.log("x:", canvas.receivers[i].coordinate.a, ", y:" ,canvas.receivers[i].coordinate.b);
        //     console.log("___END___");
        // }
    }

    /**
     * @notice done
     * @dev
     */
    function mergeToCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal view {
        while (canvas.matrix.next() && mix.matrix.next()) {
            IDotNugg.Pixel memory canvasPixel = canvas.matrix.current();
            IDotNugg.Pixel memory mixPixel = mix.matrix.current();
            // console.log(mixPixel.exists);
            // console.logInt(mixPixel.zindex);
            // console.logInt(canvasPixel.zindex);
            // console.log('-------------');
            if (mixPixel.exists && mixPixel.zindex >= canvasPixel.zindex) {
                canvasPixel.zindex = mixPixel.zindex;
                //  console.log(Rgba.toAscii(canvasPixel.rgba), Rgba.toAscii(mixPixel.rgba));
                //  console.log('COMBINE', canvasPixel.rgba.toAscii(), mixPixel.rgba.toAscii());
                //  console.logInt(mixPixel.zindex);
                //  console.logInt(canvasPixel.zindex);

                canvasPixel.rgba.combine(mixPixel.rgba);
                //  console.log('COMBINE', canvasPixel.rgba.toAscii(), mixPixel.rgba.toAscii());

                //  console.log(Rgba.toAscii(canvasPixel.rgba), Rgba.toAscii(mixPixel.rgba));
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
    function calculateReceivers(IDotNugg.Mix memory mix) internal view {
        Anchor.convertReceiversToAnchors(mix);
    }

    // you combine one by one, and as you combine, child refs get overridden

    // function add(Combinable comb, )
}
// add parent refs, if any - will use remys algo only for the canvas
// the canvas will always be defined as the first, so if it isnt (will not happen for dotnugg), we define the center as all the child refs
//  pick best version
// figure out offset

// function merge(Canvas memory canvas, Matrix memory versionMatrix) internal view {
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
