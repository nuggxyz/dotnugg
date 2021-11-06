// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
 * @dev Bytes1 operations.
 */

library Checksum {
    function fletcher16(bytes memory data) internal pure returns (bytes2 res) {
        uint16 sum1 = 0;
        uint16 sum2 = 0;
        for (uint256 index = 0; index < data.length; index++) {
            sum1 = (sum1 + uint8(data[index])) % 255;
            sum2 = (sum2 + sum1) % 255;
        }

        res = bytes2((sum2 << 8) | sum1);
    }
}
