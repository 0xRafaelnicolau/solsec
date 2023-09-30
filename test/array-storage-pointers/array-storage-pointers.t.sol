// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {VulnerableQueue} from "../../src/array-storage-pointers/array-storage-pointers.sol";
import {FixedQueue} from "../../src/array-storage-pointers/array-storage-pointers-fixed.sol";

contract TestQueue is Test {
    VulnerableQueue public vulnerableQueue;
    FixedQueue public fixedQueue;
    address public naiveUser = makeAddr("naiveUser");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    function setUp() public {
        vulnerableQueue = new VulnerableQueue();
        fixedQueue = new FixedQueue();

        vm.deal(naiveUser, 1 ether);

        vm.startPrank(user1);
        vulnerableQueue.enterQueue();
        fixedQueue.enterQueue();

        vm.startPrank(user2);
        vulnerableQueue.enterQueue();
        fixedQueue.enterQueue();
    }

    function testVulnerableQueue() public {
        vm.startPrank(naiveUser);
        uint256 index = vulnerableQueue.enterQueue();
        vulnerableQueue.skipQueue{value: 1 ether}(index);
        
        // check that the first user in queue is not the naiveUser
        // but actually the user1 since only the storage pointer was updated.
        assertEq(vulnerableQueue.nextInQueue(), user1);
    }

    function testFixedQueue() public {
        vm.startPrank(naiveUser);
        uint256 index = fixedQueue.enterQueue();
        fixedQueue.skipQueue{value: 1 ether}(index);

        // check that the next user in line is the naiveUser
        assertEq(fixedQueue.nextInQueue(), naiveUser);
    }
}