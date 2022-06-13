# Dotnugg V1 Smart Contracts

> **Warning**
> this code is yet to be deployed and licensed under BUSL-1.1

[![forge](https://github.com/nuggxyz/dotnugg-v1-core/actions/workflows/forge.yaml/badge.svg)](https://github.com/nuggxyz/dotnugg-v1-core/actions/workflows/forge.yaml)

the core logic and smart contracts for dotnugg v1

-   written in solidity
-   (to be soon) deployed on ethereum

## Deployments

| network | address |
| ------- | ------- |
| mainnet | `TBD`   |
| ropsten | `0x`    |
| rinkeby | `0x`    |
| goerli  | `0x`    |
| kovan   | `0x`    |

## Developing Locally

### **using nuggft's dotnugg data**

> **Note**
> the main DotnuggV1 contract is deployed with all NuggftV1's dotnugg data

```solidity
pragma solidity 0.8.14;

import {DotnuggV1} "dotnugg-v1-core/DotnuggV1.sol";

contract MyTestContract {

    DotnuggV1 dotnugg;

    // to avoid wasting time, we suggest you do this in the constructor and not the "setUp" function
    constructor() {
        dotnugg = new DotnuggV1();
    }

    function setUp() public {}

    function testA() public {
        // will return nuggft's Base 1
        dotnugg.exec(0, 1);
    }
}

```

### **using your own dotnugg data**

```solidity
pragma solidity 0.8.14;

import {DotnuggV1} "dotnugg-v1-core/DotnuggV1.sol";

import {data as myData} from "./MyDotnuggData.sol";

contract MyContract {
    DotnuggV1 dotnuggFactory;

    DotnuggV1 dotnugg;

    // to avoid wasting time, we suggest you do this in the constructor and not the "setUp" function
    constructor() {

        dotnuggFactory = new DotnuggV1();


        dotnugg = dotnuggFactory.register(myData);
    }

    function setUp() public {}

    function doSomethingWithContract() public {
        // will return the item at position 1 for feature 0
        dotnugg.exec(0, 1);
    }
}

```

## m1 configuration

```bash
# to install apple silicon version of solc
brew install solidity

# each shell you want to use forge in
export SOLC_PATH=/opt/homebrew/Cellar/solidity/0.8.14/bin/solc
```

## Licensing

The primary license for DotnuggV1 Core is the Business Source License 1.1 (`BUSL-1.1`), see [`LICENSE`](./LICENSE).

### Exceptions

-   All files in `src/_test` are unlicensed
