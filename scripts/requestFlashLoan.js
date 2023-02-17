const { getNamedAccounts, ethers } = require("hardhat")
const { networkConfig } = require("../helper-hardhat-config")
async function main() {
    const { deployer } = await getNamedAccounts()
    const aaveV3FlashLoan = await ethers.getContract("AaveV3FlashLoan", deployer)

    const txResponse = await aaveV3FlashLoan.requestFlashLoan(
        networkConfig[network.config.chainId].borrowAmount,
        networkConfig[network.config.chainId].aaveUsdc,
        networkConfig[network.config.chainId].aaveDai
    )
    const txReciept = await txResponse.wait(1)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
