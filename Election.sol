//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract Election{ 

    struct Candidate{ 
        string name; 
        uint numVotes; 

    }

    struct Voter{ 
        string name; 
        bool authorised; 
        uint whom;
        bool voted; 
    }

    address public owner; 
    string public electionName; 

    mapping(address => Voter) public voters; 
    Candidate[] public candidates; 
    uint public totalVotes; 

    
    modifier ownerOnly(){ 
        require(msg.sender == owner); 
        _; 
    }

    function startElection(string memory _name) public{ 
        owner = msg.sender; 
        electionName = _name; 

    }

    function addCandidate(string memory _name) ownerOnly public{ 
        candidates.push(Candidate(_name, 0)); 
        
    }

    function getNumCandidates() public view returns(uint){
        return candidates.length; 
    }

    function authorizeVoter(address _voterAddress) ownerOnly public{ 
        voters[_voterAddress].authorised = true; 
    }

    function vote(uint candidateIndex)public{ 
        require(!voters[msg.sender].voted); 
        require(voters[msg.sender].authorised);
        voters[msg.sender].whom = candidateIndex; 
        voters[msg.sender].voted = true;

        candidates[candidateIndex].numVotes++; 
        totalVotes++; 
    }

    // function end() ownerOnly public{ 
    //     selfdestruct(owner); 
    // }
}
