// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.13;

import {ERC721} from "@rari-capital/solmate/tokens/ERC721.sol";

import {IDotnuggV1Safe} from "../interfaces/IDotnuggV1Safe.sol";

contract DotnuggV1ERC721 is ERC721 {
    IDotnuggV1Safe public immutable safe;

    struct Metadata {
        uint8 _0;
        uint8 _1;
        uint8 _2;
        uint8 _3;
        uint8 _4;
        uint8 _5;
        uint8 _6;
        uint8 _7;
    }

    Metadata public traitTotals;

    mapping(uint256 => Metadata) traits;

    constructor(
        string memory _name,
        string memory _symbol,
        IDotnuggV1Safe _safe
    ) ERC721(_name, _symbol) {
        safe = _safe;

        traitTotals = Metadata({
            _0: safe.lengthOf(1),
            _1: safe.lengthOf(1),
            _2: safe.lengthOf(1),
            _3: safe.lengthOf(1),
            _4: safe.lengthOf(1),
            _5: safe.lengthOf(1),
            _6: safe.lengthOf(1),
            _7: safe.lengthOf(1)
        });
    }

    function mint() public payable {
        uint8[8] memory working;

        // dotnuggIds[0] = safe.pack(traits);
    }

    function tokenURI(uint256) public view override returns (string memory) {
        return safe.exec([1, 1, 1, 1, 1, 1, 1, 1], false);
    }

    /// @notice Generates a pseudo-random number with parameters that is hard for one entity to
    /// reasonably control.
    /// @param _nonce A nonce hashed as part of the pseudo-random generation.
    /// @return A pseudo-random uint256.
    function generateRandomNumber(uint256 _nonce) internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        msg.sender,
                        block.difficulty,
                        _nonce
                        //
                    )
                )
            );
    }
}
