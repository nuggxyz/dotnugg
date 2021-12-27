// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import './Matrix.sol';
import './Rgba.sol';
import './Anchor.sol';

import '../types/Version.sol';
import '../types/Pixel.sol';

import '../types/Types.sol';

library Calculator {
    using Rgba for Types.Rgba;
    using Matrix for Types.Matrix;
    using Pixel for uint256;

    /**
     * @notice
     * @devg
     */
    function postionForCanvas(Types.Canvas memory canvas, Types.Mix memory mix) internal pure {
        Types.Anchor memory receiver = canvas.receivers[mix.feature];
        Types.Anchor memory anchor = mix.version.anchor;

        mix.xoffset = receiver.coordinate.a > anchor.coordinate.a ? receiver.coordinate.a - anchor.coordinate.a : 0;
        mix.yoffset = receiver.coordinate.b > anchor.coordinate.b ? receiver.coordinate.b - anchor.coordinate.b : 0;

        canvas.matrix.moveTo(mix.xoffset, mix.yoffset, mix.matrix.width, mix.matrix.height);
    }

    /**
     * @notice
     * @dev
     */
    function formatForCanvas(Types.Canvas memory canvas, Types.Mix memory mix) internal pure {
        Types.Anchor memory receiver = canvas.receivers[mix.feature];
        Types.Anchor memory anchor = mix.version.anchor;

        if (mix.version.expanders.l != 0 && anchor.radii.l != 0 && anchor.radii.l <= receiver.radii.l) {
            uint8 amount = receiver.radii.l - anchor.radii.l;
            mix.matrix.addColumnsAt(mix.version.expanders.l - 1, amount);
            anchor.coordinate.a += amount;
            if (mix.version.expanders.r > 0) mix.version.expanders.r += amount;
        }
        if (mix.version.expanders.r != 0 && anchor.radii.r != 0 && anchor.radii.r <= receiver.radii.r) {
            mix.matrix.addColumnsAt(mix.version.expanders.r - 1, receiver.radii.r - anchor.radii.r);
        }
        if (mix.version.expanders.d != 0 && anchor.radii.d != 0 && anchor.radii.d <= receiver.radii.d) {
            uint8 amount = receiver.radii.d - anchor.radii.d;
            mix.matrix.addRowsAt(mix.version.expanders.d, amount);
            anchor.coordinate.b += amount;
            if (mix.version.expanders.u > 0) mix.version.expanders.u += amount;
        }
        if (mix.version.expanders.u != 0 && anchor.radii.u != 0 && anchor.radii.u <= receiver.radii.u) {
            mix.matrix.addRowsAt(mix.version.expanders.u, receiver.radii.u - anchor.radii.u);
        }
    }

    function pickVersionIndex(Types.Canvas memory canvas, Version.Memory[] memory versions) internal pure returns (uint8) {
        require(versions.length > 0, 'CALC:PVI:0');
        if (versions.length == 1) {
            return 0;
        }
        uint8 index = uint8(versions.length) - 1;

        uint256 feature = (versions[0].data >> 75) & ShiftLib.mask(3);

        while (index > 0) {
            uint256 bits = (versions[index].data >> 27) & ShiftLib.mask(24);
            Types.Rlud memory anchorRadii = Types.Rlud({
                r: uint8((bits >> 18) & ShiftLib.mask(6)),
                l: uint8((bits >> 12) & ShiftLib.mask(6)),
                u: uint8((bits >> 6) & ShiftLib.mask(6)),
                d: uint8((bits) & ShiftLib.mask(6)),
                exists: true
            });

            if (checkRluds(anchorRadii, canvas.receivers[feature].radii)) {
                return index;
            }
            index = index - 1;
        }

        return 0;
    }

    function checkRluds(Types.Rlud memory r1, Types.Rlud memory r2) internal pure returns (bool) {
        return (r1.r <= r2.r && r1.l <= r2.l) || (r1.u <= r2.u && r1.d <= r2.d);
    }

    function setMix(
        Types.Mix memory res,
        Version.Memory[] memory versions,
        uint8 versionIndex
    ) internal pure {
        uint256 radiiBits = (versions[versionIndex].data >> 27) & ShiftLib.mask(24);
        uint256 expanderBits = (versions[versionIndex].data >> 3) & ShiftLib.mask(24);

        (uint256 x, uint256 y) = Version.getAnchor(versions[versionIndex]);

        (uint256 width, uint256 height) = Version.getWidth(versions[versionIndex]);

        res.version.width = uint8(width);
        res.version.height = uint8(height);
        res.version.anchor = Types.Anchor({
            radii: Types.Rlud({
                r: uint8((radiiBits >> 18) & ShiftLib.mask(6)),
                l: uint8((radiiBits >> 12) & ShiftLib.mask(6)),
                u: uint8((radiiBits >> 6) & ShiftLib.mask(6)),
                d: uint8((radiiBits >> 0) & ShiftLib.mask(6)),
                exists: true
            }),
            coordinate: Types.Coordinate({a: uint8(x), b: uint8(y), exists: true})
        });
        res.version.expanders = Types.Rlud({
            r: uint8((expanderBits >> 18) & ShiftLib.mask(6)),
            l: uint8((expanderBits >> 12) & ShiftLib.mask(6)),
            u: uint8((expanderBits >> 6) & ShiftLib.mask(6)),
            d: uint8((expanderBits >> 0) & ShiftLib.mask(6)),
            exists: true
        });
        res.version.calculatedReceivers = new Types.Coordinate[](8);

        res.version.staticReceivers = new Types.Coordinate[](8);

        for (uint256 i = 0; i < 8; i++) {
            (uint256 _x, uint256 _y, bool exists) = Version.getReceiverAt(versions[versionIndex], i, false);
            if (exists) {
                res.version.staticReceivers[i].a = uint8(_x);
                res.version.staticReceivers[i].b = uint8(_y);
                res.version.staticReceivers[i].exists = true;
            }
        }

        for (uint256 i = 0; i < 8; i++) {
            (uint256 _x, uint256 _y, bool exists) = Version.getReceiverAt(versions[versionIndex], i, true);
            if (exists) {
                res.version.calculatedReceivers[i].a = uint8(_x);
                res.version.calculatedReceivers[i].b = uint8(_y);
                res.version.calculatedReceivers[i].exists = true;
            }
        }

        // TODO - receivers?
        res.xoffset = 0;
        res.yoffset = 0;
        res.receivers = new Types.Anchor[](res.receivers.length);
        res.feature = uint8((versions[versionIndex].data >> 75) & ShiftLib.mask(3));
        res.matrix.set(versions[versionIndex], width, height);
    }

    function updateReceivers(Types.Canvas memory canvas, Types.Mix memory mix) internal pure {
        for (uint8 i = 0; i < mix.receivers.length; i++) {
            Types.Anchor memory m = mix.receivers[i];
            if (m.coordinate.exists) {
                m.coordinate.a += mix.xoffset;
                m.coordinate.b += mix.yoffset;
                canvas.receivers[i] = m;
            }
        }
    }

    function mergeToCanvas(Types.Canvas memory canvas, Types.Mix memory mix) internal pure {
        while (canvas.matrix.next() && mix.matrix.next()) {
            uint256 canvasPixel = canvas.matrix.current();
            uint256 mixPixel = mix.matrix.current();

            if (mixPixel.e() && mixPixel.z() >= canvasPixel.z()) {
                canvas.matrix.setCurrent(Rgba.combine(canvasPixel, mixPixel));
            }
        }
        canvas.matrix.moveBack();
        canvas.matrix.resetIterator();
        mix.matrix.resetIterator();
    }

    function calculateReceivers(Types.Mix memory mix) internal pure {
        Anchor.convertReceiversToAnchors(mix);
    }
}
