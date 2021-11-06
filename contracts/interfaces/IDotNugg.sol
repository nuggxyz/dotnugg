pragma solidity 0.8.4;

import '../interfaces/INuggIn.sol';

interface IDotNugg {
    struct Rlud {
        uint8 r;
        uint8 l;
        uint8 u;
        uint8 d;
    }

    struct Rgba {
        uint8 r;
        uint8 g;
        uint8 b;
        uint8 a;
    }

    struct Anchor {
        Coordinate coordinate;
        Rlud radii;
    }

    struct Coordinate {
        uint8 x;
        uint8 y;
    }

    struct Base {
        Matrix matrix;
        Coordinate[] anchors;
    }

    struct Item {
        uint8 feature;
        Pixel[] pallet;
        Version[] versions;
    }

    struct Version {
        Anchor anchor;
        Coordinate[] childAnchors; // can be empty
        Rlud expanders;
        bytes data;
    }

    struct Mix {
        uint8 feature;
        Version version;
        Matrix matrix;
    }

    struct Pixel {
        Rgba rgba;
        int8 layer;
    }

    struct Matrix {
        uint8 width;
        uint8 height;
        // uint8 radius;
        Pixel[][] data;
        uint8 currentUnsetX;
        uint8 currentUnsetY;
        bool init;
    }
}
