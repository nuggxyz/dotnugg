// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './interfaces/IResolver.sol';

/**
 * @title DotNugg V1 - onchain encoder/decoder for dotnugg files
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
 * @dev hold my margarita
 */
contract CompressedResolver is INuggFtProcessor {
    IPostProcessResolver public immutable override postProcessor;

    IProcessResolver public immutable override processor;

    IPreProcessResolver public immutable override preProcessor;

    constructor(address _preProcessor, address _processor) {
        postProcessor = IPostProcessResolver(address(this));
        preProcessor = IPreProcessResolver(_preProcessor);
        processor = IProcessResolver(_processor);
    }

    function preProcess(bytes memory data) public view override returns (bytes memory _res) {
        return preProcessor.preProcess(data);
    }

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

    function supportsInterface(bytes4 interfaceId) public pure override(INuggFtProcessor) returns (bool) {
        return
            interfaceId == type(IPostProcessResolver).interfaceId ||
            interfaceId == type(INuggFtProcessor).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }
}
