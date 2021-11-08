// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import '../../lib/DSTest.sol';
import '../../../contracts/logic/Decoder.sol';
import '../../../contracts/interfaces/IDotNugg.sol';
import '../../../contracts/libraries/BytesLib.sol';

contract ItemTest is DSTest {
    using BytesLib for bytes;

    bytes sample1 = hex'444f544e554747670a00000e002c00f19325e500eb8a12e500f9b042e500c96619e500a84b1ee500f49f35e521210000010000000001000000000f0f0f0f0f0f0f0f0f0f0f0e5c0f015130633222520f005030653124500f005031653222500f005031663222500e5131651035500e50336436500e50346435500e50346435500e503111306534500e5034651033500e5035641132500e50346633500e50346930500e503569500e503569500f50321169500f50341067510f5034116124500f00504033601026500f0050402032622341500f0050412031622341500f00522031612241510f035a0f0f0f0f0f0f0f0f0f';

    function test_ItemFunTimes() public {
        IDotNugg.Item memory item = Decoder.parseItem(sample1);


        assert(item.feature == 0);
        assert(item.versions.length == 1);
        assert(item.versions[0].width == 33);
        assert(item.pallet.length == 6);
    }
}
