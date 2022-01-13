// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;
import {IDotnuggV1StorageProxy} from '../interfaces/IDotnuggV1StorageProxy.sol';
import {IDotnuggV1Implementer} from '../interfaces/IDotnuggV1Implementer.sol';

import {SSTORE2} from '../libraries/SSTORE2.sol';
import {SafeCastLib} from '../libraries/SafeCastLib.sol';

contract DotnuggV1StorageProxy is IDotnuggV1StorageProxy {
    using SafeCastLib for uint256;
    using SafeCastLib for uint16;

    address public immutable dotnuggv1;

    address public implementer;

    event log(string);
    event logs(bytes);

    event log_address(address);
    event log_bytes32(bytes32);
    event log_int(int256);
    event log_uint(uint256);
    event log_bytes(bytes);
    event log_string(string);

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    constructor() {
        dotnuggv1 = msg.sender;
    }

    function init(address _implementer) external {
        require(implementer == address(0) && msg.sender == dotnuggv1, 'C:0');
        implementer = _implementer;
    }

    // Mapping from token ID to owner address
    mapping(uint8 => uint200[]) sstore2Pointers;
    mapping(uint8 => uint8) featureLengths;

    function stored(uint8 feature) public view override returns (uint8 res) {
        return featureLengths[feature];
    }

    /* ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                TRUSTED
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ */

    function unsafeBulkStore(bytes[] calldata data) public override {
        for (uint8 i = 0; i < 8; i++) {
            // uint8 len = data[i].length.safe8();

            if (data[i].length > 0) {
                // emit log_uint(i);
                (address ptr, uint8 len) = SSTORE2.write(data[i]);

                bool ok = IDotnuggV1Implementer(implementer).dotnuggV1StoreCallback(msg.sender, i, len, ptr);

                require(ok, 'C:0');

                sstore2Pointers[i].push(uint168(uint160(ptr)) | (uint168(len) << 160));

                featureLengths[i] += len;
            }
        }
    }

    // function unsafeBulkStore(uint256[][][] calldata data) public override {
    //     uint256[] memory tmpPointers = new uint256[](8);

    //     for (uint8 i = 0; i < 8; i++) {
    //         // uint8 len = data[i].length.safe8();

    //         address ptr;

    //         bytes memory buffer;

    //         uint8 count;

    //         while (i < 8) {
    //             data[i].length.safe8();

    //             bytes memory enc = abi.encode(data[i]);
    //             // bytes memory tmp = bytes.concat(buffer, abi.encode(data[i]));
    //             require(enc.length <= 23000, 'U:2');

    //             if (buffer.length + enc.length <= 23000) {
    //                 uint256 start = buffer.length.safe16();
    //                 buffer = bytes.concat(buffer, enc);
    //                 uint256 end = buffer.length.safe16();
    //                 tmpPointers[i] = (start << 16) | (end);
    //                 count++;

    //                 if (i < 8) {
    //                     i++;
    //                     continue;
    //                 } else {
    //                     break;
    //                 }
    //             }
    //             i--;
    //             break;
    //         }

    //         // if (len > 0) {
    //         ptr = SSTORE2.write(buffer);

    //         for (uint8 j = (i + 1) - count; j < count; j++) {
    //             uint8 len = uint8(data[j].length);

    //             bool ok = IDotnuggV1Implementer(implementer).dotnuggV1StoreCallback(msg.sender, j, len, ptr);

    //             require(ok, 'C:0');

    //             uint256 fin = tmpPointers[j];

    //             fin |= uint160(ptr);

    //             sstore2Pointers[j].push((uint200(fin) << 168) | (uint200(len) << 160) | uint200(uint160(ptr)));

    //             featureLengths[j] += len;
    //         }

    //         // }
    //     }
    // }

    function store(uint8 feature, uint256[][] calldata data) public override returns (uint8 res) {
        require(feature < 8, 'F:3');

        // uint8 len = data.length.safe8();

        // require(len > 0, 'F:0');

        // address ptr = SSTORE2.write(data);

        // bool ok = IDotnuggV1Implementer(implementer).dotnuggV1StoreCallback(msg.sender, feature, len, ptr);

        // require(ok, 'C:0');

        // sstore2Pointers[feature].push(uint168(uint160(ptr)) | (uint168(len) << 160));

        // featureLengths[feature] += len;

        // return len;
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

        uint200[] memory ptrs = sstore2Pointers[feature];

        address stor;
        uint8 storePos;

        // uint16 start;
        // uint16 end;

        uint8 workingPos;

        for (uint256 i = 0; i < ptrs.length; i++) {
            uint8 here = uint8(ptrs[i] >> 160);
            if (workingPos + here > pos) {
                // start = uint16(ptrs[i] >> 200);
                // end = uint16((ptrs[i] >> 168));
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
