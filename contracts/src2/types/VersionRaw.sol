// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

library VersionRaw {
    function setZ(uint256 input, uint256 z) internal view {
        require(z <= 0xf, 'VERS:SETZ:0');
        input |= z << 78;
    }

    function getZ(uint256 input) internal view returns (uint256 res) {
        res = (input >> 78) & 0xf;
    }

    function getReceiver(
        uint256 input,
        uint256 index,
        bool calculated
    ) internal view returns (uint256 x, uint256 y) {}

    function setReceiver(
        uint256 input,
        uint256 index,
        bool calculated,
        uint256 x,
        uint256 y
    ) internal view returns (uint256 res) {}

    function getOffset(uint256 input)
        internal
        view
        returns (
            bool negX,
            uint256 diffX,
            bool negY,
            uint256 diffY
        )
    {}

    function setOffset(
        uint256 input,
        bool negX,
        uint256 diffX,
        bool negY,
        uint256 diffY
    ) internal view returns (uint256 res) {}

    function getAnchor(uint256 input) internal view returns (uint256 x, uint256 y) {}

    function setAnchor(
        uint256 input,
        uint256 x,
        uint256 y
    ) internal view returns (uint256 res) {}

    function getExpanders(uint256 input)
        internal
        view
        returns (
            uint256 r,
            uint256 l,
            uint256 u,
            uint256 d
        )
    {}

    function setExpanders(
        uint256 input,
        uint256 r,
        uint256 l,
        uint256 u,
        uint256 d
    ) internal view returns (uint256 res) {}

    function getRadii(uint256 input)
        internal
        view
        returns (
            uint256 r,
            uint256 l,
            uint256 u,
            uint256 d
        )
    {}

    function setRadii(
        uint256 input,
        uint256 r,
        uint256 l,
        uint256 u,
        uint256 d
    ) internal view returns (uint256 res) {}

    function getWidth(uint256 input) internal view returns (uint256 width, uint256 height) {}

    function setWidth(
        uint256 input,
        uint256 width,
        uint256 height
    ) internal view returns (uint256 res) {}

    function setFeature(uint256 input, uint256 feature) internal view returns (uint256 res) {}

    function getFeature(uint256 input) internal view returns (uint256 feature) {}

    function setPalletColor(
        uint256[] memory input,
        uint256 index,
        uint256 r,
        uint256 g,
        uint256 b,
        uint256 a,
        uint256 z
    ) internal view returns (uint256[] memory res) {}

    function getPalletColor(uint256[] memory input, uint256 index)
        internal
        view
        returns (
            uint256 r,
            uint256 g,
            uint256 b,
            uint256 a,
            uint256 z
        )
    {}
}
