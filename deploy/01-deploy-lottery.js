const { network } = require("hardhat");
const {verify} = require ("../utils/verify")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
require("dotenv").config()

async function deployLottery({ deployments, getNamedAccounts }) {
    
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();

    const lottery = await deploy("Lottery", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.waitConfirmations || 1,
      });
}