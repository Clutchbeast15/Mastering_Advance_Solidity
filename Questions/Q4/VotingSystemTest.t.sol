// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {VotingSystem} from "../src/VotingSystem.sol";

contract VotingSystemTest is Test{
        
        VotingSystem public votingSystem;
        address public voter1 = address(0x1);
        address public voter2 = address(0x2);
        uint256 public candidateId1 = 1;
        uint256 public candidateId2 = 2;
            //event to emit when a vote is casted
        event VoteCast(address indexed voter, uint256 candidateId);

        function setUp() public{
                votingSystem = new VotingSystem();
        }

        // test that voter can vote for a candidate
        
        function  testUserCanVote() public {
                //voter 1 has voted for candidate 1
                vm.prank(voter1);
                votingSystem.vote(candidateId1);

                //check that the vote  was recorded
                assertEq(votingSystem.getVotesForCandidate(candidateId1),1 ,"Candidate 1 should have 1 vote");
                assertTrue(votingSystem.hasVoted(voter1), "voter1 should have voted");

        }

        //test that a voter can only vote once
        function testUserCanVoteOnlyOnce() public{
                //voter 1 has voted for candidate 1
                vm.prank(voter1);
                votingSystem.vote(candidateId1);

                //voter 1 tries to vote again for candidate 1
                vm.prank(voter1);
                vm.expectRevert("You have alredy voted");
                votingSystem.vote(candidateId2);

        }

        // test multiple voter can votefor same candidate
        function testMultipleVoterCanVoteForSameCandidate() public{
                //voter 1 votes for candidate 1
                vm.prank(voter1);
                votingSystem.vote(candidateId1);

                //voter 2 votes for candidate 1
                vm.prank(voter2);
                votingSystem.vote(candidateId1);

                //check that the vote was recorded
                assertEq(votingSystem.getVotesForCandidate(candidateId1),2, "Candidate 1should have 2 votes");

        }

        //test vote for diffrent candidates
        function testVotersCanVoteForDiffrentCandidates()public {
                //voter 1 votes for candidate 1
                vm.prank(voter1);
                votingSystem.vote(candidateId1);

                //voter 2 votes for candidate 2
                vm.prank(voter2); 
                votingSystem.vote(candidateId2);

                //check that the votes were recorded
                assertEq(votingSystem.getVotesForCandidate(candidateId1),1, "Candidate 1 should have 1 vote");
                assertEq(votingSystem.getVotesForCandidate(candidateId2), 1, "Candiddate 2should have 1 vote");
        }

        // test the vote casting event is emitted correctly
        function testVoteCastingEventIsEmites() public {
                //expect the vote cast event to be emitted
                vm.expectEmit(true, true, false, true);
                emit VoteCast(voter1, candidateId1);

                //voter 1 votes for candidate 1
                vm.prank(voter1);
                votingSystem.vote(candidateId1);


        }


}
