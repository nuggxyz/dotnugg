// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import {IDotnuggV1} from "./interfaces/IDotnuggV1.sol";

import {IDotnuggV1Safe} from "./interfaces/IDotnuggV1Safe.sol";

import {DotnuggV1Safe} from "./DotnuggV1Safe.sol";

contract DotnuggV1 is IDotnuggV1, DotnuggV1Safe {
    function register(bytes[] calldata input) external returns (IDotnuggV1Safe proxy) {
        require(address(this) == factory, "oooooops");

        proxy = deploy();

        proxy.init(input);
    }

    function deploy() internal returns (IDotnuggV1Safe instance) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, address()))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create(0, ptr, 0x37)
        }
        require(address(instance) != address(0), "ERC1167: create2 failed");
    }
}
