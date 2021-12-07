// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './IMockDotNuggHolder.sol';
import './DotNuggLib.sol';
import '../types/ItemType.sol';

import './../../src/interfaces/IDotNugg.sol';
import './../../src/interfaces/IResolver.sol';

contract MockDotNuggHolder is IMockDotNuggHolder {
    using DotNuggLib for DotNuggLib.Storage;

    address defaultResolver;

    DotNuggLib.Storage dotnugg_storage;
    ItemLib.Storage item_storage;

    constructor(address _defaultResolver) {
        defaultResolver = _defaultResolver;
    }

    function dotNuggUpload(uint256[][] calldata items, bytes memory) external override {
        dotnugg_storage.addItems(items);

        ItemLib.mint(item_storage, dotnugg_storage, 0, uint256(blockhash(block.number - 1)));
    }

    function tokenUri(uint256 tokenId) external view returns (string memory res) {
        return string(tokenUri(tokenId, address(0), address(0), address(0)));
    }

    function tokenUri(
        uint256 tokenId,
        address resolver,
        address preResolver,
        address postResolver
    ) public view returns (bytes memory res) {
        resolver = resolver == address(0) ? defaultResolver : resolver;
        preResolver = preResolver == address(0) ? defaultResolver : preResolver;
        postResolver = postResolver == address(0) ? defaultResolver : postResolver;

        res = abi.encode(dotnugg_storage.generateTokenURI(item_storage, tokenId, resolver, preResolver, postResolver));

        res = IPreProcessResolver(preResolver).preProcess(res);
        res = IProcessResolver(resolver).process(res);
        res = IPostProcessResolver(postResolver).postProcess(res);
    }

    // function tokenUriTest(uint256 tokenId) external view returns (uint256[] memory res) {
    //     res = dotnugg_storage.generateTokenURITest(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // }

    // function tokenUri2(uint256 tokenId) external view returns (string memory res) {
    //     res = dotnugg_storage.generateTokenURI2(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // }

    // function tokenUriTest2(uint256 tokenId) external view returns (uint256[] memory res) {
    //     res = dotnugg_storage.generateTokenURITest2(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // }
}
