// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {ShiftLib} from "git.nugg.xyz/dotnugg/src/libraries/ShiftLib.sol";

import {DotnuggV1Pixel as Pixel} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Pixel.sol";
import {DotnuggV1Reader as Reader} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Reader.sol";

/// @title DotnuggV1Parser
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @notice a library decoding DotnuggV1 encoded data files
library DotnuggV1Parser {
	using Reader for Reader.Memory;
	using Pixel for uint256;

	struct Memory {
		Reader.Memory reader;
		uint256[] pallet;
		uint256[] minimatrix;
		uint256[] bigmatrix;
		uint256 receivers;
		uint256 data;
		uint256 bitmatrixptr;
		uint8 palletBitLen;
		bool exists;
	}

	function parse(uint256[][] memory reads) internal pure returns (Memory[8] memory m, uint256 len) {
		unchecked {
			for (uint256 j = 0; j < reads.length; j++) {
				(bool empty, Reader.Memory memory reader) = Reader.init(reads[j]);

				if (empty) continue;

				// indicates dotnuggV1 encoded file
				require(reader.select(32) == 0x420690_01, "0x42");

				uint256 feature = reader.select(3);

				if (m[feature].exists) continue;

				len++;

				m[feature].exists = true;
				m[feature].reader = reader;
			}

			uint256[] memory graftPallet;

			for (uint256 feature = 0; feature < 8; feature++) {
				if (!m[feature].exists) continue;

				uint256 id = m[feature].reader.select(8);

				m[feature].palletBitLen = uint8((m[feature].reader.select(1) * 4) + 4);

				uint256[] memory pallet = parsePallet(m[feature], id, feature, graftPallet);

				if (m[feature].reader.select(1) == 1) {
					require(graftPallet.length == 0, "0x34");
					graftPallet = pallet;
				}

				uint256 versionLength = m[feature].reader.select(2) + 1;

				require(versionLength == 1, "UNSUPPORTED_VERSION_LEN");

				m[feature].data = parseData(m[feature].reader, feature);

				m[feature].receivers = parseReceivers(m[feature].reader);

				(uint256 width, uint256 height) = getWidth(m[feature]);

				m[feature].minimatrix = parseMiniMatrix(m[feature], width, height);

				m[feature].pallet = pallet;
			}
		}
	}

	function parsePallet(
		Memory memory parser,
		uint256 id,
		uint256 feature,
		uint256[] memory graftPallet
	) internal pure returns (uint256[] memory res) {
		unchecked {
			uint256 palletLength = parser.reader.select(parser.palletBitLen) + 1;

			res = new uint256[](palletLength + 1);

			for (uint256 i = 0; i < palletLength; i++) {
				// 4 bits: zindex
				uint256 z = parser.reader.select(4);

				uint256 color;

				uint256 graftIndex = parser.reader.select(1);
				if (graftIndex == 1) graftIndex = parser.reader.select(4);

				uint256 isBlack = parser.reader.select(1);
				uint256 isWhite = parser.reader.select(1);

				if (isWhite == 1) {
					color = 0xffffff;
				} else if (isBlack == 1) {
					color = 0x000000;
				} else {
					color = parser.reader.select(24);
				}

				// // 1 or 8 bits: a
				uint256 a = (parser.reader.select(1) == 0x1 ? 0xff : parser.reader.select(8));

				if (graftIndex != 0 && graftPallet.length > graftIndex) {
					res[i + 1] = Pixel.unsafeGraft(graftPallet[graftIndex], id, z, feature);
				} else {
					res[i + 1] = Pixel.unsafePack(color, a, id, z, feature);
				}
			}
		}
	}

	uint8 constant DATA_FEATURE_OFFSET = 95;
	uint8 constant DATA_WIDTH_OFFSET = 67;
	uint8 constant DATA_HIEGHT_OFFSET = 75;
	uint8 constant DATA_X_ANCHOR_OFFSET = 51;
	uint8 constant DATA_Y_ANCHOR_OFFSET = 59;
	uint8 constant DATA_RADII_OFFSET = 128;
	uint8 constant DATA_COORDINATE_BIT_LEN = 8;
	uint8 constant DATA_COORDINATE_BIT_LEN_2X = 16;
	uint8 constant DATA_RLUD_LEN = DATA_COORDINATE_BIT_LEN * 4;

	function parseData(Reader.Memory memory reader, uint256 feature) internal pure returns (uint256 res) {
		// 12 bits: coordinate - anchor x and y
		unchecked {
			res |= feature << DATA_FEATURE_OFFSET;

			uint256 width = reader.select(DATA_COORDINATE_BIT_LEN);
			uint256 height = reader.select(DATA_COORDINATE_BIT_LEN);

			res |= height << DATA_HIEGHT_OFFSET;
			res |= width << DATA_WIDTH_OFFSET;

			uint256 anchorX = reader.select(DATA_COORDINATE_BIT_LEN);
			uint256 anchorY = reader.select(DATA_COORDINATE_BIT_LEN);

			res |= anchorX << DATA_X_ANCHOR_OFFSET;
			res |= anchorY << DATA_Y_ANCHOR_OFFSET;

			// 1 or 25 bits: rlud - radii
			res |= (reader.select(1) == 0x1 ? 0 : reader.select(DATA_RLUD_LEN)) << DATA_RADII_OFFSET;

			// 1 or 25 bits: rlud - expanders
			res |= (reader.select(1) == 0x1 ? 0 : reader.select(DATA_RLUD_LEN)) << 3;
		}
	}

	function parseReceivers(Reader.Memory memory reader) internal pure returns (uint256 res) {
		unchecked {
			uint256 receiversLength = reader.select(1) == 0x1 ? 0x1 : reader.select(4);

			for (uint256 j = 0; j < receiversLength; j++) {
				uint256 receiver = 0;

				uint256 yOrYOffset = reader.select(DATA_COORDINATE_BIT_LEN);

				uint256 xOrPreset = reader.select(DATA_COORDINATE_BIT_LEN);

				// rFeature
				uint256 rFeature = reader.select(3);

				uint256 calculated = reader.select(1);

				if (calculated == 0x1) {
					receiver |= yOrYOffset << DATA_COORDINATE_BIT_LEN;
					receiver |= xOrPreset;
				} else {
					receiver |= xOrPreset << DATA_COORDINATE_BIT_LEN;
					receiver |= yOrYOffset;
				}

				receiver <<= ((rFeature * DATA_COORDINATE_BIT_LEN_2X) + (calculated == 0x1 ? 128 : 0));

				res |= receiver;
			}
		}
	}

	function parseMiniMatrix(
		Memory memory parser,
		uint256 height,
		uint256 width
	) internal pure returns (uint256[] memory res) {
		unchecked {
			uint8 miniMatrixSizer = uint8(256 / parser.palletBitLen);
			uint256 groupsLength = parser.reader.select(1) == 0x1
				? parser.reader.select(8) + 1
				: parser.reader.select(16) + 1;

			res = new uint256[]((height * width) / miniMatrixSizer + 1);

			uint256 index = 0;

			for (uint256 a = 0; a < groupsLength; a++) {
				uint256 len = parser.reader.select(2) + 1;

				if (len == 4) len = parser.reader.select(4) + 4;

				uint256 key = parser.reader.select(parser.palletBitLen);

				for (uint256 i = 0; i < len; i++) {
					res[index / miniMatrixSizer] |= (key << (parser.palletBitLen * (index % miniMatrixSizer)));
					index++;
				}
			}
		}
	}

	function getReceiverAt(
		Memory memory m,
		uint256 index,
		bool calculated
	)
		internal
		pure
		returns (
			uint256 x,
			uint256 y,
			bool exists
		)
	{
		unchecked {
			uint256 data = m.receivers >> (index * DATA_COORDINATE_BIT_LEN_2X + (calculated ? 128 : 0));

			data &= ShiftLib.mask(DATA_COORDINATE_BIT_LEN_2X);

			x = data & ShiftLib.mask(DATA_COORDINATE_BIT_LEN);
			y = data >> DATA_COORDINATE_BIT_LEN;

			exists = x != 0 || y != 0;
		}
	}

	function setReceiverAt(
		Memory memory m,
		uint256 index,
		bool calculated,
		uint256 x,
		uint256 y
	) internal pure returns (uint256 res) {
		unchecked {
			// yOrYOffset
			res |= y << DATA_COORDINATE_BIT_LEN;

			//xOrPreset
			res |= x;

			m.receivers |= res << ((index * DATA_COORDINATE_BIT_LEN_2X) + (calculated ? 128 : 0));
		}
	}

	function getRadii(Memory memory m) internal pure returns (uint256 res) {
		unchecked {
			res = (m.data >> DATA_RADII_OFFSET) & ShiftLib.mask(DATA_RLUD_LEN);
		}
	}

	function getExpanders(Memory memory m) internal pure returns (uint256 res) {
		unchecked {
			res = (m.data >> 3) & ShiftLib.mask(DATA_RLUD_LEN);
		}
	}

	function setFeature(Memory memory m, uint256 z) internal pure {
		unchecked {
			require(z <= ShiftLib.mask(3), "VERS:SETF:0");
			m.data &= ShiftLib.fullsubmask(3, DATA_FEATURE_OFFSET);
			m.data |= (z << DATA_FEATURE_OFFSET);
		}
	}

	function getFeature(Memory memory m) internal pure returns (uint256 res) {
		unchecked {
			res = (m.data >> DATA_FEATURE_OFFSET) & ShiftLib.mask(3);
		}
	}

	function getWidth(Memory memory m) internal pure returns (uint256 width, uint256 height) {
		unchecked {
			// yOrYOffset
			width = (m.data >> DATA_WIDTH_OFFSET) & ShiftLib.mask(DATA_COORDINATE_BIT_LEN);
			height = (m.data >> DATA_HIEGHT_OFFSET) & ShiftLib.mask(DATA_COORDINATE_BIT_LEN);
		}
	}

	function setWidth(
		Memory memory m,
		uint256 w,
		uint256 h
	) internal pure {
		unchecked {
			require(w <= ShiftLib.mask(DATA_COORDINATE_BIT_LEN), "VERS:SETW:0");
			require(h <= ShiftLib.mask(DATA_COORDINATE_BIT_LEN), "VERS:SETW:1");

			m.data &= ShiftLib.fullsubmask(DATA_COORDINATE_BIT_LEN_2X, DATA_WIDTH_OFFSET);

			m.data |= (w << DATA_WIDTH_OFFSET);
			m.data |= (h << DATA_HIEGHT_OFFSET);
		}
	}

	function getAnchor(Memory memory m) internal pure returns (uint256 x, uint256 y) {
		unchecked {
			// yOrYOffset
			x = (m.data >> DATA_X_ANCHOR_OFFSET) & ShiftLib.mask(DATA_COORDINATE_BIT_LEN);
			y = (m.data >> DATA_Y_ANCHOR_OFFSET) & ShiftLib.mask(DATA_COORDINATE_BIT_LEN);
		}
	}

	function getPixelAt(
		Memory memory m,
		uint256 x,
		uint256 y
	) internal pure returns (uint256 palletKey) {
		unchecked {
			uint8 miniMatrixSizer = uint8(256 / m.palletBitLen);

			(uint256 width, ) = getWidth(m);
			uint256 index = x + (y * width);

			if (index / miniMatrixSizer >= m.minimatrix.length) return 0x0;

			palletKey =
				(m.minimatrix[index / miniMatrixSizer] >> (m.palletBitLen * (index % miniMatrixSizer))) &
				ShiftLib.mask(m.palletBitLen);
		}
	}

	function getPalletColorAt(Memory memory m, uint256 index)
		internal
		pure
		returns (
			uint256 res,
			uint256 color,
			uint256 zindex
		)
	{
		unchecked {
			// res = (m.pallet[index / 7] >> (36 * (index % 7))) & ShiftLib.mask(36);
			res = m.pallet[index];

			color = Pixel.rgba(res);

			zindex = Pixel.z(res);
		}
	}

	function initBigMatrix(Memory memory m, uint256 width) internal pure {
		unchecked {
			m.bigmatrix = new uint256[](((width * width) / 6) + 2);
		}
	}

	function setBigMatrixPixelAt(
		Memory memory m,
		uint256 x,
		uint256 y,
		uint256 color
	) internal pure {
		unchecked {
			(uint256 width, ) = getWidth(m);

			uint256 index = x + (y * width);

			setBigMatrixPixelAt(m, index, color);
		}
	}

	function setBigMatrixPixelAt(
		Memory memory m,
		uint256 index,
		uint256 color
	) internal pure {
		unchecked {
			if (m.bigmatrix.length > index / 6) {
				uint8 offset = uint8(42 * (index % 6)); // NOTE: i removed safe8
				m.bigmatrix[index / 6] &= ShiftLib.fullsubmask(42, offset);
				m.bigmatrix[index / 6] |= (color << offset);

				assembly {

				}
			}
		}
	}

	function getBigMatrixPixelAt(
		Memory memory m,
		uint256 x,
		uint256 y
	) internal pure returns (uint256 res) {
		unchecked {
			(uint256 width, ) = getWidth(m);

			(res, ) = getPixelAt(m.bigmatrix, x, y, width);
		}
	}

	function getPixelAt(
		uint256[] memory arr,
		uint256 x,
		uint256 y,
		uint256 width
	) internal pure returns (uint256 res, uint256 row) {
		unchecked {
			uint256 index = x + (y * width);

			if (index / 6 >= arr.length) return (0, 0);

			row = (arr[index / 6] >> (42 * (index % 6)));

			res = row & ShiftLib.mask(42);
		}
	}

	function bigMatrixHasPixelAt(
		Memory memory m,
		uint256 x,
		uint256 y
	) internal pure returns (bool res) {
		unchecked {
			uint256 pix = getBigMatrixPixelAt(m, x, y);

			res = pix & 0x7 != 0x00;
		}
	}

	function setArrayLength(uint256[] memory input, uint256 size) internal pure {
		assembly {
			let ptr := mload(input)
			ptr := size
			mstore(input, ptr)
		}
	}
}
