import { ethers, waffle } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../../hardhat.config';
import { NuggFatherFix, NuggFatherFixture } from '../lib/fixtures/NuggFather.fix';
import { bashit2 } from '../lib/groups';

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
            const data = fix.hre.dotnugg.map((x) => x.hex);
            console.log(data);
            await fix.holder.dotNuggUpload(
                fix.hre.dotnugg.map((x) => x.hex),
                '0x00',
            );

            const res = await fix.holder.tokenUriTest(0);
            bashit2(res, 33, 33);
        });
    });
});
