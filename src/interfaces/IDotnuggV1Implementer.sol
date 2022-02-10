// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

interface IDotnuggV1Implementer {}

interface IDotnuggV1ImplementerWithCallback {
    function dotnuggV1Callback(uint256 artifactId) external view returns (uint8[8] memory res);
}
