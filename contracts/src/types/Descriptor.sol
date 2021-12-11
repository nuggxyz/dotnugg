// SPDX-License-Identifier: MIT

// 1.5 x each feature for a coordinate (0.75 x 2)
// 2 byte each feature for expanders coordinate (16, 16, 16, 16)
// 1 byte each feature for expanders amount (4, 4, 4, 4)

// 3 | 1/2 bytes - base ---- 8 | .5 --- 8 | .5   ---- 1 vars

// 8 | 1 bytes - head
// 8 | 1 bytes - eyes
// 8 | 1 bytes - mouth
// 8 | 1 bytes - back
// 8 | 1 bytes - hair
// 8 | 1 bytes - neck ---- 48 | 6 --- 51 | 6.5    ----- 6 vars

// 8 | 1 bytes - head
// 8 | 1 bytes - eyes
// 8 | 1 bytes - mouth
// 8 | 1 bytes - back
// 8 | 1 bytes - hair
// 8 | 1 bytes - neck ---- 48 | 6  -- 99 | 12.5 ---- 6 vars

// 12 | 1.5 bytes - head coordinate
// 12 | 1.5 bytes - eyes coordinate
// 12 | 1.5 bytes - mouth coordinate
// 12 | 1.5 bytes - back coordinate
// 12 | 1.5 bytes - hair coordinate
// 12 | 1.5 bytes - neck coordinate ---- 159-    ----- 12 vars

// 3            - expander 3 feat      ------- 3 vars

// 3            - expander 1 feat
// 24 | 3 bytes - expander 1
// 3            - expander 2 feat
// 24 | 3 bytes - expander 2
// 24 | 3 bytes - expander 3       - 24 vars

library Descriptor {
    // struct Memory {
    //     IDotNugg.Rlud[] expanderOffset; // 0 - 8
    //     IDotNugg.Rlud[] expanderOffsetDirection; // 0 - 1
    //     IDotNugg.Rlud[] expanderAmount; // 0 - 3
    //     IDotNugg.Coordinate[] anchors; // 0 - 63
    // }

    // function parse(uint256 input) internal pure returns (Memory memory m) {
    //     m.expanderOffset = new IDotNugg.Rlud[](8);
    //     m.expanderOffsetDirection = new IDotNugg.Rlud[](8);
    //     m.expanderAmount = new IDotNugg.Rlud[](8);
    //     m.anchors = new IDotNugg.Coordinate[](8);

    //     uint256[] memory tmp = new uint256[](2);
    //     tmp[0] = 1;
    //     tmp[1] = input;

    //     (, BitReader.Memory memory reader) = BitReader.init(tmp);

    //     reader.select(99);

    //     for (uint256 i = 1; i < 7; i++) {
    //         m.anchors[i].a = uint8(reader.select(6));
    //         m.anchors[i].b = uint8(reader.select(6));
    //         m.anchors[i].exists = m.anchors[i].a != 0 || m.anchors[i].b != 0;
    //     }
    // }

    function receiverOverride(uint256 input, uint256 feature)
        internal
        pure
        returns (
            bool exists,
            uint256 x,
            uint256 y
        )
    {
        return (false, 15, 15);
    }
}
