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