// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EquitEdge} from "../src/EquitEdge.sol";

contract EquitEdgeTest is Test {
    EquitEdge public equitEdge;

    function setUp() public {
        address[] memory initialAddresses = new address[](2);
        // address[] memory initialAddresses;
        initialAddresses[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        initialAddresses[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;

        // Define the approvers array as a dynamic array
        address[] memory approvers = new address[](2);
        approvers[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        approvers[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;
        // Specify the number of required approvals
        uint256 requiredApprovals = 2;

        equitEdge = new EquitEdge(
            initialAddresses,
            approvers,
            requiredApprovals
        );
    }

    function testInitialMinting() public view {
        address[] memory initialAddresses = new address[](2);
        // address[] memory initialAddresses;
        initialAddresses[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        initialAddresses[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;

        // Define the approvers array as a dynamic array
        address[] memory approvers = new address[](2);
        approvers[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        approvers[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;
        // Check that the initial balances are correct
        uint256 balance1 = equitEdge.balanceOf(initialAddresses[0]);
        uint256 balance2 = equitEdge.balanceOf(initialAddresses[1]);

        assertEq(
            balance1,
            40_000_000 * 10 ** 18,
            "Initial balance for address 1 should be 40 million"
        );
        assertEq(
            balance2,
            40_000_000 * 10 ** 18,
            "Initial balance for address 2 should be 40 million"
        );
    }

    function testMintRequest() public {
        // Request a minting operation
        uint256 requestId = equitEdge.requestMint(
            address(this),
            1_000_000 * 10 ** 18
        );
        assertEq(requestId, 1, "First request ID should be 1");
    }

    function testApproveMinting() public {
        // Request a minting operation
        uint256 requestId = equitEdge.requestMint(
            address(this),
            1_000_000 * 10 ** 18
        );

        // Simulate the first approver approving the mint request
        vm.prank(0x8c52c1b313530D457206C0DB104DF61B1213fe97); // Change msg.sender to the first approver
        equitEdge.approveMint(requestId);

        // Simulate the second approver approving the mint request
        vm.prank(0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0); // Change msg.sender to the second approver
        equitEdge.approveMint(requestId);

        // Check that the mint was executed
        uint256 newBalance = equitEdge.balanceOf(address(this));
        assertEq(
            newBalance,
            1_000_000 * 10 ** 18,
            "Minting was not executed correctly"
        );
    }

    function testPauseMinting() public {
        // Pause minting
        equitEdge.pauseMinting();

        // Verify that minting is paused
        bool paused = equitEdge.mintingPaused();
        assertTrue(paused, "Minting should be paused");
    }

    function testUnpauseMinting() public {
        // Pause and then unpause minting
        equitEdge.pauseMinting();
        equitEdge.unpauseMinting();

        // Verify that minting is not paused
        bool paused = equitEdge.mintingPaused();
        assertTrue(!paused, "Minting should not be paused");
    }

    function testMintBeyondCapShouldRevert() public {
        // Try to request a mint that exceeds the 500 million cap
        uint256 excessAmount = 500_000_001 * (10 ** 18); // 500 million + 1 token
        
        // Expect the mint to revert due to cap being exceeded
        vm.expectRevert("ERC20Capped: cap exceeded");
        equitEdge.requestMint(address(this), excessAmount);
    }
}
