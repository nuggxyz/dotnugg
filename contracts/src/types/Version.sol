// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../libraries/BitReader.sol';

library Version {
    using BitReader for BitReader.Memory;
    using Event for uint256;
    using Event for uint256[];

    struct Memory {
        uint256[] pallet;
        uint256[] minimatrix;
        uint256[] bigmatrix;
        uint256 receivers;
        uint256 data;
    }

    function parse(uint256[][] memory data) internal view returns (Memory[][] memory m) {
        m = new Memory[][](data.length);

        for (uint256 j = 0; j < data.length; j++) {
            BitReader.Memory memory reader = BitReader.init(data[j]);

            uint256 check = reader.select(32);
            check.log('reader');

            // 32 bits: NUGG
            require(check == 0x4e554747, 'DEC:PI:0');

            uint256 feature = reader.select(3);

            uint256[] memory pallet = parsePallet(reader);

            uint256 versionLength = reader.select(2) + 1;

            m[j] = new Memory[](versionLength);

            for (uint256 i = 0; i < versionLength; i++) {
                m[j][i].data = parseData(reader, feature);

                m[j][i].receivers = parseReceivers(reader);

                (uint256 width, uint256 height) = getWidth(m[j][i]);

                m[j][i].minimatrix = parseMiniMatrix(reader, width, height);

                m[j][i].pallet = pallet;

                (uint256 ancX, uint256 ancY) = getAnchor(m[j][i]);
                (, , uint256 ancZ) = getPalletColorAt(m[j][i], getPixelAt(m[j][i], ancX, ancY));

                setZ(m[j][i], ancZ);

                // m[j][i].minimatrix.log('minimatrix');
            }
        }
    }

    function parsePallet(BitReader.Memory memory reader) internal pure returns (uint256[] memory res) {
        uint256 palletLength = reader.select(4) + 1;

        res = new uint256[]((palletLength) / 7 + 1);

        res = new uint256[](palletLength + 1);

        for (uint256 i = 0; i < palletLength; i++) {
            uint256 working = 0;
            // 4 bits: zindex
            working |= (reader.select(4) << 32);

            uint256 color;
            uint256 selecta = reader.select(1);
            if (selecta == 1) {
                color = 0x000000;
            } else {
                uint256 r = reader.select(8);
                uint256 g = reader.select(8);
                uint256 b = reader.select(8);

                color = (r << 16) | (g << 8) | b;
            }

            // // uint256 color = ((reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 8);
            // // 1 or 25 bits: rgb
            working |= color << 8;

            // // 1 or 8 bits: a
            working |= (reader.select(1) == 0x1 ? 0xff : reader.select(8));

            // res[i / 7] |= (working << (36 * (i % 7)));

            res[i + 1] = working;
        }
    }

    function parseData(BitReader.Memory memory reader, uint256 feature) internal pure returns (uint256 res) {
        // 12 bits: coordinate - anchor x and y

        res |= feature << 75;

        uint256 width = reader.select(6);
        uint256 height = reader.select(6);

        res |= height << 69; // heighth and width
        res |= width << 63;

        // 12 bits: coordinate - anchor x and y
        res |= reader.select(6) << 51;
        res |= reader.select(6) << 57;

        // 1 or 25 bits: rlud - radii
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 27;

        // 1 or 25 bits: rlud - expanders
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 3;
    }

    function parseReceivers(BitReader.Memory memory reader) internal pure returns (uint256 res) {
        uint256 receiversLength = reader.select(1) == 0x1 ? 0x1 : reader.select(4);

        for (uint256 j = 0; j < receiversLength; j++) {
            uint256 receiver = 0;

            uint256 xOrPreset = reader.select(6);

            uint256 yOrYOffset = reader.select(6);

            // yOrYOffset
            receiver |= yOrYOffset << 6;

            //xOrPreset
            receiver |= xOrPreset;

            // rFeature
            uint256 rFeature = reader.select(3);

            receiver <<= ((rFeature * 12) + (reader.select(1) == 0x1 ? 128 : 0));

            res |= receiver;
        }
    }

    function parseMiniMatrix(
        BitReader.Memory memory reader,
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
        require(z <= 0xf, 'VERS:SETZ:0');
        m.data |= z << 78;
    }

    function getZ(Memory memory m) internal pure returns (uint256 res) {
        res = (m.data >> 78) & 0xf;
    }

    function getWidth(Memory memory m) internal pure returns (uint256 width, uint256 height) {
        // yOrYOffset
        width = (m.data >> 63) & ShiftLib.mask(6);
        height = (m.data >> 69) & ShiftLib.mask(6);
    }

    function getAnchor(Memory memory m) internal pure returns (uint256 x, uint256 y) {
        // yOrYOffset
        x = (m.data >> 51) & ShiftLib.mask(6);
        y = (m.data >> 57) & ShiftLib.mask(6);
    }

    function getPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y
    ) internal pure returns (uint256 palletKey) {
        (uint256 width, ) = getWidth(m);
        uint256 index = x + (y * width);

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

        color = res & 0xffffffff;

        zindex = (res >> 32) & 0xf;
    }

    function getDiffOfReceiverAt(Memory memory base, Memory memory mix)
        internal
        pure
        returns (
            bool negX,
            uint256 diffX,
            bool negY,
            uint256 diffY
        )
    {
        (uint256 recX, uint256 recY, ) = getReceiverAt(base, (mix.data >> 75) & ShiftLib.mask(3), false);
        (uint256 ancX, uint256 ancY) = getAnchor(mix);

        negX = recX < ancX;
        diffX = negX ? ancX - recX : recX - ancX;
        negY = recY < ancY;
        diffY = negY ? ancY - recY : recY - ancY;
    }

    function getPixelAtPositionWithOffset(Memory memory m, uint256 index) internal pure returns (bool exists, uint256 palletKey) {
        (uint256 width, ) = getWidth(m);

        uint256 indexY = index / 33;
        uint256 indexX = index % 33;

        (, uint256 diffX, , uint256 diffY) = getOffset(m);

        if (width != 33) {}

        if (indexX < diffX) return (false, 0);
        uint256 realX = indexX - diffX;

        if (indexY < diffY) return (false, 0);
        uint256 realY = indexY - diffY;

        if (width != 33) {}

        // require(indexX >= diffX, 'VERS:GPAP:0');
        // uint256 realX = indexX - diffX;

        // require(indexY >= diffY, 'VERS:GPAP:1');
        // uint256 realY = indexY - diffY;

        // if (realX >= width || realY >= height) return (false, 0);

        uint256 realIndex = realY * width + realX;

        if (realIndex / 64 >= m.minimatrix.length) return (false, 0);
        exists = true;

        palletKey = (m.minimatrix[realIndex / 64] >> (4 * (realIndex % 64))) & 0xf;
    }

    function initBigMatrix(Memory memory m, uint256 width) internal pure {
        m.bigmatrix = new uint256[](((width * width) / 8) + 2);
    }

    function setBigMatrixPixelAt(
        Memory memory m,
        uint256 index,
        uint256 color
    ) internal pure {
        require(m.bigmatrix.length > index / 8, 'VERS:SBM:0');

        m.bigmatrix[index / 8] |= (color << (32 * (index % 8)));
    }

    function bigMatrixWithData(Memory memory m) internal pure returns (uint256[] memory res) {
        res = m.bigmatrix;
        res[res.length - 1] = m.data;
    }
}
