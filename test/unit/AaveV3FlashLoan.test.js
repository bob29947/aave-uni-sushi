const { assert, expect } = require("chai")
const { network, getNamedAccounts, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../../helper-hardhat-config")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("AaveV3FlashLoan unit tests", function () {
          let aaveV3FlashLoan, uniswapV3SingleSwap, sushiSingleSwap

          beforeEach(async function () {
              deployer = (await getNamedAccounts()).deployer
              await deployments.fixture(["all"])

              sushiSingleSwap = await ethers.getContract("SushiSingleSwap", deployer)
              aaveV3FlashLoan = await ethers.getContract("AaveV3FlashLoan", deployer)
              uniswapV3SingleSwap = await ethers.getContract("UniswapV3SingleSwap", deployer)
          })

          describe("constructor", async function () {
              it("initializes the owner correctly", async function () {
                  const owner = await aaveV3FlashLoan.getOwner()
                  assert.equal(owner, deployer)
              })
          })
      })
