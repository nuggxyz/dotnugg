// SPDX-License-Identifier: MIT

import '../libraries/BitReader.sol';

library Version {
    using BitReader for BitReader.Memory;
    using Event for uint256[];
    using Event for uint256;

    struct Memory {
        uint256[] pallet;
        uint256[] minimatrix;
        uint256 receivers;
        uint256 data;
    }

    function parse(uint256[][] memory data) internal view returns (Memory[][] memory m) {
        m = new Memory[][](data.length);

        for (uint256 j = 0; j < data.length; j++) {
            BitReader.Memory memory reader = BitReader.init(data[j]);

            // 32 bits: NUGG
            require(reader.select(32) == 0x4e554747, 'DEC:PI:0');

            uint256 feature = reader.select(3);

            uint256[] memory pallet = parsePallet(reader);

            uint256 versionLength = reader.select(2) + 1;

            m[j] = new Memory[](versionLength);

            for (uint256 i = 0; i < versionLength; i++) {
                m[j][i].data = parseData(reader, feature);

                m[j][i].data.log('m[j][i].data');
                m[j][i].receivers = parseReceivers(reader);

                (uint256 width, uint256 height) = getWidth(m[j][i]);

                m[j][i].minimatrix = parseMiniMatrix(reader, width, height);
                m[j][i].pallet = pallet;
            }
        }
    }

    function parsePallet(BitReader.Memory memory reader) internal view returns (uint256[] memory res) {
        uint256 palletLength = reader.select(4) + 1;

        res = new uint256[]((palletLength) / 7 + 1);

        for (uint256 i = 0; i < palletLength; i++) {
            uint256 working = 0;
            // 4 bits: zindex
            working |= reader.select(4) << 32;

            // 1 or 25 bits: rgb
            working |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 8;

            // 1 or 8 bits: a
            working |= reader.select(1) == 0x1 ? 0xff : reader.select(8);

            res[i / 7] |= (working << (36 * (i % 7)));
        }
    }

    function parseData(BitReader.Memory memory reader, uint256 feature) internal view returns (uint256 res) {
        // 12 bits: coordinate - anchor x and y

        res |= feature << 75;

        res |= reader.select(6) << 69; // heighth and width
        res |= reader.select(6) << 63;

        // 12 bits: coordinate - anchor x and y
        res |= reader.select(6) << 51;
        res |= reader.select(6) << 57;

        // 1 or 25 bits: rlud - radii
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 27;

        // 1 or 25 bits: rlud - expanders
        res |= (reader.select(1) == 0x1 ? 0x000000 : reader.select(24)) << 3;
    }

    function parseReceivers(BitReader.Memory memory reader) internal pure returns (uint256 res) {
        uint256 receiversLength = reader.select(1) == 0x1 ? 0x1 : reader.select(3);

        for (uint256 j = 0; j < receiversLength; j++) {
            uint256 receiver = 0;

            // yOrYOffset
            receiver |= reader.select(6) << 6;

            //xOrPreset
            receiver |= reader.select(6);

            // rFeature
            uint256 rFeature = reader.select(3) + reader.select(1) == 0x1 ? 128 : 0;

            res |= receiver << (rFeature * 8);
        }
    }

    function parseMiniMatrix(
        BitReader.Memory memory reader,
        uint256 height,
        uint256 width
    ) internal view returns (uint256[] memory res) {
        uint256 groupsLength = reader.select(1) == 0x1 ? reader.select(8) + 1 : reader.select(16) + 1;

        res = new uint256[]((height * width) / 64);

        uint256 index = 0;

        for (uint256 a = 0; a < groupsLength; a++) {
            uint256 len = reader.select(2) + 1;

            if (len == 4) len = reader.select(4) + 4;

            uint256 key = reader.select(4);

            for (uint256 i = 0; i < len; i++) res[index / 64] |= key << (4 * (index++ % 64));
        }

        groupsLength.log('groupsLength');
        res.log('minimatrix');
    }

    function getReceiverAt(
        Memory memory m,
        uint256 index,
        bool calculated
    )
        internal
        pure
        returns (
            uint256 data,
            uint256 x,
            uint256 y,
            uint256 zindex
        )
    {
        data = m.receivers >> (index * 8 + (calculated ? 128 : 0));

        data &= ShiftLib.mask(12);

        x = data & ShiftLib.mask(6);
        y = data >> 6;

        (, , zindex) = getPixelAt(m, x, y);
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

        m.receivers |= res << ((index * 8) + (calculated ? 128 : 0));
    }

    function getWidth(Memory memory m) internal pure returns (uint256 width, uint256 height) {
        // yOrYOffset
        width = (m.data >> 63) & ShiftLib.mask(6);
        height = (m.data >> 69) & ShiftLib.mask(6);
    }

    function getPixelAt(
        Memory memory m,
        uint256 x,
        uint256 y
    )
        internal
        pure
        returns (
            uint256 palletKey,
            uint256 color,
            uint256 zindex
        )
    {
        (uint256 width, ) = getWidth(m);
        uint256 index = x + y * width;

        palletKey = (m.minimatrix[index / 64] >> (4 * (index % 64))) & 0xf;

        (, color, zindex) = getPalletColorAt(m, palletKey);
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
        res = (m.pallet[index / 7] >> (36 * (index % 7))) & ShiftLib.mask(36);

        color = res & 0xffffffff;

        zindex = (res >> 32) & 0xf;
    }

    function getAnchor(Memory memory m)
        internal
        pure
        returns (
            uint256 x,
            uint256 y,
            uint256 zindex,
            uint256 color
        )
    {
        uint256 anchor = (m.data >> 51) & ShiftLib.mask(12);
        x = anchor & ShiftLib.mask(6);
        y = anchor >> 6;
        (, color, zindex) = getPixelAt(m, x, y);
    }

    function getDiffFromReceiverAt(Memory memory m, uint256 receiverIndex) internal pure returns (uint256 diffX, uint256 diffY) {
        (, uint256 recX, uint256 recY, ) = getReceiverAt(m, receiverIndex, false);
    }
}
