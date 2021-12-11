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
    HEAD,
    HAIR,
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
            // const data = fix.hre.dotnugg.items;

            // console.log({ data });

            // await fix.holder.dotNuggUpload(
            //     data.map((x) => x.hex),
            //     '0x00',
            // );

            console.log(fix.hre.dotnugg.itemsByFeatureById[Features.BACK][1]);
            // console.log(data[0].hex);
            // const res = await fix.compressedResolver.process([ethers.BigNumber.from(data[0].length), ...data[0].hex], '0x00', '0x00');

            // const res = await fix.holder['tokenUri(uint256,address)'](0, fix.compressedResolver.address);
            // const res = await fix.holder['tokenUri(uint256)'](0);

            // console.log(res);

            // dotnugg.log.Console.drawOutput(res);
        });
    });
});
