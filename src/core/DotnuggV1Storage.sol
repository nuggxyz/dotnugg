// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import {DotnuggV1Lib} from "../libraries/DotnuggV1Lib.sol";

// ======================
// add = []
// move= ()
// delete = {}
// transform = <>
// refered = !
// ======================
library DotnuggV1Storage {
    // uint8 constant DOTNUGG_HEADER_BYTE_LEN = 84;

    // uint8 constant DOTNUGG_RUNTIME_BYTE_LEN = 0x39;

    uint8 constant DOTNUGG_HEADER_BYTE_LEN = 25;

    uint8 constant DOTNUGG_RUNTIME_BYTE_LEN = 1;

    bytes25 internal constant DOTNUGG_HEADER =
        0x60_20_80_60_18_80_38_03_80_91_3D_39_03_80_3D_82_90_20_81_51_14_02_3D_F3_00;
    // keccak256(
    //     abi.encodePacked(
    //         // DOTNUGG_CONSTRUCTOR
    //         hex"60006020601e80380380913d390380918082039020815114023df300"
    //         // DOTNUGG_RUNTIME
    //         // hex"6020600260043581026004808483603a01903982513D8452809180519086801B90520380859006606003600186830401865281838239013DF3"
    //     )
    // );

    // DOTNUGG_CONSTRUCTOR [32 bytes]
    // +=====+==============+==============+========================================+
    // | pos |    opcode    |   name       |          stack                         |
    // +=====+==============+==============+========================================+
    //   00    60 [00]        PUSH1          [44]
    //   02    60 [20]        PUSH1          [32]  44
    //   04    60 [1b]        PUSH1          [27]  32 44
    //   06    80             DUP1           [27] !27 32 44
    //   07    38             CODESIZE       [CS] 27 27 32 44
    //   08    03             SUB            <A: CS - 27> 27 32 44
    //   09    80             DUP1           [A] !A 27 32 44
    //   10    91             SWAP2          (27) A (A) 32 44
    //   11    3D             RETSIZE        [0] 27 A A 32 44
    //   12    39             CODECOPY       {0 27 A} | code[27,A) -> mem[0, A-27)
    //   13    03             SUB            <B: A - 32> 44
    //   14    80             DUP1           [B] !B 44
    //   15    91             SWAP2          (44) B (B)
    //   16    80             DUP            [44] !44 B B
    //   17    82             DUP3           [B] 44 44 !B B
    //   18    03             SUB            <C: B - 44> 44 !B B
    //   19    90             SWAP           (44) (C) B B
    //   20    20             SHA3           <D: kek(44 C)> B B
    //   21    81             DUP2           [B] D !B 44
    //   22    51             MLOAD          <E: mload(B)> D B
    //   23    14             EQ             <F: eq(E, D)> B
    //   24    02             MUL            <G: F * B = 0 | B>
    //   25    3D             RETSIZE        [0] G
    //   26    F3             RETURN         {0 G} | mem[0, G) -> contract code
    // +=====+==============+==============+========================================+

    bytes18 internal constant PROXY_INIT_CODE = 0x69_36_3d_3d_36_3d_3d_37_f0_33_FF_3d_52_60_0a_60_16_f3;

    // +=====+==============+==============+========================================+
    // | pos |    opcode    |   name       |          stack                         |
    // +=====+==============+==============+========================================+
    //  PROXY_INIT_CODE [14 bytes]: 0x69_RUNTIME_3d_52_60_0a_60_16_f3
    //   - exectued during "create2"
    // +=====+==============+==============+========================================+
    //   00    69 [RUNTIME]   PUSH10         [RUNTIME]
    //   09    3D             RETSIZE        [0] RUNTIME
    //   10    52             MSTORE         {0 RUNTIME} | RUNTIME -> mem[22,32)
    //   11    60 [0A]        PUSH1          [10]
    //   12    60 [18]        PUSH1          [22] 10
    //   13    F3             RETURN         {22 10} | mem[22, 32) -> contract code
    // +=====+==============+==============+========================================+
    //  RUNTIME [10 bytes]: 0x36_3d_3d_36_3d_3d_37_f0_33_FF\
    //   - executed during "call"
    //   - saved during "create2"
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

    function save(bytes memory data, uint8 feature) internal returns (uint8 amount) {
        // require(DOTNUGG_HEADER == bytes25(data[:DOTNUGG_HEADER_BYTE_LEN]), "A");

        address proxy;

        assembly {
            mstore(0x0, PROXY_INIT_CODE)

            proxy := create2(0, 0, 18, feature)
        }

        require(proxy != address(0), "");

        (bool fileDeployed, ) = proxy.call(data);

        require(fileDeployed, "");

        require((amount = DotnuggV1Lib.size(DotnuggV1Lib.location(address(this), feature))) > 0, "");
    }
}

// SIZE HAS BEEN REDUCED 1

// 6020_6002_6004_35_81_02_60_04_80_84_83_603b_01_90_39_82_51_3D_84_52_80_91_80_51_90_86_80_1B_90_52_03_80____85_90_06_6060_03__6001_86_83_04_01_86_52__81_83_82_39_01_3D_F3

// // 60 [20]   PUSH1 32     [32]
// // 60 [02]   PUSH1 02     [02] 32
// // 60 [04]   PUSH1 04     [04] 02 32
// // 35        CALLDATALOAD <A: cload(0, 32)> 02 32
// // 81        DUP2         [02] _A !02 32
// // 02        MUL          <B:2*A> 02 32
//    60 [04]   PUSH1        [04] _B 02 32
// // 80        DUP          [04] !04 _B 02 32
// // 84        DUP5         [32] 04 04 _B 02 !32
// // 83        DUP4         [_B] 32 04 04 !_B 02 32
// // 60 [35]   PUSH1        [48] _B 32 04 04 _B 02 32 @note 2d = len of this + 1 (the size)
// // 01        ADD          <D:45+B> 32 04 04 _B 02 32
// // 90        SWAP         (32) (_D) 04 04 _B 02 32
// // 39        CODECOPY     {32 _D 04} | code[D,D+4) -> mem[32,32+4)
// // 82        DUP3         [02] 04 _B !02 32
// // 51        MLOAD        {02} <E: mem[32,34)> 04 _B 02 32
//              RETCOPY
// // 84        DUP5         [02] _L _E 04 _B !02 32
// // 52        MSTORE       {02 _L} | 0 -> mem[32,34)
// // 80        DUP          [_E] !_E 04 _B 02 32
// // 91        SWA2P2       (04) _E (_E) _B 02 32
//    80        DUP
// // 51        MLOAD        {04} <F: mem[34,36)> 04 _E _E _B 02 32
//    90        SWAP 1
// // 86        DUP7         [32] _E 04 _B 02 !32
//    80        DUP1         [32] 32 _E 04 _B 02 32
//    1B        SHL          <L:32<<32> _E 04 _B 02 32
//    90        SWAP1
//    52        MSTORE
// // 03        SUB          <G:F-E> _E _B 02 32
// // 80        DUP          [_G] !_G _E _B 02 32
//    85        DUP6         [32] _G _G _E _B 02 !32
//    90        SWAP         (_G) (32) _G _E _B 02 32
// // 06        MOD          <H:G%32> _G _E _B 02 32
//    60 [60]   PUSH1        [96] _H _G _E _B 02 !32 @note - would need to dup 32 and add, dup 32 again
// // 03        SUB          <I:64-H> _G _E _B 02 32 @note - dup i and then divide by 32 - mstore that to 0
//    60 [01]   PUSH1        [01] _I _G _E _B 02 32
//    86        DUP7         [32] 01 _I _G _E _B 02 !32
///   83        DUP4         [_G] 32 01 _I !_G _E _B 02 32
//    04        DIV          <L:G/32> 01 _I _G _E _B 02 32
//    01        ADD          <M:L+1> _I _G _E _B 02 32
//    86        DUP7         [00] [_M] _I _G _E _B 02 32
//    52        MSTORE        {0 M} | M -> mem[0,32)
// // 81        DUP2         [_G] _I !_G _E _B 02 32
// // 83        DUP4         [_E] _G _I _G !_E _B 02 32
// // 82        DUP3         [_I] _E _G !_I _G _E _B 02 32
// // 39        CODE COPY    {I E G} | code[E,E+G) -> mem[I,I+G]
// // 01        ADD          <K:I+G> _E _B 02 32
// // 3D        RETSIZE      [0] _K _E _B 02 32
// // F3        RETURN       {0 _K} | mem[0, K) -> returndata
