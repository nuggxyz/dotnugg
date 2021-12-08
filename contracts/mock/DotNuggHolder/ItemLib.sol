// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../types/ItemType.sol';
import '../types/LengthType.sol';

import '../types/OldShiftType.sol';

import '../../src/libraries/ShiftLib.sol';
import './DotNuggLib.sol';

library ItemLib {
    using ItemType for uint256;
    using LengthType for uint256;

    using ShiftLib for uint256;
    using OldShiftType for uint256;

    struct Storage {
        mapping(uint256 => uint256) tokenData;
        mapping(uint256 => uint256) protocolItems;
    }

    event PreMint(uint256 tokenId, uint256[] items);
    event PopItem(uint256 tokenId, uint256 itemId);
    event PushItem(uint256 tokenId, uint256 itemId);
    event OpenSlot(uint256 tokenId);

    function mint(
        Storage storage s,
        DotNuggLib.Storage storage dns,
        uint256 tokenId,
        uint256 data
    ) internal returns (uint256[] memory items) {
        require(s.tokenData[tokenId] == 0, 'IL:M:0');

        uint256 lendata = dns.lengths;

        // console.log('item0: ', data.item0(), lendata.length(0), data.item0() % lendata.length(0));
        // console.log('item1: ', data.item1(), lendata.length(1), data.item1() % lendata.length(1));
        // console.log('item3: ', data.item3(), lendata.length(4), data.item4() % lendata.length(4));

        data = data.size(0x0);
        data = OldShiftType.base(data, OldShiftType.base(data) % lendata.length(0));
        data = data.item(1, 0, data.item1() % lendata.length(1));
        data = data.item(2, 0, data.item(2) % lendata.length(2));
        data = data.item(4, 0, data.item(4) % lendata.length(4));
        // data = data.item(5, 0, data.item(5) % lendata.length(5));

        // .item4(data.item4() % lendata.item4());

        s.tokenData[tokenId] = data;

        return data.items();
    }

    function pop(
        Storage storage s,
        uint256 tokenId,
        uint256 itemId
    ) internal {
        uint256 data = s.tokenData[tokenId];

        require(data != 0, '1155:STF:0');

        (data, , ) = data.popFirstMatch(uint16(itemId));

        s.tokenData[tokenId] = data;

        s.protocolItems[itemId]++;

        emit PushItem(tokenId, itemId);
    }

    function push(
        Storage storage s,
        uint256 tokenId,
        uint256 itemId
    ) internal {
        uint256 data = s.tokenData[tokenId];
        require(data != 0, '1155:STF:0');

        require(s.protocolItems[itemId] > 0, '1155:SBTF:1');

        s.protocolItems[itemId]++;

        (data, ) = data.pushFirstEmpty(uint16(itemId));

        s.tokenData[tokenId] = data;

        emit PushItem(tokenId, itemId);
    }

    function open(Storage storage s, uint256 tokenId) internal {
        uint256 data = s.tokenData[tokenId];
        require(data != 0, '1155:STF:0');

        data = data.size(OldShiftType.size(data) + 1);

        s.tokenData[tokenId] = data;

        emit OpenSlot(tokenId);
    }

    function infoOf(Storage storage s, uint256 tokenId)
        internal
        view
        returns (
            uint256 base,
            uint256 size,
            uint256[] memory items
        )
    {
        uint256 data = s.tokenData[tokenId];
        items = data.items();
        size = OldShiftType.size(data);
        base = OldShiftType.base(data);
    }

    // 1/2 byte - size ---- 0-15
    // 1/2 bytes - base -----  0-15
    // 1/2 byte - traits 0-3
    // 1/2 byte - traits 4-7 --- 2

    // 1.5 bytes - head
    // 1.5 bytes - eyes
    // 1.5 bytes - mouth
    // 1.5 bytes - other
    // 1.5 bytes - other2 ---- 7.5  9.5

    // 1.5 bytes - head
    // 1.5 bytes - eyes
    // 1.5 bytes - mouth
    // 1.5 bytes - other
    // 1.5 bytes - other2 ---- 7.5  17

    // 1.5 bytes - head
    // 1.5 bytes - eyes
    // 1.5 bytes - mouth
    // 1.5 bytes - other
    // 1.5 bytes - other2 ---- 7.5  24.5

    // 1.5 bytes - head
    // 1.5 bytes - eyes
    // 1.5 bytes - mouth
    // 1.5 bytes - other
    // 1.5 bytes - other2 ---- 7.5  32
}
