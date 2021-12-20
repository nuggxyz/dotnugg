// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

interface IdotnuggV1Data {
    struct Data {
        uint256 version;
        string name;
        string desc;
        address owner;
        uint256 tokenId;
        uint256 proof;
        uint8[] ids;
        uint8[] extras;
        uint8[] xovers;
        uint8[] yovers;
    }
}

interface IdotnuggV1BytesResolver {
    function resolveBytes(uint256[] memory file, IdotnuggV1Data.Data memory data) external view returns (bytes memory res);
}

interface IdotnuggV1RawResolver {
    function resolveRaw(uint256[] memory file, IdotnuggV1Data.Data memory data) external view returns (uint256[] memory res);
}

interface IdotnuggV1DataResolver {
    function resolveData(uint256[] memory file, IdotnuggV1Data.Data memory data) external view returns (IdotnuggV1Data.Data memory res);
}

interface IdotnuggV1StringResolver {
    function resolveString(uint256[] memory file, IdotnuggV1Data.Data memory data) external view returns (string memory res);
}

interface IdotnuggV1Processer is IdotnuggV1BytesResolver, IdotnuggV1RawResolver, IdotnuggV1StringResolver, IdotnuggV1DataResolver {
    function process(uint256[][] memory files, IdotnuggV1Data.Data memory data) external view returns (uint256[] memory file);
}
