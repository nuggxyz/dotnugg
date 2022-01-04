// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

interface IDotnuggV1Metadata {
    struct Memory {
        uint8[] ids;
        uint8[] xovers;
        uint8[] yovers;
        uint256 version;
        address implementer;
        // uint256 renderedAt;
        // string name;
        // string desc;
        uint256 artifactId;
        // address owner;
        string[] labels;
        // json data
        string[] jsonKeys;
        string[] jsonValues;
        // svg styling
        string[] styles;
        string globalStyle;
        // extra
        bytes data;
    }
}
