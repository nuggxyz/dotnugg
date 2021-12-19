// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

interface IMockDotNuggHolder {
    function dotNuggUpload(uint256[][] memory items, bytes memory data) external;
}
