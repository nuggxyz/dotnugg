// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Read, DotnuggV1Calculated} from "./DotnuggV1Files.sol";

interface IDotnuggV1Storage {
    event Write(uint8 feature, uint8 amount, address pointer, address sender);

    function init(address trusted) external;

    function write(uint8 feature, bytes memory data) external;

    function write(bytes[] calldata data) external;

    function read(uint8[8] memory ids) external view returns (DotnuggV1Read[8] memory data);

    function read(uint8 feature, uint8 pos) external view returns (DotnuggV1Read memory data);

    function exec(uint8[8] memory ids, bool base64) external view returns (string memory);

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) external view returns (string memory);

    function lengths() external view returns (uint8[8] memory res);

    function lengthOf(uint8 feature) external view returns (uint8 res);

    function pointers() external view returns (uint168[][8] memory res);

    function pointersOf(uint8 feature) external view returns (uint168[] memory res);
}
