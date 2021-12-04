// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
 * @dev Bytes1 operations.
 */

import '../libraries/ShiftLib.sol';

library Checksum {
    // using ShiftLib for uint256[];

    function fletcher16(bytes memory data) internal pure returns (uint16 res) {
        uint16 sum1 = 0;
        uint16 sum2 = 0;
        for (uint256 index = 0; index < data.length; index++) {
            sum1 = (sum1 + uint8(data[index])) % 255;
            sum2 = (sum2 + sum1) % 255;
        }

        res = (sum2 << 8) | sum1;
    }

    // function simpleChecksum(uint256[] memory data)internal pure returns (uint16 res) {
    //     // remove the checksum
    //     // keccak whole thing
    //     // check result
    // }
}
