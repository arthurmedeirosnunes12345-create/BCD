-- Active: 1788519230432@@127.0.0.1@3306@sesi_cr_ta
-- Geração de Modelo físico - MySQL

CREATE DATABASE IF NOT EXISTS SESI_CR_TA;
USE SESI_CR_TA;

CREATE TABLE Produto (
    Id_Produto INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Produto VARCHAR(60) NOT NULL
);

CREATE TABLE Fornecedor (
    Id_Fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Razao_Social VARCHAR(100) NOT NULL
);

CREATE TABLE Pedido (
    Id_Pedido INT AUTO_INCREMENT PRIMARY KEY,
    Data_Pedido DATETIME NOT NULL
);

CREATE TABLE Cliente (
    Id_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Cliente VARCHAR(100) NOT NULL,
    Id_Pedido INT,
    CPF VARCHAR(14) NOT NULL UNIQUE
);

CREATE TABLE ESTOQUE (
    Id_Estoque INT AUTO_INCREMENT PRIMARY KEY,
    Id_Pedido INT NOT NULL,
    Data_Pedido DATETIME NOT NULL,
    Id_Cliente INT NOT NULL
);

CREATE TABLE Relacao_Produto_Fornecedor (
    Id_Produto INT NOT NULL,
    Id_Fornecedor INT NOT NULL,
    Id_Item INT NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Id_Produto, Id_Fornecedor, Id_Item)
);
ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente_Pedido 
FOREIGN KEY (Id_Pedido) REFERENCES Pedido (Id_Pedido);

ALTER TABLE Relacao_Produto_Fornecedor ADD CONSTRAINT FK_Relacao_Produto 
FOREIGN KEY (Id_Produto) REFERENCES Produto(Id_Produto);

ALTER TABLE Relacao_Produto_Fornecedor ADD CONSTRAINT FK_Relacao_Fornecedor 
FOREIGN KEY (Id_Fornecedor) REFERENCES Fornecedor(Id_Fornecedor);

 --DESAFIOS
 --QUESTÃO 1
 --CATEGORIA --POSSUI ---PRODUTO
  --RESPOSTA : 1,N E 1,1

  --QUESTÃO 2 
  --FUNCIONÁRIO --REGISTRA --PEDIDOS
  --RESPOSTA: 1,N E 1,1

  --QUESTÃO 3
  -- FORNECEDOR -- FORNECE -- PRODUTO
  --REPOSTA: 1,N E 1,N

  --QUESTÃO 4 
  -- CLIENTE ---RESERVA --MESA
  ---RESPOSTA: 0,N E 1,1

  --QUESTÃO 5 
  --CLIENTE --POSUI -- ITEM_PEDIDO
  --RESPOSTA: 1,N E 1,1