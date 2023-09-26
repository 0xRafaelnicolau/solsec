// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {VulnerableParty} from "../../src/empty-loop/empty-loop.sol";
import {FixedParty} from "../../src/empty-loop/empty-loop-fixed.sol";

contract TestParty is Test {
    VulnerableParty public vulnerableParty;
    FixedParty public fixedParty;

    address public attendee = makeAddr("attendee");
    address public attacker = makeAddr("attacker");

    function setUp() public {
        address[] memory organizers = new address[](2);
        organizers[0] = makeAddr("organizer-1");
        organizers[1] = makeAddr("organizer-2");

        vulnerableParty = new VulnerableParty(organizers);
        fixedParty = new FixedParty(organizers);
    }

    function testMintEmptyLoop() public {
        VulnerableParty.Signature[] memory signatures = new VulnerableParty.Signature[](0);
        vm.prank(attacker);
        vulnerableParty.mint(signatures);
        assertEq(vulnerableParty.balanceOf(attacker), 1);
    }

    function testMintEmptyLoopFixed() public {
        FixedParty.Signature[] memory signatures = new FixedParty.Signature[](0);
        vm.startPrank(attacker);
        vm.expectRevert(FixedParty.InvalidNumberOfSignatures.selector);
        fixedParty.mint(signatures);
        vm.stopPrank();
    }
}
