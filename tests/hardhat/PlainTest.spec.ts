import {
    ethers,
    waffle,
} from 'hardhat';

import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../hardhat.config';
import {
    DotNugg,
    DotNugg__factory,
    PlainTest,
    PlainTest__factory,
    SvgNuggIn,
    SvgNuggIn__factory,
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
let nuggin: SvgNuggIn;
let dotnugg: DotNugg;

const refresh = async () => {
    accounts = await prepareAccounts();
    loadFixture = createFixtureLoader();
    plain = await deployContract<PlainTest__factory>({ factory: 'PlainTest', from: accounts.frank, args: [] });
    nuggin = await deployContract<SvgNuggIn__factory>({ factory: 'SvgNuggIn', from: accounts.frank, args: [] });
    dotnugg = await deployContract<DotNugg__factory>({ factory: 'DotNugg', from: accounts.frank, args: [] });
};

describe('uint tests', async function () {
    beforeEach(async () => {
        await refresh();
    });

    describe('internal', async () => {
        it('should not fuck up', async () => {
            await plain.tfizzle(dotnugg.address, nuggin.address);
            // expect
            // console.log(a.toString(), b.toString(), c.toString(), d.toString());
            // expect(a).to.be.revertedWith('WE FUCKED UP');
        });
    });
});
