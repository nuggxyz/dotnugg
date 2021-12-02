pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';
import './MatrixType.sol';
import './SudoArrayType.sol';
import './ContentType.sol';
import './CanvasType.sol';
import './ItemType.sol';

library CollectionType {
    using ShiftLib for uint256;

    struct Memory {
        ItemType.Memory[] items;
        uint256 info;
    }

    function collection_width(uint256 input) internal returns (uint256 res) {
        res = input.bit(8, 0);
    }

    function collection_width(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(8, 0, update);
    }

    function collection_height(uint256 input) internal returns (uint256 res) {
        res = input.bit(8, 16);
    }

    function collection_height(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(8, 16, update);
    }

    function collection_numfeatures(uint256 input) internal returns (uint256 res) {
        res = input.bit(8, 24);
    }

    function collection_numfeatures(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(8, 24, update);
    }
}
