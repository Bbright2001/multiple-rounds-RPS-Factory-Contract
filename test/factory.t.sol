// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {factory} from "../src/RPS_Factory_contract.sol";

contract factoryTest is Test {
    factory public multiple;
    address public player2;

    function setUp() public {
        multiple = new factory();
        player2 = address(0x1);
    }

    function testCreateContract() public{

        multiple.createContract(player2);
        
        uint256 games = multiple.getNumberOfDeployedContract();
        assertEq(games, 1);
        console.log(games);
    }
}
