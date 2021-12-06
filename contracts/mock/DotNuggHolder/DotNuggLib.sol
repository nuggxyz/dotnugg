// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import './ItemLib.sol';
import '../../src/libraries/ShiftLib.sol';
import '../types/ItemType.sol';
import '../types/LengthType.sol';
// import '../../test/Console.sol';
import '../../src/interfaces/IDotNugg.sol';

library DotNuggLib {
    using ItemType for uint256;
    using LengthType for uint256;
    using Event for uint256;

    struct Storage {
        uint256[] collection;
        mapping(uint256 => uint256) items;
        uint256 lengths;
        mapping(uint256 => address) resolvers;
    }

    function generateTokenURIDefaultResolver(
        Storage storage s,
        ItemLib.Storage storage item_storage,
        address dotnugg,
        uint256 tokenId,
        address defaultResolver
    ) internal view returns (string memory) {
        address res = s.resolvers[tokenId];
        if (res != address(0)) defaultResolver = res;
        return generateTokenURI(s, item_storage, dotnugg, tokenId, defaultResolver);
    }

    /**
     * @notice calcualtes the token uri for a given epoch
     */
    function generateTokenURI(
        Storage storage s,
        ItemLib.Storage storage item_storage,
        address dotnugg,
        uint256 tokenId,
        address resolver
    ) internal view returns (string memory) {
        uint256 item_memory = item_storage.tokenData[tokenId];
        uint256[][] memory data = new uint256[][](3);

        data[0] = loadItem(s, 0, item_memory.base());
        data[1] = loadItem(s, 1, item_memory.item(1, 0));
        data[2] = loadItem(s, 3, item_memory.item(3, 0));
        // data[3] = loadItem(s, 3, item_memory.item(ItemType.Index.MOUTH, 0));
        // data[4] = loadItem(s, 4, item_memory.item(ItemType.Index.OTHER, 0));
        // data[5] = loadItem(s, 5, item_memory.item(ItemType.Index.SPECIAL, 0));

        string memory uriname = 'NuggFT {#}';
        string memory descrription = 'the description';

        return IDotNugg(dotnugg).nuggify(33, data, resolver, uriname, descrription, tokenId, '');
    }

    function generateTokenURITest(
        Storage storage s,
        ItemLib.Storage storage item_storage,
        address dotnugg,
        uint256 tokenId,
        address resolver
    ) internal view returns (uint256[] memory res) {
        uint256 item_memory = item_storage.tokenData[tokenId];
        uint256[][] memory data = new uint256[][](2);

        data[0] = loadItem(s, 0, item_memory.base());
        // data[1] = loadItem(s, 5, item_memory.item(5, 0));
        data[1] = loadItem(s, 1, item_memory.item(1, 0));
        // data[3] = loadItem(s, 3, item_memory.item(ItemType.Index.MOUTH, 0));
        // data[4] = loadItem(s, 4, item_memory.item(ItemType.Index.OTHER, 0));
        // data[5] = loadItem(s, 5, item_memory.item(ItemType.Index.SPECIAL, 0));

        string memory uriname = 'NuggFT {#}';
        string memory descrription = 'the description';

        return IDotNugg(dotnugg).nuggifyTest(33, data, resolver, uriname, descrription, tokenId, '');
    }

    // 50/50 chance of main  being 0

    // 5 le

    //

    function addItems(Storage storage s, uint256[][] calldata data) internal {
        uint256 lengths = s.lengths;

        for (uint256 i = 0; i < data.length; i++) {
            uint256 itemType = (data[i][data[i].length - 1] >> 32) & 0x7;
            // console.log('type:', itemType);
            uint256 len = lengths.length(itemType);

            uint256 itemtypebytes = uint256(itemType) << 96;
            uint256 check = uint256(data[i][0]);
            assembly {
                check := and(check, not(0xff))
            }
            s.items[itemtypebytes | len++] = data[i][0];
            for (uint256 j = 1; j < data[i].length; j++) {
                s.items[check | j] = data[i][j];
            }
            lengths = lengths.length(itemType, len);
        }
        s.lengths = lengths;
    }

    function loadItem(
        Storage storage s,
        uint8 itemType,
        uint256 id
    ) internal view returns (uint256[] memory data) {
        // console.log('here', id);

        data = new uint256[](10);
        data[1] = s.items[(uint256(itemType) << 96) | id];
        uint256 tmp = data[1];
        uint256 check = uint256(tmp);
        assembly {
            check := and(check, not(0xff))
        }
        uint256 i;

        for (i = 1; (tmp = s.items[(check) | i]) != 0; i++) {
            data[i + 1] = tmp;
        }
        data[0] = i;
    }
}
