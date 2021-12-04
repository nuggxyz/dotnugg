import { subtask } from 'hardhat/config';
import {
    TASK_COMPILE_GET_COMPILATION_TASKS,
    TASK_COMPILE_SOLIDITY,
    TASK_COMPILE_SOLIDITY_FILTER_COMPILATION_JOBS,
    TASK_COMPILE_SOLIDITY_GET_ARTIFACT_FROM_COMPILATION_OUTPUT,
    TASK_COMPILE_SOLIDITY_GET_DEPENDENCY_GRAPH,
    TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS,
    TASK_TEST,
    TASK_TEST_SETUP_TEST_ENVIRONMENT,
} from 'hardhat/builtin-tasks/task-names';
import {
    ArgumentType,
    CompilerOutput,
    CompilerOutputContract,
    HardhatArguments,
    HardhatRuntimeEnvironment,
    RunSuperFunction,
    SolcBuild,
    TaskArguments,
} from 'hardhat/types';

import { TASK_DEPLOY } from 'hardhat-deploy';
import { DotNuggCompiler } from '../../../dotnugg-compiler-2/src/main';

subtask(TASK_TEST_SETUP_TEST_ENVIRONMENT).setAction(
    async (
        args: { sourceName: string; contractName: string; contractOutput: CompilerOutputContract; test: string },
        hre: HardhatRuntimeEnvironment,
        runSuper: RunSuperFunction<unknown>,
    ): Promise<void> => {
        // console.log(args.contractOutput.evm.bytecode.object);
        hre.dotnugg = (await DotNuggCompiler.build('../nuggft-art')) as unknown as any;

        return await runSuper(args);
    },
);
