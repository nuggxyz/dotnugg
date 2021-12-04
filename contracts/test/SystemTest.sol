// SPDX-License-Identifier: MIT


// pragma solidity 0.8.10;

// import '../src/libraries/BytesLib.sol';
// import '../src/logic/Rgba.sol';
// import '../src/logic/Decoder.sol';
// import '../src/libraries/Base64.sol';

// import '../src/interfaces/INuggIn.sol';
// import '../../contracts/test/Console.sol';

// import '../src/logic/Matrix.sol';

// contract SystemTest {
//     using BytesLib for bytes;
//     //  using Rgba for IDotNugg.Rgba;

//     bytes sample1 =
//         hex'444f544e554747c7cc00000e002c00f19325e500eb8a12e500f9b042e500c96619e500a84b1ee500f49f35e52121101000001720fe20ff20fd32fa11fc40f912fb00f80f0f0f0f0f0f0f0f0f0f0e5d0f005130633322520f5030653224500f5031663222500f5031673222500d5131661035500d50336536500d50346535500d50346535500d503111306634500d5034661033500d5035651132500d50346733500d50346a30500d50356a500d50356a500e5032116a500e50341068510e5034116224500f504033601027500f50402032632341500f50412031632341500f522031612341510f025b0f0f0f0f0f0f0f0f0e';

//     bytes sample2 =
//         hex'444f544e554747c072050010001a003903000000990300eae19911050803010c06010001040404000f05140a112211041102122012021f1f1313060905010e06020001040405000f05160a1809122212041101142014011f1f17';

//     bytes sample3 =
//         hex'444f544e5547475295030010001a0038020000009902e100e19909040401010505000001050500000f1300142112211121100010211400130d050601010707000001090900000f140215221002102211221422112210021022150214';

//     bytes sample4 =
//         hex'444f544e5547478ca8030010001f004802f85c0f9902fb1a069902ffdb3c990a040401010406000001030300000f01100310021020021020011020302100203021001020021020010f050601010509000001050500000f0110061004102010041020100210203023001020302300102010041020100410061003';

//     bytes sampleCollection =
//         hex'444f544e5547472109000d004d444f544e55474753d9020010001a002601000000ff01ffffffff0702030000000711021302110b030500010606000001090900000f2204231020042010230422444f544e554747dc75060010001a0022010000009901ffffffff0301010000000712050302010000071500200010001200';

//     function tfizzle(IDotNugg _contract, IFileResolver _resolver) public view returns (string memory res) {
//         //   IDotNugg.Item memory item = Decoder.parseItem(sample1);
//         //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);
//         //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);
//         bytes[] memory sampleItems = new bytes[](3);

//         sampleItems[0] = sample1;
//         sampleItems[1] = sample2;
//         sampleItems[2] = sample3;
//         //   sampleItems[3] = sample4;

//         //   res = _contract.nuggify(sampleCollection, sampleItems, address(_resolver), '');
//         IDotNugg.Matrix memory temp = Matrix.create(17, 5);
//         IDotNugg.Item memory t2 = Decoder.parseItem(sample2, 10);
//         Matrix.set(temp, t2.versions[0].data, t2.pallet, t2.versions[0].width, t2.versions[0].height);
//         (bytes memory tmp, string memory file) = _resolver.resolveFile(temp, '');
//         //   (bytes memory byt, string memory file) = _resolver.resolveFile(temp, '');
//         res = Base64.encode(tmp, file);
//         //   General.convert(sampleCollection, sampleItems, address(0), '');
//         //   assertTrue(item.feature == 0);
//         //   assertTrue(item.versions.length == 1);
//         //   assertTrue(item.versions[0].width == 33);

//         //   assertTrue(item.pallet.length == 7);
//         //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);

//         //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);

//         //   assertTrue(mat.width == 33);
//         //  IDotNugg.Item memory item = Decoder.parseItem(sample1);
//     }

//     function tfull(IDotNugg _contract, IFileResolver _resolver) public view returns (string memory res) {
//         //   IDotNugg.Item memory item = Decoder.parseItem(sample1);
//         //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);
//         //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);
//         bytes[] memory sampleItems = new bytes[](4);

//         sampleItems[0] = sample1;
//         sampleItems[1] = sample2;
//         sampleItems[2] = sample3;
//         sampleItems[3] = sample4;

//         res = _contract.nuggify(sampleCollection, sampleItems, address(_resolver), 'the name', 'the desc', 245, hex'02', '');
//         //   IDotNugg.Matrix memory temp = Matrix.create(17, 5);
//         //   IDotNugg.Item memory t2 = Decoder.parseItem(sample2, 10);
//         //   Matrix.set(temp, t2.versions[0].data, t2.pallet, t2.versions[0].width, t2.versions[0].height);
//         //   (bytes memory tmp, string memory file) = _resolver.resolveFile(temp, '');
//         //   //   (bytes memory byt, string memory file) = _resolver.resolveFile(temp, '');
//         //   res = Base64.encode(tmp, file);
//         //   General.convert(sampleCollection, sampleItems, address(0), '');
//         //   assertTrue(item.feature == 0);
//         //   assertTrue(item.versions.length == 1);
//         //   assertTrue(item.versions[0].width == 33);

//         //   assertTrue(item.pallet.length == 7);
//         //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);

//         //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);

//         //   assertTrue(mat.width == 33);
//         //  IDotNugg.Item memory item = Decoder.parseItem(sample1);
//     }
// }
