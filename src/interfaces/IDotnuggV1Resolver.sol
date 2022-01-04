// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata as Metadata} from './IDotnuggV1Metadata.sol';
import {IDotnuggV1File as File} from './IDotnuggV1File.sol';

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
        File.Processed memory proc, //
        bytes memory data
    ) external view returns (string memory res);

    function dotnuggV1JsonCallback(
        File.Processed memory proc, //
        bytes memory data
    ) external view returns (string memory res);

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              basic resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggV1StringCallback(
        File.Processed memory proc, //
        bytes memory data
    ) external view returns (string memory res);

    function dotnuggV1BytesCallback(
        File.Processed memory proc, //
        bytes memory data
    ) external view returns (bytes memory res);
}
