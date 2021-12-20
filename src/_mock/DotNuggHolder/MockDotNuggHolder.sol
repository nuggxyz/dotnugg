// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

// import './IMockDotNuggHolder.sol';
// import './DotNuggLib.sol';
// import '../types/ItemType.sol';

// import './../../src/interfaces/IDotNugg.sol';
// import './../../src/interfaces/IResolver.sol';

contract MockDotNuggHolder {
    // using DotNuggLib for DotNuggLib.Storage;
    // address _defaultResolver;
    // DotNuggLib.Storage dotnugg_storage;
    // ItemLib.Storage item_storage;
    // constructor(address defaultResolver_) {
    //     _defaultResolver = defaultResolver_;
    // }
    // function dotNuggUpload(uint256[][] calldata items, bytes memory) external override {
    //     dotnugg_storage.addItems(items);
    //     ItemLib.mint(item_storage, dotnugg_storage, 0, uint256(blockhash(block.number - 1)));
    // }
    // function tokenUri(uint256 tokenId) external view returns (string memory res) {
    //     return string(tokenUri(tokenId, defaultResolver(tokenId)));
    // }
    // function defaultResolver(uint256) public view returns (address res) {
    //     return _defaultResolver;
    // }
    // function tokenUri(uint256 tokenId, address resolver) public view returns (bytes memory res) {
    //     (uint256[][] memory files, uint256 itemData) = dotnugg_storage.getData(item_storage, tokenId);
    //     bytes memory data = abi.encode(tokenId, itemData, address(this));
    //     bytes memory customData = IPreProcessResolver(resolver).preProcess(data);
    //     uint256[] memory processedFile = IProcessResolver(resolver).process(files, data, customData);
    //     return IPostProcessResolver(resolver).postProcess(processedFile, data, customData);
    // }
    // // function tokenUriTest(uint256 tokenId) external view returns (uint256[] memory res) {
    // //     res = dotnugg_storage.generateTokenURITest(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // // }
    // // function tokenUri2(uint256 tokenId) external view returns (string memory res) {
    // //     res = dotnugg_storage.generateTokenURI2(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // // }
    // // function tokenUriTest2(uint256 tokenId) external view returns (uint256[] memory res) {
    // //     res = dotnugg_storage.generateTokenURITest2(item_storage, address(dotnugg), tokenId, address(svgResolver));
    // // }
}
