import {
    ethers,
    waffle,
} from 'hardhat';

import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

import { NamedAccounts } from '../../hardhat.config';
import {
    DotNugg,
    DotNugg__factory,
    GroupNuggIn,
    GroupNuggIn__factory,
    SvgNuggIn,
    SvgNuggIn__factory,
    SystemTest,
    SystemTest__factory,
} from '../../types';
import {
    deployContract,
    prepareAccounts,
} from './';
import { bashit } from './shared/groups';

// import { getHRE } from './shared/deployment';
const createFixtureLoader = waffle.createFixtureLoader;
const {
    constants: { MaxUint256 },
} = ethers;

let loadFixture: ReturnType<typeof createFixtureLoader>;
let accounts: Record<keyof typeof NamedAccounts, SignerWithAddress>;
let plain: SystemTest;
let nuggin: GroupNuggIn;
let nugginSVG: SvgNuggIn;
let dotnugg: DotNugg;

const refresh = async () => {
    accounts = await prepareAccounts();
    loadFixture = createFixtureLoader();
    plain = await deployContract<SystemTest__factory>({ factory: 'SystemTest', from: accounts.frank, args: [] });
    nugginSVG = await deployContract<SvgNuggIn__factory>({ factory: 'SvgNuggIn', from: accounts.frank, args: [] });
    nuggin = await deployContract<GroupNuggIn__factory>({ factory: 'GroupNuggIn', from: accounts.frank, args: [] });
    dotnugg = await deployContract<DotNugg__factory>({ factory: 'DotNugg', from: accounts.frank, args: [] });
};

describe('uint tests', async function () {
    beforeEach(async () => {
        await refresh();
    });

    describe('internal', async () => {
        it('should not fuck up', async () => {
            const str = await plain.tfull(dotnugg.address, nuggin.address);

            // console.log(ethers.utils.base64.decode(str));
            console.log(str);
            bashit(str, 33, 33);
            // expect
            // console.log(a.toString(), b.toString(), c.toString(), d.toString());
            // expect(a).to.be.revertedWith('WE FUCKED UP');
        });
    });
});
