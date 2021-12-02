// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.4;

interface IDotNugg {
    function nuggify(
        bytes memory _collection,
        bytes[] memory _items,
        address _resolver,
        string memory name,
        string memory description,
        uint256 tokenId,
        bytes memory data
    ) external returns (string memory image);

    // struct Rlud {
    //     bool exists;
    //     uint8 r;
    //     uint8 l;
    //     uint8 u;
    //     uint8 d;
    // }

    // struct Anchor {
    //     Rlud radii;
    //     Coordinate coordinate;
    // }

    // struct Coordinate {
    //     uint8 a; // anchorId
    //     uint8 b; // yoffset
    //     bool exists;
    // }

    // struct Collection {
    //     uint8 width;
    //     uint8 height;
    //     uint8 numFeatures;
    //     uint256[][] defaults;
    // }

    // struct Item {
    //     uint8 feature;
    //     Pixel[] pallet;
    //     Version[] versions;
    // }

    // struct Version {
    //     uint8 width;
    //     uint8 height;
    //     Anchor anchor;
    //     // these must be in same order as canvas receivers, respectively
    //     Coordinate[] calculatedReceivers; // can be empty
    //     Coordinate[] staticReceivers; // can be empty
    //     Rlud expanders;
    //     bytes data;
    // }

    // struct Canvas {
    //     Matrix matrix;
    //     Anchor[] receivers;
    // }

    // struct Mix {
    //     uint8 feature;
    //     Version version;
    //     Matrix matrix;
    //     Anchor[] receivers;
    // }

    // struct Pixel {
    //     int8 zindex;
    //     Rgba rgba;
    //     bool exists;
    // }

    // struct Pallet {
    //     Pixel[] pixels;
    // }

    // struct Matrix {
    //     uint8 width;
    //     uint8 height;
    //     Pixel[][] data;
    //     uint8 currentUnsetX;
    //     uint8 currentUnsetY;
    //     bool init;
    //     uint8 startX;
    // }

    // struct Rgba {
    //     uint8 r;
    //     uint8 g;
    //     uint8 b;
    //     uint8 a;
    // }
}
