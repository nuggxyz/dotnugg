import { ethers, waffle } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../../hardhat.config';
import { NuggFatherFix, NuggFatherFixture } from '../lib/fixtures/NuggFather.fix';
import { dotnugg } from '../../../../dotnugg-sdk/src';

import { prepareAccounts } from './';

// import { getHRE } from './shared/deployment';
const createFixtureLoader = waffle.createFixtureLoader;
const {
    constants: { MaxUint256 },
} = ethers;

let loadFixture: ReturnType<typeof createFixtureLoader>;
let accounts: Record<keyof typeof NamedAccounts, SignerWithAddress>;
// let plain: SystemTest;

let fix: NuggFatherFixture;

enum Features {
    BASE,
    HAIR,
    HEAD,
    EYES,
    MOUTH,
    BACK,
    NECK,
}

const refresh = async () => {
    accounts = await prepareAccounts();
    loadFixture = createFixtureLoader();
    fix = await loadFixture(NuggFatherFix);
};

describe('uint tests', async function () {
    beforeEach(async () => {
        await refresh();
    });
    describe('internal', async () => {
        it('should not fuck up', async () => {
            const res = await fix.defaultResolver.process(
                [
                    fix.hre.dotnugg.itemsByFeatureById[Features.BASE][0].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.BACK][0].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.EYES][2].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.MOUTH][3].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.HEAD][2].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.HAIR][6].hexMocked,
                ],
                '0x00',
                '0x00',
            );
            dotnugg.log.Console.drawSvg(res, 10);

            // const res2 = await fix.defaultResolver.postProcess(
            //     res,
            //     new ethers.utils.AbiCoder().encode(['uint256', 'uint256', 'address'], [0, 0, fix.defaultResolver.address]),
            //     '0x00',
            // );

            // const b64 = ethers.utils.toUtf8String(res2);

            // console.log(b64);

            // const tokenUri = JSON.parse(ethers.utils.toUtf8String(ethers.utils.base64.decode(b64)));

            // const svg = ethers.utils.toUtf8String(ethers.utils.base64.decode(tokenUri.image));

            // console.log(svg);
        });
    });
});
