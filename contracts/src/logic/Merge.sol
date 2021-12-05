// SPDX-License-Identifier: MIT

import '../types/Version.sol';

library Merge {
    using Version for Version.Memory;

    function begin(Version.Memory[][] memory versions) internal view returns (Version.Memory memory res) {
        // figure out the order  - loop theorugh them "backwards" pixel by pixel, we can reduce the amount of times we have to loop through everything

        // finalize receivers
        for (uint256 i = 0; i < versions.length; i++) {
            for (uint256 j = 0; j < 8; j++) {
                (, uint256 x, uint256 y, uint256 z) = versions[i][0].getReceiverAt(j, false);

                (, , , uint256 curZ) = res.getReceiverAt(j, false);

                if (z > curZ) res.setReceiverAt(j, false, x, y);
            }
        }

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
}
