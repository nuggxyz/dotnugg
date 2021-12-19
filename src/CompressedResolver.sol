// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import './interfaces/IResolver.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract CompressedResolver is INuggFtProcessor {
    function process(
        uint256[][] memory files,
        bytes memory data,
        bytes memory preProcessorData
    ) public view override returns (uint256[] memory resp) {
        return processor.process(files, data, preProcessorData);
    }

    function postProcess(
        uint256[] memory file,
        bytes memory,
        bytes memory
    ) public pure override returns (bytes memory res) {
        res = abi.encode(file);
    }
}
