// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract RPSGame{

 enum roundResult{
      draw,
      player1Wins,
      player2Wins
 }

  address public immutable player1;
  address public immutable player2;
  uint8 constant maxRound = 4;
  uint8 currentRound = 1;
  roundResult result;

  mapping(address => uint256) public scores;
  mapping(uint256 => mapping(address => string)) movesPerRound;
  mapping(address => bool) public hasPlayed;
  bool gameOver;

  constructor(address _player2){
    player1 = msg.sender;
    player2 = _player2;
  }
  //what does this function do?
  //submit the player moves for commitment for evaluation
  //arguments: string move

  function submitMoves(string memory move) external { 
    require(msg.sender == player1 || msg.sender == player2, "invalid player address" );
    require(!gameOver,"Game isn't over");
    require(!hasPlayed[msg.sender], "can't play twice");
    require( invalidMove(move), "Invalid move");
    
    movesPerRound[currentRound][msg.sender] = move;
    hasPlayed[msg.sender] = true;


     if(hasPlayed[player1] || hasPlayed[player2]) return;

   address winner = evaluateWinner();
    if(winner == address(0)) scores[winner]++;

    hasPlayed[player1] = false;
    hasPlayed[player2] = false;

    currentRound++;
    
     if(currentRound >= maxRound || scores[player1] == 3 || scores[player2] == 3){
       gameOver = true;
     }
  } 
  // what does this function do?
  //parameters: the player move (rock, paper, scissors)
  //check the move played by the player..to see if it is an invalid move
  
  function invalidMove(string memory _move) internal pure returns (bool) {
      bytes32 moveHash = keccak256(bytes(_move));

      return (
         moveHash == keccak256(bytes("rock")) ||
        moveHash == keccak256(bytes("paper")) ||
        moveHash == keccak256(bytes("scissors"))
      );
  }
  

   //Function Name: evaluateWinnner;
   // function: compares player moves and evaluates winner for a round
   //
    function evaluateWinner() internal returns(address){
        string memory move1 = movesPerRound[currentRound][player1];
        string memory move2 = movesPerRound[currentRound][player2];

        if(keccak256(bytes(move1)) == keccak256(bytes(move2))){
           result = roundResult.draw;
           return address(0);
        } else if(
          compare(move1, "scissor") && compare(move2, "paper") ||
          compare(move1, "paper") && compare(move2, "rock") || 
          compare(move1, "rock") && compare(move2, "scissor")
      ){
        result = roundResult.player1Wins;
        return player1;
      } else{
        result = roundResult.player2Wins;
        return player2;
      }
    }

    function compare(string memory a, string memory b) internal pure returns (bool){
       return keccak256(bytes(a)) == keccak256(bytes(b));
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