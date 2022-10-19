// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/GuessTheNumber.sol";
import "forge-std/console.sol";

// forge test --match-contract GuessTheNumberTest -vvvv
contract GuessTheNumberTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testGuessTheNumberHack() public {
        /****************
         * Factory setup *
         *************** */
        GuessTheNumberChallenge guessTheNumber = new GuessTheNumberChallenge{value: 1 ether}();
        vm.startPrank(player);
        address levelAddress = address(guessTheNumber);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
        * This level is pretty straightforward, it's more to get us started
        * we can see on the first line the answer :)
        * We simply need to pass the answer to the guess function, sending 1 ether with it.
        */
        guessTheNumber.guess{value: 1 ether}(42);
        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = guessTheNumber.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
