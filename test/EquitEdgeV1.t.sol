// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EquitEdge} from "../src/EquitEdgeV1.sol";

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


        equitEdge = new EquitEdge(
            initialAddresses,
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
            100_000_000 * 10 ** 18,
            "Initial balance for address 1 should be 100 million"
        );
        assertEq(
            balance2,
            100_000_000 * 10 ** 18,
            "Initial balance for address 2 should be 100 million"
        );
    }

 // Test to ensure that the total supply after deployment matches 500 million
    function testInitialSupplyIsCapped() public view {
        // Check total supply is 500 million tokens
        uint256 totalSupply = equitEdge.totalSupply();
        uint256 expectedSupply = 500_000_000 * (10 ** 18);
        
        assertEq(totalSupply, expectedSupply, "Total supply does not match cap.");
    }

    // Test to ensure no more tokens can be minted beyond the cap
    // function testMintBeyondCapShouldFail() public {
    //     // Try to mint new tokens, which should fail since the cap is reached
    //     vm.expectRevert("ERC20Capped: cap exceeded");
    //     equitEdge.mint(address(this), 1 * (10 ** 18)); // Attempt to mint 1 token
    // }

    // Test that the owner cannot mint beyond cap
    // function testOwnerCannotMintBeyondCap() public {
    //     // Try minting more tokens and expect failure
    //     vm.expectRevert("ERC20Capped: cap exceeded");
    //     equitEdge.mint(address(0x6), 1 * (10 ** 18)); // Owner trying to mint additional tokens
    // }

    // Test renouncing ownership works correctly
    function testOwnerCanRenounceOwnership() public {
        // Renounce ownership
        equitEdge.renounceOwnership();

        // Check if the owner is the zero address
        assertEq(equitEdge.owner(), address(0), "Ownership was not renounced correctly.");
    }
}
