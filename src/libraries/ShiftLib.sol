// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {SafeCastLib} from './SafeCastLib.sol';

library ShiftLib {
    using SafeCastLib for uint256;

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

    function set(
        uint256 cache,
        uint8 bits,
        uint8 pos,
        uint256 value
    ) internal pure returns (uint256 res) {
        res = cache & fullsubmask(bits, pos);

        assembly {
            value := shl(pos, value)
        }

        res |= value;
    }

    function get(
        uint256 cache,
        uint8 bits,
        uint8 pos
    ) internal pure returns (uint256 res) {
        assembly {
            res := shr(pos, cache)
        }
        res &= mask(bits);
    }

    /*━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                ARRAYS
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━*/

    function getArray8x8(uint256 store, uint8 pos) internal pure returns (uint8[] memory arr) {
        store = get(store, 64, pos);

        arr = new uint8[](8);
        for (uint256 i = 0; i < 8; i++) {
            arr[i] = uint8(store & 0xff);
            store >>= 8;
        }
    }

    function setArray8x8(
        uint256 store,
        uint8 pos,
        uint8[] memory arr
    ) internal pure returns (uint256 res) {
        for (uint256 i = 8; i > 0; i--) {
            res |= uint256(arr[i - 1]) << ((8 * (i - 1)));
        }

        res = set(store, 64, pos, res);
    }
}
