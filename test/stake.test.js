const Staker = artifacts.require('Staker');
const RewardToken = artifacts.require("RewardToken");

function convert(n) {
    return web3.utils.toWei(n, 'ether');
  }

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Staker', (accounts) => {
  let staker, rewardToken
  const owner = accounts[0]

  before(async () => {
    // Load Contracts
    rewardToken = await RewardToken.new(1000000000000)
    staker = await Staker.new(rewardToken.address)

  })

  describe('Staking and withdrawing tokens', async () => {

    it('rewards accounts for staking', async () => {
        let result

        // Transfer RT
        await rewardToken.transfer(accounts[1], 100000000000, { from: owner})
        await rewardToken.transfer(accounts[2], 50000000000, { from: owner})

        // // Check accounts balance before staking
        result = await rewardToken.balanceOf(accounts[1])
        assert.equal(result.toString(), 100000000000, 'accounts[1] has correct amount')

        // // Stake RT
        await rewardToken.approve(staker.address, 100000000000, { from: accounts[1] })
        await staker.deposit(100000000000, { from: accounts[1]})

        await rewardToken.approve(staker.address, 50000000000, { from: accounts[2] })
        await staker.deposit(50000000000, { from: accounts[2]})

        result = await rewardToken.balanceOf(accounts[1])
        assert.equal(result.toString(), 0, 'accounts[1] has correct amount')

        // // Reward RT
        await staker.reward({ from: owner })

        // // Withdraw RT
        await staker.withdraw(166666666666, { from: accounts[1]})
        await staker.withdraw(83333333333, { from: accounts[2]})

        // // Check accounts balance after staking
        result = await rewardToken.balanceOf(accounts[1])
        assert.equal(result.toString(), '166666666666', 'accounts[1] has correct amount')
        result = await rewardToken.balanceOf(accounts[2])
        assert.equal(result.toString(), '83333333333', 'accounts[1] has correct amount')

        
    })
  })

})
