// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {VulnerableParty} from "../../src/empty-loop/empty-loop.sol";
import {FixedParty} from "../../src/empty-loop/empty-loop-fixed.sol";

contract PartyTest is Test {
    VulnerableParty public vulnerableParty;
    FixedParty public fixedParty;

    address public attendee = makeAddr("attendee");
    address public attacker = makeAddr("attacker");

    address[] public organizers;
    uint256[] public privateKeys;

    function setUp() public {
        (address organizer1, uint256 privateKey1) = makeAddrAndKey("organizer-1");
        (address organizer2, uint256 privateKey2) = makeAddrAndKey("organizer-2");

        organizers = new address[](2);
        organizers[0] = organizer1;
        organizers[1] = organizer2;

        privateKeys = new uint256[](2);
        privateKeys[0] = privateKey1;
        privateKeys[1] = privateKey2;

        vulnerableParty = new VulnerableParty(organizers);
        fixedParty = new FixedParty(organizers);
    }

    function testMint() public {
        string memory header = "\x19Ethereum Signed Message:\n52";
        bytes32 messageHash1 = keccak256(abi.encodePacked(header, organizers[0], attendee));
        bytes32 messageHash2 = keccak256(abi.encodePacked(header, organizers[1], attendee));

        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(privateKeys[0], messageHash1);
        (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(privateKeys[1], messageHash2);

        FixedParty.Signature[] memory signatures = new FixedParty.Signature[](2);
        signatures[0] = FixedParty.Signature(v1, r1, s1);
        signatures[1] = FixedParty.Signature(v2, r2, s2);

        vm.prank(attendee);
        fixedParty.mint(signatures);

        assertEq(fixedParty.balanceOf(attendee), 1);
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