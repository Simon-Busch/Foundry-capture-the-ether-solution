// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

contract PublicKeyChallenge {
    address owner = 0x92b28647Ae1F3264661f72fb2eB9625A89D88A31;
    bool public isComplete;

    function authenticate(bytes calldata publicKey) public {
        require(address(uint160(bytes20(publicKey))) == owner);

        isComplete = true;
    }
}
