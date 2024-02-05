// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/vendor/Ownable.sol";

contract NewsAPIConsumer is ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;

    // Dirección del contrato de Flags
    address constant private FLAGS_ADDRESS = 0x491B1dDA0A8fa069bbC1125133A975BF4e85a91b;
    FlagsInterface internal chainlinkFlags;

    // Clave de la API de NewsAPI
    string public apiKey;

    // Evento que se emite cuando se actualizan los datos de la API de NewsAPI
    event NewsUpdated(string[] articles);

    // Estructura para almacenar los datos de un artículo
    struct Article {
        string title;
        string description;
        string url;
        uint256 publishedAt;
    }

    // Almacena la lista de artículos obtenidos de la API de NewsAPI
    Article[] public articles;

    // Modificador que requiere que se establezca una clave API válida
    modifier validApiKey() {
        require(bytes(apiKey).length > 0, "API key not set");
        _;
    }

    // Constructor que establece la dirección del contrato de Flags
    constructor() {
        chainlinkFlags = FlagsInterface(FLAGS_ADDRESS);
    }

    // Función para establecer la clave API
    function setApiKey(string memory _apiKey) external onlyOwner {
        apiKey = _apiKey;
    }

    // Función para obtener los datos más recientes de la API de NewsAPI
    function updateNews() external validApiKey onlyOwner {
        // Construir la solicitud para la API de NewsAPI
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillNews.selector
        );
        req.add("url", "https://newsapi.org/v2/top-headlines?q=politics&apiKey=" + apiKey);
        req.add("path", "articles[*].[title,description,url,publishedAt]");

        // Enviar la solicitud al oráculo de Chainlink
        sendChainlinkRequest(req, fee);
    }

    // Función para manejar la respuesta de la API de NewsAPI
    function fulfillNews(bytes32 _requestId, string[] memory _articles) public recordChainlinkFulfillment(_requestId) {
        // Limpiar los artículos existentes
        delete articles;

        // Convertir los datos de la respuesta en objetos Article y almacenarlos en la lista de artículos
        for (uint i = 0; i < _articles.length; i += 4) {
            articles.push(Article({
                title: _articles[i],
                description: _articles[i + 1],
                url: _articles[i + 2],
                publishedAt: uint256(_articles[i + 3])
            }));
        }

        // Emitir el evento para notificar que se han actualizado los datos
        emit NewsUpdated(_articles);
    }
}
