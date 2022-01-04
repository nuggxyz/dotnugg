// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata as Metadata} from './IDotnuggV1Metadata.sol';

interface IDotnuggV1Resolver {
    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              complex [default] resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */
    function resolveSvg(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) external view returns (string memory res);

    function resolveJson(
        uint256[] memory file,
        Metadata.Memory memory metadata,
        bytes memory data
    ) external view returns (string memory res);

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                              basic resolvers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function resolveBytes(
        uint256[] memory file, //
        Metadata.Memory memory metadata, //
        bytes memory data
    ) external view returns (bytes memory res);

    function resolveString(
        uint256[] memory file, //
        Metadata.Memory memory metadata, //
        bytes memory data
    ) external view returns (string memory res);
}
