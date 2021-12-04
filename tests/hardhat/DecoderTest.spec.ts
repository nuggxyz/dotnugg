// import {
//     ethers,
//     waffle,
// } from 'hardhat';

// import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';

// import { NamedAccounts } from '../../hardhat.config';
// import {
//     DecoderTest,
//     DecoderTest__factory,
//     SvgNuggIn,
//     SvgNuggIn__factory,
// } from '../../types';
// import {
//     deployContract,
//     prepareAccounts,
// } from './';

// // import { getHRE } from './shared/deployment';
// const createFixtureLoader = waffle.createFixtureLoader;
// const {
//     constants: { MaxUint256 },
// } = ethers;

// let loadFixture: ReturnType<typeof createFixtureLoader>;
// let accounts: Record<keyof typeof NamedAccounts, SignerWithAddress>;
// let plain: DecoderTest;
// let nuggin: SvgNuggIn;

// const refresh = async () => {
//     accounts = await prepareAccounts();
//     loadFixture = createFixtureLoader();
//     plain = await deployContract<DecoderTest__factory>({ factory: 'DecoderTest', from: accounts.frank, args: [] });
//     nuggin = await deployContract<SvgNuggIn__factory>({ factory: 'SvgNuggIn', from: accounts.frank, args: [] });
// };

// // describe('anchor tests', async function () {
// //     beforeEach(async () => {
// //         await refresh();
// //     });

// // describe('getBox', async () => {
// //     it('good box :)', async () => {
// //         const [a, b, c, d] = await anchor.tfizzle();
// //         expect(a).to.equal(9);
// //         expect(b).to.equal(10);
// //         expect(c).to.equal(16);
// //         expect(d).to.equal(11);
// //     });
// // });

// // describe('getAnchors', async () => {
// //     it('good anchors :)', async () => {
// //         const vals = await anchor.tswizzle();
// //         console.log(vals)
// //         expect(vals[0].a).to.equal(16);
// //         expect(vals[0].b).to.equal(11);
// //         expect(vals[1].a).to.equal(16);
// //         expect(vals[1].b).to.equal(2);
// //         expect(vals[2].a).to.equal(16);
// //         expect(vals[2].b).to.equal(6);
// //         expect(vals[3].a).to.equal(16);
// //         expect(vals[3].b).to.equal(16);
// //         expect(vals[4].a).to.equal(16);
// //         expect(vals[4].b).to.equal(21);
// //     });
// // })
// //     describe('all the receivers shit', async () => {
// //         it('good receivers', async () => {
// //             const vals = await plain.tfizzle(nuggin.address, nuggin.address);
// //         });
// //     });
// // });
