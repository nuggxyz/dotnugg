// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Storage} from "./DotnuggV1Storage.sol";

import {IDotnuggV1Factory} from "./interfaces/IDotnuggV1Factory.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";

contract DotnuggV1Factory is IDotnuggV1Factory, DotnuggV1Storage {
    function register() external returns (IDotnuggV1Storage proxy) {
        require(address(this) == factory, "oooooops");

        proxy = deploy();

        proxy.init(msg.sender);
    }

    function deploy() internal returns (IDotnuggV1Storage instance) {
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
