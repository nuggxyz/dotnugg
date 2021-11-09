// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';

import '../libraries/Bytes.sol';
import '../libraries/BytesLib.sol';
import '../libraries/Checksum.sol';
import '../libraries/Uint.sol';
import '../logic/Rgba.sol';

import '../test/Console.sol';

library Decoder {
    using Bytes for bytes;
    using Bytes for bytes;

    using Checksum for bytes;
    using BytesLib for bytes;

    using Uint256 for uint256;
    using Rgba for IDotNugg.Rgba;

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

    function parseCollection(bytes memory data) internal view returns (IDotNugg.Collection memory res) {
        res.width = data.toUint8(7);
        res.height = res.width;

        res.numFeatures = data.toUint8(8);
        uint16 tmp = data.toUint16(9);
        uint16[] memory itemIndexs = new uint16[]((tmp - 9) / 2);

        itemIndexs[0] = tmp;
        for (uint16 i = 1; i < itemIndexs.length; i++) {
            itemIndexs[i] = data.toUint16(9 + i * 2);
        }

        res.defaults = new bytes[](itemIndexs.length);

        for (uint16 i = 0; i < itemIndexs.length; i++) {
            uint256 endIndex = i + 1 == itemIndexs.length ? data.length : itemIndexs[i + 1];
            res.defaults[i] = data.slice(itemIndexs[i], endIndex - itemIndexs[i]);
        }
        return res;
    }

    function parseItems(bytes[] memory data, uint8 featureLen) internal view returns (IDotNugg.Item[] memory res) {
        res = new IDotNugg.Item[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            if (data[i].length > 0) res[i] = parseItem(data[i], featureLen);
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
        require(data.slice(0, 7).equal(abi.encodePacked('DOTNUGG')), 'D:VI:1');
        require(data.slice(9, data.length - 9).fletcher16() == data.toUint16(7), 'D:VI:2');
    }

    function parseItem(bytes memory data, uint8 featureLen) internal view returns (IDotNugg.Item memory res) {
        validateItem(data);

        res.feature = parseItemFeatureId(data);

        uint16 colorsIndex = data.toUint16(10);
        uint16[] memory versionsIndexz = new uint16[]((colorsIndex - 12) / 2);
        console.log('yello', versionsIndexz.length);

        for (uint16 i = 0; i < versionsIndexz.length; i++) {
            versionsIndexz[i] = data.toUint16(12 + i * 2);
        }

        res.pallet = new IDotNugg.Pixel[](1 + (versionsIndexz[0] - colorsIndex) / 5);
        res.versions = new IDotNugg.Version[](versionsIndexz.length);
        console.log('p', res.pallet.length);

        require(res.versions.length > 0, 'DEC:PI:0');
        res.pallet[0] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 1, g: 1, b: 1, a: 0}), zindex: 0, exists: false});
        for (uint16 i = 1; i < res.pallet.length; i++) {
            res.pallet[i] = parsePixel(data, colorsIndex + 5 * (i - 1));
            console.log(res.pallet[i].rgba.toAscii(), uint8(int8(res.pallet[i].zindex * int8(res.pallet[i].zindex < int8(0) ? -1 : int8(1)))));
        }

        for (uint16 i = 0; i < versionsIndexz.length; i++) {
            uint256 endIndex = i + 1 == versionsIndexz.length ? data.length : versionsIndexz[i + 1];
            res.versions[i] = parseVersion(data, versionsIndexz[i], uint16(endIndex), featureLen);
        }
    }

    function parseItemFeatureId(bytes memory data) internal view returns (uint8 res) {
        res = uint8(data[9]);
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

    function parsePixel(bytes memory _bytes, uint256 _start) internal view returns (IDotNugg.Pixel memory res) {
        require(_bytes.length >= _start + 5, 'parsePixel_outOfBounds');

        console.log('sup', _bytes.toUint8(_start));

        res.zindex = _bytes.toInt8(_start);

        console.logInt(res.zindex);
        res.rgba = parseRgba(_bytes, _start + 1);
        res.exists = true;
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

    function parseRgba(bytes memory _bytes, uint256 _start) internal view returns (IDotNugg.Rgba memory res) {
        require(_bytes.length >= _start + 4, 'parsePixel_outOfBounds');
        res.r = uint8(_bytes[_start + 0]);
        res.g = uint8(_bytes[_start + 1]);
        res.b = uint8(_bytes[_start + 2]);
        res.a = uint8(_bytes[_start + 3]);
    }

    function parseRlud(bytes memory _bytes, uint256 _start) internal view returns (IDotNugg.Rlud memory res) {
        // require(_bytes.length >= _start + 5, 'parseRlud_outOfBounds');
        res.exists = bool(uint8(_bytes[_start + 0]) == 1);
        if (res.exists) {
            res.r = uint8(_bytes[_start + 1]);
            res.l = uint8(_bytes[_start + 2]);
            res.u = uint8(_bytes[_start + 3]);
            res.d = uint8(_bytes[_start + 4]);
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
        bytes memory _bytes,
        uint256 _start,
        uint256 _end,
        uint8 featureLen
    ) internal view returns (IDotNugg.Version memory res) {
        require(_bytes.length >= _end && _start < _end, 'parsePixel_outOfBounds');

        res.calculatedReceivers = new IDotNugg.Coordinate[](featureLen);
        res.staticReceivers = new IDotNugg.Coordinate[](featureLen);

        res.width = _bytes.toUint8(_start + 0);
        res.height = _bytes.toUint8(_start + 1);
        res.anchor.coordinate.a = _bytes.toUint8(_start + 2);
        res.anchor.coordinate.b = _bytes.toUint8(_start + 3);
        res.expanders = parseRlud(_bytes, _start + 4);

        res.anchor.radii = parseRlud(_bytes, _start + (res.expanders.exists ? 10 : 5));

        uint16 groupsIndex = uint16(_start) +
            _bytes.toUint8(_start + (res.expanders.exists && res.anchor.radii.exists ? 15 : res.expanders.exists || res.anchor.radii.exists ? 11 : 6));

        uint256 i = _start + (res.expanders.exists && res.expanders.exists ? 15 : res.expanders.exists || res.expanders.exists ? 11 : 6) + 1;

        console.log('ayo', _start, groupsIndex, i);
        for (; i < groupsIndex; i += 2) {
            (IDotNugg.Coordinate memory rec, uint8 feature, bool calculated) = parseReceiver(_bytes, i);
            console.log('HERE IS THE RECEIVER: ', rec.a, feature, calculated);

            if (calculated) {
                res.calculatedReceivers[feature] = rec;
            } else {
                //  require(feature < 16, String.fromUint256(i));
                res.staticReceivers[feature] = rec;
            }
        }

        res.data = _bytes.slice(groupsIndex, _end - groupsIndex);
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

    function parseReceiver(bytes memory _bytes, uint256 _start)
        internal
        view
        returns (
            IDotNugg.Coordinate memory res,
            uint8 feature,
            bool calculated
        )
    {
        require(_bytes.length >= _start + 2, 'parseRlud_outOfBounds');
        (res.a, res.b) = _bytes.toUint4(_start + 0);
        res.exists = true;
        int8 tmpfeat = _bytes.toInt8(_start + 1);

        if (tmpfeat >= 0) {
            feature = uint8(tmpfeat);
        } else {
            feature = uint8(tmpfeat * -1);
            calculated = true;
        }
    }
}
