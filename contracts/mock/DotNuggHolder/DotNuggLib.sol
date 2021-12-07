// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './ItemLib.sol';
import '../../src/libraries/ShiftLib.sol';
import '../types/ItemType.sol';
import '../types/LengthType.sol';
// import '../../test/Console.sol';
import '../../src/interfaces/IResolver.sol';

library DotNuggLib {
    using ItemType for uint256;
    using LengthType for uint256;
    using Event for uint256;
    using Event for uint256[];

    struct Storage {
        uint256[] collection;
        mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) items;
        uint256 lengths;
        mapping(uint256 => address) resolvers;
    }

    // function generateTokenURIDefaultResolver(
    //     Storage storage s,
    //     ItemLib.Storage storage item_storage,
    //     address dotnugg,
    //     uint256 tokenId,
    //     address defaultResolver
    // ) internal view returns (string memory) {
    //     address res = s.resolvers[tokenId];
    //     if (res != address(0)) defaultResolver = res;
    //     return generateTokenURI(s, item_storage, dotnugg, tokenId, defaultResolver);
    // }

    function addItems(Storage storage s, uint256[][] calldata data) internal {
        uint256 lengths = s.lengths;

        for (uint256 i = 0; i < data.length; i++) {
            uint256 itemType = (data[i][data[i].length - 1] >> 32) & 0x7;

            itemType.log('itemType');

            uint256 len = lengths.length(itemType);

            for (uint256 j = 0; j < data[i].length; j++) {
                s.items[itemType][len][j] = data[i][j];
            }
            len++;

            lengths = lengths.length(itemType, len);
        }
        s.lengths = lengths;
    }

    /**
     * @notice calcualtes the token uri for a given epoch
     */
    function getData(
        Storage storage s,
        ItemLib.Storage storage item_storage,
        uint256 tokenId
    ) internal view returns (uint256[][] memory res, uint256 itemData) {
        itemData = item_storage.tokenData[tokenId];

        res = new uint256[][](3);

        res[0] = loadItem(s, 0, itemData.base());
        res[1] = loadItem(s, 1, itemData.item(1, 0));
        res[2] = loadItem(s, 4, itemData.item(4, 0));
        // data[3] = loadItem(s, 3, item_memory.item(ItemType.Index.MOUTH, 0));
        // data[4] = loadItem(s, 4, item_memory.item(ItemType.Index.OTHER, 0));
        // data[5] = loadItem(s, 5, item_memory.item(ItemType.Index.SPECIAL, 0));
        // IDotNugg(dotnugg).nuggify(33, data, resolver, uriname, descrription, tokenId, '');
        // string memory uriname = 'NuggFT {#}';
        // string memory descrription = 'the description';
    }

    function loadItem(
        Storage storage s,
        uint8 itemType,
        uint256 id
    ) internal view returns (uint256[] memory data) {
        data = new uint256[](10);

        uint256 i;
        uint256 tmp;

        for (i = 0; (tmp = s.items[itemType][id][i]) != 0; i++) {
            data[i + 1] = tmp;
        }

        data[0] = i;

        data.log('data');
    }
}
