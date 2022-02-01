//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;


contract CrowdFunding{ 
    mapping(address=>uint) public contributors; 
    address public manager;
    uint public deadline; 
    uint public noOfContributors; 
    uint public target; 
    uint public raisedMoney; 
    uint public minimumContribtion;

    struct Request{ 
        string description; 
        address payable recepient; 
        uint noOfVoters; 
        uint value; 
        bool completed; 
        mapping(address => bool) voters; 
    }

    mapping(uint => Request) public requests; 
    uint public numRequests;

    
 
    constructor(){
        target= 1000 wei;
        deadline=block.timestamp + 3600; //10sec + 3600sec (60*60)
        minimumContribtion=100 wei;
        manager=msg.sender;
    }


    function sendEth()public payable { 
        require(block.timestamp<deadline, "Deadline Missed") ;
        require(msg.value>=minimumContribtion, "Minimum Contribution is not met");


        // same contributor should not be counted more than once
        if(contributors[msg.sender] == 0){ 
            noOfContributors++ ;
            
        }
        contributors[msg.sender]+= msg.value; 
            raisedMoney+=msg.value; 

    }
    function getBalance()public view returns(uint){ 
        return address(this).balance;
    }
    function refund()public{ 
        require(block.timestamp>deadline && raisedMoney<target);
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender); 
        user.transfer(contributors[msg.sender]); //return back the money
        contributors[msg.sender] = 0;
    }



    modifier onlymanager(){
        require(manager == msg.sender, "Only Manager can create request"); 
        _;
    }

    function createRequest(string memory _description, address payable _recepient, uint _value) public{ 
        Request storage newRequest = requests[numRequests]; 
        numRequests++; 
        newRequest.description = _description; 
        newRequest.value = _value; 
        newRequest.recepient = _recepient; 
        newRequest.completed= false; 
        newRequest.noOfVoters = 0;

    }

    function voteRequest(uint _requestNo)public{ 
        require(contributors[msg.sender]>0);
        Request storage thisRequest = requests[_requestNo]; 
        require(thisRequest.voters[msg.sender] == false, "You have already voted");
        thisRequest.voters[msg.sender] = true; 
        thisRequest.noOfVoters++;

    }


    function makePayment(uint _reqNo)public onlymanager{ 
        require(raisedMoney>target); 
        Request storage request = requests[_reqNo]; 
        require(request.completed == false, "Already Completed"); 
        require(request.noOfVoters> request.noOfContributors/2); 
        request.recepient.transfer(request.value);
        request.completed = true;

    }



}
