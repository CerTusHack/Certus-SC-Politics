# Certus Protocol Token

Certus Protocol Token is an ERC20 token contract that includes functionality to interact with the Chainlink oracle for fetching data from the NewsAPI. It also implements standard ERC20 token functionalities such as minting, burning, and transferring tokens.

## Features

- Fetches data from the NewsAPI using the Chainlink oracle.
- Maintains a list of articles obtained from the NewsAPI.
- Supports standard ERC20 token functionalities.
- Allows the owner to withdraw ETH and ERC20 tokens sent to the contract.

## Deployment

The contract can be deployed on an Ethereum-compatible blockchain network using tools like Remix, Truffle, or Hardhat. Before deployment, make sure to set the necessary parameters such as the Chainlink oracle address, job ID, and fee, as well as the API key for accessing the NewsAPI.

## Usage

1. Deploy the contract to an Ethereum-compatible blockchain network.
2. Set the Chainlink oracle address, job ID, and fee using the constructor.
3. Set the API key for accessing the NewsAPI using the `setApiKey` function.
4. Mint initial tokens using the constructor or any other designated function.
5. Interact with the contract to fetch news data from the NewsAPI and perform token transfers.

## Dependencies

- OpenZeppelin Contracts: Library for secure smart contract development.
- Chainlink Client: Library for interacting with Chainlink oracles.
- Solidity Compiler: Compiler for Solidity smart contracts.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

