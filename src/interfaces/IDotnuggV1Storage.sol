// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

interface IDotnuggV1Storage {
    event Write(uint8 feature, uint168 pointer, address sender);

    function init(
        address _implementer,
        string[8] calldata _labels,
        address trusted
    ) external;

    function write(uint8 feature, bytes memory data) external;

    function write(bytes[8] calldata data) external;

    function read(uint8[8] memory ids) external view returns (uint256[][8] memory data);

    function read(uint8 feature, uint8 pos) external view returns (uint256[] memory data);

    function labels() external view returns (string[8] memory res);

    function labelOf(uint8 feature) external view returns (string memory res);

    function lengths() external view returns (uint8[8] memory res);

    function lengthOf(uint8 feature) external view returns (uint8 res);

    function pointers() external view returns (uint168[][8] memory res);

    function pointersOf(uint8 feature) external view returns (uint168[] memory res);
}
