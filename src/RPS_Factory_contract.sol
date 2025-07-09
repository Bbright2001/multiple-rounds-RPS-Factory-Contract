// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract RPSGame{
    enum  gameRound {first, second, third, fourth}

  address player1;
  address player2;
  uint256 roundDuration = 30 seconds;
  bool isGameOver;
  uint256 startTime;

  gameRound currentRound;


  mapping (address => uint) public scores;
  mapping (address => bytes32) public commitedMoves;
  mapping (address => string) public revealedMoves;
  mapping (address => bool) public hasCommitted;
  mapping (address => bool) public hasReavealed;

  constructor(address _player2) {
    player1 = msg.sender;
    player2 = _player2;
    currentRound = gameRound.first;
  }

  function commitMove(string memory _move) external {
    require(!(isGameOver), "Game Over");
    require(msg.sender == player1 || msg.sender == player2, "You aren't allowed to participate");
    require(hasCommitted[msg.sender], "You can't commit a move more than one");
    require(block.timestamp < startTime + roundDuration, "You lost this round");

    bytes32 hash = keccak256(bytes(_move));

    startTime = block.timestamp;

    if(msg.sender == player1){
        commitedMoves[player1] = hash;
        hasCommitted[player1] = true;
    }else{
        commitedMoves[player2] = hash;
        hasCommitted[player2] = true;
    }
  }

}


contract factory{
    //Array to store deployed child contracts
    address [] public deployedContracts;

    //event that emits when a contract is deployed

    event contractDeployed(address productContract, address player1, address player2 );


    function createContract(address player2) external returns (address){
        
        RPSGame rpsGameInstance = new RPSGame(player2);

        deployedContracts.push(address(rpsGameInstance));

        emit contractDeployed(address(rpsGameInstance),msg.sender, player2);

        return address(rpsGameInstance);
    }

    function getNumberOfDeployedContract() external view returns (uint256){
        return deployedContracts.length;
    }

}