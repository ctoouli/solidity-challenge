// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./RewardToken.sol";

contract Staker {
    using SafeMath for uint256;

    address public owner;
    RewardToken rewardToken;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;
    uint256 public stakerCount = 0;
    uint256 public totalStaked = 0;

    constructor(RewardToken _rewardToken) public {
        owner = msg.sender;
        rewardToken = _rewardToken;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function addStaker(address _address) internal {
        if(hasStaked[_address] == false) {
            stakers.push(_address);
        }
        if(isStaking[_address] == false) {
            isStaking[_address] = true;
            stakerCount++;
        }
    }

    function removeStaker(address _address) internal {
        if(isStaking[_address] == true && stakingBalance[_address] == 0) {
            isStaking[_address] = false;
        }
    }

    function deposit(uint _amount) external {
        if(isStaking[msg.sender] == false) {
            addStaker(msg.sender);
        }
        rewardToken.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add(_amount);
        totalStaked = totalStaked.add(_amount);
    }

    function withdraw(uint _amount) external {
        require(stakingBalance[msg.sender] >= _amount);
        rewardToken.transfer(msg.sender, _amount);

        stakingBalance[msg.sender] = stakingBalance[msg.sender].sub(_amount);
        totalStaked = totalStaked.sub(_amount);

        if(stakingBalance[msg.sender] == 0) {
            removeStaker(msg.sender);
        }
    }

    function reward() isOwner public {
        rewardToken.mint(address(this), 100000000000);
        for(uint256 i = 0; i < stakerCount; i++) {
            address staker = stakers[i];
            if(isStaking[staker] == true) {
                uint256 balance = stakingBalance[staker];
                uint256 rewardAmount = balance.mul(100000000000); // (balance/total) * 100
                rewardAmount = rewardAmount.div(totalStaked);
                stakingBalance[staker] = balance.add(rewardAmount);
            }
        }
        totalStaked += 100000000000;
    }
}
