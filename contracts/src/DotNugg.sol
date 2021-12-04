// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import './logic/Decoder.sol';
import './logic/Calculator.sol';

import './libraries/Base64.sol';
import './libraries/Uint.sol';

import './interfaces/IDotNugg.sol';
import './interfaces/IResolver.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract DotNugg is IDotNugg {
    using Uint256 for uint256;

    function nuggify(
        uint256 featureLen,
        uint256 width,
        uint256[][] memory _items,
        address _resolver,
        string memory name,
        string memory desc,
        uint256 tokenId,
        // bytes32 seed,
        bytes memory data
    ) public override returns (string memory image) {
        IFileResolver fileResolver = IFileResolver(_resolver);
        IColorResolver colorResolver = IColorResolver(_resolver);

        // require(fileResolver.supportsInterface(type(IFileResolver).interfaceId), 'NUG:TURI:2');

        // uint256 collection = Decoder.parseCollection(_collection);
        // emit log_named_uint('HERE2', collection);

        // bytes[] memory selected = new bytes[](8);

        // for (uint256 i = 0; i < _items.length; i++) {
        //     selected[Decoder.parseItemFeatureId(_items[i])] = _items[i];
        // }

        // for (uint256 i = 0; i < collection.defaults.length; i++) {
        //     uint8 featureId = Decoder.parseItemFeatureId(collection.defaults[i]);
        //     if (selected[featureId].length == 0) {
        //         selected[featureId] = collection.defaults[i];
        //     }
        // }

        MatrixType.Memory memory matrix = Calculator.combine(featureLen, width, _items);

        // if (colorResolver.supportsInterface(type(IColorResolver).interfaceId)) {
        //     colorResolver.resolveColor(matrix, data);
        // }
        (bytes memory fileData, string memory fileType) = fileResolver.resolveFile(matrix, data);

        image = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{"name":"',
                    name,
                    '","tokenId":"',
                    tokenId.toString(),
                    '","description":"',
                    desc,
                    '", "image": "',
                    Base64.encode(fileData, fileType),
                    '"}'
                )
            ),
            'json'
        );
        //   image = fileData.toAscii();
    }
}
