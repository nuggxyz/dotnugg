// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// import 'hardhat/console.sol';
import '../src/libraries/Uint.sol';

library Event {
    // function chop(
    //     uint256[] memory input,
    //     // uint256 b,
    //     uint256 bstart,
    //     uint256 bend
    // ) internal  returns (uint256[] memory output) {
    //     // require(pos <= input.length * 256, 'SL:B4:0');
    //     res = bit(input[pos / 256], b, pos % 256);
    // }

    // event log(string);
    // event logs(bytes);

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

    function log(uint256 val, string memory name) internal view {
        // console.log('-----------------------');
        // console.log('variable: ', name);
        // console.log('|', val, '=', Uint256.toHexString(val, 32));
    }

    function log(
        uint256 val0,
        string memory name0,
        uint256 val1,
        string memory name1,
        uint256 val2,
        string memory name2
    ) internal view {
        // console.log('-----------------------');
        // console.log(name0, val0, '|', Uint256.toHexString(val0, 32));
        // console.log(name1, val1, '|', Uint256.toHexString(val1, 32));
        // console.log(name2, val2, '|', Uint256.toHexString(val2, 32));
    }

    function log(uint256[] memory arr, string memory name) internal view {
        // console.log('--------------------');
        // console.log('array: ', name);
        // for (uint256 i = 0; i < arr.length; i++) {
        //     console.log('[', i, ']', Uint256.toHexString(arr[i], 32));
        // }
    }
}
