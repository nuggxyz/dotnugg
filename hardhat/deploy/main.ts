import { BigNumber } from 'ethers';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

import { fromEth } from '../utils/conversion';
import { Helper } from '../utils/Helper';
// import { XNUGG as xNUGG } from '../typechain/XNUGG';
// import { NuggFT } from '../typechain/NuggFT.d';
// import { fromEth, toEth } from '../tests/hardhat/lib/shared/conversion';
// import { NuggSwap } from '../typechain';

const deployment = async (hre: HardhatRuntimeEnvironment) => {
    await Helper.init(hre);
    // if (chainID === '3' || chainID === '31337') {

    const __trusted = Helper.namedSigners.__trusted;
    const __special = Helper.namedSigners.__special;

    hre.deployments.log('__trusted:             ', __trusted.address);
    hre.deployments.log('__special:             ', __special.address);

    const breaker = async () => {
        hre.deployments.log('__trusted balance: ', fromEth(await __trusted.getBalance()));
        hre.deployments.log('__special balance: ', fromEth(await __special.getBalance()));

        hre.deployments.log('----------------------------');
    };

    await breaker();

    const gasPrice = BigNumber.from(hre.network.config.gasPrice);

    const gasLimit = BigNumber.from(8000000);

    hre.deployments.log('estimated total tx cost:  ', fromEth(gasPrice.mul(gasLimit)));

    await breaker();

    // send the deployer all eth
    await hre.deployments.rawTx({ to: __special.address, from: __trusted.address, value: gasPrice.mul(gasLimit), log: true });

    await breaker();

    await hre.deployments.rawTx({ to: __special.address, from: __trusted.address, value: gasPrice.mul(gasLimit), log: true });

    await hre.deployments
        .deploy('DotnuggV1', {
            from: __special.address,
            log: true,
            gasPrice,
            gasLimit,
            nonce: 0,
        })
        .then((data) => {
            hre.deployments.log('DotnuggV1 Deployment Complete at address: ', data.address);
            return data;
        });

    await breaker();

    // // send the deployer all eth
    // await hre.deployments.rawTx({ to: __trusted.address, from: __special.address, value: await __special.getBalance() });

    // await breaker();
};

export default deployment;
