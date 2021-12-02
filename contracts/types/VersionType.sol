pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';
import './MatrixType.sol';
import './SudoArrayType.sol';
import './ContentType.sol';
import '../test/Event.sol';

library VersionType {
    using ShiftLib for uint256;
    using PalletType for uint256[];
    using Event for uint256;

    using SudoArrayType for SudoArrayType.Memory;

    struct Memory {
        bytes content;
        uint256 info;
        SudoArrayType.Memory recs;
    }

    function version_anchor(uint256 input) internal returns (uint256 res) {
        res = input.bit(32, 0);
    }

    function version_anchor(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(32, 0, update);
    }

    function version_expanders(uint256 input) internal returns (uint256 res) {
        res = input.bit(32, 32);
    }

    function version_expanders(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(32, 32, update);
    }

    function version_width(uint256 input) internal returns (uint256 res) {
        res = input.bit(8, 64);
    }

    function version_width(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(8, 64, update);
    }

    function version_height(uint256 input) internal returns (uint256 res) {
        res = input.bit(8, 72);
    }

    function version_height(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(8, 72, update);
    }

    function version_contentStart(uint256 input) internal returns (uint256 res) {
        res = input.bit(16, 80);
    }

    function version_contentStart(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(16, 80, update);
    }

    function version_feature(uint256 input) internal returns (uint256 res) {
        res = input.bit(32, 0);
    }

    function version_feature(uint256 input, uint256 update) internal returns (uint256 res) {
        res = input.bit(32, 0, update);
    }

    // function conentEnd(Memory memory m) internal  returns (uint256 res) {
    //     res = m.info.bit(16, 96);
    // }

    // function conentEnd(Memory memory m, uint256 update) internal  returns (uint256 res) {
    //     res = m.info.bit(16, 96, update);
    // }

    function calcrec(Memory memory m, uint256 index) internal returns (uint256 res) {
        require(index < 8, 'VT:CR:0');
        res = m.recs.pull(16, 128, index);
    }

    function calcrec(
        Memory memory m,
        uint256 index,
        uint256 update
    ) internal {
        index.log('VERSION:INDEX');
        require(index < 8, 'VT:CR:1');
        m.recs.push(16, 128, index, update);
    }

    function staticrec(Memory memory m, uint256 index) internal returns (uint256 res) {
        require(index < 8, 'VT:SR:0');
        res = m.recs.pull(16, 0, index);
    }

    function staticrec(
        Memory memory m,
        uint256 index,
        uint256 update
    ) internal {
        require(index < 8, 'VT:SR:1');
        m.recs.push(16, 0, index, update);
    }
}
