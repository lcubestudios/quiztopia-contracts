// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriviaQuiz {
    address public owner;
    bytes32 public answerHash;
    uint256 public prizePool;
    uint256 public questionCount;
    uint256 public timePerQuestion = 15; // in seconds
    uint256 public startTime;

    struct Player {
        address addr;
        uint256 correctAnswers;
        mapping(uint256 => bytes32) commitments;
    }

    Player[] public players;
    mapping(address => bool) public hasJoined;

    constructor(bytes32 _answerHash, uint256 _questionCount) payable {
        owner = msg.sender;
        answerHash = _answerHash;
        prizePool = msg.value;
        questionCount = _questionCount;
        startTime = block.timestamp;
    }

    function joinGame() public {
        require(!hasJoined[msg.sender], "Already joined");
        players.push(Player({addr: msg.sender, correctAnswers: 0}));
        hasJoined[msg.sender] = true;
    }

    function commitAnswer(bytes32 commitment, uint256 questionNumber) public {
        require(hasJoined[msg.sender], "Not a player");
        require(block.timestamp >= startTime + questionNumber * timePerQuestion, "Too early");
        require(block.timestamp < startTime + (questionNumber + 1) * timePerQuestion, "Too late");

        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].addr == msg.sender) {
                players[i].commitments[questionNumber] = commitment;
                break;
            }
        }
    }
    function revealAnswer(string memory answer, bytes32 salt, uint256 questionNumber) public {
        require(hasJoined[msg.sender], "Not a player");
        require(block.timestamp >= startTime + (questionNumber + 1) * timePerQuestion, "Too early to reveal");
// Logic to distribute prize among correctAnswers

        bytes32 commitment = keccak256(abi.encodePacked(answer, salt));
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].addr == msg.sender) {
                require(players[i].commitments[questionNumber] == commitment, "Invalid commitment");
                if (keccak256(abi.encodePacked(answer)) == answerHash) {
                    players[i].correctAnswers++;
                }
                break;
            }
        }
    }

    function concludeGame() public {
        require(msg.sender == owner, "Only the owner can conclude the game");
        require(block.timestamp >= startTime + questionCount * timePerQuestion, "Game is not yet over");

        uint256 numWinners = 0;
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].correctAnswers == questionCount) {
                numWinners++;
            }
        }

        uint256 prize = prizePool / numWinners;
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].correctAnswers == questionCount) {
                payable(players[i].addr).transfer(prize);
            }
        }
    }
}