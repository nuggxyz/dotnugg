// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './interfaces/IDotNugg.sol';
import './interfaces/IResolver.sol';

import './logic/Calculator.sol';
import './logic/Matrix.sol';
import './logic/Svg.sol';

import './v2/Merge.sol';

import './interfaces/IResolver.sol';
import './libraries/Base64.sol';

import './types/Version.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract DefaultResolver is IProcessResolver, IPostProcessResolver, IPreProcessResolver {
    // /**
    //  * @dev See {IERC165-supportsInterface}.
    //  */
    function supportsInterface(bytes4 interfaceId) public pure override(IProcessResolver, IPostProcessResolver, IPreProcessResolver) returns (bool) {
        return interfaceId == type(IProcessResolver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function preProcess(bytes memory data) public pure override returns (bytes memory res) {
        res = data;
    }

    function process(bytes memory data) public view override returns (bytes memory res) {
        (uint256[][] memory files) = abi.decode(data, ( uint256[][]));
        //
        Version.Memory[][] memory versions = Version.parse(files);

        // if (old) {
            IDotNugg.Matrix memory mat = Calculator.combine(8, 33, versions);
            Version.Memory memory result = Matrix.update(mat);
            return abi.encode( result.bigmatrix);
        // } else {
        //     Version.Memory memory result = Merge.begin(versions, 33);
        //     (uint256 width, uint256 height) = Version.getWidth(result);
        //     // return abi.encode(width, height, result.bigmatrix);
        //                 return abi.encode( result.bigmatrix);

        // // }
    }

    function postProcess(bytes memory data) public pure override returns (bytes memory res) {
        res = data;
        // ( uint256 width, uint256 height, uint256[] memory file) = abi.decode(data, ( uint256, uint256, uint256[]));
        // // // bytes memory rects = getSvgRects(matrix, 10);
        // // // '</svg>'
        // // res = Base64.encode(
        // //     bytes(
        // //         abi.encodePacked(
        // //             '{"name":"',
        // //             'NuggFT',
        // //             '","tokenId":"',
        // //             tokenId.toString(),
        // //             '","description":"',
        // //             'The Nuggiest FT',
        // //             '", "image": "',
        // //             Base64.encode(buildSvg(file, width, height), 'svg'),
        // //             '"}'
        // //         )
        // //     ),
        // //     'json'
        // // );

        // return Base64._encode(Svg.buildSvg(file, width, height));
    }

    // function nuggifyTest(
    //     uint256 width,
    //     uint256[][] memory _items,
    //     address _resolver,
    //     string memory name,
    //     string memory desc,
    //     uint256 tokenId,
    //     // bytes32 seed,
    //     bytes memory data
    // ) public view override returns (uint256[] memory image) {
    //     // IFileResolver fileResolver = IFileResolver(_resolver);
    //     // IColorResolver colorResolver = IColorResolver(_resolver);

    //     Version.Memory[][] memory versions = Version.parse(_items);

    //     IDotNugg.Matrix memory old = Calculator.combine(8, uint8(width), versions);

    //     Vers.Memory memory result = Matrix.update(old);

    //     return result.bigmatrix;
    // }

    // function nuggify2(
    //     uint256 width,
    //     uint256[][] memory _items,
    //     address _resolver,
    //     string memory name,
    //     string memory desc,
    //     uint256 tokenId,
    //     // bytes32 seed,
    //     bytes memory data
    // ) public view override returns (string memory image) {
    //     // IPreProcessResolver colorResolver = IPreProcessResolver(_resolver);

    //     IPostProcessResolver postProcesser = IPostProcessResolver(_resolver);

    //     Vers.Memory[][] memory versions = Vers.parse(_items);

    //     Vers.Memory memory result = Merge.begin(versions, width);

    //     return postProcesser.resolvePostProcess(tokenId, width, width, result.bigmatrix, data);
    // }

    // function nuggifyTest2(
    //     uint256 width,
    //     uint256[][] memory _items,
    //     address _resolver,
    //     string memory name,
    //     string memory desc,
    //     uint256 tokenId,
    //     // bytes32 seed,
    //     bytes memory data
    // ) public view override returns (uint256[] memory image) {
    //     // IFileResolver fileResolver = IFileResolver(_resolver);
    //     // IColorResolver colorResolver = IColorResolver(_resolver);

    //     Vers.Memory[][] memory versions = Vers.parse(_items);

    //     Vers.Memory memory result = Merge.begin(versions, width);

    //     return result.bigmatrix;
    // }
}
