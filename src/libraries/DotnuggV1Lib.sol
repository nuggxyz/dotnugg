library DotnuggV1Lib {
    uint8 constant DOTNUGG_HEADER_BYTE_LEN = 25;

    uint8 constant DOTNUGG_RUNTIME_BYTE_LEN = 1;

    bytes18 internal constant PROXY_INIT_CODE = 0x69_36_3d_3d_36_3d_3d_37_f0_33_FF_3d_52_60_0a_60_16_f3;

    bytes32 internal constant PROXY_INIT_CODE_HASH = keccak256(abi.encodePacked(PROXY_INIT_CODE));

    function weights(address safe, uint8 feature) internal view returns (bytes memory res) {
        address loc = address(location(safe, feature));
        uint8 len = uint8(loc.code[DOTNUGG_RUNTIME_BYTE_LEN]);

        return readBytecode(loc, DOTNUGG_RUNTIME_BYTE_LEN + 1, len * 2);
    }

    function search(
        address safe,
        uint8 feature,
        uint256 seed
    ) internal view returns (uint8 res) {
        seed = uint256(keccak256(abi.encodePacked(seed, feature, address(this))));

        bytes memory w = weights(safe, feature);

        uint8 low = 0;

        uint8 high = uint8(uint16(w.length / 2) - 1);

        seed %= index16(w, high);

        uint8 selectedId;

        unchecked {
            // Binary search.
            while (low <= high) {
                uint8 mid = uint8((uint16(low) + uint16(high)) >> 1);
                if (index16(w, mid) <= seed) low = mid + 1;
                else if (mid == 0) return high + 1;
                else (selectedId, high) = (high, mid - 1);
            }
        }

        return selectedId + 1;
    }

    function index16(bytes memory input, uint8 ind) internal pure returns (uint16 res) {
        assembly {
            res := mload(add(add(input, 0x2), shl(1, ind)))
        }
    }

    function readBytecodeAsArray(
        address file,
        uint256 start,
        uint256 size
    ) private view returns (uint256[] memory data) {
        assembly {
            let offset := sub(0x20, mod(size, 0x20))

            let arrlen := add(0x01, div(size, 0x20))

            // Get a pointer to some free memory.
            data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to size and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            mstore(0x40, add(data, and(add(add(add(size, 32), offset), 31), not(31))))

            // Store the size of the data in the first 32 byte chunk of free memory.
            mstore(data, arrlen)

            // Copy the code into memory right after the 32 bytes we used to store the size.
            extcodecopy(file, add(add(data, 32), offset), start, size)
        }
    }

    function location(address registration, uint8 feature) internal pure returns (address) {
        bytes32 proxy = keccak256(
            abi.encodePacked(
                // Prefix:
                bytes1(0xFF),
                // Creator:
                registration,
                // Salt:
                uint256(feature),
                // Bytecode hash:
                PROXY_INIT_CODE_HASH
            )
        );

        proxy = keccak256(
            abi.encodePacked(
                // 0xd6 = 0xc0 (short RLP prefix) + 0x16 (length of: 0x94 ++ proxy ++ 0x01)
                // 0x94 = 0x80 + 0x14 (0x14 = the length of an address, 20 bytes, in hex)
                hex"d6_94",
                uint160(uint256(proxy)),
                hex"01" // Nonce of the proxy contract (1)
            )
        );

        return address(uint160(uint256(proxy)));
    }

    function readBytecode(
        address file,
        uint256 start,
        uint256 size
    ) private view returns (bytes memory data) {
        assembly {
            // Get a pointer to some free memory.
            data := mload(0x40)

            // Update the free memory pointer to prevent overriding our data.
            // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
            // Adding 31 to size and running the result through the logic above ensures
            // the memory pointer remains word-aligned, following the Solidity convention.
            mstore(0x40, add(data, and(add(add(size, 32), 31), not(31))))

            // Store the size of the data in the first 32 byte chunk of free memory.
            mstore(data, size)

            // Copy the code into memory right after the 32 bytes we used to store the size.
            extcodecopy(file, add(data, 32), start, size)
        }
    }
}
