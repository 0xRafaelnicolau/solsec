// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract VulnerableStorageArray {
    
    address[] public users;

    function register(address newUser) public {
        users.push(newUser);
    }
    
    function deleteAllUsers() public {
        for (uint i; i < users.length; ++i) {
            delete users[i];
        }
    }
}