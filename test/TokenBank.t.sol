// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/miscellaneous/TokenBank.sol";
import "forge-std/console.sol";

// forge test --match-contract TokenBankTest -vvvv
contract TokenBankTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testTokenBankHack() public {
        /****************
         * Factory setup *
         *************** */
        TokenBankChallenge tokenBank = new TokenBankChallenge(player);
        vm.startPrank(player);
        address levelAddress = address(tokenBank);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */

        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = tokenBank.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
