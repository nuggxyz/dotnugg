// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

library DotnuggV1FileStorage {
    // ======================
    // add = []
    // move= ()
    // delete = {}
    // transform = <>
    // refered = !
    // ======================
    // 0x60_20_80_80_80_38_03_80_91_3D_39_03_80_82_20_83_51_14_02_90_F3_00_04_20_00_00_69_00_00_00_00;

    bytes27 internal constant DOTNUGG_HEADER =
        0x60_2c_60_20_60_1b_80_38_03_80_91_3D_39_03_80_82_80_82_03_90_20_81_51_14_02_3D_F3;

    // -- 22 -- 0x16

    // 602060023D358102808201828001808584602d01903983513D85528091510380869006860381838239013DF3 -- 44 -- 0x2c

    // FILE HEADER [32 bytes]
    // +=====+==============+==============+========================================+
    // | pos |    opcode    |   name       |          stack                         |
    // +=====+==============+==============+========================================+
    //                                                                          00    3D             RETSIZE        [00]
    //   01    60 [2c]        PUSH1          [44]
    //         60 [20]        PUSH1          [32] 44
    //                                                                      03    80             DUP1           [32] !44
    //                                                                      04    80             DUP1           [32] !32 44
    //                                                                          05    80             DUP1           [32] !32 32 32 0
    //         60 [1b]        PUSH1          [27]  32 44
    //         80             DUP1           [27] !27 32 44
    //   06    38             CODESIZE       [MYSIZE] 27 27 32 44
    //   07    03             SUB            <A: MYSIZE - 27> 27 32 44              @note a needs to be -27 not -32
    //   08    80             DUP1           [A] !A 27 32 44
    //   09    91             SWAP2          (27) A (A) 32 44
    //   10    3D             RETSIZE        [0] 27 A A 32 44                         @note the 32 here needs to be 27
    //   11    39             CODECOPY       {0 27 A} | code[27,A) -> mem[0, A-27)
    //   12    03             SUB            <B: A - 32> 44
    //   13    80             DUP1           [B] !B 44
    //   14    82             DUP3           [44] B B !44
    //                        DUP
    //                         DUP2
    //                          SUB
    // SWAP
    //   18    20             SHA3           <C: kek(44 B)> B 44    @note the 32 here needs to be a 44
    //   19    83             DUP2           [B] C !B 44            @note this needs to dup B
    //   20    51             MLOAD          <D: mload(B)> C B 44
    //   21    14             EQ             <E: eq(D, C)> B 44
    //   22    02             MUL            <F: E * B = 0 | B> 44
    //         3D             RETSIZE        [0] F
    //   24    F3             RETURN
    //   25*   --             --             UNREACHABLE
    // +=====+==============+==============+========================================+
    //
    //

    bytes18 internal constant PROXY_INIT_CODE = 0x69_36_3d_3d_36_3d_3d_37_f0_33_FF_3d_52_60_0a_60_16_f3;

    //  PROXY_INIT_CODE [14 bytes]: 0x69_RUNTIME_3d_52_60_0a_60_16_f3
    // +=====+==============+==============+========================================+
    // | pos |    opcode    |   name       |          stack                         |
    // +=====+==============+==============+========================================+
    //   00    69 [RUNTIME]   PUSH10         [RUNTIME]
    //   09    3D             RETSIZE        [0] RUNTIME
    //   10    52             MSTORE         {0 RUNTIME} | RUNTIME -> mem[22,32)
    //   11    60 [0A]        PUSH1          [10]
    //   12    60 [18]        PUSH1          [22] 10
    //   13    F3             RETURN         {22 10} | mem[22, 32) => contract code
    // +=====+==============+==============+========================================+
    //  notes:
    //  - exectued during "create2"
    //

    //  RUNTIME [10 bytes]: 0x36_3d_3d_36_3d_3d_37_f0_33_FF
    // +=====+==============+==============+========================================+
    // | pos |    opcode    |     name     |                 stack                  |
    // +=====+==============+==============+========================================+
    //   00    36             CALLDATASIZE   [CDS]
    //   01    3D             RETSIZE        [0] CDS
    //   02    3D             RETSIZE        [0] 0 CDS
    //   03    36             CALLDATASIZE   [CDS] 0 0 CDS
    //   04    3D             RETSIZE        [0] CDS  0 0 CDS
    //   05    3D             RETSIZE        [0] 0 CDS 0 0 CDS
    //   06    37             CALLDATACOPY   {0 0 CDS} | calldata -> mem[0, CDS)
    //   07    F0             CREATE         {0 0 CDS} | mem[0, CDS) -> contract code
    //   08    33             CALLER         [msg.sender]
    //   09    FF             SELFDESTRUCT
    // +=====+==============+==============+========================================+
    //  notes:
    //  - saved during "create2"
    //  - executed during "call"

    function save(bytes memory data, uint8 feature) internal {
        assembly {
            switch eq(DOTNUGG_HEADER, mload(add(data, 32)))
            case 0 {
                mstore(0x00, "DEPLOYMENT_FAILED:0")
                revert(0x00, 19)
            }
            default {
                mstore(0x0, PROXY_INIT_CODE)

                let res := create2(0, 0, 18, feature)

                // clean up scratch space
                mstore(0x00, 0x00)

                if iszero(extcodesize(res)) {
                    mstore(0x00, "DEPLOYMENT_FAILED:1")
                    revert(0x00, 19)
                }

                if iszero(call(gas(), res, 0x00, add(data, 0x20), mload(data), 0x00, 0x20)) {
                    mstore(0x00, "DEPLOYMENT_FAILED:2")
                    revert(0x00, 19)
                }
            }
        }
    }

    function location(uint8 feature) internal view returns (address pointer) {
        assembly {
            mstore(0x0, PROXY_INIT_CODE)

            let inithash := keccak256(0x00, 18)

            let mptr := mload(0x40)
            mstore8(mptr, 0xff)
            mstore(add(0x01, mptr), shl(96, address()))
            mstore(add(0x15, mptr), feature)
            mstore(add(0x35, mptr), inithash)

            let proxy := keccak256(mptr, 0x55)

            mstore8(0x00, 0xD6)
            mstore8(0x01, 0x94)
            mstore(0x02, shl(96, proxy))
            mstore8(0x16, 0x01)

            pointer := shr(96, shl(96, keccak256(0x00, 23)))

            mstore(0x00, 0x00)

            mstore(0x40, add(mptr, and(add(add(0x55, 32), 31), not(31))))
        }
    }

    function fetch(uint8 feature, uint8 pos) internal view returns (uint256[] memory res) {
        address pointer = location(feature);

        assembly {
            mstore(0x00, pos)

            let a := staticcall(gas(), pointer, 0, 0x20, 0x0, 0)

            let rds := returndatasize()

            res := mload(0x40)

            mstore(0x40, add(res, add(rds, 0x20)))

            mstore(res, div(rds, 0x20))

            returndatacopy(add(res, 0x20), 0x00, rds)
        }
    }
}
