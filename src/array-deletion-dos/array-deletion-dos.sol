// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract VulnerableArray {

    address[] public users;

    function register(address newUser) public {
        users.push(newUser);
    }

    // if the number of registed users becomes too long
    // it will become undeletable due to it's gas cost
    // making the function unusable
    function deleteAllUsers() public {
        delete users;
    }
}
