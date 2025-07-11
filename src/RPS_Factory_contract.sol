// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract RPSGame{

 enum roundResult{
      draw,
      player1Wins,
      player2Wins
 }

  address player1;
  address player2;
  uint256 maxRound;
  uint256 currentRound;
  roundResult result;

  mapping(address => uint256) public scores;
  mapping(uint256 => mapping(address => string)) movesPerRound;
  mapping(address => bool) public hasPlayed;
  bool gameOver = false;

  constructor(address _player2){
    player1 = msg.sender;
    player2 = _player2;

    maxRound = 4;
    currentRound = 1;
  }
  //what does this function do?
  //submit the player moves for commitment for evaluation
  //arguments: string move

  function submitMoves(string memory move) external { 
    require(msg.sender == player1 || msg.sender == player2, "invalid player address" );
    require(gameOver,"Game isn't over");
    require(!hasPlayed[msg.sender], "can't play twice");
    require( invalidMove(move));
    
    movesPerRound[1][msg.sender] = move;
    hasPlayed[msg.sender] = true;


    revealMove(msg.sender);

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
  //What does this function do?
  // reveals the move that the player played,
  //parameter: the address of the player
   
   function revealMove(address _player) internal view returns (string memory){
    require(!hasPlayed[_player], "player hasn't played");

     return (movesPerRound[1][_player]);
   }

   //Function Name: evaluateWinnner;
   // function: compares player moves and evaluates winner for a round
   //
    function evaluateWinner() internal {
        string memory move1 = movesPerRound[1][player1];
        string memory move2 = movesPerRound[1][player2];

        if(keccak256(bytes(move1)) == keccak256(bytes(move2))){
           result = roundResult.draw;
        } else if(
          compare(move1, "scissor") && compare(move2, "paper") ||
          compare(move1, "paper") && compare(move2, "rock") || 
          compare(move1, "rock") && compare(move2, "scissor")
      ){
        result = roundResult.player1Wins;
      } else{
        result = roundResult.player2Wins;
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