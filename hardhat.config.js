require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
// require("@nomiclabs/hardhat-etherscan");
// require("@nomiclabs/hardhat-ethers");
// require("dotenv").config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.0",
  networks: {
    'goerli': {
      url: process.env.VCC_ETH_GOERLI,
      accounts: [process.env.PRIVATE_KEY]
    },
    'base-goerli': {
      url: process.env.BASE_GOERLI,
      accounts: [process.env.PRIVATE_KEY],
      gasPrice: 35000000000,
      saveDeployments: true,
    },
    'scroll-sepolia': {
      url: process.env.SCROLL_SEP_TESTNET,
      accounts: [process.env.PRIVATE_KEY]
    },    
    'arbitrum-goerli': {
      url: process.env.ARB_GOERLI,
      accounts: [process.env.PRIVATE_KEY]
    },
    'matic': {
      url: process.env.MUMBAI,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  'etherscan': {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  customChains: [
    {
      network: "base-goerli",
      chainId: 84531,
      urls: {
       apiURL: "https://api-goerli.basescan.org/api",
       browserURL: "https://goerli.basescan.org"
      }
    }
  ]

};
