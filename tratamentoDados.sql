/*
* Script SQL para criar uma tabela única contendo os dados necessários dos arquivos
* fixed_database_1.json e fixed_database_2.json, deve ser rodado em ambiente
* SQL Online (https://sqliteonline.com/) utilizando Postgre SQL com os dois
* arquivos JSON já importados
*/

/* 
* Comandos para alterar os nomes das colunas dos bancos de dados,
* já que estas perdem seus nomes durante a importação no ambient SQL Online.
*/
ALTER table fixed_database_1
RENAME COLUMN c1 TO datas;
ALTER table fixed_database_1
RENAME COLUMN c2 TO marca;
ALTER table fixed_database_1
RENAME COLUMN c3 TO vendas;
ALTER table fixed_database_1
RENAME COLUMN c4 TO valor_do_veiculo;
ALTER table fixed_database_1
RENAME COLUMN c5 TO nome;

ALTER table fixed_database_2
RENAME COLUMN c1 TO id_marca;
ALTER table fixed_database_2
RENAME COLUMN c2 TO nome_marca;

/* Comando para adicionar um ID na tabela com as vendas de carros */
ALTER TABLE fixed_database_1
ADD COLUMN id SERIAL PRIMARY KEY;

/* 
* Comandos para transformar as colunas de id de marca de SMALLINT para VARCHAR 
* Necessário para consulta posterior
*/
ALTER TABLE fixed_database_1
ALTER COLUMN marca TYPE VARCHAR(30);
ALTER TABLE fixed_database_2
ALTER COLUMN id_marca TYPE VARCHAR(30);

/* 
*  Consulta para transformar a coluna da tabela 1 contendo os IDs de cada marca
*  no nome da marca associada com esses IDs na tabela 2
*/
UPDATE fixed_database_1 AS d1
SET marca = d2.nome_marca 
FROM fixed_database_2 AS d2
WHERE d1.marca = d2.id_marca;

/* Comando para visualizar a tabela resultante (ordenada pelo ID) */
SELECT * FROM fixed_database_1 ORDER BY ID

/* 
* Após fazer essas consultas, já temos todos os dados necessários 
* e é possível fazer a exportação do arquivo como .csv
*/

/***CONSULTAS PARA RESPONDER AS PERGUNTAS DO RELATÓRIO***/

/*1. Qual marca teve o maior volume de vendas?*/ 

/*
* Consulta de qual marca teve a maior receita em suas vendas
* organizando da marca que mais ganhou até a que menos ganhou
*/
SELECT marca, SUM(valor_do_veiculo*vendas) AS receita_total
FROM fixed_database_1
GROUP BY  marca
ORDER BY sum(valor_do_veiculo*vendas) DESC

/*
* Consulta de qual marca teve a maior quantidade de carros vendidos
* organizando da marca que mais vendeu até a que menos vendeu
*/
SELECT marca, SUM(vendas) AS total_vendas
FROM fixed_database_1
GROUP BY  marca
ORDER BY sum(vendas) DESC

/*2. Qual veículo gerou a maior e menor receita?*/ 
/*
* Consulta das receitas de cada modelo de carro que voi vendido
* organizando do modelo com maior receita até o com menor receita
*/
SELECT marca, nome, SUM(valor_do_veiculo*vendas) AS receita_total
FROM fixed_database_1
GROUP BY marca, nome
ORDER BY sum(valor_do_veiculo*vendas) DESC

/*3. Considere faixas de preço de venda dos carros a cada 10 mil reais.
     Qual faixa mais vendeu carros? Quantos?*/
/*
* Consulta do número de vendas por cada faixa de preço
* organizando pelo número de vendas
*/
SUM(vendas) AS num_vendas,
(FLOOR(valor_do_veiculo / 10000))*10000 AS faixa_de_preço
FROM fixed_database_1
group by FLOOR(valor_do_veiculo / 10000)
ORDER BY SUM(vendas) DESC


/*4. Qual a receita das 3 marcas que têm os menores tickets médios?*/ 
/*
* Consulta do ticket medio e receita de cada marca
* organizando da marca com maiot ticket até a com menor
* limitando aos 3 primeiros resultados
*/
SELECT 
marca,  
ROUND(AVG(valor_do_veiculo), 2) AS ticket_medio, 
SUM(valor_do_veiculo*vendas) AS receita_total
FROM fixed_database_1
GROUP BY marca
ORDER BY AVG(valor_do_veiculo)
LIMIT 3

/*5. Existe alguma relação entre os veículos mais vendidos?*/ 
/*
* Consulta dos carros que mais foram vendidos
* organizando do modelo que mais vendeu até o que menos vendeu
* e analisando o ticket medio de cada modelo para buscar relações entre eles
*/
SELECT 
marca, nome, 
SUM(vendas) AS num_vendas, 
ROUND(AVG(valor_do_veiculo),2) AS ticket_medio
FROM fixed_database_1
GROUP BY marca, nome
ORDER BY sum(vendas) DESC