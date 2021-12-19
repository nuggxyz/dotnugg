// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

interface IdotnuggV1BytesResolver {
    function resolveBytes(uint256[] memory file, bytes memory data) external view returns (bytes memory res);
}

interface IdotnuggV1RawResolver {
    function resolveRaw(uint256[] memory file, bytes memory data) external view returns (uint256[] memory res);
}

interface IdotnuggV1StringResolver {
    function resolveString(uint256[] memory file, bytes memory data) external view returns (string memory res);
}

interface IdotnuggV1Processer is IdotnuggV1BytesResolver, IdotnuggV1RawResolver, IdotnuggV1StringResolver {
    function process(uint256[][] memory files, bytes memory data) external view returns (uint256[] memory file);
}
