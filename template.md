pre-deployment:

1. compile NuggftV1
2. generate initcodehash for NuggftV1
3. generate private key for deployer
4. run create2cruch to get seed for NuggftV1

deployment:

1. dub6ix sends eth to deployer eoa
2. deployer deploys DotnuggV1 & NuggftV1Deployer
3. deployer sends remaining eth back to dub6ix
