// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {ERC721} from "solmate/tokens/ERC721.sol";

import {IDotnuggV1Storage} from "../../../dotnugg-v1-core/src/interfaces/IDotnuggV1Storage.sol";

contract DotnuggV1ERC721 is ERC721 {
    IDotnuggV1Storage public immutable proxy;

    constructor(
        string memory _name,
        string memory _symbol,
        IDotnuggV1Storage _proxy
    ) ERC721(_name, _symbol) {
        proxy = _proxy;
    }

    function tokenURI(uint256) public view override returns (string memory) {
        // return proxy.exec([1, 1, 1, 1, 1, 1, 1, 1], false);
    }
}
