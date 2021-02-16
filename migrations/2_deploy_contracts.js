const Staker = artifacts.require('Staker');
const RewardToken = artifacts.require("RewardToken");

module.exports = async function(deployer) {
    // Deploy Mock DAI Token
    await deployer.deploy(RewardToken, 1000000000000);
    const rewardToken = await RewardToken.deployed();
  
    await deployer.deploy(Staker, rewardToken.address);
  }