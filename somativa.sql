-- Active: 1794504478336@@127.0.0.1@3306@mysql
--Criar tabekas - Usuários,livro,Emprestimo,Categoria,Forncecedor

DROP DATABASE IF EXISTS retrogame_recuperacao;
CREATE DATABASE retrogame_recuperacao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE retrogame_recuperacao;

-- 2. Tabela CLIENTE 
CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- 3. Tabelas PLATAFORMA e CATEGORIA 
CREATE TABLE PLATAFORMA (
    id_plataforma INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE CATEGORIA (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(80) NOT NULL UNIQUE
);


-- 4. Tabela JOGO 
CREATE TABLE JOGO (
    id_jogo INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    codigo VARCHAR(15) NOT NULL UNIQUE,
    ano_lancamento INT NOT NULL,
    quantidade_disponivel INT DEFAULT 0 CHECK (quantidade_disponivel >= 0),
    id_plataforma INT NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_jogo_plataforma FOREIGN KEY (id_plataforma) 
        REFERENCES PLATAFORMA(id_plataforma) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_jogo_categoria FOREIGN KEY (id_categoria) 
        REFERENCES CATEGORIA(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 5. Tabela LOCACAO 
CREATE TABLE LOCACAO (
    id_locacao INT PRIMARY KEY AUTO_INCREMENT,
    data_retirada DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATE NULL,
    status_locacao VARCHAR(20) DEFAULT 'ABERTA' 
        CHECK (status_locacao IN ('ABERTA', 'DEVOLVIDA', 'ATRASADA')),
    id_cliente INT NOT NULL,
    id_jogo INT NOT NULL,
    -- ON DELETE RESTRICT protege o histórico contra exclusão de clientes ou jogos vinculados
    CONSTRAINT fk_locacao_cliente FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_locacao_jogo FOREIGN KEY (id_jogo) 
        REFERENCES JOGO(id_jogo) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 6. ALTER TABLE na tabela JOGO
ALTER TABLE JOGO ADD COLUMN desenvolvedora VARCHAR(100);


-- 7. Inserir clientes (pelo menos 4, um com telefone NULL)
INSERT INTO CLIENTE (nome, email, telefone) VALUES
('Lucas Mendes', 'lucas.mendes@email.com', '(19) 99123-4567'),
('Mariana Costa', 'mariana.costa@email.com', NULL), -- Telefone NULL conforme solicitado
('Rafael Oliveira', 'rafael.oliveira@email.com', '(19) 98234-5678'),
('Beatriz Santos', 'beatriz.santos@email.com', '(19) 99345-6789');

-- 8. Inserir plataformas, categorias e jogos
INSERT INTO PLATAFORMA (nome) VALUES
('Super Nintendo (SNES)'),
('PlayStation 1'),
('PlayStation 2'),
('Mega Drive');

INSERT INTO CATEGORIA (descricao) VALUES
('Plataforma'),
('RPG'),
('Ação e Aventura'),
('Corrida');

INSERT INTO JOGO (titulo, codigo, ano_lancamento, quantidade_disponivel, id_plataforma, id_categoria, desenvolvedora) VALUES
('Super Mario World', 'SNES-001', 1990, 5, 1, 1, 'Nintendo'),
('Chrono Trigger', 'SNES-002', 1995, 2, 1, 2, 'Square'),
('Final Fantasy VII', 'PS1-001', 1997, 3, 2, 2, 'Square'),
('Shadow of the Colossus', 'PS2-001', 2005, 4, 3, 3, 'Team Ico'),
('Sonic the Hedgehog 2', 'MD-001', 1992, 1, 4, 1, 'Sega'),
('God of War', 'PS2-002', 2005, 3, 3, 3, 'Santa Monica Studio');

-- 9. Inserir locações 
INSERT INTO LOCACAO (data_prevista, status_locacao, id_cliente, id_jogo) VALUES
('2026-11-20', 'ABERTA', 1, 1), 
('2026-11-21', 'ABERTA', 2, 3), 
('2026-11-22', 'ABERTA', 1, 4); 

UPDATE JOGO SET quantidade_disponivel = quantidade_disponivel - 1 WHERE id_jogo IN (1, 3, 4);


SELECT id_jogo, titulo, quantidade_disponivel FROM JOGO;

-- 10. SELECT + UPDATE 
SELECT id_cliente, nome, telefone FROM CLIENTE WHERE id_cliente = 2;

UPDATE CLIENTE 
SET telefone = '(19) 99999-0000' 
WHERE id_cliente = 2;

SELECT id_cliente, nome, telefone FROM CLIENTE WHERE id_cliente = 2;

-- 11. UPDATE em lote 
UPDATE JOGO 
SET quantidade_disponivel = quantidade_disponivel + 2 
WHERE ano_lancamento >= 2000;

SELECT titulo, ano_lancamento, quantidade_disponivel FROM JOGO WHERE ano_lancamento >= 2000;

-- 12. DELETE e proteção do histórico
-- 12a. Criando e excluindo um cliente SEM locações (sucesso esperado)
INSERT INTO CLIENTE (nome, email, telefone) VALUES ('Cliente Temporario', 'temp@email.com', NULL);
DELETE FROM CLIENTE WHERE email = 'temp@email.com';


-- 13. SELECT básico
SELECT titulo, ano_lancamento, quantidade_disponivel 
FROM JOGO;

-- 14. WHERE + ORDER BY 
SELECT titulo, quantidade_disponivel 
FROM JOGO 
WHERE quantidade_disponivel > 2 
ORDER BY quantidade_disponivel DESC;

-- 15. LIKE 
SELECT id_jogo, titulo, ano_lancamento 
FROM JOGO 
WHERE titulo LIKE '%Mario%';

-- 16. BETWEEN (jogos lançados entre 1990 e 2005)
SELECT titulo, ano_lancamento 
FROM JOGO 
WHERE ano_lancamento BETWEEN 1990 AND 2005;
