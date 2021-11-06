// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import '../interfaces/IDotNugg.sol';

import '../libraries/Bytes.sol';
import '../libraries/BytesLib.sol';
import '../../libraries/Uint.sol';

library Decode {
    using Bytes for bytes;
    using BytesLib for bytes;
    using Uint256 for uint256;

    function parseCollection(bytes memory data) internal pure returns (IDotNugg.Collecion memory res) {
        res = _bytesToCollection(data);
    }

    function parseItem(bytes memory data) internal pure returns (Item memory res) {
        res = _bytesToBase(data);
    }

    function parseItemFeatureId(bytes memory data) internal pure returns (uint8 res) {
        res = uint8(data[11]); // FIXME - this cannot be right lol
    }

    function parseMix(Item memory item, uint8 versionIndex) internal pure returns (Mix memory res) {}

    function parseMatrix(
        bytes memory data,
        uint8 width,
        uint8 height
    ) internal pure returns (Matrix memory res) {
        res = MatrixLib.create(width, height);

        for (uint16 i = 0; i < data.length; i += Constants.GROUP_BYTE_LEN) {
            groups[index++] = _bytesToGroup(data.slice(i, Constants.GROUP_BYTE_LEN));
        }
    }

    // for danny to delete

    function _validateFile(bytes memory data) internal pure returns (bytes memory res) {
        require(data.length > 13);
        require(data.slice(0, Constants.FILE_HEADER.length).equal(Constants.FILE_HEADER));
        res = data.slice(Constants.FILE_HEADER.length, data.length - Constants.FILE_HEADER.length);
    }

    function _bytesToCollection(bytes memory data) internal pure returns (IDotNugg.Collection memory collection) {
        data = _validateFile(data);

        require(uint8(data[0]) == Constants.NUGG_FILETYPE_COLLECTION);

        collection.features = _bytesToFeatures((data.slice(uint8(data[2]) - Constants.FILE_HEADER.length, uint8(data[1]) * Constants.FEATURE_BYTE_LEN)));
    }

    function _bytesToBase(bytes memory data) internal pure returns (IDotNugg.Base memory base) {
        data = _validateFile(data);

        require(uint8(data[0]) == Constants.NUGG_FILETYPE_BASE);

        base.baseFeatures = _bytesToBaseFeatures((data.slice(uint8(data[4]) - Constants.FILE_HEADER.length, uint8(data[3]) * Constants.BASE_FEATURE_BYTE_LEN)));

        base.display.colors = _bytesToColors(data.slice(uint8(data[2]) - Constants.FILE_HEADER.length, uint8(data[1]) * Constants.COLOR_BYTE_LEN));

        base.display.len = _bytesToCoordinate(data[7], data[8]);

        base.display.groups = _bytesToGroups(data.slice(uint8(data[6]) - Constants.FILE_HEADER.length, uint16(uint8(data[5])) * Constants.GROUP_BYTE_LEN));
    }

    function _bytesToAttribute(bytes memory data) internal pure returns (IDotNugg.Attribute memory attribute) {
        data = _validateFile(data);
        require(uint8(data[0]) == Constants.NUGG_FILETYPE_ATTRIBUTE);

        attribute.feature.id = uint8(data[11]);
        attribute.anchor = _bytesToCoordinate(data.slice(13 - Constants.FILE_HEADER.length, 2));
        attribute.expanders = _bytesToExpanderGroup(data.slice(uint8(data[4]) - Constants.FILE_HEADER.length, uint8(data[3]) * Constants.EXPANDER_BYTE_LEN));
        attribute.display.len = _bytesToCoordinate(data[7], data[8]);
        attribute.display.colors = _bytesToColors(data.slice(uint8(data[2]) - Constants.FILE_HEADER.length, uint8(data[1]) * Constants.COLOR_BYTE_LEN));
        attribute.display.groups = _bytesToGroups(data.slice(uint8(data[6]) - Constants.FILE_HEADER.length, uint8(data[5]) * Constants.GROUP_BYTE_LEN));
    }

    function _bytesToFeatures(bytes memory data) internal pure returns (IDotNugg.Feature[] memory features) {
        require(data.length % Constants.FEATURE_BYTE_LEN == 0, 'DN_DECODER:ARGUMENTS: length of data must be 6');
        features = new IDotNugg.Feature[](data.length / Constants.FEATURE_BYTE_LEN);
        uint8 index = 0;
        for (uint8 i = 0; i < data.length; i += Constants.FEATURE_BYTE_LEN) {
            features[index++] = _bytesToFeature(data.slice(i, Constants.FEATURE_BYTE_LEN));
        }
    }

    function _bytesToFeature(bytes memory data) internal pure returns (IDotNugg.Feature memory feature) {
        require(data.length == Constants.FEATURE_BYTE_LEN, 'DN_DECODER:FEATURE: length of data must be FEATURE_BYTE_LEN');

        feature.id = uint8(data[0]);
    }

    function _bytesToColors(bytes memory data) internal pure returns (INuggIn.Color[] memory colors) {
        require(data.length % Constants.COLOR_BYTE_LEN == 0, 'DN_DECODER:COLORS: length of data must be ');
        colors = new INuggIn.Color[](data.length / Constants.COLOR_BYTE_LEN);
        uint16 index = 0;
        for (uint16 i = 0; i < data.length; i += Constants.COLOR_BYTE_LEN) {
            colors[index++] = _bytesToColor(data.slice(i, Constants.COLOR_BYTE_LEN));
        }
    }

    function _bytesToColor(bytes memory data) internal pure returns (INuggIn.Color memory color) {
        require(data.length == Constants.COLOR_BYTE_LEN, 'DN_DECODER:COLOR: length of bytes must be Constants.COLOR_BYTE_LEN');
        color.exists = true;
        color.id = uint8(data[0]);
        color.layer = uint8(data[1]);
        color.rgba.r = uint8(data[2]);
        color.rgba.g = uint8(data[3]);
        color.rgba.b = uint8(data[4]);
        color.rgba.a = uint8(data[5]);
    }

    function _bytesToExpanderGroup(bytes memory data) internal pure returns (IDotNugg.ExpanderGroup memory expanderGroup) {
        require(data.length % Constants.EXPANDER_BYTE_LEN == 0, 'DN_DECODER:EXPANDERGROUP: length of DATA invaliid');
        for (uint16 i = 0; i < data.length; i += Constants.EXPANDER_BYTE_LEN) {
            if (uint8(data[i]) == 82) {
                // R
                expanderGroup.right = _bytesToExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else if (uint8(data[i]) == 114) {
                // r
                expanderGroup.right2 = _bytesToExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else if (uint8(data[i]) == 76) {
                // L
                expanderGroup.left = _bytesToExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else if (uint8(data[i]) == 108) {
                // l
                expanderGroup.left2 = _bytesToExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else if (uint8(data[i]) == 85) {
                // U
                expanderGroup.up = _bytesToVerticalExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else if (uint8(data[i]) == 68) {
                // D
                expanderGroup.down = _bytesToVerticalExpander(data.slice(i, Constants.EXPANDER_BYTE_LEN));
            } else {
                require(false, 'DN_DECODER:EXPANDERGROUP: invalid expander type found');
            }
        }
    }

    function _bytesToGroups(bytes memory data) internal pure returns (INuggIn.Group[] memory groups) {
        require(data.length % Constants.GROUP_BYTE_LEN == 0, 'DN_DECODER:GROUPS: length of data must be 6');
        groups = new INuggIn.Group[](data.length / Constants.GROUP_BYTE_LEN);
        uint16 index = 0;
        for (uint16 i = 0; i < data.length; i += Constants.GROUP_BYTE_LEN) {
            groups[index++] = _bytesToGroup(data.slice(i, Constants.GROUP_BYTE_LEN));
        }
    }

    function _bytesToGroup(bytes memory data) internal pure returns (INuggIn.Group memory group) {
        require(data.length == 2, 'DN_DECODER:GROUP: length of group must be 2');
        group.colorID = uint8(data[0]);
        group.len = uint8(data[1]);
    }

    function _bytesToBaseFeatures(bytes memory data) internal pure returns (IDotNugg.BaseFeature[] memory baseFeatures) {
        require(data.length % Constants.BASE_FEATURE_BYTE_LEN == 0, 'DN_DECODER:ARGUMENTS: length of data must be 6');

        IDotNugg.BaseFeature[] memory tmp = new IDotNugg.BaseFeature[](data.length / Constants.BASE_FEATURE_BYTE_LEN);
        uint16 index = 0;
        for (uint16 i = 0; i < data.length; i += Constants.BASE_FEATURE_BYTE_LEN) {
            tmp[index++] = _bytesToBaseFeature(data.slice(i, Constants.BASE_FEATURE_BYTE_LEN));
        }
        baseFeatures = new IDotNugg.BaseFeature[](tmp.length);
        for (uint16 i = 0; i < tmp.length; i++) {
            baseFeatures[tmp[i].feature.id] = tmp[i];
        }
    }

    function _bytesToBaseFeature(bytes memory data) internal pure returns (IDotNugg.BaseFeature memory baseFeature) {
        require(data.length == Constants.BASE_FEATURE_BYTE_LEN, 'DN_DECODER:BASEFEATURE: length of data must be Constants.BASE_FEATURE_BYTE_LEN');
        baseFeature.feature.id = uint8(data[0]);
        baseFeature.anchor = _bytesToCoordinate(data[1], data[2]);
        baseFeature.arguments = _bytesToArguments(data.slice(3, Constants.ARGUMENTS_BYTE_LEN));
        baseFeature.exists = true;
    }

    function _bytesToArguments(bytes memory data) internal pure returns (IDotNugg.Arguments memory arguments) {
        require(data.length == 6, 'DN_DECODER:ARGUMENTS: length of data must be 6');
        arguments.l = uint8(data[0]);
        arguments.r = uint8(data[1]);
        arguments.u = uint8(data[2]);
        arguments.d = uint8(data[3]);
        arguments.z = uint8(data[4]);
        arguments.c = uint8(data[5]);
    }

    function _bytesToCoordinate(bytes memory data) internal pure returns (INuggIn.Coordinate memory coordinate) {
        require(data.length == 2, 'DN_DECODER:COORDINATE: length of data must be 2');
        coordinate = _bytesToCoordinate(data[0], data[1]);
    }

    function _bytesToCoordinate(bytes1 x, bytes1 y) internal pure returns (INuggIn.Coordinate memory coordinate) {
        coordinate.x = uint8(x);
        coordinate.y = uint8(y);
    }
}
