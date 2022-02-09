# DotnuggV1

[![Forge](https://github.com/nuggxyz/dotnugg-v1-core/actions/workflows/forge.yml/badge.svg)](https://github.com/nuggxyz/dotnugg-v1-core/actions/workflows/forge.yml)
[![npm version](https://img.shields.io/npm/v/@nuggxyz/dotnugg-v1-core/latest.svg)](https://www.npmjs.com/package/@nuggxyz/dotnugg-v1-core/v/latest)

This repository contains the core smart contracts for the DotnuggV1 Protocol.
For higher level contracts, see the [dotnugg-v1-periphery](https://github.com/nuggxyz/dotnugg-v1-periphery)
repository.

## Bug bounty

This repository is subject to the DotnuggV1 bug bounty program, per the terms defined [here](./bug-bounty.md).

## Local deployment

In order to deploy this code to a local testnet, you should install the npm package
`@nuggxyz/dotnugg-v1-core`
and import the factory bytecode located at
`@nuggxyz/dotnugg-v1-core/DotnuggV1Factory.json`.
For example:

```typescript
import {
    abi as DotnuggV1Factory__ABI,
    bytecode as DotnuggV1Factory__BYTECODE,
} from "@nuggxyz/dotnugg-v1-core/DotnuggV1Factory.json";

// deploy the bytecode
```

This will ensure that you are testing against the same bytecode that is deployed to
mainnet and public testnets, and all DotnuggV1 code will correctly interoperate with
your local deployment.

## Using solidity interfaces

The DotnuggV1 interfaces are available for import into solidity smart contracts
via the npm artifact `@nuggxyz/dotnugg-v1-core`, e.g.:

```solidity
import "@nuggxyz/dotnugg-v1-core/IDotnuggV1Factory.sol";

contract MyContract {
    IDotnuggV1Factory factory;

    function doSomethingWithContract() {
        // factory.register(...);
    }
}

```

## Licensing

The primary license for DotnuggV1 Core is the Business Source License 1.1 (`BUSL-1.1`), see [`LICENSE`](./LICENSE).

### Exceptions

-   All files in `contracts/interfaces/` are licensed under `GPL-2.0-or-later` (as indicated in their SPDX headers), see [`src/interfaces/LICENSE`](./src/interfaces/LICENSE)
-   Several files in `src/libraries/` are licensed under `GPL-2.0-or-later` (as indicated in their SPDX headers), see [`src/libraries/LICENSE_GPL`](src/libraries/LICENSE_GPL)
-   All files in `src/test` remain unlicensed.
