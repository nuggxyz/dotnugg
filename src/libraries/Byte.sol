// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

/**
 * @dev Bytes1 operations.
 */
library Byte {
    bytes32 internal constant ALPHABET = '0123456789abcdef';

    function toAscii(bytes1 value) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2);
        for (uint256 i = 2; i > 0; i--) {
            buffer[i - 1] = ALPHABET[uint8(value) & 0xf];
            value >>= 4;
        }
        return string(buffer);
    }
}
