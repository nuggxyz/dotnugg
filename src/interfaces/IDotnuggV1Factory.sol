// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Storage} from "./IDotnuggV1Storage.sol";

import {IDotnuggV1Resolver} from "./IDotnuggV1Resolver.sol";

interface IDotnuggV1Factory is IDotnuggV1Resolver {
    function register(address trusted, string[8] memory labels) external returns (IDotnuggV1Storage proxy);

    function proxyOf(address implementer) external view returns (IDotnuggV1Storage proxy);

    function rawWithCallback(address implementer, uint256 artifactId) external view returns (uint256[][8] memory res);

    function raw(address implementer, uint8[] memory ids) external view returns (uint256[][8] memory res);

    function raw(
        address implementer,
        uint8 feature,
        uint8 pos
    ) external view returns (uint256[] memory res);
}
