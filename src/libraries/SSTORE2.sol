// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.9;

// import {DSEmit} from '../_test/utils/DSEmit.sol';
import {BytesLib} from './BytesLib.sol';
// import '../_test/utils/console.sol';
// import '../_test/utils/logger.sol';

import {ShiftLib} from './ShiftLib.sol';
import {StringCastLib} from './StringCastLib.sol';

/// @notice Read and write to persistent storage at a fraction of the cost.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SSTORE2.sol)
/// @author Modified from 0xSequence (https://github.com/0xSequence/sstore2/blob/master/contracts/SSTORE2.sol)
library SSTORE2 {
    uint16 internal constant DATA_PRE_OFFSET = 1; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.
    uint16 internal constant DATA_POST_OFFSET = 32; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.

    /*///////////////////////////////////////////////////////////////
                               WRITE LOGIC
    //////////////////////////////////////////////////////////////*/

    function write(bytes memory data) internal returns (address pointer, uint8 len) {
        // Prefix the bytecode with a STOP opcode to ensure it cannot be called.
        // bytes memory runtimeCode = abi.encodePacked(hex'00', data);

        //---------------------------------------------------------------------------------------------------------------//
        // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
        //---------------------------------------------------------------------------------------------------------------//
        // 0x60    |  0x6012             | PUSH1 19     | codeOffset                                                     //
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset                                                   //
        // 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset                                        //
        // 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 codeOffset                               //
        // 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 codeOffset                           //
        // 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 codeOffset   //
        // 0x92    |  0x92               | SWAP3        | codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset)   //
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset) //
        // 0x39    |  0x39               | CODECOPY     | 0 (codeSize - codeOffset)                                      //
        // 0xf3    |  0xf3               | RETURN       |                                                                //
        //---------------------------------------------------------------------------------------------------------------//

        // 1. push unset
        // 2. push codesize
        //
        // 3.

        //---------------------------------------------------------------------------------------------------------------//
        // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
        //---------------------------------------------------------------------------------------------------------------//
        // 0x60    |  0x6012             | PUSH1 19     | codeOffset
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset
        // 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset
        // 0x60    |  0x60_20            | PUSH1 32     | X codeOffset 0 codeOffset
        // 0x38    |  0x38               | CODESIZE     | codeSize X codeOffset 0 codeOffset
        // 0x03    |  0x03               | SUB          | (codeSize - X) codeOffset 0 codeOffset
        // 0x80    |  0x80               | DUP          | (codeSize - X) (codeSize - X) codeOffset 0 codeOffset
        // 0x91    |  0x91               | SWAP2        | codeOffset (codeSize - X) (codeSize - X) 0 codeOffset
        // 0x90    |  0x90               | SWAP1        | (codeSize - X) codeOffset  (codeSize - X) 0 codeOffset
        // 0x03    |  0x03               | SUB          | (codeSize - X -codeOffset ) (codeSize - X) 0 codeOffset
        // 0x80    |  0x80               | DUP          | (codeSize - X -codeOffset ) (codeSize - X -codeOffset ) (codeSize - X) 0 codeOffset
        // 0x93    |  0x93               | SWAP4        | codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
        // 0x81    |  0x81               | DUP2         | (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
        // 0x81    |  0x81               | DUP2         | codeOffset (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
        // 0x39    |  0x39               | CODECOPY     | codeOffset (codeSize - X - codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
        // 0x39    |  0x39               | CODECOPY     | 0 DATA_LEN
        // 0xf3    |  0xf3               | RETURN       |                                                                //
        //---------------------------------------------------------------------------------------------------------------//

        //---------------------------------------------------------------------------------------------------------------//
        // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
        //---------------------------------------------------------------------------------------------------------------//
        // 0x60    |  0x6012             | PUSH1 19     | codeOffset                                                     //
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset                                                   //
        // 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset                                        //
        // 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 codeOffset                               //
        // 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 codeOffset                           //
        // 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 codeOffset   //
        // 0x92    |  0x92               | SWAP3        | codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset)   //
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset) //

        // swap1
        // dup2
        // swap2

        // 0x39    |  0x39               | CODECOPY     | 0 0 (codeSize - codeOffset)                                      //

        // 0x60    |  0x60_20            | PUSH1 32     | X 0 0 (codeSize - codeOffset)
        // 0x80    |  0x80               | DUP          | X X 0 0 (codeSize - codeOffset)   //
        // 0x83    |  0x83               | DUP4         | (codeSize - codeOffset) X X 0 0 (codeSize - codeOffset)   //
        // 0x03    |  0x03               | SUB          | (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)                           //
        // 0x80    |  0x80               | DUP          | (codeSize - codeOffset - X) (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)
        // 0x92    |  0x92               | SWAP3        | X (codeSize - codeOffset - X) (codeSize - codeOffset - X) 0 0 (codeSize - codeOffset)
        // 0x93    |  0x93               | SWAP4        | 0 (codeSize - codeOffset - X) (codeSize - codeOffset - X) X 0 (codeSize - codeOffset)
        // 0x01    |  0x01               | ADD          | (codeSize - codeOffset - X + 0)[KEK_MEM_LOC] (codeSize - codeOffset - X)  X 0 (codeSize - codeOffset)

        // 0x51    |  0x51               | MLOAD        | TRUSTED_KEK (codeSize - codeOffset - X) X 0 (codeSize - codeOffset)

        // 0x03    |  0x03               | SUB          | (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)                           //

        // 0x20    |  0x20               | SHA3         | K 0 (codeSize - codeOffset)

        // swap 1                                         0 (codeSize - codeOffset - X)  0 (codeSize - codeOffset)

        // 0xf3    |  0xf3               | RETURN       |                                                                //

        //---------------------------------------------------------------------------------------------------------------//

        //---------------------------------------------------------------------------------------------------------------//
        // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
        //---------------------------------------------------------------------------------------------------------------//
        // 0x60    |  0x60_20            | PUSH1 32     | codeUnset
        // 0x60    |  0x60_14            | PUSH1 21     | codeOffset codeUnset
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset codeUnset
        // 0x82    |  0x82               | DUP3         | codeUnset 0 codeOffset codeUnset
        // 0x80    |  0x80               | DUP1         | codeUnset codeUnset 0 codeOffset codeUnset
        // 0x38    |  0x38               | CODESIZE     | codeSize codeUnset codeUnset 0 codeOffset codeUnset
        // 0x03    |  0x03               | SUB          | KEK_OST codeUnset 0 codeOffset codeUnset
        // 0x80    |  0x80               | DUP          | KEK_OST KEK_OST codeUnset 0 codeOffset codeUnset
        // 0x80    |  0x80               | DUP          | DATA_LEN DATA_LEN 0 codeOffset
        // 0x92    |  0x92               | SWAP3        | codeOffset DATA_LEN 0 DATA_LEN
        // 0x59    |  0x59               | MSIZE        | 0 codeOffset DATA_LEN 0 DATA_LEN
        // 0x39    |  0x39               | CODECOPY     | 0 DATA_LEN
        // 0xf3    |  0xf3               | RETURN       |
        //---------------------------------------------------------------------------------------------------------------//
        // 0x83    |  0x83               | DUP4         | codeOffset codeUnset codeUnset 0 codeOffset codeUnset
        // 0x01    |  0x01               | ADD > A      | A codeUnset 0 codeOffset codeUnset
        // 0x82    |  0x82               | DUP3         | codeOffset codeUnset 0 codeOffset codeUnset
        // 0x01    |  0x01               | ADD          | TOTAL_OFFSET 0 codeOffset
        //   2: write: 141114
        //   2: write: 1082666
        //   2: write: 1323721
        //   2: write: 1453058
        //   2: write: 947527
        //   2: write: 456440
        //   2: write: 277066
        //   2: write: 519903
        // uint256 header = 0x60_0B_59_81_38_03_80_92_59_39_F3_00_64_6F_74_6E_75_67_67;
        // DSEmit.startMeasuringGas('1: kec check');

        uint256 header = 0x60_12_59_81_38_03_80_92_59_39_F3_64_6F_74_6E_75_67_67_00;

        uint256 prefix = BytesLib.prefix(data, 20);

        uint256 lenr = data.length;

        uint256 keklen = lenr - 32 - 19;

        assembly {
            len := and(prefix, 0xff)
            prefix := shr(8, prefix)
        }
        uint256 check;
        uint256 kek;
        assembly {
            check := mload(add(add(data, 0x20), sub(lenr, 32)))

            kek := keccak256(add(data, add(0x20, 19)), keklen)

            // if not(eq(check, kek)) {
            //     revert(0, 0)
            // }
        }

        // console.log(check);
        // console.log(kek);

        require(check == kek, 'O:4');

        require(prefix == header, 'O:5');
        // DSEmit.stopMeasuringGas();

        // DSEmit.startMeasuringGas('2: write');

        assembly {
            // Deploy a new contract with the generated creation code.
            // We start 32 bytes into the code to avoid copying the byte length.
            pointer := create(0, add(data, 32), mload(data))
        }

        // DSEmit.stopMeasuringGas();

        require(pointer != address(0), 'DEPLOYMENT_FAILED');
    }

    /*///////////////////////////////////////////////////////////////
                               READ LOGIC
    //////////////////////////////////////////////////////////////*/

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint168 pointer, uint8 num) internal view returns (uint256[] memory res) {
        address addr = address(uint160(pointer));
        uint16 offset = DATA_PRE_OFFSET + 32;

        bytes memory code = bytes.concat(new bytes(32), addr.code);

        // get len
        uint8 len = BytesLib.toUint8(code, offset);

        require(num + 1 <= len, 'P:x');

        uint16 checker = (offset + 1) + (num) * 2;

        uint16 biggeroffset = len * 2;

        uint16 start = BytesLib.toUint16(code, checker) + biggeroffset + offset;

        uint16 end = (len == num + 1) ? uint16(code.length) - DATA_POST_OFFSET : BytesLib.toUint16(code, checker + 2) + biggeroffset + offset;

        require(end >= uint16(start), 'P:y');

        uint16 size = end - start;

        uint8 extra = uint8((size) % 0x20);

        // this can go below zero for the first nugg in the list if the conditions are right
        // but if the keccack is in the front then it will be enough buffer to ensure that never happens
        start -= (0x20 - (size % 0x20));

        size = end - start;

        require(size % 0x20 == 0, 'P:z');

        res = new uint256[]((size / 0x20));

        for (uint256 i = 0; i < res.length; i++) {
            res[i] = BytesLib.toUint256(code, start + i * 0x20);
        }

        // keccak would be masked away here
        if (extra != 0) {
            res[0] = res[0] & ShiftLib.mask(extra * 8);
        }
    }
}
