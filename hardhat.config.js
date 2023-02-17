require("dotenv").config()
require("hardhat-deploy")
require("@nomicfoundation/hardhat-toolbox")
const PRIVATE_KEY = process.env.PRIVATE_KEY || "0xkey"
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || "https://eth-goerli"
const MAINNET_RPC_URL = process.env.MAINNET_RPC_URL || process.env.ALCHEMY_MAINNET_RPC_URL || ""
const OPTIMISM_RPC_URL = process.env.OPTIMISM_RPC_URL || ""
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "key"
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "key"

module.exports = {
    solidity: {
        compilers: [{ version: "0.8.10" }, { version: "0.7.6" }, { version: "0.6.12" }],
    },
    networks: {
        hardhat: {
            chainId: 31337,
            forking: {
                url: OPTIMISM_RPC_URL,
                blockNumber: 16220809,
            },
        },
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
}
