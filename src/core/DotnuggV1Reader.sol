// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {ShiftLib} from "git.nugg.xyz/dotnugg/src/libraries/ShiftLib.sol";

/// @title DotnuggV1Reader
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @notice a library for reading DotnuggV1 encoded data files
library DotnuggV1Reader {
	using ShiftLib for uint256;

	struct Memory {
		uint256[] dat;
		uint256 moves;
		uint256 pos;
	}

	function init(uint256[] memory input) internal pure returns (bool err, Memory memory m) {
		unchecked {
			if (input.length == 0) return (true, m);

			m.dat = input;

			m.moves = 2;

			m.dat = new uint256[](input.length);

			for (uint256 i = input.length; i > 0; i--) {
				m.dat[i - 1] = input[input.length - i];
			}
		}
	}

	function peek(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
		res = m.dat[0] & ShiftLib.mask(bits);
	}

	function select(Memory memory m, uint8 bits) internal pure returns (uint256 res) {
		unchecked {
			res = m.dat[0] & ShiftLib.mask(bits);

			m.dat[0] = m.dat[0] >> bits;

			m.pos += bits;

			if (m.pos >= 128) {
				uint256 ptr = (m.moves / 2);
				if (ptr < m.dat.length) {
					m.dat[0] <<= m.pos - 128;
					uint256 move = m.dat[ptr] & ShiftLib.mask(128);
					m.dat[ptr] >>= 128;
					m.dat[0] |= (move << 128);
					m.dat[0] >>= (m.pos - 128);
					m.moves++;
					m.pos -= 128;
				}
			}
		}
	}
}
