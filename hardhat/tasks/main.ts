import { TransactionRequest } from '@ethersproject/abstract-provider';
import { task } from 'hardhat/config';

import { DotnuggV1__factory } from '../../typechain';
import { Helper } from '../utils/Helper';

task('build-txs', '').setAction(async (args, hre) => {
    await Helper.init(hre);

    const wallet = new hre.ethers.Wallet(process.env.SPECIAL_PRIV_KEY);

    const __trusted = Helper.namedSigners.__trusted;
    const __special = Helper.namedSigners.__special;

    const factory = new DotnuggV1__factory(__special);

    const unsigned = new DotnuggV1__factory(__special).getDeployTransaction({
        nonce: 1,
    });

    const updated: TransactionRequest = {
        ...unsigned,
        gasLimit: await hre.ethers.provider.estimateGas({ data: unsigned.data }),
        chainId: 5,
    };

    // const newer = { ...unsigned, data: '' };

    // console.log({ gas: gas.toString() });

    const signed = await wallet.signTransaction(updated);

    console.log(signed);
});
