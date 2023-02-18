const networkConfig = {
    31337: {
        name: "localhost",
    },

    5: {
        name: "goerli",
        sushiSwapRouter: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        sushiSingleSwap: "0xCB6637989Df0571e8E93aCB4d15dA7201Eea3d0f",

        uniSwapRouter: "0xE592427A0AEce92De3Edee1F18E0157C05861564",
        uniswapV3SingleSwap: "0xdd1E450DA7B04BB6e0E398B6aB42cC68A808fb7B",
        poolAddressProvider: "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D",
        //aaveV3FlashLoan: "0x64228f0C9C0F834978f5Ebf0fc775e0C6cF5b99e",
        borrowAmount: "4000000",
        aaveUsdc: "0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43",
        aaveDai: "0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464",
    },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains,
}
