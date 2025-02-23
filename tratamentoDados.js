/*
* Script para ler dois arquivos JSON com dados corrompidos de venda de carros e de marcas de carros,
* corrigir estes dados, e salvar a versão corrigida em novos arquivos JSON
*/

const fs = require('fs');
let brokenData1 = [];
let brokenData2 = [];

/*
* Lê os arquivos corrompidos, e depois transforma os dados JSON para objetos JavaScript
* Caso ocorra algum erro, este será logado no console
*/
try{
    const data1 = fs.readFileSync('./JSON/broken_database_1.json', 'utf-8');
    const data2 = fs.readFileSync('./JSON/broken_database_2.json', 'utf-8');
    brokenData1 = JSON.parse(data1);
    brokenData2 = JSON.parse(data2);
} catch(e){
    console.log(e);
}

/*
* Para cada objeto obtido no arquivo 1 será feito:
* - Substituição de todas as ocorrências de 'æ' por 'a' e de 'ø' por 'o' no nome do carro
* - Transformação de todos os números de vendas dos carros em inteiros
*/
brokenData1.forEach(dataCarros => {
    dataCarros.nome = dataCarros.nome.replace(/æ/g,"a").replace(/ø/g,"o");
    dataCarros.vendas = parseInt(dataCarros.vendas);
    console.log(dataCarros);
});

/*
* Para cada objeto obtido no arquivo 1 será feito:
* - Substituição de todas as ocorrências de 'æ' por 'a' e de 'ø' por 'o' no nome das marcas
*/
brokenData2.forEach(dataMarcas => {
    dataMarcas.marca = dataMarcas.marca.replace(/æ/g,"a").replace(/ø/g,"o");
    console.log(dataMarcas);
});

/*
* Escreve os arquivos já corrigidos em novos arquivos JSON
* Caso ocorra algum erro, este será logado no console
*/
try{
    fs.writeFileSync('./JSON/fixed_database_1.json', JSON.stringify(brokenData1, null, 2), 'utf-8');  
    fs.writeFileSync('./JSON/fixed_database_2.json', JSON.stringify(brokenData2, null, 2), 'utf-8');  
} catch(e) {
    console.log(e);
}
