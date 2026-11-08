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
    telefone VARCHAR(20) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    chave_pix TEXT,
	status VARCHAR(10) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ajuda_transporte BOOLEAN,
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
    senha_hash VARCHAR(255) NOT NULL
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
    nota INT,
    descricao VARCHAR(255),
    FOREIGN KEY (fk_funcionario) REFERENCES funcionario(id)
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
('Ryan Patric', 'GERENTE', 'ryan.servilha@sptech.school', 'rancho123');

-- Inserindo setores
INSERT INTO setor (nome) VALUES
('Salão'),
('Cozinha'),
('Atividades');

-- Inserindo funcionários da Cozinha
INSERT INTO funcionario(fk_setor, nome, telefone, valor_diaria, chave_pix, status, ajuda_transporte) VALUES
(1, 'Carlos Henrique', '11987654321', 150.00, '11987654321', 'ATIVO', TRUE),
(1, 'Marcos Oliveira', '11987654322', 140.00, 'marcos@email.com', 'ATIVO', FALSE),
(1, 'João Pedro', '11987654323', 160.00, '11987654323', 'ATIVO', TRUE),
(1, 'Rafael Santos', '11987654324', 145.00, 'rafael@email.com', 'ATIVO', TRUE),
(1, 'Lucas Ferreira', '11987654325', 135.00, '11987654325', 'ATIVO', FALSE);

-- Inserindo funcionários do Salão
INSERT INTO funcionario(fk_setor, nome, telefone, valor_diaria, chave_pix, status, ajuda_transporte) VALUES
(2, 'Gabriel Souza', '11987654326', 130.00, '11987654326', 'ATIVO', TRUE),
(2, 'Matheus Lima', '11987654327', 125.00, 'matheus@email.com', 'ATIVO', FALSE),
(2, 'André Costa', '11987654328', 140.00, '11987654328', 'ATIVO', TRUE),
(2, 'Felipe Almeida', '11987654329', 135.00, 'felipe@email.com', 'ATIVO', TRUE),
(2, 'Bruno Martins', '11987654330', 120.00, '11987654330', 'ATIVO', FALSE);

-- Inserindo funcionários das Atividades
INSERT INTO funcionario(fk_setor, nome, telefone, valor_diaria, chave_pix, status, ajuda_transporte)VALUES
(3, 'Diego Rodrigues', '11987654331', 110.00, '11987654331', 'ATIVO', TRUE),
(3, 'Thiago Barbosa', '11987654332', 115.00, 'thiago@email.com', 'ATIVO', FALSE),
(3, 'Vinicius Rocha', '11987654333', 125.00, '11987654333', 'ATIVO', TRUE),
(3, 'Gustavo Mendes', '11987654334', 120.00, 'gustavo@email.com', 'ATIVO', TRUE),
(3, 'Eduardo Nunes', '11987654335', 105.00, '11987654335', 'ATIVO', FALSE);