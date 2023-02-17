const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const poolAddressProvider = networkConfig[chainId].poolAddressProvider
    const uniswapV3SingleSwap = networkConfig[chainId].uniswapV3SingleSwap
    const sushiSingleSwap = networkConfig[chainId].sushiSingleSwap
    const args = [poolAddressProvider, uniswapV3SingleSwap]

    const AaveV3FlashLoan = await deploy("AaveV3FlashLoan", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        await verify(AaveV3FlashLoan.address, args)
    }

    log("-------------------------------------------------")
}

module.exports.tags = ["aave", "all"]
