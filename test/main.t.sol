// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "@dotnugg-v1-core/test/utils/forge.sol";

import "@dotnugg-v1-core/src/DotnuggV1.sol";

contract t is ForgeTest {
	IDotnuggV1 factory;

	constructor() {
		ds.setDsTest(address(this));
	}

	function reset() internal {
		factory = IDotnuggV1(address(new DotnuggV1()));
	}
}
