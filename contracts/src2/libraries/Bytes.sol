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

    function toUint4(bytes memory _bytes, uint256 _start) internal pure returns (uint8, uint8) {
        uint8 tempUint = toUint8(_bytes, _start);
        return (tempUint >> 4, tempUint & 0xf);
    }

    function toInt8(bytes memory _bytes, uint256 _start) internal pure returns (int8) {
        uint8 tempUint = toUint8(_bytes, _start);
        return (int8(~tempUint) + 1) * -1;
    }

    function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
        require(_bytes.length >= _start + 2, 'toUint16_outOfBounds');
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
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
