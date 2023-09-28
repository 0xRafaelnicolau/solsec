// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {VulnerableDAO} from "../../src/array-deletion-dos/array-deletion-dos.sol";
import {FixedDAO} from "../../src/array-deletion-dos/array-deletion-dos-fixed.sol";

contract TestDeletionDoS is Test {
    VulnerableDAO public vulnerableDAO;
    FixedDAO public fixedDAO;
    address public attacker = makeAddr("attacker");

    function setUp() public {
        vulnerableDAO = new VulnerableDAO(2);
        fixedDAO = new FixedDAO(2);
    }

    function testSubmitProposal() public {
        vm.startPrank(attacker);
        // submit two proposals
        vulnerableDAO.submitProposal(); 
        vulnerableDAO.submitProposal(); 
        // execute the oldest added proposal
        skip(1 days); // increate block.timestamp by 1 day
        vulnerableDAO.executeProposal(); 
        // assert that pending proposals was not updated properly
        assertEq(vulnerableDAO.numOfPendingProposals(), 2);
        // assert that the function was DoS and can't be used anymore
        vm.expectRevert(VulnerableDAO.ExceededPendingProposals.selector);
        vulnerableDAO.submitProposal();        
    }

    function testSubmitProposalFixed() public {
        vm.startPrank(attacker);
        // submit two proposals
        fixedDAO.submitProposal();
        fixedDAO.submitProposal();
        assertEq(fixedDAO.numOfPendingProposals(), 2);
        // execute the oldest added proposal
        skip(1 days); // increate block.timestamp by 1 day
        fixedDAO.executeProposal();
        assertEq(fixedDAO.numOfPendingProposals(), 1);
    }
}