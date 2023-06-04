// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import {ERC721} from "./solmate/ERC721.sol";

import {DotnuggV1} from "git.nugg.xyz/dotnugg/src/DotnuggV1.sol";
import {DotnuggV1Lib} from "git.nugg.xyz/dotnugg/src/DotnuggV1Lib.sol";

/// this example implements rari-capital/solmate's ERC721
contract DotnuggV1ERC721 is ERC721 {
	DotnuggV1 public immutable safe;

	uint256 constant MAX_TOKENS = 10000;

	uint256 immutable globalSeed;

	constructor(
		string memory _name,
		string memory _symbol,
		DotnuggV1 _safe
	) ERC721(_name, _symbol) {
		safe = _safe;

		/// Generates a pseudo-random number to be cached for deterministic seed generation
		globalSeed = uint256(
			keccak256(
				abi.encodePacked(
					msg.sender,
					blockhash(block.number - 1),
					block.difficulty //
				)
			)
		);
	}

	function tokenURI(uint256 tokenId) public view override returns (string memory) {
		require(tokenId <= MAX_TOKENS && tokenId != 0, "");

		uint256 seed = generateDeterministicRandomNumber(tokenId);

		return
			safe.exec(
				[
					DotnuggV1Lib.search(safe, 0, seed),
					DotnuggV1Lib.search(safe, 1, seed),
					DotnuggV1Lib.search(safe, 2, seed),
					DotnuggV1Lib.search(safe, 3, seed),
					DotnuggV1Lib.search(safe, 4, seed),
					DotnuggV1Lib.search(safe, 5, seed),
					DotnuggV1Lib.search(safe, 6, seed),
					DotnuggV1Lib.search(safe, 7, seed)
				],
				false
			);
	}

	/// @notice Generates a pseudo-random number with parameters that is hard for one entity to
	/// reasonably control
	/// @param _nonce A nonce hashed as part of the pseudo-random generation.
	/// @return A pseudo-random uint256.
	function generateDeterministicRandomNumber(uint256 _nonce) internal view returns (uint256) {
		return
			uint256(
				keccak256(
					abi.encodePacked(
						globalSeed,
						_nonce
						//
					)
				)
			);
	}
}
