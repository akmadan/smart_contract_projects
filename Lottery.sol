// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{ 
    address public manager; 
    address payable[] public participants; //ether are to be paid by participant

    constructor(){
        manager = msg.sender; //manager of Lottery Smart Contract
    } 

    //receive function can be used only once
    receive() external payable {
        require(msg.value==2 ether);
        participants.push(payable(msg.sender));

    }

    //only manager can check balance
    function getBalance()public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random()public view returns(uint){ 
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));

    }
    function selectWinner()public{ 
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r%participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
        
    }
}
