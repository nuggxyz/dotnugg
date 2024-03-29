// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IDotnuggV1} from "git.nugg.xyz/dotnugg/src/IDotnuggV1.sol";

import {DotnuggV1Storage} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Storage.sol";
import {DotnuggV1MiddleOut} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1MiddleOut.sol";
import {DotnuggV1Svg} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Svg.sol";

import {DotnuggV1Lib} from "git.nugg.xyz/dotnugg/src/DotnuggV1Lib.sol";

import {Base64} from "git.nugg.xyz/dotnugg/src/libraries/Base64.sol";

import {whoa as nuggs} from "git.nugg.xyz/dotnugg/src/nuggs.data.sol";

/// @title DotnuggV1
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @dev implements [EIP 1167] minimal proxy for cloning
abstract contract DotnuggV1Base is IDotnuggV1 {
	address public immutable factory;

	constructor() {
		factory = address(this);
	}

	/* ////////////////////////////////////////////////////////////////////////
	[EIP 1167] minimal proxy
	//////////////////////////////////////////////////////////////////////// */

	function register(bytes[] calldata input) external override returns (IDotnuggV1 proxy) {
		require(address(this) == factory, "O");

		proxy = clone();

		proxy.protectedInit(input);
	}

	function protectedInit(bytes[] memory input) external override {
		require(msg.sender == factory, "C:0");

		write(input);
	}

	/// @dev implementation the EIP 1167 standard for deploying minimal proxy contracts, also known as "clones"
	/// adapted from openzeppelin's unreleased implementation written by Philogy
	/// [ Clones.sol : MIT ] -
	/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/28dd490726f045f7137fa1903b7a6b8a52d6ffcb/contracts/proxy/Clones.sol
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

	function read(uint8[8] memory ids) public view returns (uint256[][] memory _reads) {
		_reads = new uint256[][](8);

		for (uint8 i = 0; i < 8; i++) {
			if (ids[i] != 0) {
				_reads[i] = DotnuggV1Lib.read(this, i, ids[i]);
			}
		}
	}

	// there can only be max 255 items per feature, and so num can not be higher than 255
	function read(uint8 feature, uint8 num) public view override returns (uint256[] memory _read) {
		return DotnuggV1Lib.read(this, feature, num);
	}

	/* ////////////////////////////////////////////////////////////////////////
	calculate raw dotnugg v1 files
	//////////////////////////////////////////////////////////////////////// */

	function calc(uint256[][] memory reads) public pure override returns (uint256[] memory, uint256) {
		return DotnuggV1MiddleOut.execute(reads);
	}

	/* ////////////////////////////////////////////////////////////////////////
	display dotnugg v1 computed fils
	//////////////////////////////////////////////////////////////////////// */

	// prettier-ignore
	function svg(
		uint256[] memory calculated,
		uint256 dat,
		bool base64
	)
		public
		pure
		override
		returns (string memory res)
	{
		bytes memory image = DotnuggV1Svg.fledgeOutTheRekts(calculated, dat);

		return string(encodeSvg(image, base64));
	}

	/* ////////////////////////////////////////////////////////////////////////
	execution - read & compute
	//////////////////////////////////////////////////////////////////////// */

	function combo(uint256[][] memory reads, bool base64) public pure override returns (string memory) {
		(uint256[] memory calced, uint256 sizes) = calc(reads);
		return svg(calced, sizes, base64);
	}

	function exec(uint8[8] memory ids, bool base64) public view returns (string memory) {
		return combo(read(ids), base64);
	}

	// prettier-ignore
	function exec(uint8 feature, uint8 pos, bool base64) external view returns (string memory) {
		uint256[][] memory arr = new uint256[][](1);
		arr[0] = read(feature, pos);
		return combo(arr, base64);
	}

	/* ////////////////////////////////////////////////////////////////////////
	helper functions
	//////////////////////////////////////////////////////////////////////// */

	function encodeSvg(bytes memory input, bool base64) public pure override returns (bytes memory res) {
		res = abi.encodePacked(
			"data:image/svg+xml;", base64 ? "base64" : "charset=UTF-8", ",", base64 ? Base64.encode(input) : input
		);
	}

	function encodeJson(bytes memory input, bool base64) public pure override returns (bytes memory res) {
		res = abi.encodePacked(
			"data:application/json;", base64 ? "base64" : "charset=UTF-8", ",", base64 ? Base64.encode(input) : input
		);
	}
}

contract DotnuggV1Light is DotnuggV1Base {
	address public immutable deployer;
	bool public written;

	constructor() {
		deployer = tx.origin;
	}

	function lightWrite(bytes calldata data) public {
		require(deployer == tx.origin, "not deployer");
		require(!written, "already written");

		written = true;
		write(abi.decode(data, (bytes[])));
	}
}

contract DotnuggV1 is DotnuggV1Base {
	constructor() {
		write(abi.decode(nuggs.data, (bytes[])));
	}
}
