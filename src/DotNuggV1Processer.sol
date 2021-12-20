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
    function process(uint256[][] memory files, IdotnuggV1Data.Data memory data) public view override returns (uint256[] memory resp) {
        require(data.version == 1, 'V1');

        Version.Memory[][] memory versions = Version.parse(files, data.xovers, data.yovers);

        Types.Matrix memory old = Calculator.combine(8, 63, data.proof, versions);

        resp = Version.bigMatrixWithData(old.version);
    }

    function resolveRaw(uint256[] memory file, IdotnuggV1Data.Data memory) public pure override returns (uint256[] memory res) {
        res = file;
    }

    function resolveBytes(uint256[] memory file, IdotnuggV1Data.Data memory data) public pure override returns (bytes memory res) {
        res = abi.encode(file, data);
    }

    function resolveData(uint256[] memory, IdotnuggV1Data.Data memory data) public pure override returns (IdotnuggV1Data.Data memory res) {
        res = data;
    }

    function resolveString(uint256[] memory file, IdotnuggV1Data.Data memory data) public pure override returns (string memory) {
        uint256 width = (file[file.length - 1] >> 63) & ShiftLib.mask(6);
        uint256 height = (file[file.length - 1] >> 69) & ShiftLib.mask(6);

        bytes memory working = Svg.buildSvg(file, width, height);

        working = Base64._encode(working);

        working = abi.encodePacked(
            Base64.PREFIX_JSON,
            Base64._encode(
                bytes(
                    abi.encodePacked(
                        '{"name":"',
                        data.name,
                        '","description":"',
                        data.desc,
                        '","dotnuggVersion":"',
                        Uint256.toString(data.version),
                        '","tokenId":"',
                        Uint256.toString(data.tokenId),
                        '","proof":"',
                        Uint256.toHexString(data.proof, 32),
                        '","owner":"',
                        Uint256.toHexString(uint160(data.owner), 20),
                        '", "image": "',
                        Base64.PREFIX_SVG,
                        working,
                        '"}'
                    )
                )
            )
        );

        return string(working);
    }
}
