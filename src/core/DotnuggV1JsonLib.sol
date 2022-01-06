// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {StringCastLib} from '../libraries/StringCastLib.sol';
import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Pixel} from '../types/Pixel.sol';
import {Version} from '../types/Version.sol';
import {Base64} from '../libraries/Base64.sol';

import {IDotnuggV1Metadata} from '../interfaces/IDotnuggV1Metadata.sol';

contract DotnuggV1JsonLib {
    using StringCastLib for uint256;
    using StringCastLib for uint8;

    using StringCastLib for address;

    function jsonBase64(bytes memory input) public pure returns (bytes memory res) {
        res = abi.encodePacked(Base64.PREFIX_JSON, Base64._encode(input));
    }

    function jsonUtf8(bytes memory input) public pure returns (bytes memory res) {
        res = abi.encodePacked('data:application/json;charset=UTF-8,', input);
    }

    function buildJson(
        IDotnuggV1Metadata.Memory memory data,
        string memory name,
        string memory desc,
        string memory img,
        bool base64
    ) external pure returns (bytes memory res) {
        for (uint8 i = 0; i < 8; i++) {
            res = abi.encodePacked(
                res,
                kv(
                    data.labels[i], //
                    data.ids[i] == 0 ? 'null' : ((uint256(i) << 8) | data.ids[i]).toAsciiString(),
                    i != 7
                )
            );
        }

        res = abi.encodePacked(
            '{', //
            kv('name', name, true),
            kv('description', desc, true),
            kv('image', img, true),
            obj('properties', res, false),
            '}'
        );

        if (base64) res = jsonBase64(res);
        else res = jsonUtf8(res);
    }

    function obj(
        string memory key,
        bytes memory value,
        bool comma
    ) internal pure returns (bytes memory res) {
        res = abi.encodePacked('"', key, '":{', value, '}', comma ? ',' : '');
    }

    function kv(
        string memory key,
        string memory value,
        bool comma
    ) internal pure returns (bytes memory res) {
        res = abi.encodePacked('"', key, '":"', value, '"', comma ? ',' : '');
    }
}
