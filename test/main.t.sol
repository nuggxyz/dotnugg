// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "git.nugg.xyz/dotnugg/test/utils/forge.sol";

import "git.nugg.xyz/dotnugg/src/DotnuggV1.sol";

contract t is ForgeTest {
	IDotnuggV1 factory;

	constructor() {
		ds.setDsTest(address(this));
	}

	function reset() internal {
		factory = IDotnuggV1(address(new DotnuggV1()));
	}
}
