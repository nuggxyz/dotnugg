// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "../main.t.sol";

contract systemTest__two is t {
	function setUp() public {
		reset();
	}

	function test__gas__mask() public pure {
		assembly {
			let res := 0x81026004808483603a01903982513d8452809180519086801b90

			res := shr(96, shl(44, res))
		}
	}

	function test__gas__juke() public pure {
		assembly {
			let res := 0x81026004808483603a01903982513d8452809180519086801b90

			res := and(res, sub(shl(44, 1), 1))
		}
	}

	// }
	// pragma solidity 0.8.17;

	// // contains refs to hardhat console.sol and DSTest.sol contract
	// import '../utils/forge.sol';

	// contract test is t {

	struct Test {
		uint256 a;
		uint256 b;
		uint256 c;
	}

	mapping(uint256 => Test) tmp;

	function test__structStoragePointer() public {
		assembly {
			mstore(0x00, 0x4444)
			mstore(0x20, tmp.slot)

			let ptr := keccak256(0x00, 0x40)

			sstore(add(ptr, 0x00), 0xfff0)

			sstore(add(ptr, 0x01), 0xfff1)

			sstore(add(ptr, 0x02), 0xfff2)
		}

		console.log(tmp[0x4444].a);

		console.log(tmp[0x4444].b);

		console.log(tmp[0x4444].c);
	}
}
