const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    const sushiSwapRouter = networkConfig[chainId].sushiSwapRouter

    const args = [sushiSwapRouter]
    const SushiSingleSwap = await deploy("SushiSingleSwap", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        await verify(SushiSingleSwap.address, args)
    }

    log("-------------------------------------------------")
}

module.exports.tags = ["sushiswap", "all"]
