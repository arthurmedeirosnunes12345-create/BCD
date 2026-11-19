-- Active: 1794504478336@@127.0.0.1@3306@smartcoffee_procedures_arthur
USE smartcoffee_procedures_arhur;

-- AULA 13 - ATIVIDADE STORED PROCEDURES
-- Aluno: (Arthur de Medeiros Nunes)
-- Turma: (2 Devis A)

-- 1. listar_clientes_ativos()

DELIMITER $$
CREATE PROCEDURE listar_clientes_ativos()
BEGIN
    SELECT * FROM clientes WHERE ativo = 1;
END $$
DELIMITER ;

-- 2. buscar_produto_por_nome(IN p_busca VARCHAR(100))

DELIMITER $$
CREATE PROCEDURE buscar_produto_por_nome(IN p_busca VARCHAR(100))
BEGIN
    SELECT * FROM produtos 
    WHERE nome LIKE CONCAT('%', p_busca, '%');
END 
DELIMITER ;


-- 3. produtos_por_categoria(IN p_id_categoria INT)

DELIMITER $$
CREATE PROCEDURE produtos_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT * FROM produtos                                                                                                             
    WHERE id_categoria = p_id_categoria;
END $$
DELIMITER ;


-- 4. total_clientes(OUT p_total INT)

DELIMITER $$
CREATE PROCEDURE total_clientes(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM clientes;
END $$
DELIMITER ;


-- 5. consultar_estoque(IN p_id_produto INT) usando variável local
DELIMITER $$
CREATE PROCEDURE consultar_estoque(IN p_id_produto INT)
BEGIN
    DECLARE v_estoque INT;
    
    SELECT estoque INTO v_estoque 
    FROM produtos 
    WHERE id_produto = p_id_produto;
    
    SELECT p_id_produto AS ID_Produto, v_estoque AS Quantidade_Em_Estoque;
END $$
DELIMITER ;

-- Teste:
-- CALL consultar_estoque(1);


-- 6. classificar estoque: 0 SEM ESTOQUE / <=5 BAIXO / >5 NORMAL

DELIMITER $$
CREATE PROCEDURE classificar_estoque(IN p_id_produto INT)
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_status VARCHAR(20);
    
    SELECT estoque INTO v_estoque 
    FROM produtos 
    WHERE id_produto = p_id_produto;
    
    IF v_estoque IS NULL THEN
        SET v_status = 'PRODUTO NÃO ENCONTRADO';
    ELSEIF v_estoque = 0 THEN
        SET v_status = 'SEM ESTOQUE';
    ELSEIF v_estoque <= 5 THEN
        SET v_status = 'BAIXO';
    ELSE
        SET v_status = 'NORMAL';
    END IF;
    
    SELECT p_id_produto AS ID_Produto, v_estoque AS Estoque, v_status AS Classificacao;
END $$
DELIMITER ;

-- Teste:
-- CALL classificar_estoque(1);


-- 7. cadastrar_cliente(...) com três parâmetros IN

DELIMITER $$
CREATE PROCEDURE cadastrar_cliente(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefone VARCHAR(20)
)
BEGIN
    INSERT INTO clientes (nome, email, telefone, ativo) 
    VALUES (p_nome, p_email, p_telefone, 1);
END $$
DELIMITER ;

-- Teste:
-- CALL cadastrar_cliente('Ana Silva', 'ana.silva@email.com', '11999998888');


-- 8. alterar_preco(...) impedindo valor <= 0

DELIMITER $$
CREATE PROCEDURE alterar_preco(
    IN p_id_produto INT,
    IN p_novo_preco DECIMAL(10,2)
)
BEGIN
    IF p_novo_preco <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: O novo preço deve ser maior que zero.';
    ELSE
        UPDATE produtos 
        SET preco = p_novo_preco 
        WHERE id_produto = p_id_produto;
    END IF;
END $$
DELIMITER ;

-- Teste:
-- CALL alterar_preco(1, 15.50);


-- 9 e 10. criar_pedido(IN p_id_cliente INT, OUT p_id_pedido INT) 
--         devolvendo ID com LAST_INSERT_ID()

DELIMITER $$
CREATE PROCEDURE criar_pedido(
    IN p_id_cliente INT, 
    OUT p_id_pedido INT
)
BEGIN
    INSERT INTO pedidos (id_cliente, data_pedido, status) 
    VALUES (p_id_cliente, NOW(), 'ABERTO');
    
    SET p_id_pedido = LAST_INSERT_ID();
END $$
DELIMITER ;


-- 11. adicionar_item_pedido(...) buscando o preço atual

DELIMITER $$
CREATE PROCEDURE adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco_atual DECIMAL(10,2);
    
    -- Busca o preço atual cadastrado na tabela de produtos
    SELECT preco INTO v_preco_atual 
    FROM produtos 
    WHERE id_produto = p_id_produto;
    
    -- Insere o item no pedido congelando o preço do momento da compra
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES (p_id_pedido, p_id_produto, p_quantidade, v_preco_atual);
END $$
DELIMITER ;

-- Teste:
-- CALL adicionar_item_pedido(@novo_pedido, 1, 2);


-- 12. Faça uma chamada inválida e explique o resultado.

CALL alterar_preco(1, -10.00);



-- 13. Use SHOW CREATE PROCEDURE.

 SHOW CREATE PROCEDURE classificar_estoque;


-- 14. Remova uma procedure com DROP PROCEDURE IF EXISTS e recrie-a.

DROP PROCEDURE IF EXISTS listar_clientes_ativos;

DELIMITER $$
CREATE PROCEDURE listar_clientes_ativos()
BEGIN
    -- Recriada ordenando alfabeticamente pelo nome do cliente
    SELECT id_cliente, nome, email, telefone 
    FROM clientes 
    WHERE ativo = 1 
    ORDER BY nome ASC;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE registrar_venda_item(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_estoque_atual INT;
    DECLARE v_preco_atual DECIMAL(10,2);
    
    -- 1. Busca estoque e preço atuais do produto
    SELECT estoque, preco INTO v_estoque_atual, v_preco_atual
    FROM produtos
    WHERE id_produto = p_id_produto;
    
    -- 2. Valida se o produto existe e se há saldo suficiente
    IF v_estoque_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Produto não encontrado no catálogo.';
    ELSEIF p_quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: A quantidade solicitada deve ser maior que zero.';
    ELSEIF v_estoque_atual < p_quantidade THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Estoque insuficiente para realizar a venda.';
    ELSE
        -- 3. Realiza as alterações no banco (Insere o item e desconta do estoque)
        INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
        VALUES (p_id_pedido, p_id_produto, p_quantidade, v_preco_atual);
        
        UPDATE produtos 
        SET estoque = estoque - p_quantidade 
        WHERE id_produto = p_id_produto;
    END IF;
END $$
DELIMITER ;

