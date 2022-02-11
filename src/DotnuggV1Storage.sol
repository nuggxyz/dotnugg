// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {DotnuggV1Resolver} from "./DotnuggV1Resolver.sol";

import {IDotnuggV1Storage} from "./interfaces/IDotnuggV1Storage.sol";
import {DotnuggV1Calculated, DotnuggV1Read} from "./interfaces/DotnuggV1Files.sol";

import {ShiftLib} from "./libraries/ShiftLib.sol";

import "./_test/utils/forge.sol";

contract DotnuggV1Storage is IDotnuggV1Storage, DotnuggV1Resolver {
    address public immutable factory;

    address public trusted;

    address[8] private __pointers;
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

    function lengthOfex(uint8 feature) public returns (uint8) {
        address ptr = __pointers[feature];

        assembly {
            extcodecopy(ptr, 0x1F, 0x01, 0x01)
            log1(0x00, 0x00, mload(0x0))
            return(0x0, 0x01)
        }
    }

    function lengthOf(uint8 feature) public view override returns (uint8 a) {
        address ptr = __pointers[feature];

        assembly {
            extcodecopy(ptr, 0x1F, 0x01, 0x01)

            a := mload(0x00)
        }
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

        __pointers[feature] = loc;

        emit Write(feature, len, loc, msg.sender);
    }

    function exec(uint8[8] memory ids, bool base64) public view returns (string memory) {
        // return svg(calc(read(ids)), base64);
    }

    function exec(
        uint8 feature,
        uint8 pos,
        bool base64
    ) public view returns (string memory) {
        // return svg(calc(read(feature, pos)), base64);
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                 GET FILES
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    // function read(uint8 feature, uint8 pos) public view returns (DotnuggV1Read memory res) {
    //     res.dat = _read(feature, pos - 1);
    // }

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

    function read(uint8[8] memory ids) public returns (DotnuggV1Read[8] memory res) {
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) res[i] = read(i, ids[i]);
        }
    }

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint8 feature, uint8 num) public returns (DotnuggV1Read memory res) {
        require(num != 0 && num <= lengthOf(feature), "F:1");

        num = num - 1;

        address _pointer = __pointers[feature];

        uint8 len = lengthOf(feature);

        uint256[] memory dat;

        assembly {
            let index := add(add(DATA_PRE_OFFSET, 0x01), mul(num, 2))

            let dataStart := add(mul(len, 0x2), DATA_PRE_OFFSET)

            extcodecopy(_pointer, 0x1E, index, 0x2)

            let start := add(mload(0x00), dataStart)
            let end := 0

            switch eq(len, add(num, 1))
            case 1 {
                end := extcodesize(_pointer)
            }
            default {
                extcodecopy(_pointer, 0x1E, add(index, 2), 0x2)
                end := add(mload(0x00), dataStart)
            }

            let size := sub(end, start)

            let extra := sub(0x20, mod(size, 0x20))

            let trusize := add(extra, size)

            if iszero(eq(0, mod(trusize, 0x20))) {
                mstore(0x0, 0xffffffff)
                revert(0x0, 0x20)
            }

            function allocate(length) -> pos {
                pos := mload(0x40)
                mstore(0x40, add(pos, length))
            }

            let ret := add(size, add(0x20, extra))

            let ptr := allocate(ret)

            mstore(ptr, div(trusize, 0x20))

            extcodecopy(_pointer, add(ptr, add(0x20, extra)), start, size)

            log1(ptr, mul(32, 8), ptr)

            // mstore(tmp, ptr)
            dat := ptr
        }

        res.dat = dat;
    }

    // // there can only be max 255 items per feature, and so num can not be higher than 255
    // function _read2(uint8 feature, uint8 num) public returns (bytes memory res) {
    //     uint16 offset = DATA_PRE_OFFSET;

    //     address _pointer = __pointers[feature];

    //     // get len
    //     uint8 len = lengthOf(feature);

    //     require(num + 1 <= len, "P:x");

    //     uint16 checker = (offset + 1) + (num) * 2;

    //     uint16 biggeroffset = len * 2 + offset;

    //     assembly {
    //         extcodecopy(_pointer, 0x1E, checker, 0x2)

    //         let start := add(mload(0x00), biggeroffset)
    //         let end := 0

    //         switch eq(len, add(num, 1))
    //         case 1 {
    //             end := extcodesize(_pointer)
    //         }
    //         default {
    //             extcodecopy(_pointer, 0x1E, add(checker, 2), 0x2)
    //             end := add(mload(0x00), biggeroffset)
    //         }

    //         let size := sub(end, start)

    //         let extra := mod(size, 0x20)

    //         // assembly {

    //         let jum := sub(0x20, extra)

    //         let trusize := add(jum, size)

    //         if iszero(eq(0, mod(trusize, 0x20))) {
    //             mstore(0x0, 0xffffffff)
    //             revert(0x0, 0x20)
    //         }

    //         function allocate(length) -> pos {
    //             pos := mload(0x40)
    //             mstore(0x40, add(pos, length))
    //         }

    //         let ret := add(size, 0x20)

    //         let ptr := allocate(ret)

    //         mstore(ptr, size)

    //         extcodecopy(_pointer, add(ptr, 0x20), start, size)

    //         log1(ptr, add(size, 0x20), ptr)

    //         res := ptr
    //     }
    // }

    function pointerOf(uint8 feature) external view override returns (address res) {
        return __pointers[feature];
    }
}

// 1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc2401042069001
