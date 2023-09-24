// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriviaQuiz {
    event LoggingTheHash(bytes32);
    event LoggingPlayerAnswer(uint256 questionIndex, uint8 questionAnswer);
    event LoggingTheConcatedAnswers(bytes concatenatedAnswers);
    event LOGGINGFAILEDHASH(bytes32 failedConcatenatedAnswerHash);
    address public owner;
    bytes32 public answerHash;
    uint256 public prizePool;
    uint256 public questionCount;
    uint256 public timePerQuestion = 20; // in seconds
    uint256 public startTime;
    uint256 public gameStarted;

    struct Player {
        uint256 correctAnswers;
        mapping(uint256 => uint8) answers; 
    }

    mapping(address => Player) public players;
    address[] public playerAddresses;
    mapping(address => bool) public hasJoined;

    constructor(bytes32 _answerHash, uint256 _questionCount) payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        owner = msg.sender;
        answerHash = _answerHash;
        prizePool = msg.value;
        questionCount = _questionCount;
        startTime; //can we wait to set this? separate trigger to start
        gameStarted = 0;
    }

    function depositFunds(uint256 amount) external payable {
        // ONLY DEPOSIT NATIVE TOKEN. NO ERC20s
        // require(msg.sender == owner, "Only the owner can deposit funds");
        // prizePool += msg.value;
        address payable contractAddress = payable(address(this));
        contractAddress.transfer(msg.value);
        prizePool += amount;
    }
    function joinGame() public {
        require(!hasJoined[msg.sender], "Already joined");
        require(msg.sender != owner, "Owner cannot play!");
        hasJoined[msg.sender] = true;
        playerAddresses.push(msg.sender);
    }

    function getCurrentTime() public view returns (uint256) {
        return(block.timestamp);
    }

    function startGame() public {
        require(msg.sender == owner, "Only the owner can start the game");
        require(gameStarted != 1, "Game already started");
        startTime = block.timestamp;
        gameStarted = 1;
    }
    
    function commitAnswerCheck(uint256 questionNumber) public view returns (uint256){
        if (block.timestamp >= startTime + questionNumber * timePerQuestion) {
            // TOO EARLY!
            return 8;
        }
        if (block.timestamp < startTime + (questionNumber + 1) * timePerQuestion) {
            // TOO LATE!
            return 9;
        }
        //GOOD TO GO!
        return 1;
    }

    function commitAnswer(uint8 answer, uint256 questionNumber) public returns (uint256) {
        require(msg.sender != owner, "Owner cannot play the game");
        require(hasJoined[msg.sender], "You must join to play!");
        // require(block.timestamp >= startTime + questionNumber * timePerQuestion, "Too early");
        // require(block.timestamp < startTime + (questionNumber + 1) * timePerQuestion, "Too late");
        players[msg.sender].answers[questionNumber] = answer; // 
        emit LoggingPlayerAnswer(questionNumber, players[msg.sender].answers[questionNumber]);
        return 1;
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
    function getNumberOfPlayers() public view returns (uint256) {
        return playerAddresses.length;
    }

    function concludeGame(address[] calldata winningAddresses) public {
        require(msg.sender == owner, "Only the owner can conclude the game");
        require(winningAddresses.length <= playerAddresses.length, "There cannot be more winners than players");
        // require(block.timestamp >= startTime + questionCount * timePerQuestion, "Game is not yet over");

        uint256 prize = prizePool / winningAddresses.length;
        for (uint256 i = 0; i < winningAddresses.length; i++) {
            address playerAddress = playerAddresses[i];
                payable(playerAddress).transfer(prize);
        }
    }

    function emergencyWithdraw() external onlyOwner {
        // Get the balance of the contract
        uint256 balance = address(this).balance;

        // Transfer the balance to the admin
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Failed to withdraw funds");
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the admin can call this function");
        _;
    }
}