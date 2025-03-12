/*
Write a Solidity function to implement a voting system, where each address can vote only once. 
*/

//SPdx-License-Identifier: MIT

pragma solidity 0.8.28;

contract VotingSystem{

        //mapping to keep the track of wether the address has votedor not
        mapping(address => bool) public hasVoted;

        // mapping to keep the track of the votes for each candidate
        mapping(uint256 => uint256) public votesRecived;

        //event to emit when a vote is casted
        event VoteCast(address indexed voter, uint256 candidateId);

        //Function to allow user to vote for a candidate
        function vote (uint256 candidateId) public {
                //check if the user has already voted
                require(!hasVoted[msg.sender],"You have alredy voted");

                //mark the voter as having voted
                hasVoted[msg.sender] = true;

                //increment the vote count for the candidate
                votesRecived[candidateId] += 1;

                //emit the vote casted event 
                emit VoteCast(msg.sender, candidateId);
        }

        //function to get the vnumber of votes canidate has recived
        function getVotesForCandidate(uint256 candidateId) public view returns(uint256){
                return votesRecived[candidateId];
        }

}