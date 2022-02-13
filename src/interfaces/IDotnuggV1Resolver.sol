// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Read, DotnuggV1Calculated} from "./DotnuggV1Files.sol";

// type DotnuggId is uint40;

interface IDotnuggV1Resolver {
    function calc(DotnuggV1Read[8] memory inputs) external view returns (DotnuggV1Calculated memory data);

    function calc(DotnuggV1Read memory input) external view returns (DotnuggV1Calculated memory data);

    function svg(DotnuggV1Calculated memory file, bool base64) external pure returns (string memory);

    // function pack(uint8[8] memory ids) external pure returns (DotnuggId);
}
