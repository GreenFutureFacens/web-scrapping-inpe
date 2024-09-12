# TerraBrasilis Web Scraping

Este repositório contém um script de web scraping para coletar dados atualizados sobre incêndios do site TerraBrasilis, do INPE (Instituto Nacional de Pesquisas Espaciais). 

URL: https://dataserver-coids.inpe.br/queimadas/queimadas/focos/csv/10min/

## Instalação

Para usar este projeto, siga os seguintes passos:

1. Clone este repositório em sua máquina local:

    ```bash
    git clone https://github.com/GreenFutureFacens/web-scrapping-inpe.git 
    cd web-scrapping-inpe
    ```

2. Instale as dependências necessárias usando o arquivo `requirements.txt`:

    ```bash
    pip install -r requirements.txt
    ```
3. Para criar o banco de dados execute o comando 
    ```bash
    docker compose up -d
    ```

## Observação
O Script está buscando todos os dados a partir da data 2024-09-01, porém a nova versão será lançada para buscar dados do dia.

## Execução

Após a instalação das dependências, você pode rodar o script de web scraping que se encontra na pasta `src`:

```bash
python src/web_scraping.py
