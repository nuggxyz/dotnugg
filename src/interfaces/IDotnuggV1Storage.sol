// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

struct DotnuggV1Calculated {
    uint256[] dat;
}

struct DotnuggV1Read {
    uint256[] dat;
}

interface IDotnuggV1Storage {
    event Write(uint8 feature, uint168 pointer, address sender);

    function init(address _implementer, address trusted) external;

    function write(uint8 feature, bytes memory data) external;

    function write(bytes[8] calldata data) external;

    function read(uint8[8] memory ids) external view returns (DotnuggV1Read[8] memory data);

    function read(uint8 feature, uint8 pos) external view returns (DotnuggV1Read memory data);

    function calc(uint8[8] memory ids) external view returns (DotnuggV1Calculated memory data);

    function calc(uint8 feature, uint8 pos) external view returns (DotnuggV1Calculated memory data);

    function lengths() external view returns (uint8[8] memory res);

    function lengthOf(uint8 feature) external view returns (uint8 res);

    function pointers() external view returns (uint168[][8] memory res);

    function pointersOf(uint8 feature) external view returns (uint168[] memory res);
}
