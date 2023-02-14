// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/accounts/FuzzyIdentity.sol";
import "forge-std/console.sol";

// forge test --match-contract FuzzyIdentityTest -vvvv
contract FuzzyIdentityTest is Test {
    address player = address(0);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testFuzzyIdentityHack() public {
        /****************
         * Factory setup *
         *************** */
        FuzzyIdentityChallenge fuzzyIdentityChallenge = new FuzzyIdentityChallenge();
        Attacker attacker = new Attacker(address(fuzzyIdentityChallenge));
        vm.startPrank(player);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        // bool foundKey = false;
        // uint256 counter = 0;
        // while(!foundKey) {
        //   bytes memory base = "m/44'/60'/0'/0/";
        //   address foundAddress = vm.deriveKey(abi.encodePacked(base, counter), counter);
        //   if (foundAddress.includes("badc0de")) {

        //   }
        // }
        attacker.attack();
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = fuzzyIdentityChallenge.isComplete();
        require(levelSuccessfullyPassed);
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}

contract Attacker {
    FuzzyIdentityChallenge public challenge;

    constructor(address _challenge) {
      challenge = FuzzyIdentityChallenge(_challenge);
    }

    function name() external pure returns (bytes32) {
      return bytes32("smarx");
    }

    function attack() external {
      challenge.authenticate();
    }
}
