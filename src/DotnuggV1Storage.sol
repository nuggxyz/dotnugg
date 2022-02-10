// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {IDotnuggV1Implementer} from "./interfaces/IDotnuggV1Implementer.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";

import {BytesLib} from "./libraries/BytesLib.sol";
import {SafeCastLib} from "./libraries/SafeCastLib.sol";
import {ShiftLib} from "./libraries/ShiftLib.sol";

contract DotnuggV1Storage is IDotnuggV1Storage {
    using SafeCastLib for uint256;
    using SafeCastLib for uint16;

    address public immutable factory;

    address public implementer;

    address public trusted;

    uint168[][8] public pointers;

    uint8[8] public length;

    string[8] public labels;

    constructor() {
        factory = msg.sender;
        implementer = msg.sender;
    }

    function lengthOf(uint8 feature) external view override returns (uint8 res) {
        return length[feature];
    }

    function pointersOf(uint8 feature) external view override returns (uint168[] memory res) {
        return pointers[feature];
    }

    function init(
        address _implementer,
        string[8] calldata _labels,
        address _trusted
    ) external {
        require(implementer == address(0) && msg.sender == factory, "C:0");

        implementer = _implementer;
        labels = _labels;
        trusted = _trusted;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                TRUSTED
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function store(bytes[8] calldata data) public override {
        for (uint8 i = 0; i < 8; i++) {
            if (data[i].length > 0) store(i, data[i]);
        }
    }

    function store(uint8 feature, bytes calldata data) public override {
        require(feature < 8, "F:3");

        (address ptr, uint8 len) = write(data);

        require(len > 0, "F:0");

        require(trusted == msg.sender, "C:0");

        pointers[feature].push(uint168(uint160(ptr)) | (uint168(len) << 160));

        length[feature] += len;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                 GET FILES
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function get(uint8[8] memory ids) public view returns (uint256[][8] memory data) {
        for (uint8 i = 0; i < 8; i++) {
            // if (ids[i] == 0) data[i] = new uint256[](0);
            if (ids[i] == 0) continue;
            else data[i] = get(i, ids[i]);
        }
    }

    function get(uint8 feature, uint8 pos) public view returns (uint256[] memory data) {
        require(pos != 0, "F:1");

        pos--;

        uint8 totalLength = length[feature];

        require(pos < totalLength, "F:2");

        uint168[] memory ptrs = pointers[feature];

        uint168 stor;
        uint8 storePos;

        uint8 workingPos;

        for (uint256 i = 0; i < ptrs.length; i++) {
            uint8 here = uint8(ptrs[i] >> 160);
            if (workingPos + here > pos) {
                stor = ptrs[i];
                storePos = pos - workingPos;
                break;
            } else {
                workingPos += here;
            }
        }

        require(stor != 0, "F:3");

        data = read(stor, storePos);
    }

    uint16 internal constant DATA_PRE_OFFSET = 1; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.
    uint16 internal constant DATA_POST_OFFSET = 32; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                WRITE TO STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function write(bytes memory data) internal returns (address _pointer, uint8 len) {
        uint256 header = 0x60_12_59_81_38_03_80_92_59_39_F3_64_6F_74_6E_75_67_67_00;

        uint256 prefix = BytesLib.prefix(data, 20);

        uint256 lenr = data.length;

        uint256 keklen = lenr - 32 - 19;

        assembly {
            len := and(prefix, 0xff)
            prefix := shr(8, prefix)
        }

        uint256 check;
        uint256 kek;
        assembly {
            check := mload(add(add(data, 0x20), sub(lenr, 0x20)))

            kek := keccak256(add(data, add(0x20, 19)), keklen)
        }

        require(check == kek, "O:4");

        require(prefix == header, "O:5");

        assembly {
            // Deploy a new contract with the generated creation code.
            // We start 32 bytes into the code to avoid copying the byte length.
            _pointer := create(0, add(data, 0x20), sub(mload(data), 0x20))
        }

        require(_pointer != address(0), "DEPLOYMENT_FAILED");
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                READ FROM STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint168 _pointer, uint8 num) internal view returns (uint256[] memory res) {
        address addr = address(uint160(_pointer));
        uint16 offset = DATA_PRE_OFFSET + 32;
        // uint16 offset = 32 + 1;

        // bytes memory code;

        // assembly {
        //     // let free := mload(0x40)
        //     mstore(code, sub(extcodesize(_pointer), 1))
        //     extcodecopy(addr, add(code, 0x40), 0x1, mload(code))
        // }
        // 53f10f18a6e21e5105e23c761f18789455e8f38b2d71ebb69b43c94b42069001
        bytes memory code = bytes.concat(new bytes(32), addr.code);

        // get len
        uint8 len = BytesLib.toUint8(code, offset);

        require(num + 1 <= len, "P:x");

        uint16 checker = (offset + 1) + (num) * 2;

        uint16 biggeroffset = len * 2;

        uint16 start = BytesLib.toUint16(code, checker) + biggeroffset + offset;

        uint16 end = (len == num + 1)
            ? uint16(code.length)
            : BytesLib.toUint16(code, checker + 2) + biggeroffset + offset;

        require(end >= uint16(start), "P:y");

        uint16 size = end - start;

        uint8 extra = uint8((size) % 0x20);

        // this can go below zero for the first nugg in the list if the conditions are right
        // but if the keccack is in the front then it will be enough buffer to ensure that never happens
        if (extra > 0) start -= (0x20 - (size % 0x20));

        size = end - start;

        require(size % 0x20 == 0, "P:z");

        res = new uint256[]((size / 0x20));

        for (uint256 i = 0; i < res.length; i++) {
            res[i] = BytesLib.toUint256(code, start + i * 0x20);
        }

        // keccak would be masked away here
        if (extra != 0) {
            res[0] = res[0] & ShiftLib.mask(extra * 8);
        }
    }
}
