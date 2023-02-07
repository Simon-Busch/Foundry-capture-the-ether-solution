// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/GuessTheSecretNumber.sol";
import "forge-std/console.sol";

// forge test --match-contract GuessTheSecretNumberTest -vvvv
contract GuessTheSecretNumberTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testGuessTheSecretNumberHack() public {
        /****************
         * Factory setup *
         *************** */
        GuessTheSecretNumberChallenge guessTheSecretNumber = new GuessTheSecretNumberChallenge{
                value: 1 ether
            }();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * In this level we need to find a number (uint8) that matches the answnerHash
         * In order to do so, knwoning that uint8 goes max to 256 we can create a loop and test the values
         * keccak256(abi.encodePacked(i) and check if they match the hash
        */
        // uint8 answer = guessTheRandomNumber.answer();
        bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
        uint8 answer;
        for (uint8 i = 0; i < 256; i++) {
            if (keccak256(abi.encodePacked(i)) == answerHash) {
                answer = i;
                return;
            }
        }
        guessTheSecretNumber.guess{value: 1 ether}(answer);
        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = guessTheSecretNumber.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
