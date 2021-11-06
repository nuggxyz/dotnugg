// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './Byte.sol';

/**
 * @dev Bytes operations.
 */
library Bytes {
    using Byte for bytes1;

    function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
        require(_bytes.length >= _start + 1, 'toUint8_outOfBounds');
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
        require(_bytes.length >= _start + 8, 'toUint64_outOfBounds');
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function toAscii(bytes memory val) internal pure returns (string memory res) {
        for (uint8 i = 0; i < val.length; i++) {
            res = string(abi.encodePacked(res, val[i].toAscii()));
        }
    }
}
