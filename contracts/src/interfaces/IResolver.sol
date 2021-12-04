// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../erc165/IERC165.sol';

import '../types/Version.sol';

interface IColorResolver is IERC165 {
    function resolveColor(Version.Memory memory version, bytes memory data) external view returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IFileResolver is IERC165 {
    function resolveFile(Version.Memory memory version, bytes memory data) external view returns (bytes memory, string memory fileType);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}
