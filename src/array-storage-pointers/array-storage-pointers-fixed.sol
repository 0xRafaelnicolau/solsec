// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract FixedQueue {
    struct User {
        address user;
        uint256 deposited;
        uint256 timestamp;
    }

    error AlreadyInQueue();
    error NotInQueue();
    error InvalidQueuePosition();
    error NotEnoughETH();

    User[] private _usersQueue;
    mapping(address => bool) private _inQueue;

    function enterQueue() external returns (uint256) {
        if (_inQueue[msg.sender] == true) revert AlreadyInQueue();

        User memory newUser = User(msg.sender, 0, block.timestamp);
        _usersQueue.push(newUser);
        _inQueue[newUser.user] = true;

        return _usersQueue.length - 1;
    }

    function skipQueue(uint256 index) external payable {
        if (index > _usersQueue.length - 1) revert InvalidQueuePosition();
        if (_usersQueue[index].user != msg.sender) revert NotInQueue();
        if (msg.value <= _usersQueue[0].deposited) revert NotEnoughETH();

        User memory temp = _usersQueue[0];
        _usersQueue[0] = _usersQueue[index];
        _usersQueue[index] = temp;

        _usersQueue[0].deposited = msg.value;
    }

    function priceToSkip() external view returns (uint256) {
        return _usersQueue[0].deposited;
    }

    function nextInQueue() external view returns (address) {
        return _usersQueue[0].user;
    }
}