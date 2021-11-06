pragma solidity 0.8.4;

interface IDotNugg {
    function nuggify(
        bytes calldata _collection,
        bytes[] calldata _items,
        address _resolver,
        bytes calldata data
    ) external view returns (string memory image);

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
    }

    struct Coordinate {
        uint8 a;
        uint8 b;
    }

    struct Collection {
        uint8 width;
        uint8 height;
        uint8 numFeatures;
        bytes[] defaults;
    }

    struct Item {
        uint8 feature;
        Pixel[] pallet;
        Version[] versions;
    }

    struct Version {
        uint8 width;
        Coordinate anchor;
        Coordinate[] calculatedReceivers; // can be empty
        Coordinate[] staticReceivers; // can be empty
        Rlud expanders;
        Rlud radii;
        bytes data;
    }

    struct Canvas {
        Matrix matrix;
        Coordinate[] receivers;
    }

    struct Mix {
        uint8 feature;
        Version version;
        Matrix matrix;
    }

    struct Pixel {
        int8 zindex;
        Rgba rgba;
        bool exists;
    }

    struct Matrix {
        uint8 width;
        uint8 height;
        Pixel[][] data;
        uint8 currentUnsetX;
        uint8 currentUnsetY;
        bool init;
    }
}
