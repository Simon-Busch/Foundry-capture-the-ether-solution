// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

contract DonationChallenge {
    struct Donation {
        uint256 timestamp;
        uint256 etherAmount;
    }
    Donation[] public donations;

    address public owner;

    // function DonationChallenge() public payable {
    //     require(msg.value == 1 ether);

    //     owner = msg.sender;
    // }
    constructor() payable {
      owner = msg.sender;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function donate(uint256 etherAmount) public payable {
        // amount is in ether, but msg.value is in wei
        uint256 scale = 10**18 * 1 ether;
        require(msg.value == etherAmount / scale);

        Donation memory donation;
        donation.timestamp = block.timestamp; // !! "now" before
        donation.etherAmount = etherAmount;

        donations.push(donation);
    }

    function withdraw() public {
        require(msg.sender == owner);
        address payable toSendTo = payable(msg.sender);

        toSendTo.transfer(address(this).balance);
    }
}
