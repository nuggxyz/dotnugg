pragma solidity 0.8.10;

// import 'hardhat/console.sol';

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

    function log(uint256 val, string memory name) internal {
        emit log_string('-----------------------');
        emit log_string(name);
        emit log_named_uint('uint256', val);
        emit log_named_bytes32('bytes32', bytes32(val));
    }

    function log(uint256 val) internal {
        log(val, 'unnamed');
    }
}
