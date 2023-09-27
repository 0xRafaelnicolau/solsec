// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract FixedMultiTokenBank {
    using SafeERC20 for IERC20;

    error InvalidToken();
    error TokensMustBeSubsetOfValidTokens();
    error NonMatchingArrayLength();
    error ArrayWithDuplicateToken();
    error ZeroSizeArray();

    mapping(address => bool) private _validTokens;
    mapping(address => mapping(address => uint256)) private _tokenBalances;

    constructor(address[] memory validTokens) {
        for (uint256 i; i < validTokens.length; ++i) {
            if (validTokens[i] == address(0)) revert InvalidToken();
            _validTokens[validTokens[i]] = true;
        }
    }

    function _hasDuplicate(address[] memory tokens) private pure returns (bool) {
        if (tokens.length == 0) {
            return false;
        }
        for (uint256 i = 0; i < tokens.length - 1; i++) {
            for (uint256 j = i + 1; j < tokens.length; j++) {
                if (tokens[i] == tokens[j]) {
                    return true;
                }
            }
        }
        return false;
    }

    function deposit(uint256[] calldata amounts, address[] calldata tokens) external {
        if (tokens.length != amounts.length) revert NonMatchingArrayLength();
        if (tokens.length == 0) revert ZeroSizeArray();

        for (uint256 i; i < tokens.length; ++i) {
            if (_validTokens[tokens[i]] == false) {
                revert InvalidToken();
            }
            _tokenBalances[msg.sender][tokens[i]] += amounts[i];
            IERC20(tokens[i]).safeTransferFrom(msg.sender, address(this), amounts[i]);
        }
    }

    function withdrawAll(address[] calldata tokens) external {
        if (tokens.length == 0) revert ZeroSizeArray();
        if (_hasDuplicate(tokens) == true) revert ArrayWithDuplicateToken();

        uint256[] memory balancesToSend = new uint256[](tokens.length);
        for (uint256 i; i < tokens.length; ++i) {
            if (_validTokens[tokens[i]] == false) {
                revert InvalidToken();
            }
            balancesToSend[i] = _tokenBalances[msg.sender][tokens[i]];
        }

        for (uint256 i; i < tokens.length; ++i) {
            _tokenBalances[msg.sender][tokens[i]] = 0;
            IERC20(tokens[i]).safeTransfer(msg.sender, balancesToSend[i]);
        }
    }
}
