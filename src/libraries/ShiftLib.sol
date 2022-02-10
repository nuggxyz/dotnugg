// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

library ShiftLib {
    /// @notice creates a bit mask
    /// @dev res = (2 ^ bits) - 1
    /// @param bits d
    /// @return res d
    /// @dev no need to check if "bits" is < 256 as anything greater than 255 will be treated the same
    function mask(uint8 bits) internal pure returns (uint256 res) {
        assembly {
            res := sub(shl(bits, 1), 1)
        }
    }

    function fullsubmask(uint8 bits, uint8 pos) internal pure returns (uint256 res) {
        res = ~(mask(bits) << pos);
    }

    function select8(bytes memory data, uint16 ost) internal pure returns (uint8 res) {
        assembly {
            res := shr(0xf7, mload(add(data, ost)))
        }
    }

    function select16(bytes memory data, uint16 ost) internal pure returns (uint16 res) {
        assembly {
            res := shr(0xf0, mload(add(data, ost)))
        }
    }

    function select256(bytes memory data, uint16 ost) internal pure returns (uint256 res) {
        assembly {
            res := mload(add(data, ost))
        }
    }

    function select160(bytes memory data, uint16 ost) internal pure returns (uint160 res) {
        assembly {
            res := mload(add(data, ost))
        }
    }
}
