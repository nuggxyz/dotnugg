// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../interfaces/IDotNugg.sol';

import '../libraries/Bytes.sol';
import '../libraries/BytesLib.sol';
import '../libraries/Checksum.sol';
import '../libraries/Uint.sol';

import '../types/PalletType.sol';
import '../types/MatrixType.sol';
import '../types/SudoArrayType.sol';
import '../types/ContentType.sol';
import '../types/CanvasType.sol';
import '../types/VersionType.sol';
import '../types/CollectionType.sol';
import '../types/AnchorType.sol';
import '../types/PixelType.sol';
import '../types/ReceiverType.sol';
import '../../test/Event.sol';

library Decoder {
    using Bytes for bytes;
    using Bytes for bytes;

    using Checksum for bytes;
    using BytesLib for bytes;

    using Event for uint256;

    using ShiftLib for uint256;

    using ShiftLib for uint256[];

    using PalletType for PalletType.Memory;
    using VersionType for VersionType.Memory;

    using CollectionType for uint256;
    using PixelType for uint256;
    using AnchorType for uint256;
    using VersionType for uint256;
    using ReceiverType for uint256;

    // ┌──────────────────────────────────────────────────────────────┐
    // │                                                              │
    // │           _____       _ _           _   _                    │
    // │          /  __ \     | | |         | | (_)                   │
    // │          | /  \/ ___ | | | ___  ___| |_ _  ___  _ __         │
    // │          | |    / _ \| | |/ _ \/ __| __| |/ _ \| '_ \        │
    // │          | \__/\ (_) | | |  __/ (__| |_| | (_) | | | |       │
    // │           \____/\___/|_|_|\___|\___|\__|_|\___/|_| |_|       │
    // │                                                              │
    // │   ┌─────┬────────────────────────────────────────────────┐   │
    // │   │ 0-6 │  "DOTNUGG" (7 bytes in ascii)                  │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │  x  │  file type (0x01) - (1 byte)                   │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │  7  │  width / height (1 byte because square)        │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │  8  │  numFeatures (1 byte)                          │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │9-*  │  item data index array ([*][2]byte)            │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ *-* │  item array ([*][*]byte)                       │   │
    // │   └─────┴────────────────────────────────────────────────┘   │
    // │                                                              │
    // └──────────────────────────────────────────────────────────────┘
    function parseCollection(bytes memory data) internal returns (uint256 res) {
        res = res.collection_width(data.toUint8(7));
        res = res.collection_height(data.toUint8(7));
        res = res.collection_numfeatures(data.toUint8(8));
    }

    function parseItems(bytes[] memory data) internal returns (ItemType.Memory[] memory res) {
        res = new ItemType.Memory[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            res[i] = parseItem(data[i]);
        }
    }

    // ┌───────────────────────────────────────────────────────────────────┐
    // │                                                                   │
    // │                     _____ _                                       │
    // │                    |_   _| |                                      │
    // │                      | | | |_ ___ _ __ ___                        │
    // │                      | | | __/ _ \ '_ ` _ \                       │
    // │                     _| |_| ||  __/ | | | | |                      │
    // │                     \___/ \__\___|_| |_| |_|                      │
    // │                                                                   │
    // │                                                                   │
    // │     ┌─────┬────────────────────────────────────────────────┐      │
    // │     │ 0-6 │  "DOTNUGG" (7 bytes in ascii)                  │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │ 7-8 │  checksum - (2 bytes)                          │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │  9  │  feature key - (1 byte)                        │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │10-11│  colors array index from 0 (uint16)            │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │12-* │  version index array - ([*][2]byte)            │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │ *-* │  color array - ([*][6]byte)                    │      │
    // │     ├─────┼────────────────────────────────────────────────┤      │
    // │     │ *-* │  version array ([*][*]byte)                    │      │
    // │     └─────┴────────────────────────────────────────────────┘      │
    // │                                                                   │
    // │                                                                   │
    // └───────────────────────────────────────────────────────────────────┘

    function validateItem(bytes memory data) internal view {
        require(data.length > 13, 'D:VI:0');
        require(data.slice(0, 7).equal(hex'444f544e554747'), 'D:VI:1');
        require(data.slice(9, data.length - 9).fletcher16() == data.toUint16(7), 'D:VI:2');
    }

    function parseItem(bytes memory data) internal returns (ItemType.Memory memory res) {
        validateItem(data);

        uint256 feat = parseItemFeatureId(data);
        uint16 colorsIndex = data.toUint16(10);
        uint256 versionsLength = (colorsIndex - 12) / 2;

        uint16[] memory versionsIndexz = new uint16[](versionsLength);
        // console.log('yello', versionsIndexz.length);

        for (uint16 i = 0; i < versionsIndexz.length; i++) {
            versionsIndexz[i] = data.toUint16(12 + i * 2);
        }

        // console.log('yello', versionsIndexz.length);

        for (uint256 i = 0; i < versionsLength; i++) {
            // versionsLength.log('testt-1');

            versionsIndexz[i] = data.toUint16(12 + i * 2);
        }

        uint256 palletLength = 1 + (versionsIndexz[0] - colorsIndex) / 5;

        res.pallet = PalletType.load(palletLength);

        res.versions = new VersionType.Memory[](versionsLength);

        require(res.versions.length > 0, 'DEC:PI:0');
        uint256 pix0;
        pix0 = pix0.pixel_r(1);
        pix0 = pix0.pixel_g(1);
        pix0 = pix0.pixel_b(1);
        pix0 = pix0.pixel_a(0);
        pix0 = pix0.pixel_zindex(0);
        pix0 = pix0.pixel_exists(false);
        res.pallet.pixel(0, pix0);

        for (uint256 i = 1; i < palletLength; i++) {
            res.pallet.pixel(i, parsePixel(data, colorsIndex + 5 * (i - 1)));
            versionsLength.log('testt0');
        }

        for (uint256 i = 0; i < versionsLength; i++) {
            uint256 endIndex = i + 1 == versionsIndexz.length ? data.length : versionsIndexz[i + 1];
            res.versions[i] = parseVersion(data, versionsIndexz[i], uint16(endIndex), feat);
        }
    }

    function parseItemFeatureId(bytes memory data) internal view returns (uint256 res) {
        res = uint256(uint8(data[9]));
        require(res < 8, 'DE:PI:0');
    }

    // ┌──────────────────────────────────────────────────────────────┐
    // │                                                              │
    // │                                                              │
    // │                    ______ _          _                       │
    // │                    | ___ (_)        | |                      │
    // │                    | |_/ /___  _____| |                      │
    // │                    |  __/| \ \/ / _ \ |                      │
    // │                    | |   | |>  <  __/ |                      │
    // │                    \_|   |_/_/\_\___|_|                      │
    // │                                                              │
    // │                                                              │
    // │   ┌─────┬────────────────────────────────────────────────┐   │
    // │   │  0  │  zindex (int8)                                 │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ 1-4 │  rgba (4 bytes)                                │   │
    // │   └─────┴────────────────────────────────────────────────┘   │
    // │                                                              │
    // └──────────────────────────────────────────────────────────────┘
    function parsePixel(bytes memory _bytes, uint256 _start) internal returns (uint256 res) {
        require(_bytes.length >= _start + 5, 'parsePixel_outOfBounds');
        {
            int8 zindex = _bytes.toInt8(_start);
            res = res.pixel_zindex(uint8(7 + zindex));
            res = res.pixel_exists(true);
            res = res.pixel_r(uint8(_bytes[_start + 1]));
            res = res.pixel_g(uint8(_bytes[_start + 2]));
            res = res.pixel_b(uint8(_bytes[_start + 3]));
            res = res.pixel_a(uint8(_bytes[_start + 4]));
        }
    }

    // ┌──────────────────────────────────────────────────────────────┐
    // │                                                              │
    // │                                                              │
    // │                    ______      _                             │
    // │                    | ___ \    | |                            │
    // │                    | |_/ /__ _| |__   __ _                   │
    // │                    |    // _` | '_ \ / _` |                  │
    // │                    | |\ \ (_| | |_) | (_| |                  │
    // │                    \_| \_\__, |_.__/ \__,_|                  │
    // │                           __/ |                              │
    // │                          |___/                               │
    // │                                                              │
    // │    ┌─────┬─────────────────────────────────────────────┐     │
    // │    │  0  │  r (uint8)                                  │     │
    // │    ├─────┼─────────────────────────────────────────────┤     │
    // │    │  1  │  l (uint8)                                  │     │
    // │    ├─────┼─────────────────────────────────────────────┤     │
    // │    │  2  │  u (uint8)                                  │     │
    // │    ├─────┼─────────────────────────────────────────────┤     │
    // │    │  3  │  d (uint8)                                  │     │
    // │    └─────┴─────────────────────────────────────────────┘     │
    // │                                                              │
    // │                                                              │
    // └──────────────────────────────────────────────────────────────┘

    function parseRlud(bytes memory _bytes, uint256 _start) internal returns (uint256 res) {
        require(_bytes.length >= _start + 5, 'parseRlud_outOfBounds');
        bool exists = bool(uint8(_bytes[_start + 0]) == 1);
        if (exists) {
            res = res.anchor_rludExists(exists);
            res = res.rlud_right(uint8(_bytes[_start + 1]));
            res = res.rlud_left(uint8(_bytes[_start + 2]));
            res = res.rlud_up(uint8(_bytes[_start + 3]));
            res = res.rlud_down(uint8(_bytes[_start + 4]));
        }
    }

    // ┌──────────────────────────────────────────────────────────────┐
    // │                                                              │
    // │                _   _               _                         │
    // │               | | | |             (_)                        │
    // │               | | | | ___ _ __ ___ _  ___  _ __              │
    // │               | | | |/ _ \ '__/ __| |/ _ \| '_ \             │
    // │               \ \_/ /  __/ |  \__ \ | (_) | | | |            │
    // │                \___/ \___|_|  |___/_|\___/|_| |_|            │
    // │                                                              │
    // │                                                              │
    // │   ┌─────┬────────────────────────────────────────────────┐   │
    // │   │  0  │  width (1 bytes)                               │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ 1-2 │  anchor (2 bytes)                              │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ 3-7 │  expanders (2 bytes - rlud - 5 uint4s)         │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ 8-6 │  radii (2 bytes - rlud - 5 uint4s)             │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │  7  │  groups index  (uint8)                         │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ 8-* │  receivers ([*][2] bytes)                      │   │
    // │   ├─────┼────────────────────────────────────────────────┤   │
    // │   │ *-* │  group array ([*][1]byte)                      │   │
    // │   └─────┴────────────────────────────────────────────────┘   │
    // │                                                              │
    // └──────────────────────────────────────────────────────────────┘
    function parseVersion(
        bytes memory input,
        uint256 _start,
        uint256 _end,
        uint256 feat
    ) internal returns (VersionType.Memory memory res) {
        // require(_bytes.length >= _end && _start < _end, 'parsePixel_outOfBounds');

        // uint256 info;
        uint256 addr;

        uint256 info;
        uint256 anchor;
        {
            info = info.version_feature(feat);
            info = info.version_width(input.toUint8(_start + addr++));
            info = info.version_height(input.toUint8(_start + addr++));

            anchor = anchor.anchor_x(input.toUint8(_start + addr++));
            anchor = anchor.anchor_y(input.toUint8(_start + addr++));

            uint256 _anchor = parseRlud(input, _start + addr++);
            if (_anchor.anchor_rludExists()) {
                addr += 4;
                info = info.version_anchor(_anchor | anchor);
            }

            uint256 expanders = parseRlud(input, _start + addr++);
            if (expanders.anchor_rludExists()) {
                addr += 4;
                info = info.version_expanders(expanders);
            }
        }
        uint256 groupsIndex = uint256(_start) + input.toUint8(_start + addr++);

        uint256 i = _start + addr++;

        for (; i < groupsIndex; i += 2) {
            (uint256 preset, uint256 yoffset, , uint256 feature, bool calculated) = parseReceiver(input, i);

            uint256 receiver;
            receiver = receiver.receiver_yoffset(yoffset);
            receiver = receiver.receiver_preset(preset);
            receiver = receiver.receiver_exists(true);

            if (calculated) res.calcrec(feature, receiver);
            else res.staticrec(feature, receiver);
        }

        res.info = info.version_contentStart(groupsIndex);
        res.content = input.slice(groupsIndex, _end - groupsIndex);
    }

    // ┌────────────────────────────────────────────────────────────┐
    // │                                                            │
    // │             ______              _                          │
    // │             | ___ \            (_)                         │
    // │             | |_/ /___  ___ ___ ___   _____ _ __           │
    // │             |    // _ \/ __/ _ \ \ \ / / _ \ '__|          │
    // │             | |\ \  __/ (_|  __/ |\ V /  __/ |             │
    // │             \_| \_\___|\___\___|_| \_/ \___|_|             │
    // │                                                            │
    // │                                                            │
    // │  ┌─────┬────────────────────────────────────────────────┐  │
    // │  │  0  │  preset | x (uint4) & yoffset | y (int4)       │  │
    // │  ├─────┼────────────────────────────────────────────────┤  │
    // │  │  1  │  type (1 byte)                                 │  │
    // │  └─────┴────────────────────────────────────────────────┘  │
    // │                                                            │
    // └────────────────────────────────────────────────────────────┘
    function parseReceiver(bytes memory input, uint256 _start)
        internal
        returns (
            uint256 preset,
            uint256 yoffset,
            bool exists,
            uint256 feature,
            bool calculated
        )
    {
        require(input.length >= _start + 2, 'parseReceiver_outOfBounds');
        (preset, yoffset) = input.toUint4(_start + 0);
        exists = true;

        int8 tmpfeat = input.toInt8(_start + 1);

        if (tmpfeat >= 0) {
            feature = uint8(tmpfeat);
        } else {
            feature = uint8(tmpfeat * -1);
            calculated = true;
        }

        if (feature > 7) feature = 7;
    }
}
