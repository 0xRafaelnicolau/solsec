// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {VulnerableAuction} from "../../src/force-revert-dos/force-revert-dos.sol";
import {AttackAuction} from "./attack.sol";

contract TestAuction is Test {
    VulnerableAuction public vulnerableAuction;
    AttackAuction public attackAuction;
    address public user = makeAddr("user");
    address public attacker = makeAddr("attacker");

    function setUp() public {
        deal(attacker, 1 ether);
        deal(user, 2 ether);

        vulnerableAuction = new VulnerableAuction(7 days);
    }

    function testAttackAuction() public {
        vm.startPrank(attacker);
        attackAuction = new AttackAuction(address(vulnerableAuction));
        attackAuction.attack{value: 1 ether}();

        assertEq(vulnerableAuction.winner(), address(attackAuction));

        vm.startPrank(user);
        vm.expectRevert("ETH transfer failed");
        vulnerableAuction.bid{value: 2 ether}();

        skip(7 days);

        vm.startPrank(attacker);
        attackAuction.claimReward();
   
        assertEq(vulnerableAuction.balanceOf(attacker), 1);
    }
}