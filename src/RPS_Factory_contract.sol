// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract RPSGame{

}


contract factory{
    //Array to store deployed child contracts
    address [] public deployedContracts;

    //event that emits when a contract is deployed

    event contractDeployed(address productContract, address player1);


    function createContract(address player1) external returns (address){
        
        RPSGame rpsGameInstance = new RPSGame();

        deployedContracts.push(address(rpsGameInstance));

        emit contractDeployed(address(rpsGameInstance), player1);

        return address(rpsGameInstance);
    }

    function getNumberOfDeployedContract() external view returns (uint256){
        return deployedContracts.length;
    }

}