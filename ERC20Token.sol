pragma solidity ^0.8.7; 

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

contract AkshitToken is ERC20{ 

    address public admin;

    constructor() ERC20('AkshitToken' , 'ATN'){ 
        admin = msg.sender; 
        _mint(msg.sender, 1000);
    }

    function mint(address to, uint amount) external {
        require(msg.sender == admin, "Not an admin"); 
        _mint(to, amount); 

    }


    function burn(uint amount)external { 
        _burn(msg.sender, amount);
    }
}
