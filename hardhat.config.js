require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
const SEPOLIA_RPC_URL =
    process.env.SEPOLIA_RPC_URL ||
    "https://eth-sepolia.g.alchemy.com/v2/F-zyN1ITwv9KYxjuSdeRgrsVjAXej9xN"
const PRIVATE_KEY =
    process.env.PRIVATE_KEY ||
    "0x932c1bc3b1299d5bf4263cc8c94800d082f7fafd14fe2da650dd878cd30424d7"
    
module.exports = {
  solidity: "0.8.7",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
    },
    sepolia: {
        url: SEPOLIA_RPC_URL,
        accounts: [PRIVATE_KEY],
        chainId: 11155111,
        blockConfirmations: 6,
    },
  },
  namedAccounts: {
    player: {
      default: 0,
    },
    deployer: {
      default: 0,
    },
  },
};
