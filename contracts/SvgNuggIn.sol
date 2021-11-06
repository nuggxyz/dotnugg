// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './interfaces/IDotNugg.sol';

import '../erc165/ERC165.sol';

/**
 * @dev Bytes1 operations.
 */
contract SvgNuggIn is INuggIn, ERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, INuggIn) returns (bool) {
        return interfaceId == type(IFileResolver).interfaceId || interfaceId == type(IColorResolver).interfaceId || super.supportsInterface(interfaceId);
    }

    function resolveFile(IDotNugg.Matrix calldata display, bytes calldata data) public pure override returns (bytes memory res, string memory fileType) {
        uint256 svgWidth = display.len.x * pixelWidth;

        bytes memory header = abi.encodePacked(
            "<svg viewBox='0 0 ",
            svgWidth.toString(),
            ' ',
            svgWidth.toString(),
            "' width='",
            svgWidth.toString(),
            "' height='",
            svgWidth.toString(),
            "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        );

        bytes memory rects = getSvgRects(display, pixelWidth);

        return abi.encodePacked(header, rects, '</svg>');
    }

    function resolveColor(IDotNugg.Matrix memory display, uint256 pixelWidth) public pure override returns (bytes memory) {
        uint256 svgWidth = display.len.x * pixelWidth;

        bytes memory header = abi.encodePacked(
            "<svg viewBox='0 0 ",
            svgWidth.toString(),
            ' ',
            svgWidth.toString(),
            "' width='",
            svgWidth.toString(),
            "' height='",
            svgWidth.toString(),
            "' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>\n"
        );

        bytes memory rects = getSvgRects(display, pixelWidth);

        return abi.encodePacked(header, rects, '</svg>');
    }

    function getSvgRects(IDotNugg.Matrix memory matrix, uint256 pixelWidth) internal pure returns (bytes memory res) {
        uint8 lastX = 0;

        while (matrix.next()) {
            while (matrix.next() && lastX < matrix.currentX()) {
                // && colors are the same
                res = abi.encodePacked(
                    res,
                    getRekt(display.colors[ittr.current().colorID].rgba, x * pixelWidth, y * pixelWidth, pixelWidth, remaining * pixelWidth)
                );
                lastX = matrix.currentX();
            }

            uint256 x_offset = x * pixelWidth;
            uint256 y_offset = y * pixelWidth;
            uint256 size = pixelWidth;
            uint256 width = pixelWidth * ittr.current().len;
            res = abi.encodePacked(res, getRekt(display.colors[ittr.current().colorID].rgba, x_offset, y_offset, size, width));

            x += ittr.current().len;
        }
    }

    function getRekt(
        IDotNugg.Rgba memory rgba,
        uint256 x,
        uint256 y,
        uint256 xlen,
        uint256 ylen
    ) internal pure returns (bytes memory res) {
        if (rgba.a == 0) return '';

        (rgba, ) = rgba.combine(IDotNugg.Rgba({r: 0, g: 255, b: 0, a: 99}));

        res = abi.encodePacked(
            "\t<rect fill='#",
            rgba.toAscii(),
            "' x='",
            x.toString(),
            "' y='",
            y.toString(),
            "' height='",
            xlen.toString(),
            "' width='",
            ylen.toString(),
            "'/>\n"
        );
    }
}
