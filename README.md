# Certus Protocol Token

CertusToken is a Solidity smart contract that manages an ERC20 token called "Certus Protocol Token" (symbol: CERTUS). This contract allows users to perform various actions, such as buying tokens, voting on disputed news articles, and resolving disputes.

## Features

- Creation of ERC20 tokens with the name "Certus Protocol Token" and symbol "CERTUS".
- Functionality to purchase tokens at a fixed price.
- Updating news data via the NewsAPI using a Chainlink oracle.
- Functionality to initiate and resolve disputes over news articles.
- Withdrawal of ETH and ERC20 tokens from the contract.

## Requirements
- Node.js and npm installed locally.
- Connection to a compatible Ethereum network (e.g., ganache, ropsten, mainnet).
- Deployed Chainlink Oracle contracts on the desired Ethereum network.
- Valid NewsAPI API key.

## Setup

Clone this repository to your local machine.

Install project dependencies:


npm install

- Compile and migrate the contracts to the desired Ethereum network using Truffle:

truffle compile
truffle migrate --network <network>

## Configure the contract parameters:

- Oracle: Address of the Chainlink oracle contract.
- Job ID: Job ID of the Chainlink oracle for the NewsAPI.
- Fee: Fee in LINK to be paid to the Chainlink oracle for the service.
- API key: Valid NewsAPI API key.

## Usage

- Set the NewsAPI API key using the setApiKey function.
- Update news data using the updateNews function.
- Initiate a dispute over a news article using the initiateDispute function.
- Vote on a disputed news article using the voteOnArticle function.
- Resolve a dispute over a news article using the resolveDispute function.
- Purchase tokens using the purchaseTokens function.
- Withdraw ETH and ERC20 tokens using the withdrawETH and withdrawTokens functions, respectively.

## Dependencies

- OpenZeppelin Contracts: Library for secure smart contract development.
- Chainlink Client: Library for interacting with Chainlink oracles.
- Solidity Compiler: Compiler for Solidity smart contracts.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

