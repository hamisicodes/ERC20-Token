// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract Token {

    address public owner;
    uint public totalSupply;
    uint public decimals = 18;
    mapping (address => uint) public balance;
    mapping (address => bool) public blacklist;
    mapping (address => uint) public payments;
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

    function _beforeTokenTransfer(address from, address to) internal view {
        if (blacklist[from]){
            revert("sender address blacklisted");
        }else if (blacklist[to]){
            revert("recepient address blacklisted");
        }
    }

    function mintTokensToAddress(address recipient, uint amount) public  returns (bool) {
        _beforeTokenTransfer(address(0), recipient);

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
        _beforeTokenTransfer(target, address(0));

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
        _beforeTokenTransfer(from, to);

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

    function deposit() public payable {
        payments[msg.sender] += msg.value;
    }

    function convertToEthers(uint amount) public pure returns (uint) {
        return amount/10**18;
    }

    function mint() public {
        uint ethers = convertToEthers(payments[msg.sender]);
        require(ethers >= 1, "cannot mint");
        balance[msg.sender] += ethers * 1000;
        totalSupply += (ethers * 1000);
        assert(totalSupply < 10**6); //total supply not exceeding  million
        payments[msg.sender] -= (ethers * 10**18);
    }

    function withdraw() public isOwner returns (bool) {
        payable(msg.sender).transfer(address(this).balance);
        return true;
    }
}
