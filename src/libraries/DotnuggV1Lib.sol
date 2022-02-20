// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;
import "../_test/utils/forge.sol";

library DotnuggV1Lib {
    uint8 constant DOTNUGG_HEADER_BYTE_LEN = 25;

    uint8 constant DOTNUGG_RUNTIME_BYTE_LEN = 1;

    bytes18 internal constant PROXY_INIT_CODE = 0x69_36_3d_3d_36_3d_3d_37_f0_33_FF_3d_52_60_0a_60_16_f3;

    bytes32 internal constant PROXY_INIT_CODE_HASH = keccak256(abi.encodePacked(PROXY_INIT_CODE));

    function size(address pointer) internal view returns (uint8 res) {
        assembly {
            // [======================================================================
            // the amount of items inside a dotnugg file are stored at byte #1 (0 based index)
            // here we copy that single byte from the file and store it in byte #31 of memory
            // this way, we can mload(0x00) to get the properly alignede integer from memory

            extcodecopy(pointer, 0x1f, DOTNUGG_RUNTIME_BYTE_LEN, 0x01)

            // memory:                                           length of file  =  XX
            // [0x00] 0x////////////////////////////////////////////////////////////XX
            // =======================================================================]
            // [======================================================================
            // solidity will mask "res" to be only a uint8
            res := mload(0x00)
            // ⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀⋀

            // [======================================================================
            // we clear the scratch space we dirtied
            mstore(0x00, 0x00)
            // memory layout:
            // [0x00] 0x00000000000000000000000000000000000000000000000000000000000000
            // =======================================================================]
        }
    }

    function search(
        address safe,
        uint8 feature,
        uint256 seed
    ) internal view returns (uint8 res) {
        address loc = location(safe, feature);

        uint256 high = size(loc);

        assembly {
            // we adjust the seed to be unique per feature and safe, yet still deterministic

            // [======================================================================
            mstore(0x00, seed)
            mstore(0x20, or(shl(160, feature), safe))

            // [0x00] 0x___________________________SEED_______________________________
            // [0x20] 0x0000000000000__feature__|_______________address(safe)_________
            // =======================================================================]

            seed := keccak256(0x00, 0x40)

            // [======================================================================
            mstore(0x00, 0x00)
            mstore(0x20, 0x00)

            // [0x00] 0x00000000000000000000000000000000000000000000000000000000000000
            // [0x20] 0x00000000000000000000000000000000000000000000000000000000000000
            // =======================================================================]

            // Get a pointer to some free memory.
            let data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to len and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            // mstore(0x40, add(data, and(add(add(high, 32), 31), not(31))))

            // Store the len of the data in the first 32 byte chunk of free memory.
            mstore(data, high)

            // Copy the code into memory right after the 32 bytes we used to store the len.
            extcodecopy(loc, add(data, 32), add(DOTNUGG_RUNTIME_BYTE_LEN, 1), mul(high, 2))

            // normalize seed to be <= type(uint16).max
            // if we did not want to use weights, we could just mod by "len" and have our final value
            seed := mod(seed, 0xffff)

            high := sub(high, 1)
            let low := 0

            // prettier-ignore
            for { } iszero(gt(low, high)) { } {

                // mid = (low + high) / 2
                let mid := shr(1, add(low, high))


                // "is weights[mid] <= seed ?"
                switch iszero(gt(and(mload(add(add(data, 0x2), shl(1, mid))), 0xffff), seed))
                case 1 {
                    low := add(mid, 1)
                }
                default {
                     res := high
                     switch iszero(mid)
                     case 1  { break }
                     default { high := sub(mid, 1) }
                }
            }

            res := add(res, 1)
        }
    }

    function read(
        address safe,
        uint8 feature,
        uint8 index
    ) internal view returns (uint256[] memory res) {
        address loc = location(safe, feature);

        uint256 length = size(loc);

        require(index <= length && index != 0, "F:1");

        index = index - 1;

        uint32 starts = uint32(bytes4(readBytecode(loc, DOTNUGG_RUNTIME_BYTE_LEN + length * 2 + 1 + index * 2, 4)));

        uint32 begin = starts >> 16;

        return readBytecodeAsArray(loc, begin, (starts & 0xffff) - begin);
    }

    function location(address registration, uint8 feature) internal pure returns (address res) {
        bytes32 h = keccak256(abi.encodePacked(PROXY_INIT_CODE));

        assembly {
            // [======================================================================
            let mptr := mload(0x40)

            // [0x00] 0x00000000000000000000000000000000000000000000000000000000000000
            // [0x20] 0x00000000000000000000000000000000000000000000000000000000000000
            // [0x40] 0x________________________FREE_MEMORY_PTR_______________________
            // =======================================================================]

            // [======================================================================
            mstore8(0x00, 0xff)
            mstore(0x01, shl(96, registration))
            mstore(0x15, feature)
            mstore(0x35, h)

            // [0x00] 0xff>_____________registration______________>___________________
            // [0x20] 0x________________feature___________________>___________________
            // [0x40] 0x________________PROXY_INIT_CODE_HASH______////////////////////
            // =======================================================================]

            // [======================================================================
            mstore(0x02, shl(96, keccak256(0x00, 0x55)))
            mstore8(0x00, 0xD6)
            mstore8(0x01, 0x94)
            mstore8(0x16, 0x01)

            // [0x00] 0xD694_________ADDRESS_OF_FILE_CREATOR________01////////////////
            // [0x20] ////////////////////////////////////////////////////////////////
            // [0x40] ////////////////////////////////////////////////////////////////
            // =======================================================================]

            res := shr(96, shl(96, keccak256(0x00, 0x17)))

            // [======================================================================
            mstore(0x00, 0x00)
            mstore(0x20, 0x00)
            mstore(0x40, mptr)

            // [0x00] 0x00000000000000000000000000000000000000000000000000000000000000
            // [0x20] 0x00000000000000000000000000000000000000000000000000000000000000
            // [0x40] 0x________________________FREE_MEMORY_PTR_______________________
            // =======================================================================]
        }
    }

    function readBytecodeAsArray(
        address file,
        uint256 start,
        uint256 len
    ) private view returns (uint256[] memory data) {
        assembly {
            let offset := sub(0x20, mod(len, 0x20))

            let arrlen := add(0x01, div(len, 0x20))

            // Get a pointer to some free memory.
            data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to size and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            mstore(0x40, add(data, and(add(add(add(len, 32), offset), 31), not(31))))

            // Store the len of the data in the first 32 byte chunk of free memory.
            mstore(data, arrlen)

            // Copy the code into memory right after the 32 bytes we used to store the len.
            extcodecopy(file, add(add(data, 32), offset), start, len)
        }
    }

    function readBytecode(
        address file,
        uint256 start,
        uint256 len
    ) private view returns (bytes memory data) {
        assembly {
            // Get a pointer to some free memory.
            data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to len and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            mstore(0x40, add(data, and(add(add(len, 32), 31), not(31))))

            // Store the len of the data in the first 32 byte chunk of free memory.
            mstore(data, len)

            // Copy the code into memory right after the 32 bytes we used to store the len.
            extcodecopy(file, add(data, 32), start, len)
        }
    }
}

// function inject(val) {
//                 let a := mload(0x00)
//                 let b := mload(0x20)
//                 mstore(0x00, 0x27b7cf85)
//                 mstore(0x20, val)
//                 let r := staticcall(gas(), 0x12345, 0x1C, 0x24, 0x00, 0x00)
//                 mstore(0x00, a)
//                 mstore(0x00, b)
//             }
