const fs = require('fs');

const data1 = fs.readFileSync('./JSON/broken_database_1.json', 'utf-8');
const brokenData1 = JSON.parse(data1);

const data2 = fs.readFileSync('./JSON/broken_database_2.json', 'utf-8');
const brokenData2 = JSON.parse(data2);

brokenData1.forEach(carro => {
    carro.nome = carro.nome.replace(/æ/g,"a").replace(/ø/g,"o");
    carro.vendas = parseInt(carro.vendas);
    console.log(carro);
});

brokenData2.forEach(carro => {
    carro.marca = carro.marca.replace(/æ/g,"a").replace(/ø/g,"o");
});

fs.writeFileSync('./JSON/fixed_database_1.json', JSON.stringify(brokenData1, null, 2), 'utf-8');  

fs.writeFileSync('./JSON/fixed_database_2.json', JSON.stringify(brokenData2, null, 2), 'utf-8');  
