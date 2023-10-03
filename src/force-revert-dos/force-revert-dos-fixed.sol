// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ReentrancyGuard} from "../../lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {ERC721} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract FixedAuction is ERC721, ReentrancyGuard {
    address public winner;
    uint256 public winnerDeposit;
    uint256 public immutable auctionEnd;
    bool public claimed;

    mapping(address => uint256) public refunds;

    constructor(uint256 auctionDuration) ERC721("Auction Reward NFT", "AR") {
        auctionEnd = block.timestamp + auctionDuration;
    }

    function bid() external payable nonReentrant {
        require(block.timestamp < auctionEnd, "Auction already finished");
        require(msg.sender != winner, "You are the current winner");
        require(msg.value > winnerDeposit, "Not enough ETH");

        if (winner == address(0)) {
            winner = msg.sender;
            winnerDeposit = msg.value;
        } else {
            address prevWinner = winner;
            uint256 prevWinnerDeposit = winnerDeposit;

            winner = msg.sender;
            winnerDeposit = msg.value;

            refunds[prevWinner] += prevWinnerDeposit;
        }
    }

    function claimRefund() external nonReentrant {
        uint256 refundAmount = refunds[msg.sender];
        require(refundAmount != 0, "No ETH to refund");

        refunds[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: refundAmount}("");
        require(success, "ETH transfer failed");
    }

    function claimReward() external nonReentrant {
        require(block.timestamp >= auctionEnd, "Auction not finished");
        require(msg.sender == winner, "Not the winner of the auction");
        require(!claimed, "Reward already claimed");

        claimed = true;

        _safeMint(winner, 1);
    }

    function hasAuctionEnded() external view returns (bool) {
        return auctionEnd < block.timestamp;
    }
}
