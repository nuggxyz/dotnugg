// SPDX-License-Identifier: MIT

import '../types/Version.sol';
import '../../test/Event.sol';

library Merge {
    using Version for Version.Memory;
    using Event for uint256[];
    using Event for uint256;

    function begin(Version.Memory[][] memory versions, uint256 width) internal view returns (Version.Memory memory res) {
        // figure out the order  - loop theorugh them "backwards" pixel by pixel, we can reduce the amount of times we have to loop through everything

        for (uint256 i = 0; i < 8; i++) {
            uint256 num = width / 2 + 1;
            res.setReceiverAt(i, false, num, num);
        }

        uint256 sorter;
        uint256 zcheck;
        // TODO flip these loops - will be able to set receivers here
        // finalize receivers
        for (uint256 i = 0; i < versions.length; i++) {
            uint256 z = versions[i][0].getZ();
            z.log('z');
            sorter = addToSort(sorter, i, z);
            versions[i][0].receivers.log('versions[i][0].receivers');

            for (uint256 j = 0; j < 8; j++) {
                (uint256 x, uint256 y, bool exists) = versions[i][0].getReceiverAt(j, false);

                if (!exists) continue;

                zcheck.log('zcheck');

                if (z > (zcheck >> (j * 3)) & ShiftLib.mask(3)) {
                    zcheck = (zcheck & (ShiftLib.mask(3) << (j * 3))) | (z << (j * 3));
                    res.setReceiverAt(j, false, x, y);
                }
            }
        }

        res.receivers.log('res.receivers');

        for (uint256 i = 0; i < versions.length; i++) {
            (bool negX, uint256 diffX, bool negY, uint256 diffY) = res.getDiffOfReceiverAt(versions[i][0]);
            // negX.log('negX', diffX, 'diffX', i, 'i');
            // negY.log('negY', diffY, 'diffY', i, 'i');
            diffX.log('diffX');
            diffX.log('diffY');

            versions[i][0].setOffset(negX, diffX, negY, diffY);
        }

        res.initBigMatrix(width);

        for (uint256 i = 0; i < width * width; i++) {
            uint256 workingColor;

            for (uint256 j = 0; j < versions.length; j++) {
                // sorter.log('sorter', i, 'i', j, 'j');
                (bool exists1, uint256 feature, ) = getFromSorter(sorter, j);
                if (!exists1) break;
                // if (i > 200) assert(false);
                (bool exists2, uint256 key) = versions[feature][0].getPixelAtPositionWithOffset(i);
                if (!exists2) continue;

                (, uint256 color, ) = versions[feature][0].getPalletColorAt(key);

                if (workingColor > 0) {
                    // mix set with color
                }

                workingColor = color;
                // workingColor.log('workingColor', feature, 'feature', key, 'key');
                if (workingColor & 0xff == 0xff) break;

                continue;
            }

            res.setBigMatrixPixelAt(i, workingColor);
            // assert(false);
        }

        res.bigmatrix.log('bigmatrix');

        // add pallet to end of res's pallet

        // loop through each pixel in res
        // loop through all versions (sorted) and add first color to the matrix

        //
        // (uint256 width, uint256 height) = res.getWidth();
        // calculate offset, sort values values by z, and determine if we need to
        // going deeper as far as a color is conserned is only doable when we are looping thorough
        // for (uint256 i = 0; i < versions.length; i++) {
        //     (uint256 x, uint256 y, uint256 z, ) = versions[i][0].getAnchor();
        //     //
        // }

        // TODO decide if we want to use multiple versions, and then what to do about it

        // loop through them and put all of them on the first one

        // find the receivers to give all of them an offset

        // just take highest level from each of them

        // give all of them an offset

        // for (uint256 )
    }

    function getFromSorter(uint256 input, uint256 index)
        internal
        pure
        returns (
            bool exists,
            uint256 feature,
            uint256 z
        )
    {
        uint256 curr = (input >> (index * 9)) & ShiftLib.mask(9);

        exists = (curr >> 8) & 0x1 == 0x1;

        if (exists) {
            feature = (curr >> 4) & 0xf;
            z = curr & 0xf;
        }
    }

    function addToSort(
        uint256 input,
        uint256 inFeature,
        uint256 inZ
    ) internal view returns (uint256 res) {
        res = input;
        // 1 bit exists
        // 4 bit feature
        // 4 bit z
        // console.log('add to sort', input, inFeature, inZ);
        uint256 i;
        for (i = 0; i < 8; i++) {
            uint256 curr = (res >> (i * 9)) & ShiftLib.mask(9);
            if (curr >> 8 == 0x1) {
                // uint256 feautre = (curr >> 4) & 0xf;
                uint256 z = curr & 0xf;

                if (z <= inZ) {
                    res = ((res << 9) & ~ShiftLib.mask(9 * i)) | (input & ShiftLib.mask(9 * (i)));
                    res |= ((0x1 << 8) | (inFeature << 4) | inZ) << (9 * i);

                    break;
                }
            } else {
                res |= ((0x1 << 8) | (inFeature << 4) | inZ) << (9 * i);
                break;
            }
        }

        // console.log('add to sort end', res);
    }
}
