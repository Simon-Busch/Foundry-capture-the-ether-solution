// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/accounts/PublicKey.sol";
import "forge-std/console.sol";

// forge test --match-contract PublicKeyTest -vvvv
contract PublicKeyTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testPublicKeyHack() public {
        /****************
         * Factory setup *
         *************** */
        PublicKeyChallenge publicKeyChallenge = new PublicKeyChallenge();
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        publicKeyChallenge.authenticate(abi.encodePacked(address(uint160(bytes20(0x92b28647Ae1F3264661f72fb2eB9625A89D88A31)))));
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = publicKeyChallenge.isComplete();
        require(levelSuccessfullyPassed);
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
