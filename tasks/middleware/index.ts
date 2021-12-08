// import { subtask } from 'hardhat/config';
// import { TASK_TEST_SETUP_TEST_ENVIRONMENT } from 'hardhat/builtin-tasks/task-names';
// import { CompilerOutputContract, HardhatRuntimeEnvironment, RunSuperFunction } from 'hardhat/types';

// import { DotNuggCompiler } from '../../../dotnugg-compiler-2/src/main';

// subtask(TASK_TEST_SETUP_TEST_ENVIRONMENT).setAction(
//     async (
//         args: { sourceName: string; contractName: string; contractOutput: CompilerOutputContract; test: string },
//         hre: HardhatRuntimeEnvironment,
//         runSuper: RunSuperFunction<unknown>,
//     ): Promise<void> => {
//         // console.log(args.contractOutput.evm.bytecode.object);
//         hre.dotnugg = (await DotNuggCompiler.build('../nuggft-art')) as unknown as any;

//         return await runSuper(args);
//     },
// );
