const { getNamedAccounts, ethers } = require("hardhat")
const { networkConfig } = require("../helper-hardhat-config")
async function main() {
    const { deployer } = await getNamedAccounts()
    const sushiSingleSwap = await ethers.getContract("SushiSingleSwap", deployer)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
