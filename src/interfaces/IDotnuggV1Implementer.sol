// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata} from './IDotnuggV1Metadata.sol';

interface IDotnuggV1Implementer {
    function dotnuggV1ImplementerCallback(uint256 artifactId) external view returns (IDotnuggV1Metadata.Memory memory data);

    function dotnuggV1TrustCallback(address caller) external;

    // function dotnuggV1StyleCallback(uint256 artifactId, uint16 id) external view returns (string memory res);

    // function dotnuggV1OverrideCallback(uint256 artifactId, uint16 id) external view returns (uint8 x, uint8 y);

    // function dotnuggV1BackgroundCallback(uint256 artifactId) external view returns (string memory res);

    // function dotnuggV1LabelCallback(uint8 feature) external view returns (string memory res);

    // function dotnuggV1ItemCallback(uint256 artifactId) external view returns (uint8[] memory vis);
}
