// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './libraries/Base64.sol';
import './libraries/Uint.sol';

import './types/Version.sol';
import './logic/Merge.sol';

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
    ) public view override returns (string memory image) {
        IFileResolver fileResolver = IFileResolver(_resolver);
        IColorResolver colorResolver = IColorResolver(_resolver);

        Version.Memory[][] memory versions = Version.parse(_items);

        Merge.begin(versions, width);

        // MatrixType.Memory memory matrix = Calculator.combine(featureLen, width, _items);

        (bytes memory fileData, string memory fileType) = fileResolver.resolveFile(versions[0][0], data);

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

    function nuggifyTest(
        uint256 featureLen,
        uint256 width,
        uint256[][] memory _items,
        address _resolver,
        string memory name,
        string memory desc,
        uint256 tokenId,
        // bytes32 seed,
        bytes memory data
    ) public view override returns (uint256[] memory image) {
        IFileResolver fileResolver = IFileResolver(_resolver);
        IColorResolver colorResolver = IColorResolver(_resolver);

        Version.Memory[][] memory versions = Version.parse(_items);

        return Merge.begin(versions, width).bigmatrix;

        // MatrixType.Memory memory matrix = Calculator.combine(featureLen, width, _items);

        // (bytes memory fileData, string memory fileType) = fileResolver.resolveFile(versions[0][0], data);

        // image = Base64.encode(
        //     bytes(
        //         abi.encodePacked(
        //             '{"name":"',
        //             name,
        //             '","tokenId":"',
        //             tokenId.toString(),
        //             '","description":"',
        //             desc,
        //             '", "image": "',
        //             Base64.encode(fileData, fileType),
        //             '"}'
        //         )
        //     ),
        //     'json'
        // );
        //   image = fileData.toAscii();
    }
}
