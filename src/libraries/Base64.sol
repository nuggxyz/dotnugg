// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.13;

/**
 * @title Base64
 * @author Nugg Labs - @danny7even & @dub6ix
 * @notice library for encoding bytes into base64
 */
library Base64 {
    string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function _encode(bytes memory data) internal pure returns (bytes memory) {
        unchecked {
            if (data.length == 0) return "";

            // load the table into memory
            string memory table = _TABLE;

            // multiply by 4/3 rounded up
            uint256 encodedLen = 4 * ((data.length + 2) / 3);

            // add some extra buffer at the end required for the writing
            bytes memory result = new bytes(encodedLen + 32);

            assembly {
                // set the actual output length
                mstore(result, encodedLen)

                // prepare the lookup table
                let tablePtr := add(table, 1)

                // input ptr
                let dataPtr := data
                let endPtr := add(dataPtr, mload(data))

                // result ptr, jump over length
                let resultPtr := add(result, 32)

                // run over the input, 3 bytes at a time
                for {

                } lt(dataPtr, endPtr) {

                } {
                    dataPtr := add(dataPtr, 3)

                    // read 3 bytes
                    let input := mload(dataPtr)

                    // write 4 characters
                    mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
                    resultPtr := add(resultPtr, 1)
                    mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
                    resultPtr := add(resultPtr, 1)
                    mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F)))))
                    resultPtr := add(resultPtr, 1)
                    mstore(resultPtr, shl(248, mload(add(tablePtr, and(input, 0x3F)))))
                    resultPtr := add(resultPtr, 1)
                }

                // padding with '='
                switch mod(mload(data), 3)
                case 1 {
                    mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
                }
                case 2 {
                    mstore(sub(resultPtr, 1), shl(248, 0x3d))
                }
            }

            return result;
        }
    }
}
