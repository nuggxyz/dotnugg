// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

library String {
    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function fromUint256(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return '0';
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    //  function concat(
    //      string memory _a,
    //      string memory _b,
    //      string memory _c,
    //      string memory _d,
    //      string memory _e,
    //      string memory _f,
    //      string memory _g,
    //      string memory _h
    //  ) internal pure returns (string memory) {
    //      return string(abi.encodePacked(_a, _b, _c, _d, _e, _f, _g, _h));
    //  }

    function concat(string memory _a, string memory _b) internal pure returns (string memory) {
        return concat(_a, _b, '', '', '', '', '', '');
    }

    function concat(
        string memory _a,
        string memory _b,
        string memory _c
    ) internal pure returns (string memory) {
        return concat(_a, _b, _c, '', '', '', '', '');
    }

    function concat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    ) internal pure returns (string memory) {
        return concat(_a, _b, _c, _d, '', '', '', '');
    }

    function concat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d,
        string memory _e,
        string memory _f,
        string memory _g,
        string memory _h
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_a, ' ', _b, ' ', _c, ' ', _d, ' ', _e, ' ', _f, ' ', _g, ' ', _h));
    }
}
