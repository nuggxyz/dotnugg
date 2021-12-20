// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import './interfaces/IdotnuggV1.sol';

import './logic/Calculator.sol';
import './logic/Matrix.sol';
import './logic/Svg.sol';

import './libraries/Base64.sol';

import './types/Version.sol';

/// @title dotnugg Processor V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract dotnuggV1Processer is IdotnuggV1Processer {
    function process(uint256[][] memory files, bytes memory data) public view override returns (uint256[] memory resp) {
        (uint256 version, , , , , , uint8[] memory xovers, uint8[] memory yovers) = parseData(data);

        require(version == 1, 'V1');

        Version.Memory[][] memory versions = Version.parse(files);

        Types.Matrix memory old = Calculator.combine(8, 63, itemData, versions, xovers, yovers);

        resp = Version.bigMatrixWithData(old.version);
    }

    function resolveRaw(uint256[] memory file, bytes memory) public pure override returns (uint256[] memory res) {
        res = file;
    }

    function resolveBytes(uint256[] memory file, bytes memory data) public pure override returns (bytes memory res) {
        res = data;
    }

    function resolveString(uint256[] memory file, bytes memory data) public pure override returns (string memory res) {
        (uint256 version, , , , , , uint8[] memory xovers, uint8[] memory yovers) = parseData(data);

        uint256 width = (file[file.length - 1] >> 63) & ShiftLib.mask(6);
        uint256 height = (file[file.length - 1] >> 69) & ShiftLib.mask(6);

        res = Svg.buildSvg(file, width, height);

        res = Base64._encode(res);

        res = string(
            abi.encodePacked(
                Base64.PREFIX_JSON,
                Base64._encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            'NuggFT',
                            '","tokenId":"',
                            Uint256.toString(tokenId),
                            '","description":"',
                            'The Nuggiest FT',
                            '","itemData":"',
                            Uint256.toHexString(itemData, 32),
                            '","owner":"',
                            Uint256.toHexString(uint160(owner), 20),
                            '", "image": "',
                            Base64.PREFIX_SVG,
                            res,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function parseData(bytes memory data)
        internal
        returns (
            uint256 version,
            address sender,
            uint256 tokenId,
            uint256 proof,
            uint8[] memory ids,
            uint8[] memory extras,
            uint8[] memory xovers,
            uint8[] memory yovers
        )
    {
        (version, sender, tokenId, proof, ids, extras, xovers, yovers) = abi.decode(
            data,
            (uint256, address, uint256, uint256, uint8[], uint8[], uint8[], uint8[])
        );
    }
}
