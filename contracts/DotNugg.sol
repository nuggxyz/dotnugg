// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './logic/Decoder.sol';
import './logic/Calculator.sol';

import './libraries/Base64.sol';
import './interfaces/IDotNugg.sol';
import './interfaces/INuggIn.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract DotNugg is IDotNugg {
    using Calculator for IDotNugg.Collection;

    function nuggify(
        bytes memory _collection,
        bytes[] memory _items,
        address _resolver,
        bytes memory data
    ) public view override returns (string memory image) {
        //   IFileResolver fileResolver = IFileResolver(_resolver);
        //   IColorResolver colorResolver = IColorResolver(_resolver);

        //   require(fileResolver.supportsInterface(type(IFileResolver).interfaceId), 'NUG:TURI:2');

        IDotNugg.Collection memory collection = Decoder.parseCollection(_collection);

        bytes[] memory selected = new bytes[](collection.numFeatures);

        for (uint256 i = 0; i < _items.length; i++) {
            selected[Decoder.parseItemFeatureId(_items[i])] = _items[i];
        }

        for (uint256 i = 0; i < collection.defaults.length; i++) {
            uint8 featureId = Decoder.parseItemFeatureId(collection.defaults[i]);
            if (selected[featureId].length == 0) {
                selected[featureId] = collection.defaults[i];
            }
        }

        IDotNugg.Matrix memory matrix = collection.combine(selected);

        //   if (colorResolver.supportsInterface(type(IColorResolver).interfaceId)) {
        //       colorResolver.resolveColor(matrix, data);
        //   }
        //   (bytes memory fileData, string memory fileType) = fileResolver.resolveFile(matrix, data);

        //   image = Base64.encode(fileData, fileType);
    }
}
