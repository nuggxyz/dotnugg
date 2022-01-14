// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.9;

import {DSEmit} from '../_test/utils/DSEmit.sol';
import {BytesLib} from './BytesLib.sol';
import '../_test/utils/console.sol';
import '../_test/utils/logger.sol';

import {ShiftLib} from './ShiftLib.sol';
import {StringCastLib} from './StringCastLib.sol';

/// @notice Read and write to persistent storage at a fraction of the cost.
/// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SSTORE2.sol)
/// @author Modified from 0xSequence (https://github.com/0xSequence/sstore2/blob/master/contracts/SSTORE2.sol)
library SSTORE2 {
    uint16 internal constant DATA_OFFSET = 19; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.

    /*///////////////////////////////////////////////////////////////
                               WRITE LOGIC
    //////////////////////////////////////////////////////////////*/

    function write(bytes memory data) internal returns (address pointer, uint8 len) {
        // Prefix the bytecode with a STOP opcode to ensure it cannot be called.
        // bytes memory runtimeCode = abi.encodePacked(hex'00', data);

        //---------------------------------------------------------------------------------------------------------------//
        // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
        //---------------------------------------------------------------------------------------------------------------//
        // 0x60    |  0x600B             | PUSH1 11     | codeOffset                                                     //
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
        uint256 header = 0x60_0B_59_81_38_03_80_92_59_39_F3_00_64_6F_74_6E_75_67_67;

        uint256 prefix = BytesLib.prefix(data, 20);

        assembly {
            len := and(prefix, 0xff)
            prefix := shr(8, prefix)
        }
        // 600b
        // 5981
        // 3803
        // 8092
        // 5939
        // f300
        // 646f
        // 746e
        // 7567
        // 67

        // 02
        // 0001
        // 00de
        require(prefix == header, 'O:5');

        DSEmit.startMeasuringGas('2: write');

        assembly {
            // Deploy a new contract with the generated creation code.
            // We start 32 bytes into the code to avoid copying the byte length.
            pointer := create(0, add(data, 32), mload(data))
        }

        DSEmit.stopMeasuringGas();

        require(pointer != address(0), 'DEPLOYMENT_FAILED');
    }

    /*///////////////////////////////////////////////////////////////
                               READ LOGIC
    //////////////////////////////////////////////////////////////*/

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint168 pointer, uint8 num) internal view returns (uint256[] memory res) {
        address addr = address(uint160(pointer));
        uint16 offset = 8;

        bytes memory code = addr.code;

        // get len
        uint8 len = BytesLib.toUint8(code, offset);

        require(num + 1 <= len, 'P:x');

        uint16 checker = (offset + 1) + (num) * 2;

        uint16 biggeroffset = len * 2;

        uint16 start = BytesLib.toUint16(code, checker) + biggeroffset + offset;

        uint16 end = (len == num + 1) ? uint16(code.length) : BytesLib.toUint16(code, checker + 2) + biggeroffset + offset;

        require(end >= uint16(start), 'P:y');

        uint16 size = end - start;

        uint8 extra = uint8((size) % 0x20);

        start -= (0x20 - (size % 0x20));

        size = end - start;

        require(size % 0x20 == 0, 'P:z');

        res = new uint256[]((size / 0x20));

        for (uint256 i = 0; i < res.length; i++) {
            res[i] = BytesLib.toUint256(code, start + i * 0x20);
        }

        if (extra != 0) {
            res[0] = res[0] & ShiftLib.mask(extra * 8);
        }

        logger.log(res, 'to');
    }

    function read(
        address pointer,
        uint256 start,
        uint256 end
    ) internal view returns (bytes memory) {
        start += DATA_OFFSET;
        end += DATA_OFFSET;

        require(pointer.code.length >= end, 'OUT_OF_BOUNDS');

        return readBytecode(pointer, start, end - start);
    }

    /*///////////////////////////////////////////////////////////////
                         INTERNAL HELPER LOGIC
    //////////////////////////////////////////////////////////////*/

    function readBytecode(
        address pointer,
        uint256 start,
        uint256 size
    ) private view returns (bytes memory data) {
        assembly {
            // Get a pointer to some free memory.
            data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to size and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            mstore(0x40, add(data, and(add(add(size, 32), 31), not(31))))

            // Store the size of the data in the first 32 byte chunk of free memory.
            mstore(data, size)

            // Copy the code into memory right after the 32 bytes we used to store the size.
            extcodecopy(pointer, add(data, 32), start, size)
        }
    }
}
// 8: 646f746e75676702

// 2: 0001

// 2: 00de

// 13 - 232 --- 221: 1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc2401042069001

// 233 - 408 --- 175: 06cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001

// 600b5981380380925939f300646f746e75676702000100de1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001
