// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../erc165/IERC165.sol';

interface IProcessResolver is IERC165 {
    function process(bytes memory data) external view returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IPreProcessResolver is IERC165 {
    function preProcess(bytes memory data) external pure returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IPostProcessResolver is IERC165 {
    function postProcess(bytes memory data) external view returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}
