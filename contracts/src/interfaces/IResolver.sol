// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../erc165/IERC165.sol';

interface IPreProcessResolver is IERC165 {
    function resolvePreProcess(
        uint256 tokenId,
        uint256[][] memory file,
        bytes memory data
    ) external pure returns (uint256[][] memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IPostProcessResolver is IERC165 {
    function resolvePostProcess(
        uint256 tokenId,
        uint256 width,
        uint256 height,
        uint256[] memory file,
        bytes memory data
    ) external view returns (string memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}
