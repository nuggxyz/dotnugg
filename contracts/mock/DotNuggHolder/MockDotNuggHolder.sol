// SPDX-License-Identifier: MIT

import './IMockDotNuggHolder.sol';
import './../../src/interfaces/IDotNugg.sol';
import './../../src/interfaces/IResolver.sol';

contract MockDotNuggHolder is IMockDotNuggHolder {
    IDotNugg dotnugg;
    IFileResolver svgResolver;

    constructor(address _dotnugg, address _dotnuggFileResolver) {
        dotnugg = IDotNugg(_dotnugg);
        svgResolver = IFileResolver(_dotnuggFileResolver);
    }

    function dotNuggUpload(uint256[][] memory items, bytes memory data) external {}

    function tokenUri(uint256 tokenId) external view returns (string memory res) {}
}
