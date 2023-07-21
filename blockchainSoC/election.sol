//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Define a struct to represent each candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Declare a mapping to store the candidates by ID
    mapping(uint => Candidate) public candidates;

    // Declare a mapping to keep track of who has voted
    mapping(address => bool) public voters;

    // Declare a variable to keep track of the total number of candidates
    uint public candidatesCount;

    // Define an event that will be emitted whenever a new candidate is added
    event CandidateAdded(uint id, string name);

    // Define an event that will be emitted whenever a vote is cast
    event VoteCast(uint candidateId);

    // Add a function to add a new candidate
    function addCandidate(string memory _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Add a function to cast a vote
    function castVote(uint _candidateId) public {
        // Make sure the voter hasn't already voted
        require(!voters[msg.sender], "You have already voted.");

        // Make sure the candidate exists
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        // Update the candidate's vote count
        candidates[_candidateId].voteCount++;

        // Record that the voter has voted
        voters[msg.sender] = true;

        emit VoteCast(_candidateId);
    }

    // Add a function to get the winner
    function getWinner() public view returns (string memory) {
        uint maxVoteCount = 0;
        uint winningCandidateId = 0;

        // Loop through all candidates to find the one with the most votes
        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVoteCount) {
                maxVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;
    }
}