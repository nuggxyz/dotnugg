import { Fixture, MockProvider } from 'ethereum-waffle';
import { BigNumber, Wallet } from 'ethers';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

import { getHRE } from '../shared/deployment';
import { deployContractWithSalt } from '../shared';
import { DotnuggV1Processor__factory } from '../../../../typechain/factories/DotnuggV1Processor__factory';
import { DotnuggV1Processor } from '../../../../typechain/DotnuggV1Processor';

export interface NuggFatherFixture {
    // holder: MockDotNuggHolder;
    // let nuggin: GroupNuggIn;
    // let nugginSVG: DotnuggV1Processor;
    // let nugginDotNugg: DotnuggV1Processor;
    processor: DotnuggV1Processor;
    owner: string;
    ownerStartBal: BigNumber;
    hre: HardhatRuntimeEnvironment;
    blockOffset: BigNumber;

    // toNuggSwapTokenId(b: BigNumberish): BigNumber;
}

export const NuggFatherFix: Fixture<NuggFatherFixture> = async function (
    wallets: Wallet[],
    provider: MockProvider,
): Promise<NuggFatherFixture> {
    const hre = getHRE();

    const eoaDeployer = provider.getWallets()[16];
    const eoaOwner = provider.getWallets()[17];

    // const dotnugg = await deployContractWithSalt<DotNugg__factory>({
    //     factory: 'DotNugg',
    //     from: eoaDeployer,
    //     args: [],
    // });

    const processor = await deployContractWithSalt<DotnuggV1Processor__factory>({
        factory: 'DotnuggV1Processor',
        from: eoaDeployer,
        args: [],
    });

    // const holder = await deployContractWithSalt<MockDotNuggHolder__factory>({
    //     factory: 'MockDotNuggHolder',
    //     from: eoaDeployer,
    //     args: [processor.address],
    // });

    // const nuggswap = await deployContractWithSalt<NuggSwap__factory>({
    //     factory: 'NuggSwap',
    //     from: eoaDeployer,
    //     args: [xnugg.address],
    // });

    //0x435ccc2eaa41633658be26d804be5A01fEcC9337
    //0x770f070388b13A597b84B557d6B8D1CD94Fc9925

    // const nuggft = await deployContractWithSalt<NuggFT__factory>({
    //     factory: 'NuggFT',
    //     from: eoaDeployer,
    //     args: [xnugg.address, xnugg.address, xnugg.address],
    // });

    // hre.tracer.nameTags[nuggft.address] = `NuggFT`;

    const blockOffset = BigNumber.from(await hre.ethers.provider.getBlockNumber());

    const owner = eoaDeployer.address;

    // hre.tracer.nameTags[holder.address] = 'MockDotNuggHolder';
    hre.tracer.nameTags[processor.address] = 'dotnuggV1Processor';
    hre.tracer.nameTags['0x0000000000000000000000000000000000000000'] = 'BLACK_HOLE';
    hre.tracer.nameTags[owner] = 'Owner';
    // hre.tracer.nameTags[mockERC1155.address] = 'mockERC1155';

    // function toNuggSwapTokenId(epoch: BigNumberish): BigNumber {
    //     return ethers.BigNumber.from(nuggswap.address).shl(96).add(epoch);
    // }

    return {
        // holder,
        // toNuggSwapTokenId,
        // mockERC1155,
        // dotnugg: hre.dotnugg,
        // nuggft,
        // xnugg,
        processor,
        blockOffset,
        owner,
        // nuggswap,
        hre: getHRE(),
        ownerStartBal: await getHRE().ethers.provider.getBalance(owner),
    };
};
