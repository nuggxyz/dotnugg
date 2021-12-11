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
    MOUT,
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
            const RAND_INDEXS = {
                BACK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.BACK].amount),
                EYES: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.EYES].amount),
                MOUT: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.MOUT].amount),
                HEAD: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HEAD].amount),
                HAIR: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HAIR].amount),
                NECK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.NECK].amount),
            };

            // const RAND_INDEXS = {
            //     BACK: 6,
            //     EYES: 7,
            //     MOUT: 10,
            //     HEAD: 2,
            //     HAIR: 5,
            //     NECK: 6,
            // };

            console.log(RAND_INDEXS);

            const res = await fix.defaultResolver.process(
                [
                    fix.hre.dotnugg.itemsByFeatureById[Features.BASE][0].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.BACK][RAND_INDEXS.BACK].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.EYES][RAND_INDEXS.EYES].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.MOUT][RAND_INDEXS.MOUT].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.HEAD][RAND_INDEXS.HEAD].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.HAIR][RAND_INDEXS.HAIR].hexMocked,
                    fix.hre.dotnugg.itemsByFeatureById[Features.NECK][RAND_INDEXS.NECK].hexMocked,
                ],
                '0x00',
                '0x00',
            );

            dotnugg.log.Console.drawConsole(res);

            dotnugg.log.Console.drawSvg(res, 10);
        });
    });
});
