// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './logic/Calculator.sol';
import {Matrix as MatrixLib} from './logic/Matrix.sol';

import './libraries/Base64.sol';
import './interfaces/IDotNugg.sol';
import './interfaces/INuggIn.sol';
import {Version as Vers} from './types/Version.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract DotNugg2ElectricBoogaloo is IDotNugg {
    using Bytes for bytes;
    using Uint256 for uint256;

    function nuggify(
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

        Vers.Memory[][] memory versions = Vers.parse(_items);

        // Calculator.combine(versions, width);

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

    function nuggifyTest(
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

        Vers.Memory[][] memory versions = Vers.parse(_items);

        IDotNugg.Matrix memory old = Calculator.combine(8, uint8(width), versions);

        Vers.Memory memory result = MatrixLib.update(old);

        return result.bigmatrix;

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
