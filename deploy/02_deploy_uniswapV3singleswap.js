const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const uniSwapRouter = networkConfig[chainId].uniSwapRouter
    const sushiSingleSwap = networkConfig[chainId].sushiSingleSwap
    const args = [uniSwapRouter, sushiSingleSwap]

    const UniswapV3SingleSwap = await deploy("UniswapV3SingleSwap", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        await verify(UniswapV3SingleSwap.address, args)
    }

    log("-------------------------------------------------")
}

module.exports.tags = ["uniswap", "all"]
