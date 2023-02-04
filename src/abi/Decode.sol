import "./Pointer.sol";

uint256 constant AlmostTwoWords = 0x3f;
uint256 constant OnlyFullWordMask = 0xffffe0;
uint256 constant array_8_uint8_tail_size = 256;

function abi_decode_dyn_array_bytes(CalldataPointer cdPtrLength) pure returns (MemoryPointer mPtrLength) {
	assembly {
		let arrLength := calldataload(cdPtrLength)
		mPtrLength := mload(0x40)
		mstore(mPtrLength, arrLength)
		let mPtrHead := add(mPtrLength, 32)
		let cdPtrHead := add(cdPtrLength, 32)
		let tailOffset := mul(arrLength, 0x20)
		let mPtrTail := add(mPtrHead, tailOffset)
		let totalOffset := tailOffset
		let isInvalid := 0
		for {
			let offset := 0
		} lt(offset, tailOffset) {
			offset := add(offset, 32)
		} {
			mstore(add(mPtrHead, offset), add(mPtrHead, totalOffset))
			let cdOffsetItemLength := calldataload(add(cdPtrHead, offset))
			isInvalid := or(isInvalid, xor(cdOffsetItemLength, totalOffset))
			let cdPtrItemLength := add(cdPtrHead, cdOffsetItemLength)
			let length := and(add(calldataload(cdPtrItemLength), AlmostTwoWords), OnlyFullWordMask)
			totalOffset := add(totalOffset, length)
		}
		if isInvalid {
			revert(0, 0)
		}
		calldatacopy(mPtrTail, add(cdPtrHead, tailOffset), sub(totalOffset, tailOffset))
		mstore(0x40, add(mPtrHead, totalOffset))
	}
}

function abi_decode_array_8_uint8(CalldataPointer cdPtr) pure returns (MemoryPointer mPtr) {
	mPtr = malloc(array_8_uint8_tail_size);
	cdPtr.copy(mPtr, array_8_uint8_tail_size);
}

function abi_decode_dyn_array_uint256(CalldataPointer cdPtrLength) pure returns (MemoryPointer mPtrLength) {
	unchecked {
		uint256 arrLength = cdPtrLength.readUint256();
		uint256 arrSize = (arrLength + 1) * 32;
		mPtrLength = malloc(arrSize);
		cdPtrLength.copy(mPtrLength, arrSize);
	}
}

function abi_decode_dyn_array_dyn_array_uint256(CalldataPointer cdPtrLength) pure returns (MemoryPointer mPtrLength) {
	assembly {
		let arrLength := calldataload(cdPtrLength)
		mPtrLength := mload(0x40)
		mstore(mPtrLength, arrLength)
		let mPtrHead := add(mPtrLength, 32)
		let cdPtrHead := add(cdPtrLength, 32)
		let tailOffset := mul(arrLength, 0x20)
		let mPtrTail := add(mPtrHead, tailOffset)
		let totalOffset := tailOffset
		let isInvalid := 0
		for {
			let offset := 0
		} lt(offset, tailOffset) {
			offset := add(offset, 32)
		} {
			mstore(add(mPtrHead, offset), add(mPtrHead, totalOffset))
			let cdOffsetItemLength := calldataload(add(cdPtrHead, offset))
			isInvalid := or(isInvalid, xor(cdOffsetItemLength, totalOffset))
			let cdPtrItemLength := add(cdPtrHead, cdOffsetItemLength)
			let length := mul(add(calldataload(cdPtrItemLength), 1), 0x20)
			totalOffset := add(totalOffset, length)
		}
		if isInvalid {
			revert(0, 0)
		}
		calldatacopy(mPtrTail, add(cdPtrHead, tailOffset), sub(totalOffset, tailOffset))
		mstore(0x40, add(mPtrHead, totalOffset))
	}
}

function abi_decode_bytes(CalldataPointer cdPtrLength) pure returns (MemoryPointer mPtrLength) {
	assembly {
		mPtrLength := mload(0x40)
		let size := and(add(calldataload(cdPtrLength), AlmostTwoWords), OnlyFullWordMask)
		calldatacopy(mPtrLength, cdPtrLength, size)
		mstore(0x40, add(mPtrLength, size))
	}
}

function to_dyn_array_bytes_ReturnType(function(CalldataPointer) internal pure returns (MemoryPointer) inFn)
	pure
	returns (function(CalldataPointer) internal pure returns (bytes[] memory) outFn)
{
	assembly {
		outFn := inFn
	}
}

function to_array_8_uint8_ReturnType(function(CalldataPointer) internal pure returns (MemoryPointer) inFn)
	pure
	returns (function(CalldataPointer) internal pure returns (uint8[8] memory) outFn)
{
	assembly {
		outFn := inFn
	}
}

function to_dyn_array_uint256_ReturnType(function(CalldataPointer) internal pure returns (MemoryPointer) inFn)
	pure
	returns (function(CalldataPointer) internal pure returns (uint256[] memory) outFn)
{
	assembly {
		outFn := inFn
	}
}

function to_dyn_array_dyn_array_uint256_ReturnType(function(CalldataPointer) internal pure returns (MemoryPointer) inFn)
	pure
	returns (function(CalldataPointer) internal pure returns (uint256[][] memory) outFn)
{
	assembly {
		outFn := inFn
	}
}

function to_bytes_ReturnType(function(CalldataPointer) internal pure returns (MemoryPointer) inFn)
	pure
	returns (function(CalldataPointer) internal pure returns (bytes memory) outFn)
{
	assembly {
		outFn := inFn
	}
}

function return_address(address proxy) pure {
	bytes memory returnData = abi.encode(proxy);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}

function return_dyn_array_dyn_array_uint256(uint256[][] memory _reads) pure {
	bytes memory returnData = abi.encode(_reads);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}

function return_tuple_dyn_array_uint256_uint256(uint256[] memory value0, uint256 value1) pure {
	bytes memory returnData = abi.encode(value0, value1);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}

function return_dyn_array_uint256(uint256[] memory _read) pure {
	bytes memory returnData = abi.encode(_read);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}

function return_string(string memory res) pure {
	bytes memory returnData = abi.encode(res);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}

function return_bytes(bytes memory res) pure {
	bytes memory returnData = abi.encode(res);
	assembly {
		return(add(returnData, 32), mload(returnData))
	}
}
