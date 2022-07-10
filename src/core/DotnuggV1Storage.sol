// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.15;

import {DotnuggV1Lib, IDotnuggV1} from "@dotnugg-v1-core/src/DotnuggV1Lib.sol";

/// @title DotnuggV1Reader
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @author inspired by 0xSequence's implemenation of
///      [ SSTORE2.sol : MIT ] - https://github.com/0xsequence/sstore2/blob/0a28fe61b6e81de9a05b462a24b9f4ba8c70d5b7/contracts/SSTORE2.sol
///      [ Create3.sol : MIT ] - https://github.com/0xsequence/create3/blob/acc4703a21ec1d71dc2a99db088c4b1f467530fd/contracts/Create3.sol
library DotnuggV1Storage {
	using DotnuggV1Lib for IDotnuggV1;

	uint8 constant DOTNUGG_HEADER_BYTE_LEN = 25;

	uint8 constant DOTNUGG_RUNTIME_BYTE_LEN = 1;

	// ======================
	// add = []
	// move= ()
	// delete = {}
	// transform = <>
	// refered = !
	// ======================

	bytes25 internal constant DOTNUGG_HEADER =
		0x60_20_80_60_18_80_38_03_80_91_3D_39_03_80_3D_82_90_20_81_51_14_02_3D_F3_00;

	// DOTNUGG_CONSTRUCTOR [25 bytes]
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
	//  RUNTIME [10 bytes]: 0x36_3d_3d_36_3d_3d_37_f0_33_FF
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
		require(DOTNUGG_HEADER == bytes25(data), "INVALID_HEADER");

		address proxy;

		assembly {
			mstore(0x0, PROXY_INIT_CODE)

			proxy := create2(0, 0, 18, feature)
		}

		require(proxy != address(0), "");

		(bool fileDeployed, ) = proxy.call(data);

		require(fileDeployed, "");

		amount = IDotnuggV1(address(this)).lengthOf(feature);

		require(amount > 0 && amount < 256, "");
	}
}
