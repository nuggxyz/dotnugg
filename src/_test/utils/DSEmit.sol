// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

library DSEmit {
    event log(string);
    event logs(bytes);

    event log_address(address);
    event log_bytes32(bytes32);
    event log_int(int256);
    event log_uint(uint256);
    event log_bytes(bytes);
    event log_string(string);

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    struct cp {
        string label;
        uint256 left;
    }

    function ptr() private pure returns (cp storage s) {
        assembly {
            s.slot := 0x432343243242342534
        }
    }

    function yep(string memory label, uint256 val) internal {
        emit log_named_bytes32(label, bytes32(val));
    }

    function yep(string memory label, bytes32 val) internal {
        emit log_named_bytes32(label, bytes32(val));
    }

    function startMeasuringGas(string memory label) internal {
        ptr().label = label;
        ptr().left = gasleft();
    }

    function stopMeasuringGas() internal {
        uint256 checkpointGasLeft2 = gasleft();

        emit log_named_uint(ptr().label, ptr().left - checkpointGasLeft2);
    }
}

//   B: 7582758
//   B2: 104837
//   C: 5392859
//   C: 849
//   1: encode: 25565
//   2: write: 154101
//   1: encode: 69413
//   2: write: 2556655
//   1: encode: 72677
//   2: write: 2550248
//   1: encode: 61761
//   2: write: 2095322
//   1: encode: 44971
//   2: write: 1480243
//   1: encode: 19029
//   2: write: 628162
//   1: encode: 14219
//   2: write: 468004
//   1: encode: 23290
//   2: write: 749883
//   C: 12061827
//   C: 47500
