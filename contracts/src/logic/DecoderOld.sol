// SPDX-License-Identifier: MIT


// pragma solidity 0.8.4;

// import '../libraries/ShiftLib.sol';

// import '../types/PalletType.sol';
// import '../types/MatrixType.sol';
// import '../types/SudoArrayType.sol';
// import '../types/ContentType.sol';
// import '../types/CanvasType.sol';
// import '../types/VersionType.sol';
// import '../types/CollectionType.sol';
// import '../types/AnchorType.sol';
// import '../types/PixelType.sol';
// import '../types/ReceiverType.sol';
// import '../../test/Event.sol';

// library Decoder {
//     using Event for uint256;

//     using ShiftLib for uint256;

//     using ShiftLib for uint256[];

//     using PalletType for PalletType.Memory;
//     using VersionType for VersionType.Memory;

//     using CollectionType for uint256;
//     using PixelType for uint256;
//     using AnchorType for uint256;
//     using VersionType for uint256;
//     using ReceiverType for uint256;

//     uint256 constant MAX_ITEMS = 8;
//     uint256 constant MASK = 0xffffffffff;

//     event log_named_address(string key, address val);
//     event log_named_bytes32(string key, bytes32 val);
//     event log_named_decimal_int(string key, int256 val, uint256 decimals);
//     event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
//     event log_named_int(string key, int256 val);
//     event log_named_uint(string key, uint256 val);
//     event log_named_bytes(string key, bytes val);
//     event log_named_string(string key, string val);

//     // using Bytes for bytes;
//     // using Bytes for bytes;

//     // using Checksum for bytes;
//     // using BytesLib for bytes;

//     // using Uint256 for uint256;
//     // using Rgba for IDotNugg.Rgba;

//     // ┌──────────────────────────────────────────────────────────────┐
//     // │                                                              │
//     // │           _____       _ _           _   _                    │
//     // │          /  __ \     | | |         | | (_)                   │
//     // │          | /  \/ ___ | | | ___  ___| |_ _  ___  _ __         │
//     // │          | |    / _ \| | |/ _ \/ __| __| |/ _ \| '_ \        │
//     // │          | \__/\ (_) | | |  __/ (__| |_| | (_) | | | |       │
//     // │           \____/\___/|_|_|\___|\___|\__|_|\___/|_| |_|       │
//     // │                                                              │
//     // │   ┌─────┬────────────────────────────────────────────────┐   │
//     // │   │ 0-6 │  "DOTNUGG" (7 bytes in ascii)                  │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │  x  │  file type (0x01) - (1 byte)                   │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │  7  │  width / height (1 byte because square)        │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │  8  │  numFeatures (1 byte)                          │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │9-*  │  item data index array ([*][2]byte)            │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ *-* │  item array ([*][*]byte)                       │   │
//     // │   └─────┴────────────────────────────────────────────────┘   │
//     // │                                                              │
//     // └──────────────────────────────────────────────────────────────┘

//     function parseCollection(uint256[] memory data) internal view returns (uint256 res) {
//         res = res.collection_width(data.rbit(8, 7 * 8));
//         res = res.collection_height(data.rbit(8, 7 * 8));
//         res = res.collection_numfeatures(data.rbit(8, 8 * 8));

//         // emit log_named_uint('data[0]', data[0]);
//         // emit log_named_uint('data.rbit(8, 7 * 8)', data.rbit(8, 7 * 8));
//         // emit log_named_uint('HERE', res);

//         // emit log_named_uint('width', res.collection_width());
//         // emit log_named_uint('height', res.collection_height());
//         // emit log_named_uint('numfeatures', res.collection_numfeatures());
//     }

//     function parseItems(uint256[][] memory items) internal view returns (ItemType.Memory[] memory res) {
//         res = new ItemType.Memory[](items.length);
//         for (uint256 i = 0; i < res.length; i++) {
//             res[i] = parseItem(items[i]);
//         }
//     }

//     // ┌───────────────────────────────────────────────────────────────────┐
//     // │                                                                   │
//     // │                     _____ _                                       │
//     // │                    |_   _| |                                      │
//     // │                      | | | |_ ___ _ __ ___                        │
//     // │                      | | | __/ _ \ '_ ` _ \                       │
//     // │                     _| |_| ||  __/ | | | | |                      │
//     // │                     \___/ \__\___|_| |_| |_|                      │
//     // │                                                                   │
//     // │                                                                   │
//     // │     ┌─────┬────────────────────────────────────────────────┐      │
//     // │     │ 0-6 │  "DOTNUGG" (7 bytes in ascii)                  │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │ 7-8 │  checksum - (2 bytes)                          │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │  9  │  feature key - (1 byte)                        │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │10-11│  colors array index from 0 (uint16)            │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │12-* │  version index array - ([*][2]byte)            │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │ *-* │  color array - ([*][6]byte)                    │      │
//     // │     ├─────┼────────────────────────────────────────────────┤      │
//     // │     │ *-* │  version array ([*][*]byte)                    │      │
//     // │     └─────┴────────────────────────────────────────────────┘      │
//     // │                                                                   │
//     // │                                                                   │
//     // └───────────────────────────────────────────────────────────────────┘

//     function validateItem(uint256[] memory data) internal view {
//         // require(data.length > 13, 'D:VI:0');

//         // (data[0] >> (25 * 8)).log('yow');
//         // (uint256(0x444f544e554747)).log('yow');
//         require(data[0] >> (25 * 8) == 0x444f544e554747, 'D:VI:1');
//         // require(data.rbit(7 * 8) == 0x444f544e554747, 'D:VI:1');

//         // require(data.slice(0, 7).equal(abi.encodePacked('DOTNUGG')), 'D:VI:1');
//         // TODO require(data.slice(9, data.length - 9).fletcher16() == data.rbit(16, 7 * 8), 'D:VI:2');
//     }

//     // @note - max feature len is now 8
//     function parseItem(uint256[] memory data) internal view returns (ItemType.Memory memory res) {
//         validateItem(data);

//         uint256 feat = parseItemFeatureId(data[0]);
//         feat.log('feat');

//         data.rbit(16, 10 * 8).log('b4');
//         // uint16 colorsIndex = data.toUint16(10);
//         uint256 colorsIndex = data.rbit(16, 10 * 8);
//         colorsIndex.log('colorsIndex');

//         uint256 versionsLength = (colorsIndex - 12) / 2;
//         versionsLength.log('versionsLength');

//         uint256[] memory versionsIndexz = new uint256[](versionsLength);
//         // console.log('yello', versionsIndexz.length);

//         for (uint256 i = 0; i < versionsLength; i++) {
//             // versionsLength.log('testt-1');
//             data[i].log('data[i]');

//             versionsIndexz[i] = data.rbit(16, 12 + i * 2);
//         }

//         uint256 palletLength = 1 + (versionsIndexz[0] - colorsIndex) / 5;

//         res.pallet = PalletType.load(palletLength);

//         res.versions = new VersionType.Memory[](versionsLength);

//         require(res.versions.length > 0, 'DEC:PI:0');

//         res.pallet.pixel(0, uint256(0).pixel_r(1).pixel_g(1).pixel_b(1).pixel_a(0).pixel_zindex(0).pixel_exists(false));

//         for (uint256 i = 1; i < palletLength; i++) {
//             res.pallet.pixel(i, parsePixel(data, colorsIndex + 5 * (i - 1)));
//             versionsLength.log('testt0');
//         }

//         for (uint256 i = 0; i < versionsLength; i++) {
//             // uint256 endIndex = i + 1 == versionsLength ? MASK : versionsIndexz[i + 1];
//             res.versions[i] = parseVersion(data, versionsIndexz[i], feat);
//             // versionsLength.log('testt1');
//         }
//     }

//     function parseItemFeatureId(uint256 data) internal view returns (uint256 res) {
//         res = data.rbit(8, 9 * 8);
//         require(res < 8, 'DE:PI:0');
//     }

//     // ┌──────────────────────────────────────────────────────────────┐
//     // │                                                              │
//     // │                                                              │
//     // │                    ______ _          _                       │
//     // │                    | ___ (_)        | |                      │
//     // │                    | |_/ /___  _____| |                      │
//     // │                    |  __/| \ \/ / _ \ |                      │
//     // │                    | |   | |>  <  __/ |                      │
//     // │                    \_|   |_/_/\_\___|_|                      │
//     // │                                                              │
//     // │                                                              │
//     // │   ┌─────┬────────────────────────────────────────────────┐   │
//     // │   │  0  │  zindex (int8)                                 │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ 1-4 │  rgba (4 bytes)                                │   │
//     // │   └─────┴────────────────────────────────────────────────┘   │
//     // │                                                              │
//     // └──────────────────────────────────────────────────────────────┘

//     function parsePixel(uint256[] memory input, uint256 _start) internal view returns (uint256 res) {
//         // require(_bytes.length >= _start + 5, 'parsePixel_outOfBounds');
//         {
//             res = res.pixel_zindex(input.rbit(8, _start++ * 8));
//             res = res.pixel_exists(true);
//             res = res.pixel_r(input.rbit(8, _start++ * 8));
//             res = res.pixel_g(input.rbit(8, _start++ * 8));
//             res = res.pixel_b(input.rbit(8, _start++ * 8));
//             res = res.pixel_a(input.rbit(8, _start++ * 8));
//         }
//     }

//     // ┌──────────────────────────────────────────────────────────────┐
//     // │                                                              │
//     // │                                                              │
//     // │                    ______      _                             │
//     // │                    | ___ \    | |                            │
//     // │                    | |_/ /__ _| |__   __ _                   │
//     // │                    |    // _` | '_ \ / _` |                  │
//     // │                    | |\ \ (_| | |_) | (_| |                  │
//     // │                    \_| \_\__, |_.__/ \__,_|                  │
//     // │                           __/ |                              │
//     // │                          |___/                               │
//     // │                                                              │
//     // │    ┌─────┬─────────────────────────────────────────────┐     │
//     // │    │  0  │  r (uint8)                                  │     │
//     // │    ├─────┼─────────────────────────────────────────────┤     │
//     // │    │  1  │  l (uint8)                                  │     │
//     // │    ├─────┼─────────────────────────────────────────────┤     │
//     // │    │  2  │  u (uint8)                                  │     │
//     // │    ├─────┼─────────────────────────────────────────────┤     │
//     // │    │  3  │  d (uint8)                                  │     │
//     // │    └─────┴─────────────────────────────────────────────┘     │
//     // │                                                              │
//     // │                                                              │
//     // └──────────────────────────────────────────────────────────────┘

//     // function parseRgba(uint256[] memory _bytes, uint256 _start) internal  returns (IDotNugg.Rgba memory res) {
//     //     require(_bytes.length >= _start + 4, 'parsePixel_outOfBounds');
//     //     res.r = uint8(_bytes[_start + 0]);
//     //     res.g = uint8(_bytes[_start + 1]);
//     //     res.b = uint8(_bytes[_start + 2]);
//     //     res.a = uint8(_bytes[_start + 3]);
//     // }

//     function parseRlud(uint256[] memory input, uint256 _start) internal view returns (uint256 res) {
//         bool exists = input.rbit(8, _start++ * 8) == 1;

//         if (exists) {
//             res = res
//                 .anchor_rludExists(exists)
//                 .rlud_right(input.rbit(8, _start++ * 8))
//                 .rlud_left(input.rbit(8, _start++ * 8))
//                 .rlud_up(input.rbit(8, _start++ * 8))
//                 .rlud_down(input.rbit(8, _start++ * 8)); // // // // // //
//         }
//     }

//     // ┌──────────────────────────────────────────────────────────────┐
//     // │                                                              │
//     // │                _   _               _                         │
//     // │               | | | |             (_)                        │
//     // │               | | | | ___ _ __ ___ _  ___  _ __              │
//     // │               | | | |/ _ \ '__/ __| |/ _ \| '_ \             │
//     // │               \ \_/ /  __/ |  \__ \ | (_) | | | |            │
//     // │                \___/ \___|_|  |___/_|\___/|_| |_|            │
//     // │                                                              │
//     // │                                                              │
//     // │   ┌─────┬────────────────────────────────────────────────┐   │
//     // │   │  0  │  width (1 bytes)                               │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ 1-2 │  anchor (2 bytes)                              │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ 3-7 │  expanders (2 bytes - rlud - 5 uint4s)         │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ 8-6 │  radii (2 bytes - rlud - 5 uint4s)             │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │  7  │  groups index  (uint8)                         │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ 8-* │  receivers ([*][2] bytes)                      │   │
//     // │   ├─────┼────────────────────────────────────────────────┤   │
//     // │   │ *-* │  group array ([*][1]byte)                      │   │
//     // │   └─────┴────────────────────────────────────────────────┘   │
//     // │                                                              │
//     // └──────────────────────────────────────────────────────────────┘

//     function parseVersion(
//         uint256[] memory input,
//         uint256 _start,
//         uint256 feat
//     ) internal view returns (VersionType.Memory memory res) {
//         // require(_bytes.length >= _end && _start < _end, 'parsePixel_outOfBounds');

//         // uint256 info;
//         uint256 addr = 0;

//         uint256 info = 0;

//         info = info.version_feature(feat).version_width(input.rbit(8, _start * 8 + addr++ * 8)).version_height(input.rbit(8, _start * 8 + addr++ * 8));

//         uint256 anchor = uint256(0).anchor_x(input.rbit(8, _start * 8 + addr++ * 8)).anchor_y(input.rbit(8, _start * 8 + addr++ * 8));

//         uint256 _anchor = parseRlud(input, _start * 8 + addr++ * 8);
//         if (_anchor.anchor_rludExists()) {
//             addr += 4;
//             info = info.version_anchor(_anchor | anchor);
//         }
//         uint256 expanders = parseRlud(input, _start * 8 + addr++ * 8);
//         if (expanders.anchor_rludExists()) {
//             addr += 4;
//             info = info.version_expanders(expanders);
//         }

//         uint256 groupsIndex = _start + input.rbit(8, (_start + addr++) * 8);

//         uint256 i = _start + addr++;

//         for (; i < groupsIndex; i += 2) {
//             (uint256 preset, uint256 yoffset, , uint256 feature, bool calculated) = parseReceiver(input, i * 8);
//             groupsIndex.log('groupIndex');
//             if (calculated) {
//                 res.calcrec(feature, uint256(0).receiver_yoffset(yoffset).receiver_preset(preset).receiver_exists(true));
//             } else {
//                 res.staticrec(feature, uint256(0).receiver_yoffset(yoffset).receiver_preset(preset).receiver_exists(true));
//             }
//         }

//         res.info = info.version_contentStart(groupsIndex);
//         res.content = input;
//     }

//     // ┌────────────────────────────────────────────────────────────┐
//     // │                                                            │
//     // │             ______              _                          │
//     // │             | ___ \            (_)                         │
//     // │             | |_/ /___  ___ ___ ___   _____ _ __           │
//     // │             |    // _ \/ __/ _ \ \ \ / / _ \ '__|          │
//     // │             | |\ \  __/ (_|  __/ |\ V /  __/ |             │
//     // │             \_| \_\___|\___\___|_| \_/ \___|_|             │
//     // │                                                            │
//     // │                                                            │
//     // │  ┌─────┬────────────────────────────────────────────────┐  │
//     // │  │  0  │  preset | x (uint4) & yoffset | y (int4)       │  │
//     // │  ├─────┼────────────────────────────────────────────────┤  │
//     // │  │  1  │  type (1 byte)                                 │  │
//     // │  └─────┴────────────────────────────────────────────────┘  │
//     // │                                                            │
//     // └────────────────────────────────────────────────────────────┘

//     function parseReceiver(uint256[] memory input, uint256 _start)
//         internal
//         returns (
//             uint256 preset,
//             uint256 yoffset,
//             bool exists,
//             uint256 feature,
//             bool calculated
//         )
//     {
//         // require(_bytes.length >= _start + 2, 'parseReceiver_outOfBounds');
//         // (preset, offset) = _bytes.toUint4(_start + 0);
//         preset = input.rbit(4, _start * 8);
//         yoffset = input.rbit(4, _start * 8 + 4);
//         exists = true;

//         calculated = input.rbit1(_start * 8 + 8);
//         feature = input.rbit(7, _start * 8 + 9);
//     }
// }
