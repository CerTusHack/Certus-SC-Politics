# News-Consumer-Politics

Este contrato inteligente está diseñado para consumir la API de NewsAPI y obtener los últimos artículos relacionados con la política. Utiliza Chainlink como oráculo para realizar llamadas HTTP y obtener datos externos.

## Requisitos

Antes de comenzar, asegúrate de tener lo siguiente:

Clave de API de NewsAPI: Debes obtener una clave de API de NewsAPI para autenticar tus solicitudes. Puedes obtenerla registrándote en NewsAPI.

Fondos LINK en el Contrato: Asegúrate de tener fondos LINK en el contrato para pagar las tarifas del oráculo. Puedes solicitar LINK en la red de prueba a través del faucet de Chainlink.

## Configuración

Antes de desplegar el contrato, debes realizar algunas configuraciones:

Dirección del Contrato Flags: Configura la dirección del contrato de Flags, que se utiliza para verificar si el oráculo de Chainlink está en línea. Esta dirección puede variar según el entorno de red.

Dirección del Contrato Oráculo: Configura la dirección del contrato de oráculo de Chainlink que se utilizará para realizar las llamadas HTTP. Esta dirección también puede variar según la red.

# Despliegue del Contrato

Despliega el contrato en la red de tu elección, asegurándote de tener suficientes fondos LINK en el contrato.

## Uso del Contrato

Una vez desplegado, sigue estos pasos para utilizar el contrato:

Establece la Clave de API: Llama a la función setApiKey para establecer tu clave de API de NewsAPI.

Actualiza las Noticias: Llama a la función updateNews para realizar una llamada a la API de NewsAPI y obtener los últimos artículos relacionados con la política.

Consulta los Artículos: Puedes acceder a los artículos actualizados llamando a la función articles.

Recuerda que este contrato es un ejemplo educativo y no debe utilizarse en entornos de producción sin una auditoría adecuada.
