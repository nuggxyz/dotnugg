// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import {ShiftLib} from "../libraries/ShiftLib.sol";

import {DotnuggV1Pixel as Pixel} from "./DotnuggV1Pixel.sol";
import {DotnuggV1Reader as Reader} from "./DotnuggV1Reader.sol";

library DotnuggV1Parser {
    using Reader for Reader.Memory;

    struct Memory {
        uint256[] pallet;
        uint256[] minimatrix;
        uint256[] bigmatrix;
        uint256 receivers;
        uint256 data;
        uint256 bitmatrixptr;
    }

    function parse(uint256[][] memory reads) internal pure returns (Memory[][] memory m) {
        m = new Memory[][](reads.length);

        for (uint256 j = 0; j < reads.length; j++) {
            (bool empty, Reader.Memory memory reader) = Reader.init(reads[j]);

            if (empty) continue;

            // indicates dotnuggV1 encoded file
            require(reader.select(32) == 0x420690_01, "DEC:PI:0");

            uint256 feature = reader.select(3);

            uint256 id = reader.select(8);

            uint256[] memory pallet = parsePallet(reader, id, feature);

            uint256 versionLength = reader.select(2) + 1;

            m[j] = new Memory[](versionLength);

            for (uint256 i = 0; i < versionLength; i++) {
                m[j][i].data = parseData(reader, feature);

                m[j][i].receivers = parseReceivers(reader);

                (uint256 width, uint256 height) = getWidth(m[j][i]);

                m[j][i].minimatrix = parseMiniMatrix(reader, width, height);

                m[j][i].pallet = pallet;
            }
        }
    }

    function parsePallet(
        Reader.Memory memory reader,
        uint256 id,
        uint256 feature
    ) internal pure returns (uint256[] memory res) {
        uint256 palletLength = reader.select(4) + 1;

        res = new uint256[](palletLength + 1);

        for (uint256 i = 0; i < palletLength; i++) {
            // uint256 working = 0;

            // 4 bits: zindex
            // working |= (reader.select(4) << 32);
            uint256 z = reader.select(4);

            uint256 color;

            uint256 selecta = reader.select(1);
            uint256 selectb = reader.select(1);

            if (selecta == 1) {
                color = 0x000000;
            } else if (selectb == 1) {
                color = 0xffffff;
            } else {
                uint256 r = reader.select(8);
                uint256 g = reader.select(8);
                uint256 b = reader.select(8);

                color = (r << 16) | (g << 8) | b;
            }

            // // 1 or 8 bits: a
            uint256 a = (reader.select(1) == 0x1 ? 0xff : reader.select(8));

            res[i + 1] = Pixel.unsafePack(color, a, id, z, feature);
        }
    }

    function parseData(Reader.Memory memory reader, uint256 feature) internal pure returns (uint256 res) {
        // 12 bits: coordinate - anchor x and y

        res |= feature << 75;

        uint256 width = reader.select(6);
        uint256 height = reader.select(6);

        res |= height << 69; // heighth and width
        res |= width << 63;

        uint256 anchorX = reader.select(6);
        uint256 anchorY = reader.select(6);

        // if (xovers.length == 8 && yovers.length == 8 && (xovers[feature] != 0 || yovers[feature] != 0)) {
        //     res |= uint256(yovers[feature]) << 57;
        //     res |= uint256(xovers[feature]) << 51;
        // } else {
        //     // 12 bits: coordinate - anchor x and y
        //     res |= anchorX << 51;
        //     res |= anchorY << 57;
        // }

        res |= anchorX << 51;
        res |= anchorY << 57;

        // 1 or 25 bits: rlud - radii
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 27;

        // 1 or 25 bits: rlud - expanders
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 3;
    }

    function parseReceivers(Reader.Memory memory reader) internal pure returns (uint256 res) {
        uint256 receiversLength = reader.select(1) == 0x1 ? 0x1 : reader.select(4);

        for (uint256 j = 0; j < receiversLength; j++) {
            uint256 receiver = 0;

            uint256 yOrYOffset = reader.select(6);

            uint256 xOrPreset = reader.select(6);

            // rFeature
            uint256 rFeature = reader.select(3);

            uint256 calculated = reader.select(1);

            if (calculated == 0x1) {
                receiver |= yOrYOffset << 6;
                receiver |= xOrPreset;
            } else {
                receiver |= xOrPreset << 6;
                receiver |= yOrYOffset;
            }

            receiver <<= ((rFeature * 12) + (calculated == 0x1 ? 128 : 0));

            res |= receiver;
        }
    }

    function parseMiniMatrix(
        Reader.Memory memory reader,
        uint256 height,
        uint256 width
    ) internal pure returns (uint256[] memory res) {
        uint256 groupsLength = reader.select(1) == 0x1 ? reader.select(8) + 1 : reader.select(16) + 1;

        res = new uint256[]((height * width) / 64 + 1);

        uint256 index = 0;

        for (uint256 a = 0; a < groupsLength; a++) {
            uint256 len = reader.select(2) + 1;

            if (len == 4) len = reader.select(4) + 4;

            uint256 key = reader.select(4);

            for (uint256 i = 0; i < len; i++) {
                res[index / 64] |= (key << (4 * (index % 64)));
                index++;
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
        uint256 data = m.receivers >> (index * 12 + (calculated ? 128 : 0));

        data &= ShiftLib.mask(12);

        x = data & ShiftLib.mask(6);
        y = data >> 6;

        exists = x != 0 || y != 0;
    }

    function setReceiverAt(
        Memory memory m,
        uint256 index,
        bool calculated,
        uint256 x,
        uint256 y
    ) internal pure returns (uint256 res) {
        // yOrYOffset
        res |= y << 6;

        //xOrPreset
        res |= x;

        m.receivers |= res << ((index * 12) + (calculated ? 128 : 0));
    }

    function setOffset(
        Memory memory m,
        bool negX,
        uint256 diffX,
        bool negY,
        uint256 diffY
    ) internal pure {
        m.data |= ((((diffX & 0xff) << 1) | (((negX ? 0x1 : 0x0)))) << 85);
        m.data |= ((((diffY & 0xff) << 1) | ((((negY ? 0x1 : 0x0))))) << 94);
    }

    function getOffset(Memory memory m)
        internal
        pure
        returns (
            bool negX,
            uint256 diffX,
            bool negY,
            uint256 diffY
        )
    {
        uint256 data = m.data;
        negX = (data >> 85) & 0x1 == 1;
        diffX = (data >> 86) & 0xff;
        negY = (data >> 94) & 0x1 == 1;
        diffY = (data >> 95) & 0xff;
    }

    function setZ(Memory memory m, uint256 z) internal pure {
        require(z <= 0xf, "VERS:SETZ:0");
        m.data |= z << 78;
    }

    function getZ(Memory memory m) internal pure returns (uint256 res) {
        res = (m.data >> 78) & 0xf;
    }

    function setFeature(Memory memory m, uint256 z) internal pure {
        require(z <= ShiftLib.mask(3), "VERS:SETF:0");
        m.data &= ShiftLib.fullsubmask(3, 75);
        m.data |= (z << 75);
    }

    function getFeature(Memory memory m) internal pure returns (uint256 res) {
        res = (m.data >> 75) & ShiftLib.mask(3);
    }

    function getWidth(Memory memory m) internal pure returns (uint256 width, uint256 height) {
        // yOrYOffset
        width = (m.data >> 63) & ShiftLib.mask(6);
        height = (m.data >> 69) & ShiftLib.mask(6);
    }

    function setWidth(
        Memory memory m,
        uint256 w,
        uint256 h
    ) internal pure {
        require(w <= ShiftLib.mask(6), "VERS:SETW:0");
        require(h <= ShiftLib.mask(6), "VERS:SETW:1");

        m.data &= ShiftLib.fullsubmask(12, 63);

        m.data |= (w << 63);
        m.data |= (h << 69);
    }

    function getAnchor(Memory memory m) internal pure returns (uint256 x, uint256 y) {
        // yOrYOffset
        x = (m.data >> 51) & ShiftLib.mask(6);
        y = (m.data >> 57) & ShiftLib.mask(6);
    }

    function getOverrides(Memory memory m)
        internal
        pure
        returns (
            bool shouldOverride,
            uint8 x,
            uint8 y
        )
    {
        // yOrYOffset
        x = uint8((m.data >> 78) & ShiftLib.mask(6));
        y = uint8((m.data >> 84) & ShiftLib.mask(6));

        shouldOverride = x != 0 && y != 0;
    }

    function getPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y
    ) internal pure returns (uint256 palletKey) {
        (uint256 width, ) = getWidth(m);
        uint256 index = x + (y * width);

        if (index / 64 >= m.minimatrix.length) return 0x0;

        palletKey = (m.minimatrix[index / 64] >> (4 * (index % 64))) & 0xf;
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
        // res = (m.pallet[index / 7] >> (36 * (index % 7))) & ShiftLib.mask(36);
        res = m.pallet[index];

        color = Pixel.rgba(res);

        zindex = Pixel.z(res);
    }

    function initBigMatrix(Memory memory m, uint256 width) internal pure {
        m.bigmatrix = new uint256[](((width * width) / 6) + 2);
    }

    function setBigMatrixPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y,
        uint256 color
    ) internal pure {
        (uint256 width, ) = getWidth(m);

        uint256 index = x + (y * width);

        setBigMatrixPixelAt(m, index, color);
    }

    function setBigMatrixPixelAt(
        Memory memory m,
        uint256 index,
        uint256 color
    ) internal pure {
        if (m.bigmatrix.length > index / 6) {
            uint8 offset = uint8(42 * (index % 6)); // NOTE: i removed safe8
            m.bigmatrix[index / 6] &= ShiftLib.fullsubmask(42, offset);
            m.bigmatrix[index / 6] |= (color << offset);

            assembly {

            }
        }
    }

    function getBigMatrixPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y
    ) internal pure returns (uint256 res) {
        (uint256 width, ) = getWidth(m);

        (res, ) = getPixelAt(m.bigmatrix, x, y, width);
    }

    function getPixelAt(
        uint256[] memory arr,
        uint256 x,
        uint256 y,
        uint256 width
    ) internal pure returns (uint256 res, uint256 row) {
        uint256 index = x + (y * width);

        if (index / 6 >= arr.length) return (0, 0);

        row = (arr[index / 6] >> (42 * (index % 6)));

        res = row & ShiftLib.mask(42);
    }

    function bigMatrixHasPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y
    ) internal pure returns (bool res) {
        uint256 pix = getBigMatrixPixelAt(m, x, y);

        res = pix & 0x7 != 0x00;
    }

    function setArrayLength(uint256[] memory input, uint256 size) internal pure {
        assembly {
            let ptr := mload(input)
            ptr := size
            mstore(input, ptr)
        }
    }
}
