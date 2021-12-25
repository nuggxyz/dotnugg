// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import '../libraries/StringCastLib.sol';

import '../types/Pixel.sol';

import 'hardhat/console.sol';

library Event {
    function log(uint256 val, string memory name) internal view {
        console.log('-----------------------');
        console.log('variable: ', name);
        console.log('|', val, '=', StringCastLib.toHexString(val, 32));
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
        console.log(name0, val0, '|', StringCastLib.toHexString(val0, 32));
        console.log(name1, val1, '|', StringCastLib.toHexString(val1, 32));
        console.log(name2, val2, '|', StringCastLib.toHexString(val2, 32));
    }

    function log(
        uint256 val0,
        string memory name0,
        uint256 val1,
        string memory name1
    ) internal view {
        console.log('-----------------------');
        console.log(name0, val0, '|', StringCastLib.toHexString(val0, 32));
        console.log(name1, val1, '|', StringCastLib.toHexString(val1, 32));
    }

    function log(
        uint256 val0,
        string memory name0,
        uint256 val1,
        string memory name1,
        uint256 val2,
        string memory name2,
        uint256 val3,
        string memory name3
    ) internal view {
        console.log('-----------------------');
        console.log(name0, val0, '|', StringCastLib.toHexString(val0, 32));
        console.log(name1, val1, '|', StringCastLib.toHexString(val1, 32));
        console.log(name2, val2, '|', StringCastLib.toHexString(val2, 32));
        console.log(name3, val3, '|', StringCastLib.toHexString(val3, 32));
    }

    function pixLog(uint256[] memory arr, string memory name) internal view {
        console.log('--------------------');
        console.log('array: ', name);
        for (uint256 i = 0; i < arr.length; i++) {
            console.log(i, '|', StringCastLib.toHexString(Pixel.rgba(arr[i]), 4), StringCastLib.toHexString(arr[i], 10));
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
