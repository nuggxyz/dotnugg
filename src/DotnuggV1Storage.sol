// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";
import {DotnuggV1Calculated, DotnuggV1Read} from "./interfaces/DotnuggV1Files.sol";

import {ShiftLib} from "./libraries/ShiftLib.sol";

contract DotnuggV1Storage is IDotnuggV1Storage, DotnuggV1Resolver {
    address public immutable factory;

    address public trusted;

    uint168[][8] private __pointers;
    uint8[8] private __lengths;

    constructor() {
        factory = address(this);

        trusted = address(this);
    }

    function init(address _trusted) external {
        require(trusted == address(0) && msg.sender == factory, "C:0");

        trusted = _trusted;
    }

    function updateTrusted(address _trusted) external {
        require(trusted == msg.sender, "C:0");

        trusted = _trusted;
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                  write
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function write(bytes[] calldata data) external {
        require(data.length == 8, "nope");
        for (uint8 i = 0; i < 8; i++) {
            if (data[i].length > 0) write(i, data[i]);
        }
    }

    function write(uint8 feature, bytes calldata data) public override {
        require(trusted == msg.sender, "C:0");

        require(feature < 8, "F:3");

        (address loc, uint8 len) = _write(data);

        require(len > 0, "F:0");

        uint168 ptr = uint168(uint160(loc)) | (uint168(len) << 160);

        __pointers[feature].push(ptr);

        __lengths[feature] += len;

        emit Write(feature, len, loc, msg.sender);
    }

    function exec(uint8[8] memory ids, bool base64) public view returns (string memory) {
        return svg(calc(read(ids)), base64);
    }

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) public view returns (string memory) {
        return svg(calc(read(feature, pos)), base64);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                 GET FILES
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function read(uint8[8] memory ids) public view returns (DotnuggV1Read[8] memory res) {
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) res[i] = read(i, ids[i]);
        }
    }

    function read(uint8 feature, uint8 pos) public view returns (DotnuggV1Read memory res) {
        require(pos != 0 && pos <= __lengths[feature], "F:1");

        pos--;

        uint168[] memory ptrs = __pointers[feature];

        for (uint256 i = 0; i < ptrs.length; i++) {
            uint8 here = uint8(ptrs[i] >> 160);
            if (here >= pos) {
                require(ptrs[i] != 0, "F:3");

                return _read(ptrs[i], pos);
            }
            pos -= here;
        }

        // uint8 workingPos;

        // for (uint256 i = 0; i < ptrs.length; i++) {
        //     uint8 here = uint8(ptrs[i] >> 160);
        //     if (workingPos + here > pos) {
        //         require(ptrs[i] != 0, "F:3");
        //         return _read(ptrs[i], pos - workingPos);
        //     } else {
        //         workingPos += here;
        //     }
        // }
    }

    uint16 internal constant DATA_PRE_OFFSET = 1; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                WRITE TO STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function _write(bytes memory data) internal returns (address _pointer, uint8 len) {
        uint256 header = 0x60_12_59_81_38_03_80_92_59_39_F3_64_6F_74_6E_75_67_67_00;

        uint256 prefix = ShiftLib.select160(data, 0);

        uint256 lenr = data.length;

        uint256 keklen = lenr - 32 - 19;

        assembly {
            len := and(prefix, 0xff)
            prefix := shr(8, prefix)

            let check := mload(add(add(data, 0x20), sub(lenr, 0x20)))

            let kek := keccak256(add(data, add(0x20, 19)), keklen)

            if iszero(eq(check, kek)) {
                mstore(0, "O:5")
                revert(0x0, 0x06)
            }

            if iszero(eq(prefix, header)) {
                mstore(0, "O:4")
                revert(0x0, 0x06)
            }

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
    function _read(uint168 _pointer, uint8 num) internal view returns (DotnuggV1Read memory res) {
        address addr = address(uint160(_pointer));

        uint16 offset = DATA_PRE_OFFSET + 32;

        bytes memory code = bytes.concat(new bytes(32), addr.code);

        // get len
        uint8 len = ShiftLib.select8(code, offset);

        require(num + 1 <= len, "P:x");

        uint16 checker = (offset + 1) + (num) * 2;

        uint16 biggeroffset = len * 2;

        uint16 start = uint16(ShiftLib.select16(code, checker)) + biggeroffset + offset;

        uint16 end = (len == num + 1)
            ? uint16(code.length)
            : ShiftLib.select16(code, checker + 2) + biggeroffset + offset;

        require(end >= uint16(start), "P:y");

        uint16 size = end - start;

        uint8 extra = uint8((size) % 0x20);

        // this can go below zero for the first nugg in the list if the conditions are right
        // but if the keccack is in the front then it will be enough buffer to ensure that never happens
        if (extra > 0) start -= (0x20 - (size % 0x20));

        size = end - start;

        require(size % 0x20 == 0, "P:z");

        res.dat = new uint256[]((size / 0x20));

        for (uint16 i = 0; i < res.dat.length; i++) {
            res.dat[i] = ShiftLib.select256(code, start + i * 0x20);
        }

        // mask keccak away from first array element if needed
        if (extra != 0) {
            res.dat[0] = res.dat[0] & ShiftLib.mask(extra * 8);
        }
    }

    function lengthOf(uint8 feature) external view override returns (uint8 res) {
        return __lengths[feature];
    }

    function pointersOf(uint8 feature) external view override returns (uint168[] memory res) {
        return __pointers[feature];
    }

    function lengths() external view override returns (uint8[8] memory res) {
        return __lengths;
    }

    function pointers() external view override returns (uint168[][8] memory res) {
        return __pointers;
    }
}
