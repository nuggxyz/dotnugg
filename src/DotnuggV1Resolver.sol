// SPDX-License-Identifier: BUS1.1

pragma solidity 0.8.11;

import {Calculator} from "./core/Calculator.sol";
import {Parser} from "./types/Parser.sol";

contract DotnuggV1Resolver {
    function resolve(uint256[][] calldata files) public view returns (uint256[] memory resp) {
        resp = Calculator.combine(8, 63, parse(files)).version.bigmatrix;
    }
}
