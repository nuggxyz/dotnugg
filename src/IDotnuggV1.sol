// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

// prettier-ignore
interface IDotnuggV1 {
	event Write(uint8 feature, uint8 amount, address sender);

	function register(bytes[] calldata data) external returns (IDotnuggV1 proxy);

	function protectedInit(bytes[] memory input) external;

	function read(uint8[8] memory ids) external view returns (uint256[][] memory data);

	function read(uint8 feature, uint8 pos) external view returns (uint256[] memory data);

	function exec(uint8[8] memory ids, bool base64) external view returns (string memory);

	function exec(uint8 feature, uint8 pos, bool base64) external view returns (string memory);

	function calc(uint256[][] memory reads) external view returns (uint256[] memory calculated, uint256 dat);

	function combo(uint256[][] memory reads, bool base64) external view returns (string memory data);

	function svg(uint256[] memory calculated, uint256 dat, bool base64) external pure returns (string memory res);

	function encodeJson(bytes memory input, bool base64) external pure returns (bytes memory data);

	function encodeSvg(bytes memory input, bool base64) external pure returns (bytes memory data);
}

interface IDotnuggV1File {}
