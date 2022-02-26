//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract VendingMachine{ 
    address public owner; 
    mapping (address => uint) public donutBalances; 

    constructor(){ 
        owner = msg.sender; 
        donutBalances[address(this)] = 100; 
    }


    function getBalanceOfVendingMachine() public view returns{
        return donutBalances[address(this)] //return no. of donuts present in vending machine 
    }

    function restock(uint amount) public{ 
        require(owner == msg.sender); 
        donutBalances[address(this)]+=amount; 
    }

    function purchase(uint amount) payable{
        require(msg.value>= amount* 1 wei, "Less amount sent"); 
        require(donutBalances[address(this)] >= amount, "Not enough donut left");  
        donutBalances[address(this)]-=amount; 
        donutBalances[msg.sender] += amount; 
    }
}
