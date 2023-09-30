// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract VulnerableStorageArray {
    struct User {
        address user;
        uint256 timestamp;
    }

    error AlreadyRegistered();

    User[] private _users;

    function register() public {
        if (_isRegistered(msg.sender) == true) revert AlreadyRegistered();

        User memory newUser = User(msg.sender, block.timestamp);
        _users.push(newUser);
    }

    function _isRegistered(address user) private view returns (bool) {
        for (uint256 i; i < _users.length; ++i) {
            if (_users[i].user == user) return true;
        }
        return false;
    }
}
