// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import {Parser} from "./Parser.sol";

library Types {
    struct Rlud {
        bool exists;
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
        Rlud radii;
        Coordinate coordinate;
    }

    struct Coordinate {
        uint8 a; // anchorId
        uint8 b; // yoffset
        bool exists;
    }

    struct Version {
        uint8 width;
        uint8 height;
        Anchor anchor;
        // these must be in same order as canvas receivers, respectively
        Coordinate[] calculatedReceivers; // can be empty
        Coordinate[] staticReceivers; // can be empty
        Rlud expanders;
        bytes data;
    }

    struct Canvas {
        Matrix matrix;
        Anchor[] receivers;
    }

    struct Mix {
        uint8 feature;
        Version version;
        Matrix matrix;
        Anchor[] receivers;
        uint8 yoffset;
        uint8 xoffset;
    }

    struct Matrix {
        uint8 width;
        uint8 height;
        Parser.Memory version;
        uint8 currentUnsetX;
        uint8 currentUnsetY;
        bool init;
        uint8 startX;
    }
}
