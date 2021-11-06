// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../../erc165/IERC165.sol';
import './IDotNugg.sol';

interface IColorResolver is IERC165 {
    function resolve(IDotNugg.Matrix memory matrix, bytes memory data) external view returns (IDotNugg.Matrix memory res);
}
