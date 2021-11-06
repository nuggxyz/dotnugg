// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './logic/Decoder.sol';
import '../libraries/Base64.sol';
import './interfaces/IDotNugg.sol';
import './interfaces/INuggIn.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract DotNugg is IDotNugg {
    function nuggify(
        bytes calldata _collection,
        bytes[] calldata _items,
        address _resolver,
        uint256 _width
    ) external view override returns (string memory image) {
        INuggIn resolver = INuggIn(_resolver);

        require(resolver.supportsInterface(type(INuggIn).interfaceId), 'NUG:TURI:2');

        IDotNugg.Collection memory collection = Decoder.parseCollection(_collection);

        bytes[] memory selected = new bytes[](collection.featurelen); // + one for the base

        for (uint256 i = 0; i < _items.length; i++) {
            selected[Decoder.parseItemFeatureId(_items[i])] = _items[i];
        }
        for (uint256 i = 0; i < colleciton.defaults.length; i++) {
            if (check[collection.defaults[i].feature] == 0) selected[collection.defaults[i].feature] = collection.defaults[i];
        }

        Items[] memory parsed = Decoder.parseItems(selected);

        Item[] memory resolved = resolver.before(parsed);

        INuggIn.Display memory display = Combine.combine(resolved);

        bytes memory data = resolver.buildNugg(display, _width);

        image = Base64.encode(data, resolver.file());
    }
}
