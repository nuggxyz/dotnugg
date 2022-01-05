// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;
import {IDotnuggV1StorageProxy} from '../interfaces/IDotnuggV1StorageProxy.sol';
import {IDotnuggV1Implementer} from '../interfaces/IDotnuggV1Implementer.sol';

import {SSTORE2} from '../libraries/SSTORE2.sol';
import {SafeCastLib} from '../libraries/SafeCastLib.sol';

import '../_test/utils/console.sol';

contract DotnuggV1StorageProxy is IDotnuggV1StorageProxy {
    using SafeCastLib for uint256;
    using SafeCastLib for uint16;

    address public immutable dotnuggv1;

    address public implementer;

    modifier requiresTrust() {
        require(IDotnuggV1Implementer(implementer).dotnuggV1TrustCallback(msg.sender), 'C:0');
        _;
    }

    constructor() {
        dotnuggv1 = msg.sender;
    }

    function init(address _implementer) external {
        require(implementer == address(0) && msg.sender == dotnuggv1, 'C:0');
        implementer = _implementer;
    }

    // Mapping from token ID to owner address
    mapping(uint8 => uint168[]) sstore2Pointers;
    mapping(uint8 => uint8) featureLengths;

    function stored(uint8 feature) public view override returns (uint8 res) {
        return featureLengths[feature];
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                TRUSTED
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function unsafeBulkStore(uint256[][][] calldata data) public override {
        require(msg.sender == implementer);
        for (uint8 i = 0; i < 8; i++) {
            uint8 len = data[i].length.safe8();

            require(len > 0, 'F:0');

            address ptr = SSTORE2.write(data[i]);

            sstore2Pointers[i].push(uint168(uint160(ptr)) | (uint168(len) << 160));

            featureLengths[i] += len;
        }
    }

    function store(uint8 feature, uint256[][] calldata data) public override requiresTrust returns (uint8 res) {
        uint8 len = data.length.safe8();

        require(len > 0, 'F:0');

        address ptr = SSTORE2.write(data);

        sstore2Pointers[feature].push(uint168(uint160(ptr)) | (uint168(len) << 160));

        featureLengths[feature] += len;

        return len;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                 GET FILES
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function getBatch(uint8[] memory ids) public view returns (uint256[][] memory data) {
        data = new uint256[][](ids.length);

        for (uint8 i = 0; i < ids.length; i++) {
            if (ids[i] == 0) data[i] = new uint256[](0);
            else data[i] = get(i, ids[i]);
        }
    }

    function get(uint8 feature, uint8 pos) public view returns (uint256[] memory data) {
        require(pos != 0, 'F:1');

        pos--;

        uint8 totalLength = featureLengths[feature];

        require(pos < totalLength, 'F:2');

        uint168[] memory ptrs = sstore2Pointers[feature];

        address stor;
        uint8 storePos;

        uint8 workingPos;

        for (uint256 i = 0; i < ptrs.length; i++) {
            uint8 here = uint8(ptrs[i] >> 160);
            if (workingPos + here > pos) {
                stor = address(uint160(ptrs[i]));
                storePos = pos - workingPos;
                break;
            } else {
                workingPos += here;
            }
        }

        require(stor != address(0), 'F:3');

        data = SSTORE2.read2DArray(stor, storePos);
    }
}
