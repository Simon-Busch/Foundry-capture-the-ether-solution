// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;
import "forge-std/Test.sol";

contract AssumeOwnershipChallenge is Test {
    address owner;
    bool public isComplete;

    function AssumeOwmershipChallenge() public {
        owner = msg.sender;
        console.log(owner);
    }

    function authenticate() public {
        require(msg.sender == owner);

        isComplete = true;
    }
}
