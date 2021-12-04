// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../erc165/IERC165.sol';

import '../types/MatrixType.sol';

interface IColorResolver is IERC165 {
    function resolveColor(MatrixType.Memory memory matrix, bytes memory data) external returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IFileResolver is IERC165 {
    function resolveFile(MatrixType.Memory memory matrix, bytes memory data) external returns (bytes memory, string memory fileType);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}
