// SPDX-License-Identifier: MIT

import './IMockDotNuggHolder.sol';
import './DotNuggLib.sol';
import '../types/ItemType.sol';

import './../../src/interfaces/IDotNugg.sol';
import './../../src/interfaces/IResolver.sol';

contract MockDotNuggHolder is IMockDotNuggHolder {
    using DotNuggLib for DotNuggLib.Storage;

    IDotNugg dotnugg;
    IFileResolver svgResolver;

    DotNuggLib.Storage dotnugg_storage;
    ItemLib.Storage item_storage;

    constructor(address _dotnugg, address _dotnuggFileResolver) {
        dotnugg = IDotNugg(_dotnugg);
        svgResolver = IFileResolver(_dotnuggFileResolver);
    }

    function dotNuggUpload(uint256[][] calldata items, bytes memory) external override {
        dotnugg_storage.addItems(items);

        ItemLib.mint(item_storage, dotnugg_storage, 0, uint256(blockhash(block.number - 1)));
    }

    function tokenUri(uint256 tokenId) external view returns (string memory res) {
        dotnugg_storage.generateTokenURI(item_storage, address(dotnugg), tokenId, address(svgResolver));
    }

    function tokenUriTest(uint256 tokenId) external view returns (uint256[] memory res) {
        res = dotnugg_storage.generateTokenURITest(item_storage, address(dotnugg), tokenId, address(svgResolver));
    }
}
