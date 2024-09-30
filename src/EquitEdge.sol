// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract EquitEdge is  ERC20Capped, Ownable, ReentrancyGuard {
    // 40 million tokens per address during initial minting
    uint256 public constant INITIAL_MINT_PER_ADDRESS = 40_000_000 * (10 ** 18); 
    uint256 public constant TOTAL_SUPPLY_EEG = 500_000_000 * (10 ** 18); 

    //Pause Minting flag
    bool public mintingPaused;

    // List of approvers
    address[] public approvers;

    // Total Approvals required
    uint256 public immutable requiredApprovers = 3;

    // To Track the approver
    mapping(address => bool) public isApprover;

    // Mapping for token minting approval
    mapping(uint256 => mapping(address => bool)) public approvals; 

    // To track total minting request
    uint256 public mintRequestCounter;

    // To track Mint Request information
    struct MintRequest {
        uint256 amount;
        address to;
        uint256 approvalsCount;
        bool isProcessed;
    }

    mapping(uint256 => MintRequest) public mintRequests;

    // Event definition
    event MintRequested(uint256 indexed requestId, address indexed to, uint256 amount);
    event MintApproved(uint256 indexed requestId, address indexed approver);
    event MintExecuted(uint256 indexed requestId, address indexed to, uint256 amount);
    event PauseOrUnpause(address indexed actionTakenBy,string action, uint256 takenOn);
    event OwnerShipRenounced(address indexed actionTakenBy,uint256 takenOn);


    // Constructor function which override the cap information to 500 million
    // Ownable by contract deployer
    constructor(
        address[] memory _initialAddresses,
        address[] memory _approvers,
        string memory _tokenName,
        string memory _tokenSymbol
    )
        ERC20(_tokenName,_tokenSymbol) // Token name and symbol
        ERC20Capped(TOTAL_SUPPLY_EEG) // Token supply cap
        Ownable(msg.sender)
    {
        require(_initialAddresses.length == 5, "Must provide exactly 5 addresses for initial minting");
        require(_approvers.length == 5, "Shoul have 5 approvers");

        approvers = _approvers;

        for (uint256 i = 0; i < _approvers.length; i++) {
            require(_approvers[i] != address(0),"Zero address found");
            require(!isApprover[_approvers[i]], "Duplicate approver address found");
            isApprover[_approvers[i]] = true;
        }

        // Mint 40 million tokens to each of the provided 5 addresses
        for (uint256 i = 0; i < _initialAddresses.length; i++) {
            _mint(_initialAddresses[i], INITIAL_MINT_PER_ADDRESS);
        }
    }

    //Access Modifier to have only listed Approver
    modifier onlyApprover() {
        require(isApprover[msg.sender], "Not an approver");
        _;
    }

    //Modifier to check if minting is not passed
    modifier whenNotPaused() {
        require(!mintingPaused, "Minting is paused");
        _;
    }

    // To request the minting to be approved and processed by approvers
    function requestMint(address _to, uint256 _amount) external onlyOwner whenNotPaused returns (uint256) {
        require(_to != address(0), "Invalid address");
        require(_amount > 0, "Mint amount must be greater than 0");
        require(totalSupply() + _amount <= cap(), "Cap exceeded");

        mintRequestCounter += 1;
        MintRequest memory newRequest = MintRequest({
            amount: _amount,
            to: _to,
            approvalsCount: 0,
            isProcessed: false
        });

        mintRequests[mintRequestCounter] = newRequest;

        emit MintRequested(mintRequestCounter, _to, _amount);

        return mintRequestCounter;
    }

    // To approve the request for minting once the sufficient approval is obtained
    function approveMint(uint256 _requestId) external onlyApprover nonReentrant whenNotPaused {
        require(mintRequests[_requestId].amount > 0, "Mint amount cannot be 0");
        require(!mintRequests[_requestId].isProcessed, "Request Processed");
        require(!approvals[_requestId][msg.sender], "Already approved");

        approvals[_requestId][msg.sender] = true;
        mintRequests[_requestId].approvalsCount += 1;

        emit MintApproved(_requestId, msg.sender);

        if (mintRequests[_requestId].approvalsCount >= requiredApprovers) {
            mintRequests[_requestId].isProcessed = true;
            _mint(mintRequests[_requestId].to, mintRequests[_requestId].amount);
            emit MintExecuted(_requestId, mintRequests[_requestId].to, mintRequests[_requestId].amount);
        }
    }

    //Pause Minting
    function pauseMinting() external onlyOwner {
        mintingPaused = true;
        emit PauseOrUnpause(msg.sender,"pause",block.timestamp);
    }

    //Un Pause Minting
    function unpauseMinting() external onlyOwner {
        mintingPaused = false;
        emit PauseOrUnpause(msg.sender,"unpause",block.timestamp);
    }

    //To renounce the ownership
    //Should be called only by the owner
    function renounceOwnership() public override onlyOwner {
        emit OwnerShipRenounced(msg.sender,block.timestamp);
        renounceOwnership();
    }

}
