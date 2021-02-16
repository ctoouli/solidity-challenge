// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("RewardToken", "RT") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address _address, uint256 _amount) public {
        _mint(_address, _amount);
    }
}