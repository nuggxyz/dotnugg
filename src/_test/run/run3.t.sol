// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.14;

import "../utils/forge.sol";

contract runner {
    struct Test {
        uint256 a;
        uint256 b;
        uint256 c;
    }

    function run() external {
        Test storage s;

        // prettier-ignore
        assembly {

            let ptr := "my random storage pointer"
            s.slot := ptr

            mstore(0x20, ptr)

            sstore(add(ptr, 0x00), 0xfff0)

            sstore(add(ptr, 0x01), 0xfff1)

            sstore(add(ptr, 0x02), 0xfff2)
        }

        console.log(s.a);

        console.log(s.b);

        console.log(s.c);
    }
}
