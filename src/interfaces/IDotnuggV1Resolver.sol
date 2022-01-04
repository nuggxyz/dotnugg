// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata as Metadata} from './IDotnuggV1Metadata.sol';

interface IDotnuggV1Resolver {
    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              complex [default] resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggV1MetadataCallback(
        address implementer,
        uint256 artifactId,
        Metadata.Memory memory input,
        bytes memory data
    ) external view returns (Metadata.Memory memory resolved);

    function dotnuggV1SvgCallback(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) external view returns (string memory res);

    function dotnuggV1JsonCallback(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) external view returns (string memory res);

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              basic resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggV1StringCallback(
        uint256[] memory file, //
        Metadata.Memory memory metadata, //
        bytes memory data
    ) external view returns (string memory res);

    function dotnuggV1BytesCallback(
        uint256[] memory file, //
        Metadata.Memory memory metadata, //
        bytes memory data
    ) external view returns (bytes memory res);
}
