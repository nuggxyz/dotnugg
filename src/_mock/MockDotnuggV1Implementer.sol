// // SPDX-License-Identifier: MIT

// pragma solidity 0.8.11;

// import {IDotnuggV1} from './../interfaces/IDotnuggV1.sol';
// import {IDotnuggV1Implementer} from './../interfaces/IDotnuggV1Implementer.sol';
// import {IDotnuggV1StorageProxy} from './../interfaces/IDotnuggV1StorageProxy.sol';

// import {IDotnuggV1Metadata} from './../interfaces/IDotnuggV1Metadata.sol';
// // import {GeneratedDotnuggV1LocalUploader} from '../_generated/GeneratedDotnuggV1LocalUploader.sol';

// contract MockDotnuggV1Implementer is  IDotnuggV1Implementer {
//     IDotnuggV1 p;

//     IDotnuggV1StorageProxy public dotnuggV1StorageProxy;

//     IDotnuggV1Metadata.Memory metadataOverride;

//     constructor(IDotnuggV1 processor) {
//         p = processor;
//         dotnuggV1StorageProxy = IDotnuggV1StorageProxy(p.register());
//         // init(address(dotnuggV1StorageProxy));
//     }

//     function afterConstructor() public {
//         init(address(dotnuggV1StorageProxy));
//     }

//     function setMetadataOverride(IDotnuggV1Metadata.Memory memory data) external {
//         metadataOverride = data;
//     }

//     function dotnuggV1ImplementerCallback(uint256 artifactId)
//         external
//         view
//         override
//         returns (IDotnuggV1Metadata.Memory memory data)
//     {
//         if (metadataOverride.implementer != address(0)) return metadataOverride;
//         // data.name = 'name';
//         // data.desc = 'desc';
//         // data.version = 1;
//         // data.tokenId = tokenId;
//         // data.owner = address(0);

//         data.labels = new string[](8);

//         data.labels[0] = 'BASE';
//         data.labels[1] = 'EYES';
//         data.labels[2] = 'MOUTH';
//         data.labels[3] = 'HAIR';
//         data.labels[4] = 'HAT';
//         data.labels[5] = 'BACK';
//         data.labels[6] = 'NECK';
//         data.labels[7] = 'HOLD';

//         data.styles = new string[](8);

//         data.styles[0] = '{filter:invert(75%);}';

//         data.background = '#c4d9f8';

//         data.version = 1;

//         data.ids = dotnuggV1CallbackHelper(artifactId, address(dotnuggV1StorageProxy), 3);

//         return data;
//     }

//     function dotnuggV1StoreCallback(
//         address caller,
//         uint8 feature,
//         uint8 amount,
//         address storagePointer
//     ) external view override(IDotnuggV1Implementer) returns (bool res) {
//         // require(caller == address(this), 'dotnuggV1TrustCallback');
//         return true;
//     }

//     // function dotnuggV1StyleCallback(uint256 artifactId, uint16 id) external pure override returns (string memory res) {}

//     // function dotnuggV1OverrideCallback(uint256 artifactId, uint16 id) external pure override returns (uint8 x, uint8 y) {}

//     // function dotnuggV1BackgroundCallback(uint256) external pure override returns (string memory res) {
//     //     return '#c4d9f8';
//     // }

//     // function dotnuggV1LabelCallback(uint8 feature) external pure override returns (string memory res) {
//     //     if (feature == 0) return 'BASE';
//     //     if (feature == 1) return 'EYES';
//     //     if (feature == 2) return 'MOUTH';
//     //     if (feature == 3) return 'HAIR';
//     //     if (feature == 4) return 'HAT';
//     //     if (feature == 5) return 'BACK';
//     //     if (feature == 6) return 'NECK';
//     //     if (feature == 7) return 'HOLD';
//     // }

//     // function dotnuggV1ItemCallback(uint256 artifactId) external view override returns (uint16[] memory displayed, uint16[] memory hidden) {}

//     function dotnuggV1StoreFiles(uint256[][] calldata data, uint8 feature) external {
//         // dotnuggV1StorageProxy.store(feature, data);
//     }
// }
