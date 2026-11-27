CREATE DATABASE gestao_rancho CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestao_rancho;

CREATE TABLE setor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE funcionario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
	fk_setor BIGINT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    chave_pix TEXT,
	status VARCHAR(10) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ajuda_transporte BOOLEAN,
	CONSTRAINT uq_funcionario_email UNIQUE (email),
	CONSTRAINT fk_funcionario_setor
		FOREIGN KEY (fk_setor)
		REFERENCES setor(id)
);

CREATE TABLE endereco_funcionario (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fk_funcionario BIGINT NOT NULL,
	cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    distancia_km DECIMAL(8,2),
    CONSTRAINT fk_endereco_funcionario
        FOREIGN KEY (fk_funcionario)
        REFERENCES funcionario(id),
    CONSTRAINT uq_endereco_funcionario
        UNIQUE (fk_funcionario)
);

CREATE TABLE usuario_sistema (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'GESTOR',
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    token_version INT NOT NULL DEFAULT 0
);

CREATE TABLE escala (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    data_escala DATE NOT NULL,
	turno ENUM('DIA', 'NOITE') NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT uq_escala_data_turno UNIQUE (data_escala, turno)
);

CREATE TABLE escala_funcionarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fk_escala BIGINT NOT NULL,
    fk_funcionario BIGINT NOT NULL,
    UNIQUE (fk_escala, fk_funcionario),
    CONSTRAINT fk_escala_funcionario_escala
        FOREIGN KEY (fk_escala)
        REFERENCES escala(id),
    CONSTRAINT fk_escala_funcionario_funcionario
        FOREIGN KEY (fk_funcionario)
        REFERENCES funcionario(id)
);

CREATE TABLE avaliacoes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fk_funcionario BIGINT NOT NULL,
    avaliador_id BIGINT NULL,
    avaliador_nome VARCHAR(255) NULL,
    nota INT,
    descricao VARCHAR(255),
	criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email_enviado_em DATETIME(6),
    email_tentativas INT, 
    email_ultimo_erro VARCHAR(255),
    FOREIGN KEY (fk_funcionario) REFERENCES funcionario(id),
    CONSTRAINT fk_avaliacoes_avaliador
    FOREIGN KEY (avaliador_id) REFERENCES usuario_sistema(id)
    ON DELETE SET NULL
);

CREATE TABLE pagamento (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fk_funcionario BIGINT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    data_pagamento DATE NULL,
    forma_pagamento ENUM('DINHEIRO', 'PIX') NULL,
    status ENUM('PENDENTE', 'PAGO') NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT fk_pagamento_funcionario
        FOREIGN KEY (fk_funcionario)
        REFERENCES funcionario(id)
);

CREATE TABLE pagamento_escalas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fk_pagamento BIGINT NOT NULL,
    fk_escala_funcionario BIGINT NOT NULL,
    CONSTRAINT fk_pagamento_escalas_pagamento
        FOREIGN KEY (fk_pagamento)
        REFERENCES pagamento(id),
    CONSTRAINT fk_pagamento_escalas_escala
        FOREIGN KEY (fk_escala_funcionario)
        REFERENCES escala_funcionarios(id),
    CONSTRAINT uq_pagamento_escala
        UNIQUE (fk_escala_funcionario)
);

-- --------------------------------------------------------------------------------------------------------
-- INSERTS & SELECTS
-- --------------------------------------------------------------------------------------------------------
INSERT INTO usuario_sistema (nome, role, email, senha_hash) VALUES
('Ryan Patric', 'GESTOR', 'ryan.servilha@sptech.school', 'rancho123');

INSERT INTO setor (nome) VALUES
('Salão'),
('Cozinha'),
('Atividades');

-- Inserindo funcionários da Cozinha
INSERT INTO funcionario
(fk_setor, nome, email, telefone, valor_diaria, chave_pix, status, ajuda_transporte)
VALUES
(1, 'Carlos Henrique', 'carlos@gmail.com', '11987654321', 150.00, '11987654321', 'ATIVO', TRUE),
(1, 'Marcos Oliveira', 'marcos@gmail.com', '11987654322', 140.00, 'marcos@email.com', 'ATIVO', FALSE),
(1, 'João Pedro', 'joao@gmail.com', '11987654323', 160.00, '11987654323', 'ATIVO', TRUE),
(1, 'Rafael Santos', 'rafael@gmail.com', '11987654324', 145.00, '11987654324', 'ATIVO', TRUE),
(1, 'Lucas Ferreira', 'lucas@gmail.com', '11987654325', 135.00, '11987654325', 'ATIVO', FALSE);

-- Inserindo funcionários do Salão
INSERT INTO funcionario
(fk_setor, nome, email, telefone, valor_diaria, chave_pix, status, ajuda_transporte)
VALUES
(2, 'Gabriel Souza', 'gabriel@gmail.com', '11987654326', 130.00, '11987654326', 'ATIVO', TRUE),
(2, 'Matheus Lima', 'matheus@gmail.com', '11987654327', 125.00, 'matheus@email.com', 'ATIVO', FALSE),
(2, 'André Costa', 'andre@gmail.com', '11987654328', 140.00, '11987654328', 'ATIVO', TRUE),
(2, 'Felipe Almeida', 'felipe@gmail.com', '11987654329', 135.00, '11987654329', 'ATIVO', TRUE),
(2, 'Bruno Martins', 'bruno@gmail.com', '11987654330', 120.00, '11987654330', 'ATIVO', FALSE);

-- Inserindo funcionários das Atividades
INSERT INTO funcionario
(fk_setor, nome, email, telefone, valor_diaria, chave_pix, status, ajuda_transporte)
VALUES
(3, 'Diego Rodrigues', 'diego@gmail.com', '11987654331', 110.00, '11987654331', 'ATIVO', TRUE),
(3, 'Thiago Barbosa', 'thiago@gmail.com', '11987654332', 115.00, 'thiago@email.com', 'ATIVO', FALSE),
(3, 'Vinicius Rocha', 'vinicius@gmail.com', '11987654333', 125.00, '11987654333', 'ATIVO', TRUE),
(3, 'Gustavo Mendes', 'gustavo@gmail.com', '11987654334', 120.00, 'gustavo@email.com', 'ATIVO', TRUE),
(3, 'Eduardo Nunes', 'eduardo@gmail.com', '11987654335', 105.00, '11987654335', 'ATIVO', FALSE);

INSERT INTO endereco_funcionario
(fk_funcionario, cep, logradouro, numero, bairro, cidade, estado)
VALUES
-- SALÃO
(1, '09710-000', 'Rua Marechal Deodoro', '120', 'Centro', 'São Bernardo do Campo', 'SP'),
(2, '09720-000', 'Avenida Brigadeiro Faria Lima', '250', 'Centro', 'São Bernardo do Campo', 'SP'),
(3, '09715-000', 'Rua João Pessoa', '85', 'Centro', 'São Bernardo do Campo', 'SP'),
(4, '09710-140', 'Rua São Bernardo', '310', 'Centro', 'São Bernardo do Campo', 'SP'),
(5, '09725-000', 'Rua Jurubatuba', '450', 'Centro', 'São Bernardo do Campo', 'SP'),
-- COZINHA
(6, '09750-000', 'Avenida Senador Vergueiro', '600', 'Centro', 'São Bernardo do Campo', 'SP'),
(7, '09710-090', 'Rua Rio Branco', '145', 'Centro', 'São Bernardo do Campo', 'SP'),
(8, '09715-120', 'Rua Santos Dumont', '220', 'Centro', 'São Bernardo do Campo', 'SP'),
(9, '09720-440', 'Rua Frei Gaspar', '95', 'Centro', 'São Bernardo do Campo', 'SP'),
(10, '09725-440', 'Avenida Senador Flaquer', '380', 'Centro', 'São Bernardo do Campo', 'SP'),

-- ATIVIDADES
(11, '09720-140', 'Rua Italo Setti', '170', 'Centro', 'São Bernardo do Campo', 'SP'),	
(12, '09715-090', 'Rua Silva Jardim', '260', 'Centro', 'São Bernardo do Campo', 'SP'),
(13, '09720-110', 'Rua Newton Prado', '115', 'Centro', 'São Bernardo do Campo', 'SP'),
(14, '09715-220', 'Rua São Pedro', '320', 'Centro', 'São Bernardo do Campo', 'SP'),
(15, '09720-510', 'Rua das Acácias', '75', 'Centro', 'São Bernardo do Campo', 'SP');
