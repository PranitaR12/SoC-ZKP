// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ZoKratesVerifier contract
import "./ZoKratesVerifier.sol";

contract InstituteElection {
    struct Candidate {
        uint id;
        string name;
    }

    struct EncryptedVote {
        bytes32 voteHash;
        bytes proof; // ZKP proof
    }

    mapping(address => EncryptedVote) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    address public electionOfficial;
    address[] public allVoters; // Array to store all voter addresses

    event CandidateAdded(uint id, string name);
    event VoteCast(address indexed voter, uint candidateId, bytes proof);

    // Include ZoKratesVerifier contract here (you need to import and deploy it separately)

    constructor() {
        electionOfficial = msg.sender;
    }

    modifier onlyOfficial() {
        require(msg.sender == electionOfficial, "Only the election official can perform this action.");
        _;
    }

    function addCandidate(string memory _name) public onlyOfficial {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Function to register voters
    function registerVoter() public {
        // Make sure the caller is not registered already
        require(voters[msg.sender].voteHash == bytes32(0), "You are already registered as a voter.");

        // Store the voter address in the array
        allVoters.push(msg.sender);
    }

    // Function to commit encrypted vote and ZKP proof
    function commitVote(bytes32 _voteHash, bytes memory _proof) public {
        // Check if voter has not voted before
        require(voters[msg.sender].voteHash == bytes32(0), "You have already voted.");

        // Store the encrypted vote and ZKP proof
        voters[msg.sender] = EncryptedVote(_voteHash, _proof);

        emit VoteCast(msg.sender, 0, _proof); // Emit an event to log the vote with proof
    }

    // Function to verify ZKP proofs and tally votes, not actual ZKP implementation
    function tallyVotes() public view returns (uint[] memory) {
        uint[] memory voteCounts = new uint[](candidatesCount);

        for (uint i = 0; i < allVoters.length; i++) {
            address voterAddress = allVoters[i];

            // Extract encrypted vote hash and proof from voters mapping
            bytes32 voteHash = voters[voterAddress].voteHash;
            bytes memory proof = voters[voterAddress].proof;

            // Verify ZKP proof using ZoKratesVerifier contract 
            // Include a separate function to interact with ZoKratesVerifier contract

            // If the ZKP proof is valid, increase the vote count for the candidate
            if (/* Verify ZKP proof */) {
                voteCounts[i]++;
            }
        }

        return voteCounts;
    }
}
