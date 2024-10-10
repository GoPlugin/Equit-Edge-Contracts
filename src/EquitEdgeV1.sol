// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract EquitEdge is ERC20Capped, Ownable, ReentrancyGuard {
    // 40 million tokens per address during initial minting
    uint256 public constant INITIAL_MINT_PER_ADDRESS = 100_000_000 * (10 ** 18);
    uint256 public constant TOTAL_SUPPLY_EEG = 500_000_000 * (10 ** 18);

    event OwnerShipRenounced(address indexed actionTakenBy, uint256 takenOn);

    // Constructor function which override the cap information to 500 million
    // Ownable by contract deployer
    constructor(
        address[] memory _initialAddresses,
        string memory _tokenName,
        string memory _tokenSymbol
    )
        ERC20(_tokenName, _tokenSymbol) // Token name and symbol
        ERC20Capped(TOTAL_SUPPLY_EEG) // Token supply cap
        Ownable(msg.sender)
    {
        require(
            _initialAddresses.length == 5,
            "Must provide exactly 5 addresses for initial minting"
        );

        // Mint 100 million tokens to each of the provided 5 addresses
        for (uint256 i = 0; i < _initialAddresses.length; i++) {
            _mint(_initialAddresses[i], INITIAL_MINT_PER_ADDRESS);
        }
    }

    //To renounce the ownership
    //Should be called only by the owner
    function renounceOwnership() public override onlyOwner {
        emit OwnerShipRenounced(msg.sender, block.timestamp);
        renounceOwnership();
    }
}
