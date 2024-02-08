# News-Consumer-Politics

This smart contract is designed to consume the NewsAPI API and fetch the latest policy related articles. It uses Chainlink as an oracle to make HTTP calls and fetch external data.

## Requirements

Before you get started, make sure you have the following:

NewsAPI API key: You must obtain a NewsAPI API key to authenticate your requests. You can obtain it by registering with NewsAPI.

LINK funds in the contract: Make sure you have LINK funds in the contract to pay oracle fees. You can request LINK on the test network through the Chainlink faucet.

## Configuration.

Before deploying the contract, you need to make some configurations:

Flags contract address: configure the Flags contract address, which is used to check if the Chainlink oracle is online. This address may vary depending on the network environment.

Oracle Contract Address: configure the address of the Chainlink oracle contract that will be used to make HTTP calls. This address may also vary depending on the network.

# Contract Deployment

Deploy the contract to the network of your choice, making sure you have sufficient LINK funds in the contract.

## Using the Contract

Once deployed, follow these steps to use the contract:

Set API Key: Call the setApiKey function to set your NewsAPI API key.

Update News: Call the updateNews function to make a NewsAPI API call and get the latest policy-related articles.

Check the Articles: You can access the updated articles by calling the articles function.


