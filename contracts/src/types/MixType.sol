// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';
import './MatrixType.sol';
import './SudoArrayType.sol';
import './ContentType.sol';
import './CanvasType.sol';
import './VersionType.sol';

library MixType {
    // using ShiftLib for uint256;
    // using PalletType for uint256[];

    struct Memory {
        CanvasType.Memory canvas;
        VersionType.Memory version;
    }
}
