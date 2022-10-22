// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "forge-std/Test.sol";
import "../src/math/Mapping.sol";
import "forge-std/console.sol";

// forge test --match-contract MappingTest -vvvv
contract MappingTest is Test {
    address player = address(100);
    address player2 = address(200);

    function setUp() public {
        vm.deal(player, 5 ether);
    }

    function testMappingHack() public {
        /****************
         * Factory setup *
         *************** */
        MappingChallenge mappingChallenge = new MappingChallenge();
        vm.startPrank(player);
        address payable levelAddress = payable(address(mappingChallenge));
        uint256 initialPlayerBalance = player.balance;
        assertEq(initialPlayerBalance, 5 ether);
        /****************
         *    Attack     *
         *************** */
        /*
         * Goal: set isComplete to true
         * we can see that there are no obvious function to call in order to so
         * We have to dive a bit deeper in storage
         * bool public isComplete; -- SLOT0
         * map.length -- SLOT1
         * map[0] -- SLOT keccak(1)
         * map[1] -- SLOT keccak(1) + 1
         * map[2] -- SLOT keccak(1) + 2
         * ....
         * the array items wrap around after they reached the max storage slot of 2^256 - 1.
         * So if we reach the map length of the array, the next slot we can write on will be SLOT0 and we can overwrite isComplete
         *
         * NB : This hack won't work as in the newer version of solidity this is no longer possible.
         */
        bytes32 map_begin_slot = keccak256(abi.encode(bytes32(uint256(1))));
        uint256 key = type(uint256).max - uint256(map_begin_slot) + 1; // 35707666377435648211887908874984608119992236509074197713628505308453184860938;
        // mappingChallenge.set(key, true);
        // assertEq(mappingChallenge.isComplete(), true);
        /*****************
         *Level Submission*
         ***************  */
        bool levelSuccessfullyPassed = mappingChallenge.isComplete();
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}
