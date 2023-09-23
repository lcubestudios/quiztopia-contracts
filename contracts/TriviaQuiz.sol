// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriviaQuiz {
    address public owner;
    // bytes32 public answerHash;
    bytes32 public answerHash;
    uint256 public prizePool;
    uint256 public questionCount;
    uint256 public timePerQuestion = 35; // in seconds
    uint256 public startTime;
    uint256 public gameStarted;

    struct Player {
        uint256 correctAnswers;
        mapping(uint256 => bytes32) commitments;
    }

    mapping(address => Player) public players;
    address[] public playerAddresses;
    mapping(address => bool) public hasJoined;

    constructor( bytes32 _answerHash, uint256 _questionCount) payable {
        owner = msg.sender;
        answerHash = _answerHash;
        prizePool = msg.value;
        questionCount = _questionCount;
        startTime; //can we wait to set this? separate trigger to start
        gameStarted = 0;
    }
    function depositFunds() public payable {
        // ONLY DEPOSIT NATIVE TOKEN. NO ERC20s
        // require(msg.sender == owner, "Only the owner can deposit funds");
        prizePool += msg.value;
    }
    function joinGame() public {
        require(!hasJoined[msg.sender], "Already joined");
        require(msg.sender != owner, "Owner cannot play!");
        hasJoined[msg.sender] = true;
        playerAddresses.push(msg.sender);
    }

    function startGame() public {
        require(msg.sender == owner, "Only the owner can start the game");
        require(gameStarted != 1, "Game already started");
        startTime = block.timestamp;
        gameStarted = 1;
    }

    function commitAnswer(bytes32 commitment, uint256 questionNumber) public {
        require(hasJoined[msg.sender], "Not a player");
        require(block.timestamp >= startTime + questionNumber * timePerQuestion, "Too early");
        require(block.timestamp < startTime + (questionNumber + 1) * timePerQuestion, "Too late");
        players[msg.sender].commitments[questionNumber] = commitment;
    }
    function getCurrentQuestion() public view returns (uint256) {
        if (gameStarted == 0 || block.timestamp < startTime) {
            return 0; // Game not started
        }

        uint256 elapsedTime = block.timestamp - startTime;
        uint256 currentQuestion = elapsedTime / timePerQuestion + 1;

        if (currentQuestion > questionCount) {
            return 0; // Game over
        }

        return currentQuestion;
    }

    function revealAnswer(string memory answer, bytes32 salt, uint256 questionNumber) public {
        require(hasJoined[msg.sender], "Not a player");
        require(block.timestamp >= startTime + (questionNumber + 1) * timePerQuestion, "Too early to reveal");

        bytes32 commitment = keccak256(abi.encodePacked(answer, salt));
        require(players[msg.sender].commitments[questionNumber] == commitment, "Invalid commitment");

        if (keccak256(abi.encodePacked(answer)) == answerHash) {
            players[msg.sender].correctAnswers++;
        }
    }

    function concludeGame() public {
        require(msg.sender == owner, "Only the owner can conclude the game");
        require(block.timestamp >= startTime + questionCount * timePerQuestion, "Game is not yet over");

        uint256 numWinners = 0;
        for (uint256 i = 0; i < playerAddresses.length; i++) {
            address playerAddress = playerAddresses[i];
            if (players[playerAddress].correctAnswers == questionCount) {
                numWinners++;
            }
        }

        uint256 prize = prizePool / numWinners;
        for (uint256 i = 0; i < playerAddresses.length; i++) {
            address playerAddress = playerAddresses[i];
            if (players[playerAddress].correctAnswers == questionCount) {
                payable(playerAddress).transfer(prize);
            }
        }
    }
}
