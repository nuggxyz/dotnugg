// SPDX-License-Identifier: BUS1.1

pragma solidity 0.8.11;

interface IDotnuggV1Resolver {
    function resolve(uint256[][] calldata files) external view returns (uint256[] memory resp);
}
