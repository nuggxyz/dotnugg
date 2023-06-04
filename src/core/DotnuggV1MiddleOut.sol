// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import {ShiftLib} from "git.nugg.xyz/dotnugg/src/libraries/ShiftLib.sol";

import {DotnuggV1Pixel as Pixel} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Pixel.sol";
import {DotnuggV1Matrix as Matrix} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Matrix.sol";
import {DotnuggV1Parser as Parser} from "git.nugg.xyz/dotnugg/src/core/DotnuggV1Parser.sol";

/// @title DotnuggV1MiddleOut
/// @author nugg.xyz - danny7even and dub6ix - 2022
/// @notice core of dotnugg - combines multiple DotnuggV1 encoded files into one
library DotnuggV1MiddleOut {
	using Matrix for Matrix.Memory;
	using Parser for Parser.Memory;
	using Pixel for uint256;

	struct Run {
		Parser.Memory[8] versions;
		Canvas canvas;
		Mix mix;
	}

	uint8 constant WIDTH = 255;
	uint8 constant CENTER = (WIDTH / 2) + 1;

	function execute(uint256[][] memory files) internal pure returns (uint256[] memory res, uint256 dat) {
		unchecked {
			Run memory run;

			uint256 len;

			(run.versions, len) = Parser.parse(files);

			run.canvas.matrix = Matrix.create(WIDTH, WIDTH);
			run.canvas.matrix.width = run.canvas.matrix.height = WIDTH;
			run.canvas.xStart = run.canvas.yStart = WIDTH;

			for (uint8 i = 0; i < run.versions.length; i++) {
				run.canvas.receivers[i].coordinate = center();
			}

			run.mix.matrix = Matrix.create(WIDTH, WIDTH);

			for (uint8 i = 0; i < 8; i++) {
				if (!run.versions[i].exists) continue;

				setMix(run.mix, run.versions[i]);

				// no reposition on single items
				if (len == 1)
					return (
						run.mix.matrix.version.bigmatrix,
						buildDat(0, run.mix.matrix.width, 0, run.mix.matrix.height)
					);

				formatForCanvas(run.canvas, run.mix);

				postionForCanvas(run.canvas, run.mix);

				mergeToCanvas(run.canvas, run.mix);

				convertReceiversToAnchors(run.mix);

				updateReceivers(run.canvas, run.mix);
			}

			res = run.canvas.matrix.version.bigmatrix;
			dat = buildDat(run.canvas.xStart, run.canvas.xEnd, run.canvas.yStart, run.canvas.yEnd);
		}
	}

	function buildDat(
		uint256 a,
		uint256 b,
		uint256 c,
		uint256 d
	) internal pure returns (uint256 res) {
		res |= a;
		res |= b << 64;
		res |= c << 128;
		res |= d << 192;
	}

	function center() internal pure returns (Coordinate memory) {
		return Coordinate({a: CENTER, b: CENTER, exists: true});
	}

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
		Matrix.Memory matrix;
		Anchor[8] receivers;
		uint256 xStart;
		uint256 xEnd;
		uint256 yStart;
		uint256 yEnd;
	}

	struct Mix {
		uint8 feature;
		Version version;
		Matrix.Memory matrix;
		Anchor[8] receivers;
		uint8 yoffset;
		uint8 xoffset;
	}

	function postionForCanvas(Canvas memory canvas, Mix memory mix) internal pure {
		unchecked {
			Anchor memory receiver = canvas.receivers[mix.feature];
			Anchor memory anchor = mix.version.anchor;

			mix.xoffset = receiver.coordinate.a > anchor.coordinate.a ? receiver.coordinate.a - anchor.coordinate.a : 0;
			mix.yoffset = receiver.coordinate.b > anchor.coordinate.b ? receiver.coordinate.b - anchor.coordinate.b : 0;

			mix.xoffset++;

			canvas.matrix.moveTo(mix.xoffset, mix.yoffset, mix.matrix.width, mix.matrix.height);

			if (mix.xoffset < canvas.xStart) canvas.xStart = mix.xoffset;
			if (mix.yoffset < canvas.yStart) canvas.yStart = mix.yoffset;
			if ((mix.xoffset + mix.matrix.width) > canvas.xEnd) canvas.xEnd = (mix.xoffset + mix.matrix.width);
			if ((mix.yoffset + mix.matrix.height) > canvas.yEnd) canvas.yEnd = (mix.yoffset + mix.matrix.height);
		}
	}

	function formatForCanvas(Canvas memory canvas, Mix memory mix) internal pure {
		unchecked {
			Anchor memory receiver = canvas.receivers[mix.feature];
			Anchor memory anchor = mix.version.anchor;

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
	}

	function checkRluds(Rlud memory r1, Rlud memory r2) internal pure returns (bool) {
		return (r1.r <= r2.r && r1.l <= r2.l) || (r1.u <= r2.u && r1.d <= r2.d);
	}

	function setMix(Mix memory res, Parser.Memory memory version) internal pure {
		unchecked {
			uint256 radiiBits = version.getRadii();
			uint256 expanderBits = version.getExpanders();

			(uint256 x, uint256 y) = version.getAnchor();

			(uint256 width, uint256 height) = version.getWidth();

			res.version.width = uint8(width);
			res.version.height = uint8(height);
			res.version.anchor = Anchor({
				radii: Rlud({
					r: uint8((radiiBits >> 24)),
					l: uint8((radiiBits >> 16)),
					u: uint8((radiiBits >> 8)),
					d: uint8((radiiBits >> 0)),
					exists: true
				}),
				coordinate: Coordinate({a: uint8(x), b: uint8(y), exists: true})
			});
			res.version.expanders = Rlud({
				r: uint8((expanderBits >> 24)),
				l: uint8((expanderBits >> 16)),
				u: uint8((expanderBits >> 8)),
				d: uint8((expanderBits >> 0)),
				exists: true
			});
			res.version.calculatedReceivers = new Coordinate[](8);

			res.version.staticReceivers = new Coordinate[](8);

			for (uint256 i = 0; i < 8; i++) {
				(uint256 _x, uint256 _y, bool exists) = version.getReceiverAt(i, false);
				if (exists) {
					res.version.staticReceivers[i].a = uint8(_x);
					res.version.staticReceivers[i].b = uint8(_y);
					res.version.staticReceivers[i].exists = true;
				}
			}

			for (uint256 i = 0; i < 8; i++) {
				(uint256 _x, uint256 _y, bool exists) = version.getReceiverAt(i, true);
				if (exists) {
					res.version.calculatedReceivers[i].a = uint8(_x);
					res.version.calculatedReceivers[i].b = uint8(_y);
					res.version.calculatedReceivers[i].exists = true;
				}
			}

			// TODO - receivers?
			res.xoffset = 0;
			res.yoffset = 0;
			// res.receivers = new Anchor[8](res.receivers.length);
			Anchor[8] memory upd;
			res.receivers = upd;

			res.feature = uint8(version.getFeature());
			res.matrix.set(version, width, height);
		}
	}

	function updateReceivers(Canvas memory canvas, Mix memory mix) internal pure {
		unchecked {
			for (uint8 i = 0; i < mix.receivers.length; i++) {
				Anchor memory m = mix.receivers[i];
				if (m.coordinate.exists) {
					m.coordinate.a += mix.xoffset;
					m.coordinate.b += mix.yoffset;
					canvas.receivers[i] = m;
				}
			}
		}
	}

	function mergeToCanvas(Canvas memory canvas, Mix memory mix) internal pure {
		unchecked {
			while (canvas.matrix.next() && mix.matrix.next()) {
				uint256 canvasPixel = canvas.matrix.current();
				uint256 mixPixel = mix.matrix.current();

				if (mixPixel.e() && mixPixel.z() >= canvasPixel.z()) {
					canvas.matrix.setCurrent(Pixel.combine(canvasPixel, mixPixel));
				}
			}
			canvas.matrix.moveBack();
			canvas.matrix.resetIterator();
			mix.matrix.resetIterator();
		}
	}

	function convertReceiversToAnchors(Mix memory mix) internal pure {
		unchecked {
			Coordinate[] memory anchors;
			uint8 stat = 0;
			uint8 cal = 0;

			for (uint8 i = 0; i < mix.version.staticReceivers.length; i++) {
				Coordinate memory coordinate;
				if (mix.version.staticReceivers[i].exists) {
					stat++;
					coordinate = mix.version.staticReceivers[i];
					mix.receivers[i].coordinate.a = coordinate.b;
					mix.receivers[i].coordinate.b = coordinate.a;
					mix.receivers[i].coordinate.exists = true;
				} else if (mix.version.calculatedReceivers[i].exists) {
					// if (mix.feature != 0) continue;

					cal++;
					if (anchors.length == 0) anchors = getAnchors(mix.matrix);

					coordinate = calculateReceiverCoordinate(mix, mix.version.calculatedReceivers[i], anchors);

					fledgeOutTheRluds(mix, coordinate, i);
				}
			}
		}
	}

	function fledgeOutTheRluds(
		Mix memory mix,
		Coordinate memory coordinate,
		uint8 index
	) internal pure {
		unchecked {
			Rlud memory radii;

			while (
				coordinate.a < mix.matrix.width - 1 &&
				mix.matrix.version.bigMatrixHasPixelAt(coordinate.a + (radii.r + 1), coordinate.b)
			) {
				radii.r++;
			}
			while (
				coordinate.a != 0 &&
				coordinate.a >= (radii.l + 1) &&
				mix.matrix.version.bigMatrixHasPixelAt(coordinate.a - (radii.l + 1), coordinate.b)
			) {
				radii.l++;
			}
			while (
				coordinate.b != 0 &&
				coordinate.b >= (radii.u + 1) &&
				mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b - (radii.u + 1))
			) {
				radii.u++;
			}
			while (
				coordinate.b < mix.matrix.height - 1 &&
				mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b + (radii.d + 1))
			) {
				radii.d++;
			}

			if (!mix.receivers[index].coordinate.exists) {
				mix.receivers[index] = Anchor({radii: radii, coordinate: coordinate});
			}
		}
	}

	function calculateReceiverCoordinate(
		Mix memory mix,
		Coordinate memory calculatedReceiver,
		Coordinate[] memory anchors
	) internal pure returns (Coordinate memory coordinate) {
		unchecked {
			coordinate.a = anchors[calculatedReceiver.a].a;
			coordinate.b = anchors[calculatedReceiver.a].b;
			coordinate.exists = true;

			if (calculatedReceiver.b < 128) {
				coordinate.b = coordinate.b - calculatedReceiver.b;
			} else {
				coordinate.b = uint8(uint256(coordinate.b) + (calculatedReceiver.b - 128));
			}

			while (!mix.matrix.version.bigMatrixHasPixelAt(coordinate.a, coordinate.b)) {
				if (anchors[0].b > coordinate.b) {
					coordinate.b++;
				} else {
					coordinate.b--;
				}
			}
			return coordinate;
		}
	}

	function getAnchors(Matrix.Memory memory matrix) internal pure returns (Coordinate[] memory anchors) {
		unchecked {
			(uint8 topOffset, uint8 bottomOffset, Coordinate memory _center) = getBox(matrix);

			anchors = new Coordinate[](5);

			anchors[0] = _center; // _center

			anchors[1] = Coordinate({a: _center.a, b: _center.b - topOffset, exists: true}); // top

			uint8 upperOffset = topOffset;
			if (upperOffset % 2 != 0) {
				upperOffset++;
			}
			anchors[2] = Coordinate({a: _center.a, b: _center.b - (upperOffset / 2), exists: true}); // inner top

			uint8 lowerOffset = bottomOffset;
			if (lowerOffset % 2 != 0) {
				lowerOffset++;
			}
			anchors[3] = Coordinate({a: _center.a, b: _center.b + (lowerOffset / 2), exists: true}); // inner bottom

			anchors[4] = Coordinate({a: _center.a, b: _center.b + bottomOffset, exists: true}); // bottom
		}
	}

	function getBox(Matrix.Memory memory matrix)
		internal
		pure
		returns (
			uint8 topOffset,
			uint8 bottomOffset,
			Coordinate memory _center
		)
	{
		unchecked {
			_center.a = (matrix.width) / 2;
			_center.b = (matrix.height) / 2;
			_center.exists = true;

			bool topFound = false;
			bool bottomFound = false;
			bool sideFound = false;
			bool shouldExpandSide = true;

			topOffset = 1;
			bottomOffset = 1;
			uint8 sideOffset = 1;

			bool allFound = false;

			while (!allFound) {
				if (shouldExpandSide = !shouldExpandSide && !sideFound) {
					if (
						matrix.version.bigMatrixHasPixelAt(_center.a - (sideOffset + 1), _center.b - topOffset) &&
						// potential top left
						matrix.version.bigMatrixHasPixelAt(_center.a + (sideOffset + 1), _center.b - topOffset) &&
						// potential top right
						matrix.version.bigMatrixHasPixelAt(_center.a - (sideOffset + 1), _center.b + bottomOffset) &&
						// potential bot left
						matrix.version.bigMatrixHasPixelAt(_center.a + (sideOffset + 1), _center.b + bottomOffset)
						// potential bot right
					) {
						sideOffset++;
					} else {
						sideFound = true;
					}
				}
				if (!topFound) {
					if (
						_center.b - topOffset > 0 &&
						matrix.version.bigMatrixHasPixelAt(_center.a - sideOffset, _center.b - (topOffset + 1)) &&
						// potential top left
						matrix.version.bigMatrixHasPixelAt(_center.a + sideOffset, _center.b - (topOffset + 1))
						// potential top right
					) {
						topOffset++;
					} else {
						topFound = true;
					}
				}
				if (!bottomFound) {
					if (
						_center.b + bottomOffset < matrix.height - 1 &&
						matrix.version.bigMatrixHasPixelAt(_center.a - sideOffset, _center.b + (bottomOffset + 1)) &&
						// potential bot left
						matrix.version.bigMatrixHasPixelAt(_center.a + sideOffset, _center.b + (bottomOffset + 1))
						// potenetial bot right
					) {
						bottomOffset++;
					} else {
						bottomFound = true;
					}
				}
				if (bottomFound && topFound && sideFound) allFound = true;
			}

			if (topOffset != bottomOffset) {
				uint8 newHeight = topOffset + bottomOffset + 1;
				uint8 relativeCenter = (newHeight % 2 == 0 ? newHeight : newHeight + 1) / 2;
				uint8 newCenter = relativeCenter + _center.b - 1 - topOffset;
				if (newCenter > _center.b) {
					uint8 diff = newCenter - _center.b;
					topOffset += diff;
					bottomOffset > diff ? bottomOffset = bottomOffset - diff : bottomOffset = diff - bottomOffset;
				} else {
					uint8 diff = _center.b - newCenter;
					topOffset > diff ? topOffset = topOffset - diff : topOffset = diff - topOffset;
					bottomOffset += diff;
				}
				_center.b = newCenter;
			}
		}
	}
}
