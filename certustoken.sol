// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract CertusToken is ERC20, ERC20Burnable, Ownable, ChainlinkClient {
    // Constants
    uint256 public constant MAX_SUPPLY = 2_850_000 * 10**18; // 5% of initial circulating supply mentioned in the whitepaper's tokenomics
    uint256 public constant INITIAL_SUPPLY = 350_000 * 10**18; // Initial supply for token in arbitrum
    uint256 public constant COMMUNITY_PRESALE_ALLOCATION = 1_500_000 * 10**18; // Allocation for presale campaign
    uint256 public constant PURCHASE_PRICE = 1 * 10**18; // Price per token in wei for purchasing additional tokens
    uint256 public constant DISPUTE_COST = 1 * 10**18; // Cost in wei to initiate a dispute

    // Chainlink variables
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // API key for the NewsAPI
    string public apiKey;

    // Event emitted when the NewsAPI data is updated
    event NewsUpdated(string[] articles);

    // Structure to store article data
    struct Article {
        string title;
        string description;
        string url;
        uint256 publishedAt;
        address trader;
        bool disputed;
    }

    // Array to store articles obtained from the NewsAPI
    Article[] public articles;

    // Mapping to track votes for disputed articles
    mapping(uint256 => mapping(address => bool)) public votes;

    // Constructor
    constructor(address _oracle, bytes32 _jobId, uint256 _fee) 
    ERC20("Certus Protocol Token", "CERTUS") 
    Ownable(msg.sender)
     
    ChainlinkClient() {
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;

        // Mint initial supply to contract creator
        _mint(msg.sender, INITIAL_SUPPLY);

        // Transfer tokens for community pre-sale
        _transfer(msg.sender, address(this), COMMUNITY_PRESALE_ALLOCATION);
    }

    // Function to set the API key
    function setApiKey(string memory _apiKey) external onlyOwner {
        apiKey = _apiKey;
    }

    // Function to update news data from the NewsAPI using Chainlink oracle
    function updateNews() external onlyOwner {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillNews.selector);
        req.add("url", bytes(string(abi.encodePacked("https://newsapi.org/v2/top-headlines?q=politics&apiKey=", apiKey))));
        req.add("path", "articles");
        req.add("copyPath", "[*].[title,description,url,publishedAt]"); // Add copyPath to specify the nested array structure
        sendChainlinkRequestTo(oracle, req, fee);
    }

    // Function to handle response from the NewsAPI
    function fulfillNews(bytes32 _requestId, string[] memory _articles) public recordChainlinkFulfillment(_requestId) {
        // Clear existing articles
        delete articles;

        // Convert response data into Article objects and store them in the articles array
        for (uint256 i = 0; i < _articles.length; i += 4) {
            articles.push(Article({
                title: _articles[i],
                description: _articles[i + 1],
                url: _articles[i + 2],
                publishedAt: uint256(_articles[i + 3]),
                trader: msg.sender,
                disputed: false
            }));
        }

        // Emit event to notify that the data has been updated
        emit NewsUpdated(_articles);
    }

    // Function to withdraw ETH sent to this contract
    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Function to withdraw any ERC20 tokens sent to this contract
    function withdrawTokens(address tokenAddress) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(owner(), token.balanceOf(address(this)));
    }

    // Function to purchase additional tokens
    function purchaseTokens(uint256 amount) external payable {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.value == amount * PURCHASE_PRICE, "Incorrect payment amount");

        // Mint tokens to the buyer
        _mint(msg.sender, amount);
    }

    // Function to initiate a dispute for an article
    function initiateDispute(uint256 articleIndex) external {
        require(articleIndex < articles.length, "Invalid article index");
        require(!articles[articleIndex].disputed, "Article is already disputed");
        require(balanceOf(msg.sender) >= DISPUTE_COST, "Insufficient balance to initiate dispute");

        // Deduct dispute cost from user's balance
        _burn(msg.sender, DISPUTE_COST);

        // Mark the article as disputed
        articles[articleIndex].disputed = true;
    }

    // Function for users to vote on a disputed article
    function voteOnArticle(uint256 articleIndex, bool support) external {
        require(articleIndex < articles.length, "Invalid article index");
        require(articles[articleIndex].disputed, "Article is not disputed");
        require(!votes[articleIndex][msg.sender], "Already voted");

        // Record user's vote
        votes[articleIndex][msg.sender] = support;
    }

    // Function to resolve a dispute for an article
    function resolveDispute(uint256 articleIndex) external onlyOwner {
        require(articleIndex < articles.length, "Invalid article index");
        require(articles[articleIndex].disputed, "Article is not disputed");

        uint256 supportVotes;
        uint256 opposeVotes;

        // Count votes
        for (uint256 i = 0; i < articles.length; i++) {
            if (votes[articleIndex][msg.sender]) {
                supportVotes++;
            } else {
                opposeVotes++;
            }
        }

        // If majority supports the article, transfer tokens to trader
        if (supportVotes > opposeVotes) {
            _transfer(address(this), articles[articleIndex].trader, DISPUTE_COST * (supportVotes - opposeVotes));
        }

        // Reset votes and mark article as no longer disputed
        delete votes[articleIndex];
        articles[articleIndex].disputed = false;
    }
}
