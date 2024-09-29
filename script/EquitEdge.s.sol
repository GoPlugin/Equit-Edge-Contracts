// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EquitEdge} from "../src/EquitEdge.sol";

contract EquitEdgeScript is Script {
    EquitEdge public equitEdge;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address[] memory initialAddresses = new address[](2);
        initialAddresses[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        initialAddresses[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;

        // Define the approvers array as a dynamic array
        address[] memory approvers = new address[](2);
        approvers[0] = 0x8c52c1b313530D457206C0DB104DF61B1213fe97;
        approvers[1] = 0x0ee64CBb3Dc7eacb782F12a6f667C450268CF3D0;

        // Specify the number of required approvals
        uint256 requiredApprovals = 2;

        // Create the EquitEdge contract with the parameters
        equitEdge = new EquitEdge(
            initialAddresses,
            approvers,
            requiredApprovals,
            "Equit Edge Token",
            "EEG"
        );

        vm.stopBroadcast();
    }
}
