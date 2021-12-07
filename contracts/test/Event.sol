// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../src/libraries/Uint.sol';
import '../../contracts/src/libraries/Uint.sol';

import 'hardhat/console.sol';

library Event {
    function log(uint256 val, string memory name) internal view {
        console.log('-----------------------');
        console.log('variable: ', name);
        console.log('|', val, '=', Uint256.toHexString(val, 32));
    }

    function log(
        uint256 val0,
        string memory name0,
        uint256 val1,
        string memory name1,
        uint256 val2,
        string memory name2
    ) internal view {
        console.log('-----------------------');
        console.log(name0, val0, '|', Uint256.toHexString(val0, 32));
        console.log(name1, val1, '|', Uint256.toHexString(val1, 32));
        console.log(name2, val2, '|', Uint256.toHexString(val2, 32));
    }

    function log(uint256[] memory arr, string memory name) internal view {
        console.log('--------------------');
        console.log('array: ', name);
        for (uint256 i = 0; i < arr.length; i++) {
            console.log('[', i, ']', Uint256.toHexString(arr[i], 32));
        }
    }
}

// library Event {
//     function log(uint256 val, string memory name) internal view {}

//     function log(
//         uint256 val0,
//         string memory name0,
//         uint256 val1,
//         string memory name1,
//         uint256 val2,
//         string memory name2
//     ) internal view {}

//     function log(uint256[] memory arr, string memory name) internal view {}
// }
