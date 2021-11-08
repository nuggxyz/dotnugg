// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';

import '../../contracts/logic/Decoder.sol';
import '../../contracts/interfaces/IDotNugg.sol';
import '../../contracts/libraries/BytesLib.sol';
import '../../contracts/logic/Rgba.sol';
import '../../contracts/logic/Matrix.sol';

contract PlainTest {
    using BytesLib for bytes;

    bytes sample1 =
        hex'6e6e6e6e75676709c800000e002c00f19325e500eb8a12e500f9b042e500c96619e500a84b1ee500f49f35e52121000000001723fe23ff23fd23fa23fc23f923fb23f80f0f0f0f0f0f0f0f0f0f0e5c0f015130633222520f005030653124500f005031653222500f005031663222500e5131651035500e50336436500e50346435500e50346435500e503111306534500e5034651033500e5035641132500e50346633500e50346930500e503569500e503569500f50321169500f50341067510f5034116124500f00504033601026500f0050402032622341500f0050412031622341500f00522031612241510f035a0f0f0f0f0f0f0f0f0f';

    function tfizzle() public {
        IDotNugg.Item memory item = Decoder.parseItem(sample1);

        //   assertTrue(item.feature == 0);
        //   assertTrue(item.versions.length == 1);
        //   assertTrue(item.versions[0].width == 33);

        for (uint256 i = 0; i < 6; i++) {
            // emit log_named_bytes(string(abi.encodePacked(i)), item.versions[0].data);
        }
        //   assertTrue(item.pallet.length == 7);
        //   IDotNugg.Matrix memory mat = Matrix.create(33, 33);

        //   Matrix.set(mat, item.versions[0].data, item.pallet, item.versions[0].width);

        //   assertTrue(mat.width == 33);
        //  IDotNugg.Item memory item = Decoder.parseItem(sample1);
    }
}
