// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MappingChallenge {
    bool public isComplete;
    uint256[] map;
    uint key = 0;

    // function set(uint256 key, uint256 value) public {
    //     // Expand dynamic array as needed
    //     if (map.length <= key) {
    //         map.length = key + 1;
    //     }
    //     map[key] = value;
    // }

    function set(uint value) public {
        map.push(value);
    }

    function get(uint _key) public view returns (uint256) {
        return map[_key];
    }
}
