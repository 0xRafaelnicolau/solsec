// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract FixedDAO {
    struct Proposal {
        uint256 timestamp;
        bool executed;
    }

    error ExceededPendingProposals();
    error ProposalStillTimeLocked();

    Proposal[] private _pendingProposals;
    uint256 private _maxPendingProposals;

    constructor(uint256 maxPendingProposals) {
        _maxPendingProposals = maxPendingProposals;
    }

    function submitProposal() public {
        if (_pendingProposals.length == _maxPendingProposals) {
            revert ExceededPendingProposals();
        }
        
        Proposal memory p = Proposal(block.timestamp + 1 days, false);
        _pendingProposals.push(p);
    }

    function executeProposal() public {
        if (block.timestamp < _pendingProposals[0].timestamp) {
            revert ProposalStillTimeLocked();
        }

        _pendingProposals[0].executed = true; 

        for (uint256 i; i < _pendingProposals.length - 1; i++) {
            _pendingProposals[i] = _pendingProposals[i + 1];
        }

        _pendingProposals.pop();
    }

    function numOfPendingProposals() external view returns (uint256) {
        return _pendingProposals.length;
    }
}