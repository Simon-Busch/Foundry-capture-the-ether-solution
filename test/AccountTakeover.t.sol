// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/accounts/AccountTakeover.sol";
import "forge-std/console.sol";

// forge test --match-contract AccountTakeoverTest -vvvv
contract AccountTakeoverTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testAccountTakeoverHack() public {
        /****************
         * Factory setup *
         *************** */
        AccountTakeoverChallenge accountTakeoverChallenge = new AccountTakeoverChallenge();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */

        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = accountTakeoverChallenge.isComplete();
        require(levelSuccessfullyPassed);
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
