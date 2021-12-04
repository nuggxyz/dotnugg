import { Fixture, MockProvider } from 'ethereum-waffle';
import { ethers } from 'hardhat';
import { BigNumber, Wallet, Contract, BigNumberish } from 'ethers';

import { getHRE } from '../shared/deployment';
import { deployContractWithSalt } from '../shared';

import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { MockDotNuggHolder } from '../../../../typechain/MockDotNuggHolder';
import { MockDotNuggHolder__factory } from '../../../../typechain/factories/MockDotNuggHolder__factory';
import { DotNugg } from '../../../../typechain/DotNugg';
import { DotNugg__factory } from '../../../../typechain/factories/DotNugg__factory';
import { SvgFileResolver, SvgFileResolver__factory } from '../../../../typechain';

export interface NuggFatherFixture {
    holder: MockDotNuggHolder;
    // let nuggin: GroupNuggIn;
    // let nugginSVG: SvgFileResolver;
    // let nugginDotNugg: SvgFileResolver;
    svgResolver: SvgFileResolver;
    dotnugg: DotNugg;
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

    const dotnugg = await deployContractWithSalt<DotNugg__factory>({
        factory: 'DotNugg',
        from: eoaDeployer,
        args: [],
    }); 

    const svgResolver = await deployContractWithSalt<SvgFileResolver__factory>({
        factory: 'SvgFileResolver',
        from: eoaDeployer,
        args: [],
    });

    const holder = await deployContractWithSalt<MockDotNuggHolder__factory>({
        factory: 'MockDotNuggHolder',
        from: eoaDeployer,
        args: [dotnugg.address, svgResolver.address],
    });

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

    hre.tracer.nameTags[holder.address] = 'MockDotNuggHolder';
    // hre.tracer.nameTags[nuggswap.address] = 'NuggSwap';
    hre.tracer.nameTags['0x0000000000000000000000000000000000000000'] = 'BLACK_HOLE';
    hre.tracer.nameTags[owner] = 'Owner';
    // hre.tracer.nameTags[mockERC1155.address] = 'mockERC1155';

    // function toNuggSwapTokenId(epoch: BigNumberish): BigNumber {
    //     return ethers.BigNumber.from(nuggswap.address).shl(96).add(epoch);
    // }

    return {
        holder,
        // toNuggSwapTokenId,
        // mockERC1155,
        // dotnugg: hre.dotnugg,
        // nuggft,
        // xnugg,
        svgResolver,
        dotnugg,
        blockOffset,
        owner,
        // nuggswap,
        hre: getHRE(),
        ownerStartBal: await getHRE().ethers.provider.getBalance(owner),
    };
};
