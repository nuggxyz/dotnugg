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

    // describe('getBox', async () => {
    //     it('good box :)', async () => {
    //         const [a, b, c, d] = await anchor.tfizzle();
    //         expect(a).to.equal(9);
    //         expect(b).to.equal(10);
    //         expect(c).to.equal(16);
    //         expect(d).to.equal(11);
    //     });
    // });

    // describe('getAnchors', async () => {
    //     it('good anchors :)', async () => {
    //         const vals = await anchor.tswizzle();
    //         console.log(vals)
    //         expect(vals[0].a).to.equal(16);
    //         expect(vals[0].b).to.equal(11);
    //         expect(vals[1].a).to.equal(16);
    //         expect(vals[1].b).to.equal(2);
    //         expect(vals[2].a).to.equal(16);
    //         expect(vals[2].b).to.equal(6);
    //         expect(vals[3].a).to.equal(16);
    //         expect(vals[3].b).to.equal(16);
    //         expect(vals[4].a).to.equal(16);
    //         expect(vals[4].b).to.equal(21);
    //     });
    // })
    describe('all the receivers shit', async () => {
        it('good receivers', async () => {
            const vals = await anchor.tbizzle();
        });
    })
});
