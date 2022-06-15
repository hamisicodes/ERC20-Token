// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract Token {

    address public owner;
    uint public totalSupply;
    mapping (address => uint) public balance;
    mapping (address => bool) public blacklist;
    address[] public specialAddresses;
    address public government;

    event Transfer(address from, address to, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner(){
        require(owner == msg.sender, "Admin only allowed");
        _;
    }

    function setGovernmentAddr(address _addr) isOwner public {
        government = _addr;
    }

    modifier onlyGovernment(){
        require(msg.sender == government, "Permission denied");
        _;
    }

    function addToBlacklist(address _addr) public onlyGovernment {
        blacklist[_addr] = true;
    }

    function removeFromBlacklist(address _addr) public onlyGovernment {
        delete blacklist[_addr];
    }


    function mintTokensToAddress(address recipient, uint amount) public  returns (bool) {
        for (uint i = 0; i < specialAddresses.length; i++){
            if (msg.sender == specialAddresses[i]){
                balance[recipient] += amount;
                totalSupply += amount;
                emit Transfer(address(0), recipient, amount);
                return true;
            }
        }
        revert("Cannot mint");
    }

    function reduceTokensAtAddress(address target, uint amount) public  returns (bool) {
        for (uint i = 0; i < specialAddresses.length; i++){
            if (msg.sender == specialAddresses[i]){
                require(balance[target] >= amount, "Not enough tokens");
                balance[target] -= amount;
                totalSupply -= amount;
                emit Transfer(target, address(0), amount);
                return true;
            }
        }
        revert("Cannot reduce");
    }

    function authoritativeTransferFrom(address from, address to, uint amount) public returns  (bool) {
        for (uint i = 0; i < specialAddresses.length; i++){
            if (msg.sender == specialAddresses[i]){
                require(balance[from] >= amount, "Insufficient balance");
                balance[from] -= amount;
                balance[to] += amount;
                emit Transfer(from, to, amount);
                return true;
            }
        }
        revert("Cannot transfer");
    }
}
