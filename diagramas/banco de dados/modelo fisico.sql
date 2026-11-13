
-- =====================================================
-- CUPCAKE STORE
-- MODELO FISICO DO BANCO DE DADOS
-- SGBD: MySQL 8.0
-- =====================================================

CREATE DATABASE IF NOT EXISTS cupcake_store
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE cupcake_store;

-- 1. TABELA USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(30) NOT NULL DEFAULT 'CLIENTE'
) ENGINE=InnoDB;

-- 2. TABELA ENDERECO
CREATE TABLE ENDERECO (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    cep VARCHAR(10) NOT NULL,

    CONSTRAINT fk_endereco_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO(id_usuario)
) ENGINE=InnoDB;

-- 3. TABELA CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
) ENGINE=InnoDB;

-- 4. TABELA PRODUTO
CREATE TABLE PRODUTO (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_produto_preco
    CHECK (preco >= 0),

    CONSTRAINT fk_produto_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES CATEGORIA(id_categoria)
) ENGINE=InnoDB;

-- 5. TABELA ESTOQUE
CREATE TABLE ESTOQUE (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL UNIQUE,
    quantidade INT NOT NULL DEFAULT 0,

    CONSTRAINT chk_estoque_quantidade
    CHECK (quantidade >= 0),

    CONSTRAINT fk_estoque_produto
    FOREIGN KEY (id_produto)
    REFERENCES PRODUTO(id_produto)
) ENGINE=InnoDB;

-- 6. TABELA CARRINHO
CREATE TABLE CARRINHO (
    id_carrinho INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_carrinho_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO(id_usuario)
) ENGINE=InnoDB;

-- 7. TABELA PEDIDO
CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_endereco INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'AGUARDANDO',
    valor_total DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_pedido_valor
    CHECK (valor_total >= 0),

    CONSTRAINT fk_pedido_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES USUARIO(id_usuario),

    CONSTRAINT fk_pedido_endereco
    FOREIGN KEY (id_endereco)
    REFERENCES ENDERECO(id_endereco)
) ENGINE=InnoDB;

-- 8. TABELA ITEM_CARRINHO
CREATE TABLE ITEM_CARRINHO (
    id_item_carrinho INT AUTO_INCREMENT PRIMARY KEY,
    id_carrinho INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_item_carrinho_quantidade
    CHECK (quantidade > 0),

    CONSTRAINT chk_item_carrinho_preco
    CHECK (preco_unitario >= 0),

    CONSTRAINT fk_item_carrinho_carrinho
    FOREIGN KEY (id_carrinho)
    REFERENCES CARRINHO(id_carrinho),

    CONSTRAINT fk_item_carrinho_produto
    FOREIGN KEY (id_produto)
    REFERENCES PRODUTO(id_produto),

    CONSTRAINT uk_carrinho_produto
    UNIQUE (id_carrinho, id_produto)
) ENGINE=InnoDB;

-- 9. TABELA ITEM_PEDIDO
CREATE TABLE ITEM_PEDIDO (
    id_item_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_item_pedido_quantidade
    CHECK (quantidade > 0),

    CONSTRAINT chk_item_pedido_preco
    CHECK (preco_unitario >= 0),

    CONSTRAINT fk_item_pedido_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES PEDIDO(id_pedido),

    CONSTRAINT fk_item_pedido_produto
    FOREIGN KEY (id_produto)
    REFERENCES PRODUTO(id_produto)
) ENGINE=InnoDB;

-- =====================================================
-- FIM DO MODELO FISICO - CUPCAKE STORE
-- =====================================================

