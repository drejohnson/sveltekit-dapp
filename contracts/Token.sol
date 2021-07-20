//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract Token {
	string public name = 'DefCoin';
	string public symbol = 'DEF';
	uint256 public totalSupply = 1000000;
	mapping(address => uint256) balances;

	constructor() {
		balances[msg.sender] = totalSupply;
	}

	function transfer(address _to, uint256 _amount) external {
		require(balances[msg.sender] >= _amount, 'Insufficient funds');
		balances[msg.sender] -= _amount;
		balances[_to] += _amount;
	}

	function balanceOf(address _account) external view returns (uint256) {
		return balances[_account];
	}
}
