pragma solidity ^0.8.0;

contract RetirementFundChallenge {
    uint256 startBalance;
    address owner = msg.sender;
    address beneficiary;
    uint256 expiration = block.timestamp + 10 * 365 days;

    constructor(address player) payable {
        require(msg.value == 1 ether, "lock 1 ether please");

        beneficiary = player;
        startBalance = msg.value;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function withdraw() public {
        require(msg.sender == owner, "only owner");
        address payable toSendTo = payable(msg.sender);

        if (block.timestamp < expiration) {
            // !! changed to update version msg.sender.transfer(address(this).balance * 9 / 10);
            // early withdrawal incurs a 10% penalty
            toSendTo.transfer((address(this).balance * 9) / 10);
        } else {
            // msg.sender.transfer(address(this).balance);
            toSendTo.transfer(address(this).balance);
        }
    }

    function collectPenalty() public {
      unchecked { //!! add it to allow overflow/underflow
        require(msg.sender == beneficiary);
        address payable toSendTo = payable(msg.sender);
        uint256 withdrawn = startBalance - address(this).balance;

        // an early withdrawal occurred
        require(withdrawn > 0, "no early withdrawn err");

        // !! changed to update version  msg.sender.transfer(address(this).balance)
        // penalty is what's left
        toSendTo.transfer(address(this).balance);
      }
    }
}
