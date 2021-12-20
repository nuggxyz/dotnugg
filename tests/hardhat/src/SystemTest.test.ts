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
    EYES,
    MOUT,
    HAIR,
    HEAD,
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
            // const RAND_INDEXS = {
            //     BACK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.BACK].amount),
            //     EYES: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.EYES].amount),
            //     MOUT: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.MOUT].amount),
            //     HEAD: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HEAD].amount),
            //     HAIR: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HAIR].amount),
            //     NECK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.NECK].amount),
            // };

            // const RAND_INDEXS = {
            //     BACK: 6,
            //     EYES: 7,
            //     MOUT: 10,
            //     HEAD: 2,
            //     HAIR: 5,
            //     NECK: 6,
            // };

            // const RAND_INDEXS = { BACK: 0, EYES: 4, MOUT: 10, HEAD: 7, HAIR: 8, NECK: 22 };

            // pretty boy
            // const RAND_INDEXS = { BACK: 4, EYES: 14, MOUT: 9, HEAD: 10, HAIR: 9, NECK: 19 };

            // foot mounty (hat does not appear to be offset)
            // const RAND_INDEXS = { BACK: 2, EYES: 12, MOUT: 3, HEAD: 5, HAIR: 15, NECK: 5 };

            //
            // const RAND_INDEXS = { BACK: 0, EYES: 14, MOUT: 3, HEAD: 1, HAIR: 13, NECK: 20 };

            // const RAND_INDEXS = { BACK: 1, EYES: 19, MOUT: 11, HEAD: 3, HAIR: 2, NECK: 8 };

            // // another keran
            // const RAND_INDEXS = { BACK: 5, EYES: 24, MOUT: 5, HEAD: 8, HAIR: 2, NECK: 0 };

            // const RAND_INDEXS = { BACK: 0, EYES: 2, MOUT: 10, HEAD: 11, HAIR: 15, NECK: 1 };

            // const RAND_INDEXS = { BACK: 1, EYES: 1, MOUT: 8, HEAD: 3, HAIR: 15, NECK: 3 };

            const RAND_INDEXS = { BACK: 4, EYES: 24, MOUT: 11, HEAD: 11, HAIR: 9, NECK: 2 };

            console.log('const RAND_INDEXS = ');
            console.log(RAND_INDEXS);
            const res = await fix.processor.processCore(
                [
                    fix.hre.dotnugg.itemsByFeatureById[Features.BASE][1].hex,
                    // fix.hre.dotnugg.itemsByFeatureById[Features.BACK][RAND_INDEXS.BACK].hex,
                    fix.hre.dotnugg.itemsByFeatureById[Features.EYES][RAND_INDEXS.EYES].hex,
                    fix.hre.dotnugg.itemsByFeatureById[Features.MOUT][RAND_INDEXS.MOUT].hex,
                    // fix.hre.dotnugg.itemsByFeatureById[Features.HAIR][RAND_INDEXS.HAIR].hex,
                    fix.hre.dotnugg.itemsByFeatureById[Features.HEAD][RAND_INDEXS.HEAD].hex,
                    // fix.hre.dotnugg.itemsByFeatureById[Features.NECK][RAND_INDEXS.NECK].hex,
                ],
                {
                    version: 1,
                    name: 'test',
                    desc: 'desc',
                    renderedAt: 0,
                    owner: ethers.constants.AddressZero,
                    tokenId: 0,
                    proof: 0,
                    ids: [0, 0, 0, 0, 0, 0, 0, 0],
                    extras: [0, 0, 0, 0, 0, 0, 0, 0],
                    xovers: [0, 0, 0, 0, 9, 0, 0, 0],
                    yovers: [0, 0, 0, 0, 12, 0, 0, 0],
                },
                45,
            );

            dotnugg.log.Console.drawConsole(res);

            dotnugg.log.Console.drawSvg(res, 10);
        });
    });
});
