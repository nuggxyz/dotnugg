// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

// import {DotnuggV1} from '../../DotnuggV1.sol';

// import {DotnuggV1Test} from '../DotnuggV1Test.sol';
// import {IDotnuggV1Implementer} from '../../interfaces/IDotnuggV1Implementer.sol';
// import {MockDotnuggV1Implementer} from '../../_mock/MockDotnuggV1Implementer.sol';

// import {UserTarget} from '../utils/User.sol';

// import {BigMatrix0} from '../objects/BigMatrix0.sol';

// import '../utils/Vm.sol';

contract ImplementerRun {
    function run() public {
        bytes
            memory data = hex"602c6020601b80380380913d390380828082039020815114023df3602060023d358102808201828001808584602d01903983513d85528091510380869006860381838239013df3020033011001bf1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb5822818420690015aec445fec4d19bf38b6b79eb76c6c0aa6e70017e8f714d5fba0b3c62094b08c";

        // address pointer;
        // uint8 size = 128;
        // uint8 start = 0;
        assembly {
            // Deploy a new contract with the generated creation code.
            // We start 32 bytes into the code to avoid copying the byte length.
            let pointer := create(0, add(data, 32), mload(data))

            mstore(0x00, 0x1)

            let a := staticcall(gas(), pointer, 0, 0x20, 0x0, 0)
        }

        // pointer.code;
    }
}
// 1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001
//---------------------------------------------------------------------------------------------------------------
// Opcode  | Opcode + Arguments  | Description  | Stack View
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x60_20            | PUSH1 32     | 32   *****
// 0x80    |  0x80               | DUP          | 32 32               //
// 0x60    |  0x60_1e            | PUSH1 1e     | codeOffset 32 32
// 0x80    |  0x80               | DUP          | codeOffset codeOffset 32 32
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset codeOffset 32 32
// 0x03    |  0x03               | SUB          | DATA_LEN codeOffset 32   32                        //
// 0x80    |  0x80               | DUP          | DATA_LEN DATA_LEN codeOffset 32 32   //
// 0x91    |  0x91               | SWAP2        | codeOffset DATA_LEN DATA_LEN 32 32   //
// 0x60    |  0x60_01            | PUSH1 01     | 01 codeOffset DATA_LEN DATA_LEN 32 32 //
// 0x39    |  0x39               | CODECOPY     | DATA_LEN 32 32
//
// _______10
// 0x03    |  0x03               | SUB          | (DATA_LEN - 32) 32
// 0x80    |  0x80               | DUP          | (DATA_LEN - 32) (DATA_LEN - 32) 32
// 0x82    |  0x82               | DUP3         | 32 (DATA_LEN - 32) (DATA_LEN - 32) 32
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC (DATA_LEN - 32) 32                                               //
// 0x60    |  0x60_00            | PUSH1 00     | 0 TRUSTED_KEC (DATA_LEN - 32) 32

// 0x51    |  0x51               | MLOAD        | UNTRUSTED_KEC TRUSTED_KEK (DATA_LEN - 32) 32
// 0x14    |  0x14               | EQ           | OK (DATA_LEN - 32) 32
// 0x02    |  0x02               | MUL          | VALID_LEN 32
// 0x90    |  0x90               | SWAP         | 32 VALID_LEN
// 0xf3    |  0xf3               | RETURN       |
// ________17
//

//   3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00:
//       0x00  0x67  0x67XXXXXXXXXXXXXXXX  PUSH8 bytecode  0x363d3d37363d34f0
//       0x01  0x3d  0x3d                  RETURNDATASIZE  0 0x363d3d37363d34f0
//       0x02  0x52  0x52                  MSTORE
//       0x03  0x60  0x6008                PUSH1 08        8
//       0x04  0x60  0x6018                PUSH1 18        24 8
//       0x05  0xf3  0xf3                  RETURN
//   0x363d3d37363d34f0:
//       0x00  0x36  0x36                  CALLDATASIZE    cds
//       0x01  0x3d  0x3d                  RETURNDATASIZE  0 cds
//       0x02  0x3d  0x3d                  RETURNDATASIZE  0 0 cds
//       0x03  0x37  0x37                  CALLDATACOPY
//       0x04  0x36  0x36                  CALLDATASIZE    cds
//       0x05  0x3d  0x3d                  RETURNDATASIZE  0 cds
//       0x06  0x34  0x34                  CALLVALUE       val 0 cds
//       0x07  0xf0  0xf0                  CREATE          addr
// require(pointer.code.length != 0, 'DEPLOYMENT_FAILED');

// MockDotnuggV1Implementer impl = new MockDotnuggV1Implementer(processor);

// forge.vm.prank(address(impl));
// impl.dotnuggV1StorageProxy().store(0, dat[0]);

// for (uint8 i = 0; i < 1; i++) {
//     // address res = impl.dotnuggV1StorageProxy().pointer(i);
//     // bytes memory a = res.code;
//     // emit log_named_address('[i]', res);
//     // assertTrue(false);
// }
// // Get a pointer to some free memory.
// data := mload(0x40)

// // Update the free memory pointer to prevent overriding our data.
// // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
// // Adding 31 to size and running the result through the logic above ensures
// // the memory pointer remains word-aligned, following the Solidity convention.
// mstore(0x40, add(data, and(add(add(size, 32), 31), not(31))))

// // Store the size of the data in the first 32 byte chunk of free memory.
// mstore(data, size)

// // Copy the code into memory right after the 32 bytes we used to store the size.
// extcodecopy(pointer, add(data, 32), start, size)

// bytes __data2 =
//     hex'60125981380380925939f3646f746e7567670002000100de1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001786649bb786ebec160886f32184c4fc127cfd3546f902141632047921d19bfbb';

// bytes
//     memory data = hex"3d602080808038038091853903808284815050208351140290f3000420006900a203cfd260d084ddc7e1d19ff9e53ed1c31f73dd86873bbfb8609a80404f1fc660023d358102808201828001806020848160070101903983513d85528091510380913d393df3_02_0027_0104_01b3_1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001";

// bytes
//     memory data = hex"3d6020808080380380918539038082208351140290f300042000006900000000a11ced978cf6be96fcad1e6435e21de8dc728293bb59b5a591d0c88b3c17c9bf60023d358102808201828001806020848160070101903983513d85528091510380913d393df3_02_002d_010a_01b9_1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001";
// memory data = hex"3D_60_20_80_80_80_38_03_80_91_85_39_03_90_F3_00_04_20_00_00_69_00_00000000000000000000_8040049e9133abd913d6db437bc0b591f6312de387ac1a38b8e3f206d6debc11_6002_3D_35_81_02_80_82_01_82_80_01_80_6020_84_81_6006_01_01_90_39_83_51_3D_85_52_80_91_51_03_80_91_3D_39_3D_F3_002a01071e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001";

// memory data = hex"3D60208080803803809185390390F300042000006900000000000000000000008040049e9133abd913d6db437bc0b591f6312de387ac1a38b8e3f206d6debc1160023D358102808201828001806020848160060101903983513D85528091510380913D393DF3002a01071e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001";

// bytes
//     memory data = hex"3D_60_20_80_80_80_38_03_80_91_85_39_03_80_82_84_81_53_20_83_51_14_02_90_F3_00_04_20_00_00_69_00_8040049e9133abd913d6db437bc0b591f6312de387ac1a38b8e3f206d6debc11_6902000100de1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001";

// bytes
//     memory data = hex'60_20_80_60_1f_80_38_03_80_91_60_00_39_03_80_82_20_60_00_51_14_02_90_F3_64_6f_74_6e_75_67_67_7040049e9133abd913d6db437bc0b591f6312de387ac1a38b8e3f206d6debc11_0002000100de1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001';

// bytes
//     memory data = hex'59_60_1e_81_38_03_80_91_59_39_60_20_80_82q_03_90_20_82_51_14_02_90_F3_64_6f_74_6e_75_67_67_00_02000100de1e0392092105e094951052422003e422021431154861402e450c214455314624500372431430850c41535880291c8185503153151188240606163318801955f314320024816736001c616b31801c316f32470c5bcc720316f321316b361316f321314316331895855055d056006050c50c50d050d082406021150c51151050e000e030858c51256100e060835445540c41802e060d592814600f898598881f7203900bc7f08058316031e8005070c850b330a61324ccb5824792ea049dab4789517edc128561f224d67fd0492c9f889128aeb133587dc240104206900106cf81ec0a722a98d006c0861a4a982b001b0218692c608c006c196420a188c006c1869296c82ca16a790c00ca16a990c00ca0eab90c00c10a24afb003042c82be43242a42c643242de43242de43242de43242de43242a64296c1a9e890a1b20b06a9692cc006c1aa3a4b3001b0728e81a8c006c9ca1a4a3203b06a3b40db1e05c6f8402c18b018f400283864285998530991e4ba8128561f224d67fd04894575892593f1124ccb582281842069001786649bb786ebec160886f32184c4fc127cfd3546f902141632047921d19bfbb';

// uint256 header = 0x60_12_59_80_38_03_80_92_59_39_F3_64_6F_74_6E_75_67_67_00;

//---------------------------------------------------------------------------------------------------------------
// Opcode  | Opcode + Arguments  | Description  | Stack View
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x60_20            | PUSH1 32     | 32   *****
// 0x60    |  0x60_12            | PUSH1 19     | codeOffset 32
// 0x80    |  0x80               | DUP          | codeOffset codeOffset 32
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset codeOffset 32
// 0x03    |  0x03               | SUB          | DATA_LEN codeOffset 32                           //
// 0x80    |  0x80               | DUP          | DATA_LEN DATA_LEN codeOffset 32   //
// 0x91    |  0x91               | SWAP2        | codeOffset DATA_LEN DATA_LEN 32   //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset DATA_LEN DATA_LEN 32 //
// 0x39    |  0x39               | CODECOPY     | DATA_LEN 32                                      //
// _______10
// 0x81    |  0x81               | DUP2          | 32 DATA_LEN 32          *****
// 0x80    |  0x80               | DUP          | 32 32 DATA_LEN 32            //
// 0x82    |  0x82               | DUP3         | DATA_LEN 32 32 DATA_LEN 32            //
// 0x03    |  0x03               | SUB          | (DATA_LEN - 32) 32 DATA_LEN 32
// 0x90    |  0x90               | SWAP         | 32 (DATA_LEN - 32) DATA_LEN 32               //
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC DATA_LEN 32                                                   //
// 0x82    |  0x82               | DUP3         | 0 TRUSTED_KEC DATA_LEN 32               //
// 0x51    |  0x51               | MLOAD        | UNTRUSTED_KEC TRUSTED_KEK DATA_LEN 32
// 0x14    |  0x14               | EQ           | OK DATA_LEN 32
// 0x02    |  0x02               | MUL          | VALID_LEN 32
// 0x90    |  0x90               | SWAP         | 32 VALID_LEN
// 0xf3    |  0xf3               | RETURN       |
// ________17
//

//---------------------------------------------------------------------------------------------------------------
// Opcode  | Opcode + Arguments  | Description  | Stack View
//---------------------------------------------------------------------------------------------------------------//
// 0x59    |  0x59               | MSIZE        | 0
// 0x60    |  0x60_12            | PUSH1 19     | codeOffset 0
// 0x80    |  0x80               | DUP          | codeOffset codeOffset 0
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset codeOffset 0
// 0x03    |  0x03               | SUB          | DATA_LEN codeOffset 0                           //
// 0x80    |  0x80               | DUP          | DATA_LEN DATA_LEN codeOffset 0   //
// 0x91    |  0x91               | SWAP2        | codeOffset DATA_LEN DATA_LEN 0   //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset DATA_LEN DATA_LEN 0 //
// 0x39    |  0x39               | CODECOPY     | DATA_LEN 0                                      //
// _______10
// 0x60    |  0x60_20            | PUSH1 32     | 32 DATA_LEN 0
// 0x80    |  0x80               | DUP          | 32 32 DATA_LEN 0            //
// 0x82    |  0x82               | DUP3         | DATA_LEN 32 32 DATA_LEN 0            //
// 0x03    |  0x03               | SUB          | (DATA_LEN - 32) 32 DATA_LEN 0
// 0x90    |  0x90               | SWAP         | 32 (DATA_LEN - 32) DATA_LEN 0               //
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC DATA_LEN 0                                                   //
// 0x82    |  0x82               | DUP3         | 0 TRUSTED_KEC DATA_LEN 0               //
// 0x51    |  0x51               | MLOAD        | UNTRUSTED_KEC TRUSTED_KEK DATA_LEN 0
// 0x14    |  0x14               | EQ           | OK DATA_LEN 0
// 0x02    |  0x02               | MUL          | LEN 0
// 0x90    |  0x90               | SWAP         | 0 LEN
// 0xf3    |  0xf3               | RETURN       |
// ________17
//

// bytes hess = hex'59_60_FF_81_38_03_80_91_59_39_60_20_80_59_03_81_20_81_51_14_02_90_F3_64_6f_74_6e_75_67_67_00';

//---------------------------------------------------------------------------------------------------------------//
// Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x60_12            | PUSH1 19    | codeOffset                                                     //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset
// 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset                                        //
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 codeOffset                               //
// 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 codeOffset                           //
// 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 codeOffset   //
// 0x92    |  0x92               | SWAP3        | codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset)   //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset) //
// 0x39    |  0x39               | CODECOPY     | 0 (codeSize - codeOffset)                                      //
// _______10
// 0x60    |  0x60_20            | PUSH1 32     | 32 0 (codeSize - codeOffset)
// 0x80    |  0x80               | DUP          | 32 32 0 (codeSize - codeOffset)            //
// 0x59    |  0x59               | MSIZE        | MSIZE 32 32 0 (codeSize - codeOffset)
// 0x03    |  0x03               | SUB          | (MSIZE - 32) 32 0 (codeSize - codeOffset)
// 0x81    |  0x81               | DUP2         | 32 (MSIZE - 32) 32 0 (codeSize - codeOffset)               //
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 0 (codeSize - codeOffset)                                                   //
// 0x81    |  0x81               | DUP2         | 0 TRUSTED_KEC 0 (codeSize - codeOffset)               //
// 0x51    |  0x51               | MLOAD        | UNTRUSTED_KEC TRUSTED_KEK 0 (codeSize - codeOffset)
// 0x14    |  0x14               | EQ           | OK 0 (codeSize - codeOffset)
// 0x60    |  0x60_19            | PUSH1 19     | 19 OK 0 (codeSize - codeOffset)
// 0x57	   |  0x57               | JUMP1 19     | 0 (codeSize - codeOffset)
// 0x80    |  0x80               | DUP          | 0 0 (codeSize - codeOffset)            //
// 0xf3    |  0xf3               | RETURN       |                                                           //
// 0x5B	   |  0x5B               | JUMPDEST 19  | 0 (codeSize - codeOffset)
// 0xf3    |  0xf3               | RETURN       |
// ________17
//
//---------------------------------------------------------------------------------------------------------------//

//---------------------------------------------------------------------------------------------------------------//
// Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x6012             | PUSH1 19     | codeOffset                                                     //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset
// 0x59    |  0x59               | MSIZE        | 0 0 codeOffset                                                   //
// 0x82    |  0x82               | DUP3         | codeOffset 0 0 codeOffset                                        //
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 0 codeOffset                               //
// 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 0 codeOffset                           //
// 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 0 codeOffset   //
// 0x93    |  0x93               | SWAP4        | codeOffset (codeSize - codeOffset) 0 0 (codeSize - codeOffset)   //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 0 (codeSize - codeOffset) //
// 0x39    |  0x39               | CODECOPY     | 0 0 (codeSize - codeOffset)                                      //

// 0x60    |  0x60_20            | PUSH1 32     | 32 0 0 (codeSize - codeOffset)
// 0x80    |  0x80               | DUP          | 32 32 0 0 (codeSize - codeOffset)               //
// 0x59    |  0x59               | MSIZE        | MSIZE 32 32 0 0 (codeSize - codeOffset)
// 0x03    |  0x03               | SUB          | (MSIZE - 32) 32 0 0 (codeSize - codeOffset)
// 0x80    |  0x80               | DUP          | 32 (MSIZE - 32) 32 0 0 (codeSize - codeOffset)               //
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 32 0 0 (codeSize - codeOffset)                                                   //
// 0x91    |  0x91               | SWAP2        | 0 32 (MSIZE - 32) 0 (codeSize - codeOffset)
// 0x51    |  0x51               | MLOAD        |

// 0x92    |  0x92               | SWAP3        | 0 32 32 (MSIZE - 32) 0 (codeSize - codeOffset)
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 0 (codeSize - codeOffset)                                                      //

// 0x60    |  0x60_00            | PUSH1 0      | 0 32 0 (codeSize - codeOffset)
// 0x59    |  0x59               | MSIZE        |
//
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 0 (codeSize - codeOffset)                                                      //

// 0xf3    |  0xf3               | RETURN       |                                                                //
//---------------------------------------------------------------------------------------------------------------//

// 0x92    |  0x92               | SWAP3        | 0 32 32 (MSIZE - 32) 0 (codeSize - codeOffset)
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 0 (codeSize - codeOffset)                                                      //

// 0x60    |  0x60_00            | PUSH1 0      | 0 32 0 (codeSize - codeOffset)
// 0x59    |  0x59               | MSIZE        |
//
// 0x20    |  0x20               | SHA3         | TRUSTED_KEC 0 (codeSize - codeOffset)                                                      //

// 1. push unset
// 2. push codesize
//
// 3.

//---------------------------------------------------------------------------------------------------------------//
// Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x6012             | PUSH1 19     | codeOffset
// 0x59    |  0x59               | MSIZE        | 0 codeOffset
// 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset
// 0x60    |  0x60_20            | PUSH1 32     | X codeOffset 0 codeOffset
// 0x38    |  0x38               | CODESIZE     | codeSize X codeOffset 0 codeOffset
// 0x03    |  0x03               | SUB          | (codeSize - X) codeOffset 0 codeOffset
// 0x80    |  0x80               | DUP          | (codeSize - X) (codeSize - X) codeOffset 0 codeOffset
// 0x91    |  0x91               | SWAP2        | codeOffset (codeSize - X) (codeSize - X) 0 codeOffset
// 0x90    |  0x90               | SWAP1        | (codeSize - X) codeOffset  (codeSize - X) 0 codeOffset
// 0x03    |  0x03               | SUB          | (codeSize - X -codeOffset ) (codeSize - X) 0 codeOffset
// 0x80    |  0x80               | DUP          | (codeSize - X -codeOffset ) (codeSize - X -codeOffset ) (codeSize - X) 0 codeOffset
// 0x93    |  0x93               | SWAP4        | codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
// 0x81    |  0x81               | DUP2         | (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
// 0x81    |  0x81               | DUP2         | codeOffset (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
// 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - X -codeOffset ) codeOffset (codeSize - X -codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
// 0x39    |  0x39               | CODECOPY     | codeOffset (codeSize - X - codeOffset ) (codeSize - X) 0 (codeSize - X - codeOffset )
// 0x39    |  0x39               | CODECOPY     | 0 DATA_LEN
// 0xf3    |  0xf3               | RETURN       |                                                                //
//---------------------------------------------------------------------------------------------------------------//

//---------------------------------------------------------------------------------------------------------------//
// Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
//---------------------------------------------------------------------------------------------------------------//
// 0x60    |  0x6012             | PUSH1 19     | codeOffset                                                     //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset                                                   //
// 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset                                        //
// 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 codeOffset                               //
// 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 codeOffset                           //
// 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 codeOffset   //
// 0x92    |  0x92               | SWAP3        | codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset)   //
// 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset) //

// swap1
// dup2
// swap2

// 0x39    |  0x39               | CODECOPY     | 0 0 (codeSize - codeOffset)                                      //

// 0x60    |  0x60_20            | PUSH1 32     | X 0 0 (codeSize - codeOffset)
// 0x80    |  0x80               | DUP          | X X 0 0 (codeSize - codeOffset)   //
// 0x83    |  0x83               | DUP4         | (codeSize - codeOffset) X X 0 0 (codeSize - codeOffset)   //
// 0x03    |  0x03               | SUB          | (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)                           //
// 0x80    |  0x80               | DUP          | (codeSize - codeOffset - X) (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)
// 0x92    |  0x92               | SWAP3        | X (codeSize - codeOffset - X) (codeSize - codeOffset - X) 0 0 (codeSize - codeOffset)
// 0x93    |  0x93               | SWAP4        | 0 (codeSize - codeOffset - X) (codeSize - codeOffset - X) X 0 (codeSize - codeOffset)
// 0x01    |  0x01               | ADD          | (codeSize - codeOffset - X + 0)[KEK_MEM_LOC] (codeSize - codeOffset - X)  X 0 (codeSize - codeOffset)

// 0x51    |  0x51               | MLOAD        | TRUSTED_KEK (codeSize - codeOffset - X) X 0 (codeSize - codeOffset)

// 0x03    |  0x03               | SUB          | (codeSize - codeOffset - X) X 0 0 (codeSize - codeOffset)                           //

// 0x20    |  0x20               | SHA3         | K 0 (codeSize - codeOffset)

// swap 1                                         0 (codeSize - codeOffset - X)  0 (codeSize - codeOffset)

// 0xf3    |  0xf3               | RETURN       |                                                                //

// pos	opcode 	name	stack
// 00	3D	    RETSIZE	        [0]
// 01	60 [20] PUSH1	        [32] 0
// 03	80	    DUP1	        [32] 32 0
// 04	80	    DUP1	        [32] 32 32 0
// 05	80	    DUP1            [32] 32 32 32 0
// 06	38	    CODESIZE        [MYSIZE] 32 32 32 0
// 07	03	    SUB             <A: MYSIZE - 32> 32 32 0
// 08	80	    DUP1            [A] A 32 32 0
// 09	91	    SWAP2           (32) A (A) 32 32 0
// 0A	85	    DUP6            [0] 32 A A 32 32 0
// 0B	39	    CODECOPY        {0 32 A} A 32 32 0
// 0C	03	    SUB             <B: A - 32> 32 0
// 0D	80	    DUP1            [B] B 32 0
// 0E	82	    DUP3            [32] B B 32 0
// 0F	84	    DUP5            [0] 32 B B 32 0
// 10	81	    DUP2            [32] 0 32 B B 32 0
// 11	53	    MSTORE8         {32 0} 32 B B 32 0
// 12	20	    sha3            <C: kek(32 B)> B 32 0
// 13	83	    DUP4            [0] C B 32 0
// 14	51	    MLOAD           <D: mload(0)> C B 32 0
// 15	14	    EQ              <E: eq(D, C)> B 32 0
// 16	02	    MUL             <F: F * B = 0 | B> 32 0
// 17	90	    SWAP            (32) (F) 0
// 18	F3	    STOP

// pos	opcode 	name	stack
// 00	3D	RETURNDATASIZE	[0]
// 01	60 [20]    PUSH1	[32] 0
// 03	80	DUP1	[32] 32 0
// 04	80	DUP1	[32] 32 32 0
// 05	80	DUP1    [32] 32 32 32 0
// 06	38	CODESIZE    [MYSIZE] 32 32 32 0
// 07	03	SUB    <A: MYSIZE - 32> 32 32 0
// 08	80	DUP1   	[A] A 32 32 0
// 09	91	SWAP2   	(32) A (A) 32 32 0
// 0A	85	DUP6    [0] 32 A A 32 32 0
// 0B	39	CODECOPY    {0 32 A} A 32 32 0
// 0C	03	SUB    <B: A - 32> 32 0
// 0D	80	DUP1    [B] B 32 0
// 0E	82	DUP3    [32] B B 32 0
// 0F	84	DUP5    [0] 32 B B 32 0
// 10	81	DUP2    [32] 0 32 B B 32 0
// 11	53	MSTORE8    {32 0} 32 B B 32 0
// 12	20	sha3    <C: kek(32 B)> B 32 0
// 13	83	DUP4    [0] C B 32 0
// 14	51	MLOAD    <D: mload(0)> C B 32 0
// 15	14	EQ    <E: eq(D, C)> B 32 0
// 16	02	MUL   	<F: F * B = 0 | B> 32 0
// 17	90	SWAP    (32) (F) 0
// 18	F3	STOP

// add = []
// move= ()
// delete = {}
// transform = <>
// +=====+=========+==========+==========================+
// | pos | opcode  |   name   |          stack           |
// +=====+=========+==========+==========================+
// | 00  | 3D      | RETSIZE  | [0]                      |
// +-----+---------+----------+--------------------------+
// | 01  | 60 [20] | PUSH1    | [32] 0                   |
// +-----+---------+----------+--------------------------+
// | 03  | 80      | DUP1     | [32] 32 0                |
// +-----+---------+----------+--------------------------+
// | 04  | 80      | DUP1     | [32] 32 32 0             |
// +-----+---------+----------+--------------------------+
// | 05  | 80      | DUP1     | [32] 32 32 32 0          |
// +-----+---------+----------+--------------------------+
// | 06  | 38      | CODESIZE | [MYSIZE] 32 32 32 0      |
// +-----+---------+----------+--------------------------+
// | 07  | 03      | SUB      | <A: MYSIZE - 32> 32 32 0 |
// +-----+---------+----------+--------------------------+
// | 08  | 80      | DUP1     | [A] A 32 32 0            |
// +-----+---------+----------+--------------------------+
// | 09  | 91      | SWAP2    | (32) A (A) 32 32 0       |
// +-----+---------+----------+--------------------------+
// | 0A  | 85      | DUP6     | [0] 32 A A 32 32 0       |
// +-----+---------+----------+--------------------------+
// | 0B  | 39      | CODECOPY | {0 32 A} A 32 32 0       |
// +-----+---------+----------+--------------------------+
// | 0C  | 03      | SUB      | <B: A - 32> 32 0         |
// +-----+---------+----------+--------------------------+
// | 0D  | 80      | DUP1     | [B] B 32 0               |
// +-----+---------+----------+--------------------------+
// | 0E  | 82      | DUP3     | [32] B B 32 0            |
// +-----+---------+----------+--------------------------+
// | 0F  | 84      | DUP5     | [0] 32 B B 32 0          |
// +-----+---------+----------+--------------------------+
// | 10  | 81      | DUP2     | [32] 0 32 B B 32 0       |
// +-----+---------+----------+--------------------------+
// | 11  | 53      | MSTORE8  | {32 0} 32 B B 32 0       |
// +-----+---------+----------+--------------------------+
// | 12  | 20      | SHA3     | <C: kek(32 B)> B 32 0    |
// +-----+---------+----------+--------------------------+
// | 13  | 83      | DUP4     | [0] C B 32 0             |
// +-----+---------+----------+--------------------------+
// | 14  | 51      | MLOAD    | <D: mload(0)> C B 32 0   |
// +-----+---------+----------+--------------------------+
// | 15  | 14      | EQ       | <E: eq(D, C)> B 32 0     |
// +-----+---------+----------+--------------------------+
// | 16  | 02      | MUL      | <F: F * B = 0 | B> 32 0  |
// +-----+---------+----------+--------------------------+
// | 17  | 90      | SWAP     | (32) (F) 0               |
// +-----+---------+----------+--------------------------+
// | 18  | F3      | STOP     |                          |
// +-----+---------+----------+--------------------------+
