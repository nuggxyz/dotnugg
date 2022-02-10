// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

interface IDotnuggV1Implementer {
    function itemsOf(uint256 artifactId) external view returns (uint8[8] memory res);

    function itemLabels() external view returns (string[8] memory res);
}
