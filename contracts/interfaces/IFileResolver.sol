// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../../erc165/IERC165.sol';
import './IDotNugg.sol';

interface IFileResolver is IERC165 {
    function resolveFile(IDotNugg.Matrix memory matrix, bytes memory data) external view returns (bytes memory res, string memory fileType);
}
