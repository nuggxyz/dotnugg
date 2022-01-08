// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {DSTestExtended as t} from './utils/DSTestExtended.sol';

import {User} from './utils/User.sol';

import {MockDotnuggV1Implementer} from '../_mock/MockDotnuggV1Implementer.sol';

import {DotnuggV1} from '../DotnuggV1.sol';

library SafeCast {
    function safeI192(uint96 input) internal pure returns (int192) {
        return (int192(int256(uint256(input))));
    }
}

contract DotnuggV1Test is t {
    using SafeCast for uint96;
    using SafeCast for uint256;
    using SafeCast for uint64;

    DotnuggV1 public processor;

    address public _processor;

    MockDotnuggV1Implementer public implementer;

    address public _implementer;

    User public safe;

    User public frank;
    User public charlie;
    User public dennis;
    User public mac;
    User public dee;

    User public any;

    constructor() {}

    function reset() public {
        fvm.roll(1);
        fvm.roll(2);
        processor = new DotnuggV1();

        _processor = address(processor);

        implementer = new MockDotnuggV1Implementer(processor);

        implementer.afterConstructor();

        _implementer = address(implementer);

        assertTrue(implementer.dotnuggV1StorageProxy().stored(0) > 0);

        safe = new User{value: 1000 ether}();
        frank = new User{value: 1000 ether}();
        charlie = new User{value: 1000 ether}();
        dennis = new User{value: 1000 ether}();
        mac = new User{value: 1000 ether}();
        dee = new User{value: 1000 ether}();

        any = new User();
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                eth modifiers
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                encodeWithSelector
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function dotnuggV1StoreFiles(uint256[][] memory files, uint8 feature) public view returns (bytes memory res) {
        return abi.encodeWithSelector(implementer.dotnuggV1StoreFiles.selector, files, feature);
    }

    function take(int256 percent, int256 value) internal pure returns (int256) {
        return (value * percent) / 100;
    }
}

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): 36422938319266817
//   nuggft.protocolEth(): 13721927850988207037
//   nuggft.stakedEth(): 254960568234867720007
//   nuggft.stakedShares(): 7000

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): .220269870602728762
//   nuggft.protocolEth(): 105.652900187038601090
//   nuggft.stakedEth(): 3524.317929643660202576
//   nuggft.stakedShares(): 16000

// Success: test__system1()
// *10
//   users length: 2000
//   nuggft.ethPerShare():  .081046931383505748
//   nuggft.protocolEth(): 36.036371675422002761
//   nuggft.stakedEth():  891.516245218563229016
//   nuggft.stakedShares(): 11000

//   users length: 2000
//   nuggft.ethPerShare():   .009923420616251655
//   nuggft.protocolEth():  10.797105517187750828
//   nuggft.stakedEth():   109.157626778768205405
//   nuggft.stakedShares(): 11000

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): .023820112972809680
//   nuggft.protocolEth(): 23.605706549631210195
//   nuggft.stakedEth(): 262.021242700906482643
//   nuggft.stakedShares(): 11000

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): 22283800801842573
//   nuggft.protocolEth(): 12045486919914902312
//   nuggft.stakedEth(): 133702804811055442627
//   nuggft.stakedShares(): 6000

//   users length: 2000
//   nuggft.ethPerShare(): 1.124042581556443270
//   nuggft.protocolEth(): 658.232592803322633239
//   nuggft.stakedEth(): 7306.276780116881258328
//   nuggft.stakedShares(): 6500

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): .179846813049030914
//   nuggft.protocolEth(): 105317214848531614175
//   nuggft.stakedEth(): 1169004284818700946598
//   nuggft.stakedShares(): 6500

// .092595956292375926

// .101719406217199627

// Success: test__system1()

//   users length: 2000
//   nuggft.ethPerShare(): .178270406414740660
//   nuggft.protocolEth(): 96363895359319273644
//   nuggft.stakedEth(): 1069622438488443964472
//   nuggft.stakedShares(): 6000

// Success: test__system1()

//   users length: 1000
//   nuggft.ethPerShare():   1.425741271002990526
//   nuggft.protocolEth():  305.518843786355111578
//   nuggft.stakedEth():   4277.223813008971579744
//   nuggft.stakedShares(): 3000
