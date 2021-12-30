// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;
import {IDotnuggV1Storage} from '../interfaces/IDotnuggV1Storage.sol';
import {SSTORE2} from '../libraries/SSTORE2.sol';
import {SafeCastLib} from '../libraries/SafeCastLib.sol';

abstract contract DotnuggV1Storage is IDotnuggV1Storage {
    using SafeCastLib for uint256;
    using SafeCastLib for uint16;

    // Mapping from token ID to owner address
    mapping(address => mapping(uint8 => uint168[])) sstore2Pointers;
    mapping(address => mapping(uint8 => uint8)) featureLengths;

    function stored(address implementer, uint8 feature) public view override returns (uint8 res) {
        return featureLengths[implementer][feature];
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                TRUSTED
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function unsafeBulkStore(uint256[][][] calldata data) public override {
        for (uint8 i = 0; i < 8; i++) {
            store(i, data[i]);
        }
    }

    function store(uint8 feature, uint256[][] calldata data) public override returns (uint8 res) {
        uint8 len = data.length.safe8();

        require(len > 0, 'F:0');

        address ptr = SSTORE2.write(abi.encode(data));

        sstore2Pointers[msg.sender][feature].push(uint168(uint160(ptr)) | (uint168(len) << 160));

        featureLengths[msg.sender][feature] += len;

        return len;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                 GET FILES
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function getBatchFiles(address implementer, uint8[] memory ids) internal view returns (uint256[][] memory data) {
        data = new uint256[][](ids.length);

        for (uint8 i = 0; i < ids.length; i++) {
            if (ids[i] == 0) data[i] = new uint256[](0);
            else data[i] = get(implementer, i, ids[i]);
        }
    }

    function get(
        address implementer,
        uint8 feature,
        uint8 pos
    ) internal view returns (uint256[] memory data) {
        require(pos != 0, 'F:1');

        pos--;

        uint8 totalLength = featureLengths[implementer][feature];

        require(pos < totalLength, 'F:2');

        uint168[] memory ptrs = sstore2Pointers[implementer][feature];

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

        data = abi.decode(SSTORE2.read(stor), (uint256[][]))[storePos];
    }
}
