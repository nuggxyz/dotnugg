// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Storage} from "./DotnuggV1Storage.sol";
import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";

import {IDotnuggV1ImplementerWithCallback} from "./interfaces/IDotnuggV1Implementer.sol";

/// @title dotnugg V1 - onchain encoder/decoder protocol for dotnugg files
/// @author nugg.xyz - danny7even & dub6ix
/// @notice yoU CAN'T HaVe ImAgES oN THe BlOCkcHAIn
/// @dev hold my margarita
contract DotnuggV1Factory is DotnuggV1Resolver {
    DotnuggV1Storage public immutable template;

    constructor() {
        template = new DotnuggV1Storage();
    }

    function register(address trusted, string[8] memory labels) external returns (IDotnuggV1Storage proxy) {
        proxy = deploy(msg.sender);

        proxy.init(msg.sender, labels, trusted);
    }

    function proxyOf(address implementer) public view returns (IDotnuggV1Storage proxy) {
        proxy = compute(implementer);

        require(address(proxy).code.length != 0, "P:0");
    }

    function rawWithCallback(address implementer, uint256 artifactId) public view returns (uint256[][8] memory res) {
        try IDotnuggV1ImplementerWithCallback(implementer).dotnuggV1Callback(artifactId, msg.sender) returns (
            uint8[8] memory ids
        ) {
            res = raw(implementer, ids);
        } catch {
            revert("implementer does not support callback");
        }
    }

    function raw(address implementer, uint8[8] memory ids) public view returns (uint256[][8] memory res) {
        res = proxyOf(implementer).read(ids);
    }

    function raw(
        address implementer,
        uint8 feature,
        uint8 pos
    ) public view returns (uint256[] memory res) {
        res = proxyOf(implementer).read(feature, pos);
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function deploy(address implementer) internal returns (IDotnuggV1Storage instance) {
        DotnuggV1Storage base = template;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, base))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            instance := create2(0, ptr, 0x37, implementer)
        }
        require(address(instance) != address(0), "ERC1167: create2 failed");
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function compute(address implementer) public view returns (IDotnuggV1Storage predicted) {
        DotnuggV1Storage base = template;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, base))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
            mstore(add(ptr, 0x38), shl(0x60, address()))
            mstore(add(ptr, 0x4c), implementer)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }
}
