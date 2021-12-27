// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DSTest} from '../../../lib/ds-test/src/test.sol';

import {Hevm, ForgeVm} from './Vm.sol';

contract DSTestPlus is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    ForgeVm internal constant fvm = ForgeVm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    address internal constant DEAD_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;

    modifier changeInBalance96(address target, int192 change) {
        int256 before_staked = int192(int256(uint256(target.balance)));
        _;
        int256 after_staked = int192(int256(uint256(target.balance)));

        assertEq(after_staked - before_staked, change, 'user balance did not change');
    }

    bytes32 checkpointLabel;
    uint256 private checkpointGasLeft;

    function startMeasuringGas(bytes32 label) internal virtual {
        checkpointLabel = label;
        checkpointGasLeft = gasleft();
    }

    function stopMeasuringGas() internal virtual {
        uint256 checkpointGasLeft2 = gasleft();

        bytes32 label = checkpointLabel;

        emit log_named_uint(string(abi.encodePacked(label, ' Gas')), checkpointGasLeft - checkpointGasLeft2 - 22134);
    }

    function fail(bytes32 err) internal virtual {
        emit log_named_string('Error', string(abi.encodePacked(err)));
        fail();
    }

    function assertFalse(bool data) internal virtual {
        assertTrue(!data);
    }

    function assertBytesEq(bytes memory a, bytes memory b) internal virtual {
        if (keccak256(a) != keccak256(b)) {
            emit log('Error: a == b not satisfied [bytes]');
            emit log_named_bytes('  Expected', b);
            emit log_named_bytes('    Actual', a);
            fail();
        }
    }

    function assertArrayEq(uint256[] memory a, uint256[] memory b) internal virtual {
        if (a.length != b.length) {
            emit log('Error: a == b not satisfied [uint256[]]');
            emit log_named_uint('  Expected length', b.length);
            emit log_named_uint('    Actual length', a.length);
            fail();
            return;
        }

        bool ok = true;
        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                ok = false;
                emit log_named_uint('Error: a == b not satisfied [bytes256[i]]: i = ', i);
                emit log_named_bytes32('  Expected', bytes32(b[i]));
                emit log_named_bytes32('    Actual', bytes32(a[i]));
            }
        }

        if (!ok) fail();
    }
}

contract DSInvariantTest {
    address[] private targets;

    function targetContracts() public view virtual returns (address[] memory) {
        require(targets.length > 0, 'NO_TARGET_CONTRACTS');

        return targets;
    }

    function addTargetContract(address newTargetContract) internal virtual {
        targets.push(newTargetContract);
    }
}
