// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './Matrix.sol';
import './Decoder.sol';
import './Rgba.sol';

import '../interfaces/IDotNugg.sol';

library Calculator {
    using Rgba for IDotNugg.Rgba;
    using Matrix for IDotNugg.Matrix;

    /**
     * @notice
     * @dev
     */
    function combine(IDotNugg.Collection memory collection, bytes[] memory inputs) internal pure returns (IDotNugg.Matrix memory resa) {
        IDotNugg.Canvas memory canvas;
        canvas.matrix = Matrix.create(collection.width, collection.height);
        canvas.receivers = new IDotNugg.Anchor[](collection.numFeatures);

        IDotNugg.Mix memory mix;
        mix.matrix = Matrix.create(collection.width, collection.height);

        IDotNugg.Item[] memory items = Decoder.parseItems(inputs);

        for (uint8 i = 0; i < inputs.length; i++) {
            setMix(mix, items[i], pickVersionIndex(canvas, items[i]));

            formatForCanvas(canvas, mix);

            postionForCanvas(canvas, mix);

            mergeToCanvas(canvas, mix);

            updateReceivers(canvas, mix);
        }

        return canvas.matrix;
    }

    /**
     * @notice
     * @dev
     */
    function postionForCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure returns (IDotNugg.Matrix memory res) {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;

        uint8 xoffset = receiver.coordinate.a - anchor.coordinate.a;
        uint8 yoffset = receiver.coordinate.b - anchor.coordinate.b;

        canvas.matrix.moveTo(xoffset, yoffset);
    }

    /**
     * @notice
     * @dev
     */
    function formatForCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure returns (IDotNugg.Matrix memory res) {
        IDotNugg.Anchor memory receiver = canvas.receivers[mix.feature];
        IDotNugg.Anchor memory anchor = mix.version.anchor;

        require(anchor.radii.r <= receiver.radii.r, 'CAL:FFC:0'); // DBP
        mix.matrix.addColumnsAt(anchor.coordinate.a + 1, receiver.radii.r - anchor.radii.r);

        require(anchor.radii.l <= receiver.radii.l, 'CAL:FFC:0'); // DBP
        mix.matrix.addColumnsAt(anchor.coordinate.a - 1, receiver.radii.l - anchor.radii.l);

        anchor.coordinate.a += receiver.radii.l - anchor.radii.l;

        require(anchor.radii.u <= receiver.radii.u, 'CAL:FFC:0'); // DBP
        mix.matrix.addRowsAt(anchor.coordinate.b + 1, receiver.radii.u - anchor.radii.u);

        require(anchor.radii.d <= receiver.radii.d, 'CAL:FFC:0'); // DBP
        mix.matrix.addRowsAt(anchor.coordinate.b - 1, receiver.radii.d - anchor.radii.d);

        anchor.coordinate.b += receiver.radii.d - anchor.radii.d;

        // postion for base
    }

    /**
     * @notice
     * @dev
     * makes the sorts versions
     */
    function pickVersionIndex(IDotNugg.Canvas memory canvas, IDotNugg.Item memory item) internal pure returns (uint8 res) {
        if (item.versions.length == 1) {
            res = 0;
        }
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
    ) internal pure {
        res.version = item.versions[versionIndex];
        res.feature = item.feature;

        res.matrix.set(res.version.data, item.pallet, res.version.width);
    }

    /**
     * @notice done
     * @dev
     */
    function updateReceivers(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure {
        for (uint8 i = 0; i < mix.version.staticReceivers.length; i++) {
            IDotNugg.Coordinate memory m = mix.version.staticReceivers[i];
            uint16 v;

            uint16 fakeV;
            uint16 fake2V;
            IDotNugg.Coordinate memory fake;
            IDotNugg.Coordinate memory fake2 = IDotNugg.Coordinate({a: 0, b: 0});

            assembly {
                v := m
                v := eq(m, 0)
                fakeV := eq(fake, 0)
                fake2V := eq(fake2, 0)
            }
            require(fakeV == 0 && fake2V != 0, 'WE FUCKED UP');
            if (v == 0) canvas.receivers[i] = m;
        }
    }

    /**
     * @notice done
     * @dev
     */
    function mergeToCanvas(IDotNugg.Canvas memory canvas, IDotNugg.Mix memory mix) internal pure {
        while (canvas.matrix.next() && mix.matrix.next()) {
            IDotNugg.Pixel memory b = canvas.matrix.current();
            IDotNugg.Pixel memory a = mix.matrix.current();

            uint8 v;

            uint8 fakeV;
            uint8 fake2V;
            IDotNugg.Coordinate memory fake;
            IDotNugg.Coordinate memory fake2 = IDotNugg.Coordinate({a: 0, b: 0});

            assembly {
                v := eq(a, 0)
                fakeV := eq(fake, 0)
                fake2V := eq(fake2, 0)
            }
            require(fakeV == 0 && fake2V != 0, 'WE FUCKED UP');

            if (v == 0 && a.zindex > b.zindex) {
                b.zindex = a.zindex;
                b.rgba.combine(a.rgba);
            }
        }

        canvas.matrix.resetIterator();
        mix.matrix.resetIterator();
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
