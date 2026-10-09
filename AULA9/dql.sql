
--AULA 09 - DQL (DATA QUERY LANGUAGE) - LINGUAGEM DE CONSULTA DE DADOS

--EX 1:SELECT SIMPLES

--SELECT coluna 
--FROM tabela;
SELECT * FROM cliente;

--CONSULTA TODAS AS COLUNAS NA TABELA
SELECT nome, telefone FROM cliente;
SELECT nome, ativo FROM produto ;

--CONSULTAR DADOS COM VÁRIAS COLUNAS

-- EX 2: CONSULTANDO E PERSONALIZANDO A CONSULTA

SELECT nome AS Nome_Cliente, telefone AS Contato_Cliente
FROM cliente;

SELECT nome, preço , preco * 2.00 AS preco_ajustado
FROM produto;

--EX 3: DISTINCT - ELIMINAR REPETIÇÕES

SELECT DISTINCT cidade 
FROM  cliente;
SELECT cidade FROM cliente;
--COM DISTINCT CADAD RESULTADO É APRESENTADO UMA UNICA VES
--SEM DISTINCT CADA RESULTADO E APRESENTADO VARIAS VEZES

--EX 4: USO DE WHERE - FILTRO DE REGISTRO 
-- INSERIR CONDIÇÕES E UTILIZAR OPERADORES DE COMPARAÇÃO
-- = IGUAL 
-- <> OU ! = DIFERENTE
-- > MAIOR QUE 
-- < MENOR QUE 
-- <= MENOR OU IGUAL
SELECT nome , preco FROM produto WHERE preco > 10;

--CONSULTAR PREÇOS QUE POSSUEM VALOR ACIMA DE 10.00 REAIS 
SELECT nome , preco, ativo FROM produto WHERE ativo = FALSE;
--CONSULTAR PRODUTOS ATIVOS OU INATIVOS 

SELECT id_pedido , data_pedido , valor_total
FROM pedido WHERE valor_total >= 25.00;
--CONSULTAR VALOR TOTAL DE PRODUTOS ACIMA DE 25.00 REAIS 

-- EX 5: USO DE AND , OR E NOT 
--AND - TODAS AS CONDIÇÕES VERDADEIRAS
SELECT nome , preco FROM produto
WHERE preco >= 8.00 AND preco <= 25.00;

-- OR UMA DAS CONDIÇÕES PRECISA SER VERDADEIRA
SELECT nome , cidade FROM cliente
WHERE cidade = 'Limeira' OR cidade = 'Campinas'

--NOT CRIAR UMA CONDIÇÃO DE NEGAÇÃO 
SELECT nome , cidade FROM cliente
WHERE NOT cidade = "Limeira";

-- AND E OR JUNTOS PRECISAMOS INSERIRI OS ()
SELECT nome , cidade, ativo FROM cliente
WHERE ativo = TRUE AND (cidade = 'Limeira' OR cidade= 'Piracicaba')

-- EX 6: BETWEEN - PESQUISAR POR INTERVALOS
-- LIMITE INICIAL E FINAL

SELECT nome, preco FROM produto 
WHERE preco  BETWEEN 8.00 AND 15.00;
--CONSULTAR POR INTERVALOS DE VALORES

SELECT id_pedido, data_pedido, valor_total
FROM pedido
WHERE data_pedido BETWEEN '2026-09-01 00:00:00 ' AND '2026-09-30 23:59:59';

--EX 7: IN- MUITAS POSSIBILIDADES

SELECT nome , cidade FROM cliente
WHERE cidade IN ('Limeira','Piracicaba','Americanas');

SELECT nome, cidade FROM cliente
WHERE cidade NOT IN ('Limeira', 'Piracicaba') ;

-- EX 8: LIKE - PESQUISA POR TEXTO
--CORINGAS 
-- % VÁRIOS CARACTERES
-- APENAS UM CARACTER

SELECT nome FROM produto
WHERE nome LIKE 'Café$';
--CONSULTAR PELA PALAVRA QUE DESEJA E QUAL COMEÇA

SELECT nome FROM produto
WHERE nome LIKE '%Chocolate%';

--CONSULTA PELA PALAVRA QUE CONTEM CHOCOLATE

SELECT nome FROM cliente
WHERE nome LIKE '%Silva';

SELECT nome FROM PRODUTO 
WHERE nome LIKE '%o_o%'

-- EX 9: NULL - AUSENCIA DE VALOR 
SELECT nome , telfone FROM cliente
WHERE telefone IS NULL;

SELECT nome , telefone FROM cliente
WHERE telefone IS NOT NULL;
 
 -- EX 10: ORDEM BY - ORDENAR RESULTADOS  
 -- ASC É CRESCENTE 
 -- DESC É DESCRESENTE

 SELECT nome , preco FROM produto
 WHERE BY preco ASC ;

 SELECT nome , preco FROM produto 
ORDER BY preco DESC;
SELECT nome , preco FROM produto
ORDER BY nome ASC , preco DESC;

SELECT cidade, nome FROM cliente
ORDER BY cidade ASC, nome DESC;
-- ORDENAR POR MAIS DE UMA COLUNA 

--EX 11: LIMIT DETERMINAR UMA QUANTIDADE DE LINHAS

SELECT nome, preco 
FROM produto 
ORDER BY preco DESC
LIMIT 10;

SELECT nome , preco A
FROM produto
ORDER BY nome 
LIMIT 10 OFFSET 5;

-- EX 12: CÁLCULOS EM COLUNAS 
SELECT nome, preco , preco * 1.30 AS Preco_Reajuste
FROM produto;

SELECT id_item , quantidade, preco_unitario, quantidade* preco_unitario AS
Subtotal FROM item_pedido;


--EX 13: FUNÇÕES 
--TEXTOS
SELECT UPPER(nome) AS NOME_M , LOWER(cidade) AS cidade_m
FROM cliente;
--USO DE MAIUSCULO E MINUSCULOS
SELECT CONCAT(nome,'--',cidade) AS Clientes_Cidades
FROM clientes;

--NUMEROS 
SELECT nome , preco , ROUND(preco*0.90 , 2 ) AS Preco_Desconto
FROM produto;

--DATAS
SELECT id_pedido, data_pedido , valor_total, DATE(data_pedido) AS DATAS, MONTH
(data_pedido) AS MÊS, YEAR(data_pedido) AS ANO, DAY(data_pedido) AS DIAS
TIME (data_pedido) AS Horario
FROM pedido;

--SUBSTITUIR O NULL NO RESULTADO COM COALESCE
SELECT nome, COALESCE(telefone, 'Não Possui Telefone') AS Telefone
FROM cliente;

--EX 14: FUNÇÕES DE AGREGAÇÃO
--COUNT= CONTAR UMA QUANTIDADE
--SUM = SOMAR VALORES 
--AVG = CALCULAR MEDIA
--MIN = MINIMO VALOR
-- MAX =  MAXIMO VALOR
SELECT COUNT(*) AS TOTAL_CLIENTE 
FROM cliente ;
--QUANTOS CLIENTES EXISTEM NA TABELA 

SELECT AVG (preco) AS Preco_Médio_Produtos
FROM produto;
--PREÇO MÉDIO DOS PRODUTOS

SELECT ROUND(MIN(precos),2) AS preco_baixo,
  ROUND(MAX(preco),2) AS precos_altos
 ROUND(AVG(preco),2) AS meida_preco
FROM produto;
--RESUMO DE PREÇOS

SELECT SUM(valor_total) AS FATURAMNETO
FROM pedido
WHERE status = 'PREPARANDO';
--TOTAL DE PEDIDOS COM CRITÉRIOS

--EX 15: GROUP BY - AGRUPAR DADOS 
SELECT cidade, COUNT (*) AS QTDE_CLIENTES
FROM cliente
GROUP BY cidade;
--QUANTOS CLIENTES TENHO EM CADA CIDADE

SELECT id_categoria , COUNT(*) AS QTDE_PRODUTOS
FROM produto
GROUP BY id_categoria;
--QUANTIDADE DE PRODUTOS POR CATEGORIA

SELECT