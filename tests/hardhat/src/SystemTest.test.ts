import { ethers, waffle } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../../hardhat.config';
import { NuggFatherFix, NuggFatherFixture } from '../lib/fixtures/NuggFather.fix';

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
    HOLD,
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
            // BASE: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.BASE].amount),
            // BACK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.BACK].amount),
            // EYES: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.EYES].amount),
            // MOUT: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.MOUT].amount),
            // HEAD: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HEAD].amount),
            // HAIR: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HAIR].amount),
            // NECK: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.NECK].amount),
            // HOLD: dotnugg.utils.randIntBetween(fix.hre.dotnugg.stats.features[Features.HOLD].amount),
            // };
            //
            // console.log(fix.hre.dotnugg.itemsByFeatureById[Features.NECK], RAND_INDEXS.NECK);

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
            // const RAND_INDEXS = { BASE: 0, BACK: 5, EYES: 24, MOUT: 5, HEAD: 8, HAIR: 2, NECK: 0 };

            // const RAND_INDEXS = { BACK: 0, EYES: 2, MOUT: 10, HEAD: 11, HAIR: 15, NECK: 1 };

            // const RAND_INDEXS = { BACK: 1, EYES: 1, MOUT: 8, HEAD: 3, HAIR: 15, NECK: 3 };

            // const RAND_INDEXS = { BACK: 4, EYES: 24, MOUT: 11, HEAD: 11, HAIR: 9, NECK: 2 };

            // const RAND_INDEXS = { BASE: 0, EYES: 9, MOUT: 6, HAIR: 0, HEAD: 0, BACK: 2 };
            // const RAND_INDEXS = {
            // BASE: 0,
            // BACK: 3,
            // EYES: 37,
            // MOUT: 38,
            // HEAD: 14,
            // HAIR: 4,
            // NECK: 11,
            // HOLD: 0,
            // };
            //
            // const RAND_INDEXS = {
            // BASE: 1,
            // BACK: 3,
            // EYES: 42,
            // MOUT: 28,
            // HEAD: 7,
            // HAIR: 27,
            // NECK: 10,
            // HOLD: 7,
            // };
            //
            // todo 21 has a problem
            const RAND_INDEXS = {
                BASE: 1,
                BACK: 3,
                EYES: 41,
                MOUT: 19,
                HEAD: 20,
                HAIR: 15,
                NECK: 20,
                HOLD: 4,
            };

            console.log('const RAND_INDEXS = ');
            console.log(RAND_INDEXS);

            // console.log(fix.hre.dotnugg.itemsByFeatureById[Features.EYES][RAND_INDEXS.EYES].hex);

            // const res = await fix.processor.dotnuggToString(fix.implementer.address, 100, ethers.constants.AddressZero, 45, 10);
            const res = await fix.processor.dotnuggToString(fix.implementer.address, 69, fix.processor.address, 63, 10);

            // res.forEach((x) => {
            //     console.log(`a.push(${x._hex});`);
            // });

            // console.log(res);

            // const aArray = a.split('0x').map((x) => BigNumber.from(x !== '' ? '0x' + x : 0));

            console.log(res);

            // dotnugg.log.Console.drawConsole(res);

            // dotnugg.log.Console.drawSvg(res, 10);
        });
    });
});
