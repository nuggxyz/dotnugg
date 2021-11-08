import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';
import { ethers, waffle } from 'hardhat';
import { deployContract, prepareAccounts } from '.';
import { NamedAccounts } from '../../hardhat.config';

import { AnchorTest, AnchorTest__factory } from '../../types';
import { expect } from 'chai';

// import { getHRE } from './shared/deployment';
const createFixtureLoader = waffle.createFixtureLoader;
const {
    constants: { MaxUint256 },
} = ethers;

let loadFixture: ReturnType<typeof createFixtureLoader>;
let accounts: Record<keyof typeof NamedAccounts, SignerWithAddress>;
let anchor: AnchorTest;
const refresh = async () => {
    accounts = await prepareAccounts();
    loadFixture = createFixtureLoader();
    anchor = await deployContract<AnchorTest__factory>({ factory: 'AnchorTest', from: accounts.frank, args: [] });
};

describe('anchor tests', async function () {
    beforeEach(async () => {
        await refresh();
    });

    describe('getBox', async () => {
        it('good box :)', async () => {
            const [a, b, c, d] = await anchor.tfizzle();
            expect(a).to.equal(9);
            expect(b).to.equal(10);
            expect(c).to.equal(16);
            expect(d).to.equal(11);
        });
    });
});
