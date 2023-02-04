// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import {IDotnuggV1} from "@dotnugg-v1-core/src/IDotnuggV1.sol";

import {DotnuggV1Storage} from "@dotnugg-v1-core/src/core/DotnuggV1Storage.sol";
import {DotnuggV1MiddleOut} from "@dotnugg-v1-core/src/core/DotnuggV1MiddleOut.sol";
import {DotnuggV1Svg} from "@dotnugg-v1-core/src/core/DotnuggV1Svg.sol";

import {DotnuggV1Lib} from "@dotnugg-v1-core/src/DotnuggV1Lib.sol";

import {Base64} from "@dotnugg-v1-core/src/libraries/Base64.sol";

import {whoa as nuggs} from "@dotnugg-v1-core/src/nuggs.data.sol";

import "@dotnugg-v1-core/src/abi/Decode.sol" as decode;

import {cds} from "@dotnugg-v1-core/src/abi/Pointer.sol";

/// @title DotnuggV1
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @dev implements [EIP 1167] minimal proxy for cloning
abstract contract DotnuggV1Base {
	event Write(uint8 feature, uint8 amount, address sender);

	address internal immutable factory;

	constructor() {
		factory = address(this);
	}

	function self(DotnuggV1Base a) internal view returns (IDotnuggV1) {
		return IDotnuggV1(address(a));
	}

	/* ////////////////////////////////////////////////////////////////////////
       [EIP 1167] minimal proxy
    //////////////////////////////////////////////////////////////////////// */

	function register(bytes[] memory input) internal returns (IDotnuggV1 proxy) {
		require(address(this) == factory, "O");

		proxy = self(clone());

		proxy.protectedInit(input);
	}

	function protectedInit(bytes[] memory input) internal {
		require(msg.sender == factory, "C:0");

		write(input);
	}

	/// @dev implementation the EIP 1167 standard for deploying minimal proxy contracts, also known as "clones"
	/// adapted from openzeppelin's unreleased implementation written by Philogy
	/// [ Clones.sol : MIT ] - https://github.com/OpenZeppelin/openzeppelin-contracts/blob/28dd490726f045f7137fa1903b7a6b8a52d6ffcb/contracts/proxy/Clones.sol
	function clone() internal returns (DotnuggV1Base instance) {
		/// @solidity memory-safe-assembly
		assembly {
			let ptr := mload(0x40)
			mstore(ptr, shl(100, 0x602d8060093d393df3363d3d373d3d3d363d73))
			mstore(add(ptr, 0x13), shl(0x60, address()))
			mstore(add(ptr, 0x27), shl(136, 0x5af43d82803e903d91602b57fd5bf3))
			instance := create(0, ptr, 0x36)
		}
		require(address(instance) != address(0), "E");
	}

	/* ////////////////////////////////////////////////////////////////////////
       store dotnugg v1 files on chain
    //////////////////////////////////////////////////////////////////////// */

	function write(bytes[] memory data) internal {
		unchecked {
			require(data.length == 8, "nope");
			for (uint8 feature = 0; feature < 8; feature++) {
				if (data[feature].length > 0) {
					uint8 saved = DotnuggV1Storage.save(data[feature], feature);

					emit Write(feature, saved, msg.sender);
				}
			}
		}
	}

	/* ////////////////////////////////////////////////////////////////////////
       read dotnugg v1 files
    //////////////////////////////////////////////////////////////////////// */

	function read(uint8[8] memory ids) internal view returns (uint256[][] memory _reads) {
		_reads = new uint256[][](8);

		for (uint8 i = 0; i < 8; i++) {
			if (ids[i] != 0) {
				_reads[i] = DotnuggV1Lib.read(self(this), i, ids[i]);
			}
		}
	}

	// there can only be max 255 items per feature, and so num can not be higher than 255
	function read(uint8 feature, uint8 num) internal view returns (uint256[] memory _read) {
		return DotnuggV1Lib.read(self(this), feature, num);
	}

	/* ////////////////////////////////////////////////////////////////////////
       calculate raw dotnugg v1 files
    //////////////////////////////////////////////////////////////////////// */

	function calc(uint256[][] memory reads) internal pure returns (uint256[] memory, uint256) {
		return DotnuggV1MiddleOut.execute(reads);
	}

	/* ////////////////////////////////////////////////////////////////////////
       display dotnugg v1 computed fils
    //////////////////////////////////////////////////////////////////////// */

	// prettier-ignore
	function svg(uint256[] memory calculated, uint256 dat, bool base64) internal  pure returns (string memory res) {
        bytes memory image = DotnuggV1Svg.fledgeOutTheRekts(calculated, dat);

        return string(encodeSvg(image, base64));
    }

	/* ////////////////////////////////////////////////////////////////////////
       execution - read & compute
    //////////////////////////////////////////////////////////////////////// */

	function combo(uint256[][] memory reads, bool base64) internal pure returns (string memory) {
		(uint256[] memory calced, uint256 sizes) = calc(reads);
		return svg(calced, sizes, base64);
	}

	function exec(uint8[8] memory ids, bool base64) internal view returns (string memory) {
		return combo(read(ids), base64);
	}

	// prettier-ignore
	function exec(uint8 feature, uint8 pos, bool base64) internal view returns (string memory) {
        uint256[][] memory arr = new uint256[][](1);
        arr[0] = read(feature, pos);
        return combo(arr, base64);
    }

	/* ////////////////////////////////////////////////////////////////////////
       helper functions
    //////////////////////////////////////////////////////////////////////// */

	function encodeSvg(bytes memory input, bool base64) internal pure returns (bytes memory res) {
		res = abi.encodePacked(
			"data:image/svg+xml;",
			base64 ? "base64" : "charset=UTF-8",
			",",
			base64 ? Base64.encode(input) : input
		);
	}

	function encodeJson(bytes memory input, bool base64) internal pure returns (bytes memory res) {
		res = abi.encodePacked(
			"data:application/json;",
			base64 ? "base64" : "charset=UTF-8",
			",",
			base64 ? Base64.encode(input) : input
		);
	}
}

// function clone() internal returns (DotnuggV1 instance) {
//     assembly {
//         let ptr := mload(0x40)
//         mstore(ptr, shl(96, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73))
//         mstore(add(ptr, 0x14), shl(0x60, address()))
//         mstore(add(ptr, 0x28), shl(136, 0x5af43d82803e903d91602b57fd5bf3))
//         instance := create(0, ptr, 0x37)
//     }
//     require(address(instance) != address(0), "E");
// }

contract DotnuggV1Raw is DotnuggV1Base {
	fallback() external {
		uint256 selector = uint256(uint32(msg.sig));
		if (selector == 0x8bbbdb64) return __calc(); // calc(uint256[][])
		if (selector == 0xac99329f) return __combo(); // combo(uint256[][],bool)
		if (selector == 0x0f3db5cc) return __encodeJson(); // encodeJson(bytes,bool)
		if (selector == 0x43861c96) return __encodeSvg(); // encodeSvg(bytes,bool)
		if (selector == 0x0a6e79ed) return __exec3(); // exec(uint8,uint8,bool)
		if (selector == 0xa976f210) return __exec2(); // exec(uint8[8],bool)
		if (selector == 0x8090b976) return __protectedInit(); // protectedInit(bytes[])
		if (selector == 0xb02726b2) return __read2(); // read(uint8,uint8)
		if (selector == 0xc78e3c79) return __read1(); // read(uint8[8])
		if (selector == 0xad144a94) return __register(); // register(bytes[])
		if (selector == 0xada838de) return __svg(); // svg(uint256[],uint256,bool)
	}

	// prettier-ignore
	function __calc(/** uint256[][] memory reads */) internal pure /** returns (uint256[] memory, uint256) */ {
        uint256[][] memory reads = decode.to_dyn_array_dyn_array_uint256_ReturnType(decode.abi_decode_dyn_array_dyn_array_uint256)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        (uint256[] memory calced, uint256 sizes) = calc(reads);

        ////////////////////////////////////////////////////////////////////////

        decode.return_tuple_dyn_array_uint256_uint256(calced, sizes);
    }

	// prettier-ignore
	function __register(/** bytes[] calldata */) internal /** returns (address) */ {
		bytes[] memory input = decode.to_dyn_array_bytes_ReturnType(decode.abi_decode_dyn_array_bytes)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        address res = address(register(input));

        ////////////////////////////////////////////////////////////////////////

        decode.return_address(res);
	}

	// prettier-ignore
	function __protectedInit(/** bytes[] calldata */) internal {
		bytes[] memory input = decode.to_dyn_array_bytes_ReturnType(decode.abi_decode_dyn_array_bytes)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        protectedInit(input);

        ////////////////////////////////////////////////////////////////////////
	}

	// prettier-ignore
	function __read1(/** uint8[8] calldata */) internal view /** returns (uint256[][] memory) */  {
		uint8[8] memory ids = decode.to_array_8_uint8_ReturnType(decode.abi_decode_array_8_uint8)(cds);

        ////////////////////////////////////////////////////////////////////////

        uint256[][] memory res = read(ids);

        ////////////////////////////////////////////////////////////////////////

		decode.return_dyn_array_dyn_array_uint256(res);
	}

	// prettier-ignore
	function __read2(/** uint8 feature, uint8 num */ ) internal view /** returns (uint256[] memory) */ {
		uint8 num = cds.offset(32).readUint8();
		uint8 feature = cds.readUint8();

        ////////////////////////////////////////////////////////////////////////

        uint256[] memory res = read(feature, num);

        ////////////////////////////////////////////////////////////////////////

		decode.return_dyn_array_uint256(res);
	}

	// prettier-ignore
	function __svg(/** uint256[] calldata, uint256 dat, bool base64 */) internal /** returns (string memory) */ {
		bool base64 = cds.offset(64).readBool();
		uint256 dat = cds.offset(32).readUint256();
		uint256[] memory calculated = decode.to_dyn_array_uint256_ReturnType(decode.abi_decode_dyn_array_uint256)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        string memory res = svg(calculated, dat, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_string(res);
	}

	// prettier-ignore
	function __combo(/** uint256[][] calldata, bool base64 */) internal /** returns (string memory) */ {
		bool base64 = cds.offset(32).readBool();
		uint256[][] memory reads = decode.to_dyn_array_dyn_array_uint256_ReturnType(decode.abi_decode_dyn_array_dyn_array_uint256)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        string memory res = combo(reads, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_string(res);
	}

	// prettier-ignore
	function __exec2(/** uint8[8] calldata, bool base64 */) internal /** returns (string memory) */ {
		bool base64 = cds.offset(256).readBool();
		uint8[8] memory ids = decode.to_array_8_uint8_ReturnType(decode.abi_decode_array_8_uint8)(cds);

        ////////////////////////////////////////////////////////////////////////

        string memory res = exec(ids, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_string(res);
	}

	// prettier-ignore
	function __exec3( /** uint8 feature, uint8 pos, bool base64 */) internal /** returns (string memory) */ {
		bool base64 = cds.offset(64).readBool();
		uint8 pos = cds.offset(32).readUint8();
		uint8 feature = cds.readUint8();

        ////////////////////////////////////////////////////////////////////////

        string memory res = exec(feature, pos, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_string(res);
	}

	// prettier-ignore
	function __encodeSvg(/** bytes calldata, bool base64 */) internal /** returns (bytes memory) */ {
		bool base64 = cds.offset(32).readBool();
		bytes memory input = decode.to_bytes_ReturnType(decode.abi_decode_bytes)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        bytes memory res = encodeSvg(input, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_bytes(res);
	}

	// prettier-ignore
	function __encodeJson(/** bytes calldata, bool base64 */) internal  /** returns (bytes memory) */ {
		bool base64 = cds.offset(32).readBool();
		bytes memory input = decode.to_bytes_ReturnType(decode.abi_decode_bytes)(cds.pptr());

        ////////////////////////////////////////////////////////////////////////

        bytes memory res = encodeJson(input, base64);

        ////////////////////////////////////////////////////////////////////////

		decode.return_bytes(res);
	}
}

contract DotnuggV1Light is DotnuggV1Raw {
	address internal immutable deployer;
	bool internal written;

	constructor() {
		deployer = tx.origin;
	}

	function lightWrite(bytes[] memory data) internal {
		require(deployer == tx.origin, "not deployer");
		require(!written, "already written");

		written = true;
		write(data);
	}
}

contract DotnuggV1 is DotnuggV1Raw {
	constructor() {
		write(abi.decode(nuggs.data, (bytes[])));
	}
}
