-- Active: 1788519230432@@127.0.0.1@3306@smartcoffee_dml_monyke
-- -- ============================================================
-- -- AULA 09 - ATIVIDADE PRÁTICA DE DQL
-- -- Nome: _______________________________________________
-- -- Turma: ______________________ Data: _________________
-- -- Base: smartcoffee_dql
-- -- ============================================================
-- USE smartcoffee_dql;

-- -- PARTE A - AQUECIMENTO

-- -- 1. Liste todos os clientes cadastrados.
-- RESPOSTA:
SELECT * FROM cliente;

-- -- 2. Exiba apenas nome, cidade e e-mail dos clientes.
-- RESPOSTA:

 SELECT nome, cidade, email FROM cliente;

-- -- 3. Liste os nomes das cidades sem repetir valores.
-- RESPOSTA:
SELECT DISTINCT cidade 
FROM  cliente;

-- -- 4. Liste todos os produtos em ordem crescente de preço.
-- RESPOSTA:
 SELECT nome , preco FROM produto 
ORDER BY preco ASC;


-- -- 5. Mostre apenas os 5 produtos mais caros.
-- RESPOSTA:
SELECT nome , preco FROM produto
OR preco DESC LIMIT 5;

-- -- PARTE B - FILTROS

-- -- 6. Liste os produtos com preço entre R$ 8,00 e R$ 15,00.
-- RESPOSTA:
SELECT nome, preco FROM produto 
WHERE preco  BETWEEN 8.00 AND 15.00;
-- -- 7. Liste os clientes das cidades Limeira ou Americana.
-- RESPOSTA:
SELECT nome, cidade FROM cliente
WHERE cidade NOT IN ('Limeira', 'Americana') ;
-- -- 8. Localize os produtos cujo nome contém a palavra “Café”.
-- RESPOSTA:
SELECT nome FROM produto
WHERE nome LIKE '$Café$';
-- -- 9. Liste os clientes que não informaram telefone.
-- RESPOSTA:
SELECT nome , telefone FROM cliente
WHERE telefone IS NULL;

-- -- 10. Mostre os pedidos FINALIZADOS com valor acima de R$ 20,00,
--     do maior para o menor valor.
-- RESPOSTA:
SELECT id_pedido , data_pedido , valor_total
FROM pedido WHERE STATUS ='PREPARANDO' AND valor_total > 
20.00 ORDER BY valor_total DESC;

-- PARTE C - CÁLCULOS E AGRUPAMENTOS

-- 11. Informe quantos produtos estão cadastrados.
-- RESPOSTA:
SELECT COUNT (*) AS total_produto FROM produto;
-- 12. Mostre menor preço, maior preço e preço médio dos produtos.
-- RESPOSTA:
SELECT ROUND(MIN(preco),2) AS Preco_baixo
       ROUND(MAX(preco),2) AS Preco_alto
       ROUND(AVG(preco),2) AS Media_preco
    FROM produto;
-- 13. Informe quantos clientes existem em cada cidade.
-- RESPOSTA:
SELECT cidade, COUNT (*) AS QTDE_CLIENTES
FROM cliente
GROUP BY cidade;

-- 14. Mostre somente as cidades que possuem dois ou mais clientes.
SELECT cidade, COUNT(*) AS QTDE_CLIENTES
FROM cliente
GROUP BY cidade
HAVING COUNT (*) >= 2

-- 15. Calcule o faturamento total considerando apenas pedidos FINALIZADOS.

SELECT SUM(valor_total) AS faturamento_total
FROM pedido
WHERE STATUS = 'FINALIZADO';