// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Token {

    uint public totalSupply;
    event Transfer(address sender, address recepient, uint amount);
    event Approval(address owner, address spender, uint amount);

    /**
     * @dev creates new tokens.total supply is then increased
     */
    function createTokens() public {
        // code here 

    }

    /**
     * @dev transfer amount from sender to recepient
     * Returns true If transfer was done
     */
    function transferFrom(address sender, address recepient, uint amount) public returns (bool) {
        // code here
    }

    /**
     * @dev approve sending of tokens on the owner's behalf by the sender
     * Returns true if approved
     */
    function approve(address owner, address spender, uint amount) public returns (bool) {
        // code here

    }


}
