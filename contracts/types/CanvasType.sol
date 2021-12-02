pragma solidity 0.8.10;

import '../libraries/Bytes.sol';
import '../interfaces/IDotNugg.sol';
import '../libraries/ShiftLib.sol';
import './PalletType.sol';
import './MatrixType.sol';
import './SudoArrayType.sol';

import '../test/Event.sol';

library CanvasType {
    using Event for uint256;

    using SudoArrayType for SudoArrayType.Memory;

    struct Memory {
        MatrixType.Memory matrix;
        SudoArrayType.Memory recs;
    }

    function canvas_receivers(Memory memory m, uint256 index) internal returns (uint256 res) {
        require(index < 8, 'CT:R:0');
        res = m.recs.pull(16, 0, index);
    }

    function canvas_receivers(
        Memory memory m,
        uint256 index,
        uint256 update
    ) internal {
        index.log('canvas_receivers:index');
        require(index < 8, 'CT:R:1');
        m.recs.push(16, 0, index, update);
    }
}
