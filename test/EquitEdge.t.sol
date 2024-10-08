// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EquitEdge} from "../src/EquitEdge.sol";

contract EquitEdgeTest is Test {
    EquitEdge public equitEdge;

    function setUp() public {
        address[] memory initialAddresses = new address[](5);
        // address[] memory initialAddresses;
        //From A/c 10 to 14
        initialAddresses[0] = 0xDD984A823176BDe6D776B0A25144AA9A95a7Ee0A;
        initialAddresses[1] = 0xCed4fECe7514f0E968eD46D0540654f22E0B519c;
        initialAddresses[2] = 0xd58D2E5D64929f61931B9847B7e1e33f813d9d2c;
        initialAddresses[3] = 0x05D5e6fd980E208474f9443505A6e3a27e478974;
        initialAddresses[4] = 0xb5c88dcc8Da552fd1c15d852b696a94367a3096c;


        // Define the approvers array as a dynamic array
        address[] memory approvers = new address[](3);
        //From a/c 4 to 8
        approvers[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        approvers[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;
        approvers[2] = 0x317705CF5007996D561cbA50E1c3B07e5d5e4083;

        equitEdge = new EquitEdge(
            initialAddresses,
            approvers,
            "EEG Token",
            "EEG"
        );
    }

    function testInitialMinting() public view {
        address[] memory initialAddresses = new address[](5);
        // address[] memory initialAddresses;
        initialAddresses[0] = 0xDD984A823176BDe6D776B0A25144AA9A95a7Ee0A;
        initialAddresses[1] = 0xCed4fECe7514f0E968eD46D0540654f22E0B519c;
        initialAddresses[2] = 0xd58D2E5D64929f61931B9847B7e1e33f813d9d2c;
        initialAddresses[3] = 0x05D5e6fd980E208474f9443505A6e3a27e478974;
        initialAddresses[4] = 0xb5c88dcc8Da552fd1c15d852b696a94367a3096c;


        // Define the approvers array as a dynamic array
        address[] memory approvers = new address[](3);
        approvers[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        approvers[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;
        approvers[2] = 0x317705CF5007996D561cbA50E1c3B07e5d5e4083;


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

        // // Simulate the second approver approving the mint request
        // vm.prank(0x317705CF5007996D561cbA50E1c3B07e5d5e4083); // Change msg.sender to the second approver
        // equitEdge.approveMint(requestId);
         
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

}
