pragma solidity 0.8.4;

import '../erc165/IERC165.sol';
import './IDotNugg.sol';

interface IColorResolver is IERC165 {
    function resolveColor(IDotNugg.Matrix memory matrix, bytes memory data) external pure returns (bytes memory res);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}

interface IFileResolver is IERC165 {
    function resolveFile(IDotNugg.Matrix memory matrix, bytes memory data) external view returns (bytes memory, string memory fileType);

    function supportsInterface(bytes4 interfaceId) external view override returns (bool);
}
