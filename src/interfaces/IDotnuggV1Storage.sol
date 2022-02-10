// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

interface IDotnuggV1Storage {
    function init(
        address _implementer,
        string[8] calldata _labels,
        address trusted
    ) external;

    function store(uint8 feature, bytes memory data) external;

    function store(bytes[8] calldata data) external;

    function lengthOf(uint8 feature) external view returns (uint8 res);

    function pointersOf(uint8 feature) external view returns (uint168[] memory res);

    function get(uint8[8] memory ids) external view returns (uint256[][8] memory data);

    function get(uint8 feature, uint8 pos) external view returns (uint256[] memory data);
}
