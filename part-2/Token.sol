// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract Token {

    address public owner;
    uint public totalSupply;
    mapping (address => uint) public balance;
    address[] public specialAddresses;
    event Transfer(address from, address to, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner(){
        require(owner == msg.sender, "Admin only allowed");
        _;
    }
}

