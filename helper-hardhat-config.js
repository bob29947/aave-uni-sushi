const networkConfig = {
    31337: {
        name: "localhost",

        sushiSwapRouter: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        sushiSingleSwap: "0xCB6637989Df0571e8E93aCB4d15dA7201Eea3d0f",

        uniSwapRouter: "0xE592427A0AEce92De3Edee1F18E0157C05861564",
        uniswapV3SingleSwap: "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9",

        poolAddressProvider: "0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb",
    },

    5: {
        name: "goerli",

        sushiSwapRouter: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        sushiSingleSwap: "0xAbDb734a9d79D9815cc756C8Bc73901B46Bd0f0d",

        uniSwapRouter: "0xE592427A0AEce92De3Edee1F18E0157C05861564",
        uniswapV3SingleSwap: "0x00C21BaD8820c1CbbE501929Ba473124ef9c0CD3",

        poolAddressProvider: "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D",
        aaveV3FlashLoan: "0xEedD550bE34D00d83e440066651d16148E53e347",

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
