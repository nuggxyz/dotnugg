// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/INuggIn.sol';

import './Matrix.sol';
import './Decoder.sol';

library Calcultor {
    /**
     * @notice
     * @dev
     */
    function combine(Collection memory collection, bytes[] memory inputs) internal pure returns (Matrix memory res) {
        Base memory base = Base({matrix: MatrixLib.create(collection.width, collection.height), anchors: new Coordinate[](collection.feautreLen)});

        Item[] memory items = Decoder.parseItems(inputs);

        for (uint8 i = 0; i < inputs.length; i++) {
            Mix memory mix = Decoder.parseMix(item, pickVersionIndex(base, item));

            formatForBase(base, mix);

            mergeToBase(base, mix);

            updateChildAnchors(base, mix);
        }

        return base.matrix;
    }

    /**
     * @notice
     * @dev
     */
    function addToBase(Base memory base, Mix memory mix) internal pure {
        // this should return not full matrix - only the thing inside .nugg files - this is because we want to make it easy to expand
        // update child anchors - this accomplishes same thing as what anchor-on-attribute did before
        // can come before or after mer
    }

    /**
     * @notice
     * @dev
     */
    function updateChildAnchors(Base memory base, Mix memory mixs) internal pure {
        for (uint8 i = 0; i < mix.version.childAnchors.length; i++) {
            if (mix.version.childAnchors[i] != 0) {
                base.anchors[i] = mix.version.childAnchors[i];
            }
        }
    }

    /**
     * @notice
     * @dev
     */
    function formatForBase(
        Base memory base,
        Item memory item,
        Matrix memory versionMatrix
    ) internal pure returns (Matrix memory res) {
        Coordinate memory baseAnchor = base.childAnchors[item.feature];
        Coordinate memory matchAnchor = item.parentAnchor;

        int8 xoffset = 0; // FIXME
        int8 yoffset = 0; // FIXME

        // this is where we exand and shit
        // this should return a matrix with
    }

    /**
     * @notice
     * @dev
     */
    function mergeToBase(Base memory base, Matrix memory versionMatrix) internal pure {
        require(versionMatrix.length == base.matrix.length && versionMatrix[0].length == base.matrix[0].length, 'COM:ADD:0');

        while (base.martrix.next() && versionMatrix.matrix.next()) {
            Pixel memory b = base.martrix.current();
            Pixel memory a = versionMatrix.current();

            if (a != 0 && a.layer > b.layer) {
                b.layer = a.layer;
                b.rgba = Colors.combine(b.rgba, a.rgba);
            }
        }
    }

    /**
     * @notice
     * @dev
     * makes the sorts versions
     */
    function pickVersionIndex(Base memory base, Item memory item) internal pure returns (uint8 res) {
        if (item.versions.length == 1) {
            res = item.versions[0];
        }
    }

    // you combine one by one, and as you combine, child refs get overridden

    // function add(Combinable comb, )
}
// add parent refs, if any - will use ***REMOVED***s algo only for the base
// the base will always be defined as the first, so if it isnt (will not happen for dotnugg), we define the center as all the child refs
//  pick best version
// figure out offset

// function merge(Base memory base, Matrix memory versionMatrix) internal pure {
//     for (int8 y = (base.matrix.length / 2) * -1; y <= base.matrix.length / 2; y++) {
//         for (int8 x = (base.matrix.width / 2) * -1; x <= base.matrix[j].width / 2; x++) {
//             Pixel memory base = base.matrix.at(x, y);
//             Pixel memory addr = combinable.matrix.at(x, y);

//             if (addr != 0 && addr.layer > base.layer) {
//                 base.layer = addr.layer;
//                 base.rgba = Colors.combine(base.rgba, add.rgba);
//             }
//         }
//     }
// }
