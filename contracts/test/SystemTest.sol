// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../../contracts/libraries/BytesLib.sol';
import '../../contracts/logic/Rgba.sol';
import '../../contracts/logic/Decoder.sol';
import '../../contracts/interfaces/INuggIn.sol';
import '../../contracts/test/Console.sol';

import '../logic/Matrix.sol';

contract SystemTest {
    using BytesLib for bytes;
    //  using Rgba for IDotNugg.Rgba;

    bytes sample1 =
        hex'444f544e55474783c800000e002c00f19325e500eb8a12e500f9b042e500c96619e500a84b1ee500f49f35e52121101000001722fe22ff22fd30fa11fc40f911fb00f80f0f0f0f0f0f0f0f0f0f0e5c0f015130633222520f005030653124500f005031653222500f005031663222500e5131651035500e50336436500e50346435500e50346435500e503111306534500e5034651033500e5035641132500e50346633500e50346930500e503569500e503569500f50321169500f50341067510f5034116124500f00504033601026500f0050402032622341500f0050412031622341500f00522031612241510f035a0f0f0f0f0f0f0f0f0f';

    bytes sample2 =
        hex'444f544e554747cb15050010001a003103000000990300eae1991105080400000705140a112211041102122012021f1f131306090500000705160a1809122212041101142014011f1f17';

    bytes sample3 =
        hex'444f544e554747d3c2030010001a0039020000009902e100e1990a0405010001040401020b00130015211221100010211000102110001300130e0507010001050501030b00140214001022100210221222142210001022100210221000140214';

    bytes sample4 =
        hex'444f544e5547476489030010001f004402f85c0f9902fb1a069902ffdb3c990a0404010001030301020b01100310021020021020011020302100203021001020021020010f0506010001050501030b0110061004102010041020100210203023001020302300102010041020100410061003';

    bytes sampleCollection =
        hex'444f544e5547472109000d0045444f544e5547471fb1020010001a002601000000ff01ffffffff0702030000000711021302110b0305000000072204231020042010230422444f544e5547473d2f060010001a0022010000009901ffffffff03010100000007120501020000000714';

    function tfizzle(IDotNugg _contract, IFileResolver _resolver) public view returns (string memory res) {
        //   IDotNugg.Item memory item = Decoder.parseItem(sample1);
        //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);
        //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);
        bytes[] memory sampleItems = new bytes[](4);

        sampleItems[0] = sample1;
        sampleItems[1] = sample2;
        sampleItems[2] = sample3;
        sampleItems[3] = sample4;

        res = _contract.nuggify(sampleCollection, sampleItems, address(_resolver), '');
        console.log(res);
        //   General.convert(sampleCollection, sampleItems, address(0), '');
        //   assertTrue(item.feature == 0);
        //   assertTrue(item.versions.length == 1);
        //   assertTrue(item.versions[0].width == 33);

        //   assertTrue(item.pallet.length == 7);
        //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);

        //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);

        //   assertTrue(mat.width == 33);
        //  IDotNugg.Item memory item = Decoder.parseItem(sample1);
    }
}
