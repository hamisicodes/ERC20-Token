// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Token {

    uint public totalSupply;
    mapping (address => uint) public balance;
    mapping (address => mapping(address => uint)) public approvals;
    event Transfer(address sender, address recepient, uint amount);
    event Approval(address owner, address spender, uint amount);

    /**
     * @dev creates new tokens.total supply is then increased
     */
    function mint(uint amount) public {
        balance[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    /**
     * @dev transfer amount from caller's account to recepient
     * Returns true If transfer was done
     */
    function transfer(address recepient, uint amount) public returns (bool) {
        balance[msg.sender] -= amount;
        balance[recepient] += amount;
        emit Transfer(msg.sender, recepient, amount);

        return true;
    }

    /**
     * @dev transfer amount from sender's account to recepient
     * Returns true If transfer was done
     */
    function transferFrom(address sender, address recepient, uint amount) public returns (bool) {
        if (approvals[sender][msg.sender] >= amount){
            approvals[sender][msg.sender] -= amount;
            balance[sender] -= amount;
            balance[recepient] += amount;
            emit Transfer(sender, recepient, amount);
            return true;
        }else{
            revert("You cannot perform this operation");
        }

    }

    /**
     * @dev approve sending of tokens on the owner's behalf by the sender
     * Returns true if approved
     */
    function approve(address spender, uint amount) public returns (bool) {
        approvals[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }


}
