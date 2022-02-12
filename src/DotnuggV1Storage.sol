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

        address loc = _write(data);

        __pointers[feature] = loc;

        uint8 len = lengthOf(feature);

        require(len > 0, "F:0");

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

    function _write(bytes memory data) internal returns (address _pointer) {
        uint256 header = 0x3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00;
        // uint256 header = 0x3D6020808080380380918539038082848153208351140290F300042000006900;

        uint256 dataHeader;
        assembly {
            dataHeader := mload(add(data, 32))
        }

        require(header == dataHeader, "");

        assembly {
            log1(add(data, 0x20), mload(data), data)
            // Deploy a new contract with the generated creation code.
            // We start 32 bytes into the code to avoid copying the byte length.
            _pointer := create(0, add(data, 0x20), mload(data))
        }

        require(_pointer != address(0), "DEPLOYMENT_FAILED:1");
        require(_pointer.code.length != 0, "DEPLOYMENT_FAILED:2");
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                READ FROM STORAGE
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function read(uint8[8] memory ids) public view returns (DotnuggV1Read[8] memory res) {
        for (uint8 i = 0; i < 8; i++) {
            if (ids[i] != 0) res[i] = read(i, ids[i]);
        }
    }

    // there can only be max 255 items per feature, and so num can not be higher than 255
    function read(uint8 feature, uint8 num) public view returns (DotnuggV1Read memory res) {
        require(num != 0 && num <= lengthOf(feature), "F:1");

        num = num - 1;

        address _pointer = __pointers[feature];

        uint8 len = lengthOf(feature);

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

            let ret := add(size, add(0x20, extra))

            let ptr := mload(0x40)

            mstore(0x40, add(ptr, ret))

            mstore(ptr, div(trusize, 0x20))

            extcodecopy(_pointer, add(ptr, add(0x20, extra)), start, size)

            mstore(mload(res), ptr)
        }
    }

    function pointerOf(uint8 feature) external view override returns (address res) {
        return __pointers[feature];
    }
}
