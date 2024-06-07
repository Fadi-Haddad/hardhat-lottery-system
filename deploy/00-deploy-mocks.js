const { network } = require("hardhat");
const { networkConfig, developmentChains} = require("../helper-hardhat-config");
require("dotenv").config();

async function deployFundMe({ deployments, getNamedAccounts }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

//   if (developmentChains.includes(chainId.name)) { // chainId.name doesn't exist
  if (chainId == 31337) {
    await deploy("VRFCoordinatorV2Mock", {
      contract: "VRFCoordinatorV2Mock",
      log: true,
      from: deployer,
      args: [BASE_FEE, GAS_PRICE_LINK], // required params obtained from VRFCoordinatorV2Mock constructor function
    });
    console.log("Mocks Deployed");
    console.log("------------------------------");
  }
}

module.exports = deployFundMe;

module.exports.tags = ["all","mocks"];