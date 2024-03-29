// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;
import "forge-std/Test.sol";

contract FiftyYearsChallenge is Test {
    struct Contribution {
        uint256 amount;
        uint256 unlockTimestamp;
    }
    Contribution[] public queue;
    uint256 head;

    address owner;

    // function FiftyYearsChallenge(address player) public payable {
    // }
    constructor(address player) payable {
        require(msg.value == 1 ether);

        owner = player;
        queue.push(Contribution(msg.value, block.timestamp + 50 * (365 days)));
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function upsert(uint256 index, uint256 timestamp) public payable {
        require(msg.sender == owner);
        Contribution memory contribution;
        if (index >= head && index < queue.length) {
            // Update existing contribution amount without updating timestamp.
            unchecked {
                contribution = queue[index];
                contribution.amount += msg.value;
            }
        } else {
            // Append a new contribution. Require that each contribution unlock
            // at least 1 day after the previous one.
            unchecked {
                require(
                    block.timestamp >=
                        queue[queue.length - 1].unlockTimestamp + 1 days
                );
                contribution.amount = msg.value;
                contribution.unlockTimestamp = timestamp;
                queue.push(contribution);
            }
        }
    }

    function withdraw(uint256 index) public {
        require(msg.sender == owner);
        require(block.timestamp >= queue[index].unlockTimestamp);
        address payable toSendTo = payable(msg.sender);
        // Withdraw this and any earlier contributions.
        uint256 total = 0;
        for (uint256 i = head; i <= index; i++) {
            total += queue[i].amount;

            // Reclaim storage.
            delete queue[i];
        }

        // Move the head of the queue forward so we don't have to loop over
        // already-withdrawn contributions.
        head = index + 1;

        // msg.sender.transfer(total);
        toSendTo.transfer(address(this).balance);
    }
}
