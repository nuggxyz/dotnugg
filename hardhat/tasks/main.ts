import * as fs from 'fs';

import { task } from 'hardhat/config';

import { DotnuggV1__factory } from '../../typechain';
import { Helper } from '../utils/Helper';

task('build-txs', '').setAction(async (args, hre) => {
    await Helper.init(hre);

    const wallet = new hre.ethers.Wallet(process.env.SPECIAL_PRIV_KEY);

    const __trusted = Helper.namedSigners.__trusted;
    const __special = Helper.namedSigners.__special;

    const fac = new DotnuggV1__factory(__special);

    // const fileHandle = await fs.promises.open('../../out/Pu', 'w');

    // fac/

    const unsigned = fac.getDeployTransaction({
        nonce: 1,
    });

    const chains = [1, 3, 4, 5, 42, 31337];

    const gasLimit = await hre.ethers.provider.estimateGas({ data: unsigned.data });

    const file = `${__dirname}/../../transactions/a.unsigned.txt`;
    // const txid = keccakFromHexString(signedData);
    const fileHandle = await fs.promises.open(file, 'w');
    await fileHandle.writeFile(unsigned.data.toString());
    await fileHandle.close();

    // for (let i = 0; i < chains.length; i++) {
    //     // const signedData = await wallet.signTransaction({
    //     //     data: unsigned.data,
    //     //     chainId: chains[i],
    //     //     gasLimit,
    //     //     gasPrice: chains[i] === 1 || chains[i] === 31337 ? toGwei('40') : toGwei('3.9'),
    //     //     nonce: 0,
    //     //     value: 0,
    //     // });
    //     const file = `${__dirname}/../../transactions/a/_${chains[i]}.signed.txt`;
    //     // const txid = keccakFromHexString(signedData);
    //     const fileHandle = await fs.promises.open(file, 'w');
    //     await fileHandle.writeFile(unsigned.data.toString());
    //     await fileHandle.close();
    // }
});
