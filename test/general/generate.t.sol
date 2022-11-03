// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "@dotnugg-v1-core/test/main.t.sol";

import {DotnuggV1Pixel as Pixel} from "@dotnugg-v1-core/src/core/DotnuggV1Pixel.sol";

contract generalTest__generate is t {
	function test__trr() public {
		bytes memory args = abi.encodePacked(
			// uint8(0x20),
			// uint8(0x40),
			// uint8(0x60),
			// uint8(0x7E),
			// uint8(0x9D),
			// uint8(0xBD),
			// uint8(0xDE),
			// uint8(0xDE),
			// uint8(0xFF)
			uint256(0x1E3D40435657595B5F60898B8E9A9B9D9EA1A2A8B6C9CBCDD0D8DFE5EBF4F8FF)
		);

		ds.emit_log_bytes(args);

		uint8 res = trr(args, 150);

		ds.emit_log_uint(res);
	}

	function trr(bytes memory weights, uint256 seed) internal returns (uint8 res) {
		uint8 low = 0;

		uint8 high = uint8(weights.length) - 1;

		seed %= uint8(weights[high]);

		uint8 selectedId;
		unchecked {
			// Binary search.
			while (low <= high) {
				uint8 mid = (low + high) >> 1;
				if (uint8(weights[mid]) <= seed) low = mid + 1;
				else if (mid == 0) return high;
				else (selectedId, high) = (high, mid - 1);
			}
		}

		return selectedId;
	}

	function test__trr2() public {
		// bytes memory args = abi.encodePacked(uint24(0xff37fe), uint16(0xfff0));
		// bytes memory args = abi.encodePacked(uint24(0xff37fe), uint16(0xfff0));
		bytes memory args2 = abi.encodePacked(uint40(0x0fffff37fe));

		ds.emit_log_bytes(args2);

		uint8 res = trr2(args2, 3000);

		ds.emit_log_uint(res);
	}

	function trr2(bytes memory weights, uint256 seed) internal returns (uint8 res) {
		uint8 low = 0;

		ds.emit_log_named_uint("len guess", (weights.length * 2) / 3);

		// uint16 rawIndex = uint16(weights.length);

		uint8 high = uint8(uint16((weights.length * 2) / 3) - 1);

		seed %= index12(weights, high);

		uint8 selectedId;

		unchecked {
			// Binary search.
			while (low <= high) {
				uint8 mid = (low + high) >> 1;
				if (index12(weights, mid) <= seed) low = mid + 1;
				else if (mid == 0) return high + 1;
				else (selectedId, high) = (high, mid - 1);
			}
		}

		return selectedId + 1;
	}

	function index(uint256 input, uint8 ind) internal pure returns (uint8) {
		return uint8((input >> (ind << 3)) & 0xff);
	}

	function l(
		bytes memory input,
		uint8 ind,
		uint8 bits
	) internal pure returns (uint8 res) {
		assembly {
			res := and(mload(add(add(input, 0x2), mul(ind, bits))), sub(shl(1, bits), 1))
		}
	}

	function index10(bytes memory input, uint8 ind) internal pure returns (uint256 res) {
		assembly {
			res := and(mload(add(add(input, 0x2), mul(ind, 10))), 1023)
		}
	}

	function index12(bytes memory input, uint8 ind) internal returns (uint256 res) {
		uint256 tmp;
		assembly {
			tmp := mload(add(add(input, 0x2), div(mul(ind, 3), 2)))
			res := and(tmp, 0xfff)
		}

		// res = uint16(tmp) >> 4;
		ds.emit_log_named_uint("index12:ind", ind);
		ds.emit_log_named_bytes32("index12:tmp", bytes32(tmp));

		ds.emit_log_named_uint("index12:res", res);
	}
}
