// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FunWithStorage {
    uint256 favoriteNumber; // Stored at slot 0
    bool someBool; // Stored at slot 1
    uint256[] myArray; /* Array Length Stored at slot 2,
        but the objects will be the keccak256(2), since 2 is the storage slot of the array */
    uint8 extraValue = 3; // Stored at slot 3    
    mapping(uint256 => bool) myMap; /* An empty slot is held at slot 4
        and the elements will be stored at keccak256(h(k) . p)
        p: The storage slot (aka, 3)
        k: The key in hex
        h: Some function based on the type. For uint256, it just pads the hex
        */
    uint256 constant NOT_IN_STORAGE = 123;
    uint256 immutable i_not_in_storage;
    uint256 s_is_in_storage; // Stored at slot 5
    uint256 s_is_in_storage2 = 6; // Stored at slot 6

    constructor() {
        favoriteNumber = 25; // See stored spot above // SSTORE
        someBool = true; // See stored spot above // SSTORE
        myArray.push(222); // SSTORE
        myMap[0] = true; // SSTORE
        i_not_in_storage = 123;
        s_is_in_storage = 5;
    }

    function doStuff() public {
        uint256 newVar = favoriteNumber + 1; // SLOAD
        bool otherVar = someBool; // SLOAD
            // ^^ memory variables
         
        myArray.push(newVar); // SLOAD
        myArray.push(22);
        myArray.push(23);
        myArray[0] = 7; 

        myMap[1] = otherVar; // SLOAD
        favoriteNumber = 69; // SSTORE
        
    }
}