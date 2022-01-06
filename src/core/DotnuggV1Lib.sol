// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import {IDotnuggV1Metadata} from '../interfaces/IDotnuggV1Metadata.sol';

import {BitReader} from '../libraries/BitReader.sol';
import {Base64} from '../libraries/Base64.sol';

import {Calculator} from '../logic/Calculator.sol';
import {Matrix} from '../logic/Matrix.sol';
import {DotnuggV1SvgLib} from './DotnuggV1SvgLib.sol';
import {DotnuggV1JsonLib} from './DotnuggV1JsonLib.sol';

import {ShiftLib} from '../libraries/ShiftLib.sol';
import {Base64} from '../libraries/Base64.sol';

import {Version} from '../types/Version.sol';
import {Types} from '../types/Types.sol';
import {DotnuggV1StorageProxy} from './DotnuggV1StorageProxy.sol';
import {StringCastLib} from '../libraries/StringCastLib.sol';

contract DotnuggV1Lib is DotnuggV1SvgLib, DotnuggV1JsonLib {
    using BitReader for BitReader.Memory;

    function process(
        uint256[][] memory files,
        IDotnuggV1Metadata.Memory memory data,
        uint8 width
    ) public view returns (uint256[] memory resp) {
        require(data.version == 1, 'V1s');

        // require(width <= 64 && width > 4, 'V1:SIZE');

        // if (width % 2 == 0) width--;

        Version.Memory[][] memory versions = parse(files, data.xovers, data.yovers);

        Types.Matrix memory old = Calculator.combine(8, width, versions);

        resp = old.version.bigmatrix;
    }

    function parse(
        uint256[][] memory data,
        uint8[] memory xovers,
        uint8[] memory yovers
    ) public view returns (Version.Memory[][] memory m) {
        m = new Version.Memory[][](data.length);

        for (uint256 j = 0; j < data.length; j++) {
            (bool empty, BitReader.Memory memory reader) = BitReader.init(data[j]);

            if (empty) continue;

            // indicates dotnuggV1 encoded file
            require(reader.select(32) == 0x420690_01, 'DEC:PI:0');

            uint256 feature = reader.select(3);

            uint256 id = reader.select(8);

            uint256[] memory pallet = Version.parsePallet(reader, id, feature);

            uint256 versionLength = reader.select(2) + 1;

            m[j] = new Version.Memory[](versionLength);

            for (uint256 i = 0; i < versionLength; i++) {
                m[j][i].data = Version.parseData(reader, feature, xovers, yovers);

                m[j][i].receivers = Version.parseReceivers(reader);

                (uint256 width, uint256 height) = Version.getWidth(m[j][i]);

                m[j][i].minimatrix = Version.parseMiniMatrix(reader, width, height);

                m[j][i].pallet = pallet;
            }
        }
    }

    function decompress(uint256[] memory input) public pure returns (uint256[] memory res) {
        res = new uint256[]((input[input.length - 1] >> 240));

        uint256 counter = 0;

        for (uint256 i = 0; i < input.length; i++) {
            uint256 numzeros = input[i] & 0xf;

            if (numzeros == 0xf) {
                numzeros = input[i++] >> 4;
            }

            for (uint256 j = 0; j < numzeros; j++) {
                // skips a row, keeping it at zero
                counter++;
            }

            res[counter++] = input[i] >> 4;
        }
    }

    function compress(uint256[] memory input, uint256 data) public pure returns (uint256[] memory res) {
        uint256 counter;
        uint256 rescounter;
        uint256 zerocount;

        do {
            if (input[counter] == 0) {
                zerocount++;
                continue;
            }

            if (zerocount > 14) {
                input[rescounter++] = (zerocount << 4) | 0xf;
                zerocount = 0;
            }

            input[rescounter++] = (input[counter] << 4) | zerocount;

            zerocount = 0;
        } while (++counter < input.length);

        if (zerocount > 14) {
            input[rescounter++] = (zerocount << 4) | 0xf;
            zerocount = 0;
        }

        input[rescounter++] = (data << 4) | zerocount | ((input.length + 1) << 240);

        Version.setArrayLength(input, rescounter);

        return input;
    }

    function base64(bytes memory input) public pure returns (bytes memory res) {
        res = Base64._encode(input);
    }
}
