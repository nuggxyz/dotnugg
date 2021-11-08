import {
    ethers,
    waffle,
} from 'hardhat';

import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../hardhat.config';
import {
    PlainTest,
    PlainTest__factory,
} from '../../types';
import {
    deployContract,
    prepareAccounts,
} from './';

// import { getHRE } from './shared/deployment';
const createFixtureLoader = waffle.createFixtureLoader;
const {
    constants: { MaxUint256 },
} = ethers;

let loadFixture: ReturnType<typeof createFixtureLoader>;
let accounts: Record<keyof typeof NamedAccounts, SignerWithAddress>;
let plain: PlainTest;
const refresh = async () => {
    accounts = await prepareAccounts();
    loadFixture = createFixtureLoader();
    plain = await deployContract<PlainTest__factory>({ factory: 'PlainTest', from: accounts.frank, args: [] });
};

describe('uint tests', async function () {
    beforeEach(async () => {
        await refresh();
    });

    describe('internal', async () => {
        it('should not fuck up', async () => {
            await plain.tfizzle();
            // expect
            // console.log(a.toString(), b.toString(), c.toString(), d.toString());
            // expect(a).to.be.revertedWith('WE FUCKED UP');
        });
    });
});
