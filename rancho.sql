CREATE DATABASE rancho;
USE rancho;

CREATE TABLE setores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE funcionarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    especialidade VARCHAR(80) NOT NULL,
    valor_hora DECIMAL(10,2) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'ativo',
    observacoes TEXT,
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
    pix_chave TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuarios_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'GESTOR',
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
);

CREATE TABLE escalas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    data_escala DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    status_escala VARCHAR(20) DEFAULT 'Agendada' CHECK (status_escala IN ('Agendada', 'Concluída', 'Cancelada')),
    observacoes TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE escala_funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_escala BIGINT,
    id_funcionario BIGINT,
    id_setor INT,
    valor_total DECIMAL(10,2),
    compareceu BOOLEAN DEFAULT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id),
    FOREIGN KEY (id_escala) REFERENCES escalas(id),
    FOREIGN KEY (id_setor) REFERENCES setores(id)
);

CREATE TABLE avaliacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario BIGINT NOT NULL,
    id_usuario_sistema INT,
    nota FLOAT,
    descricao VARCHAR(255),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id),
    FOREIGN KEY (id_usuario_sistema) REFERENCES usuarios_sistema(id)
);

CREATE TABLE pagamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario BIGINT NOT NULL,
    id_escala_func INT NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento_utilizada VARCHAR(10),
    status_pagamento VARCHAR(20) DEFAULT 'Pendente' CHECK (status_pagamento IN ('Pendente', 'Pago')),
    FOREIGN KEY (id_escala_func) REFERENCES escala_funcionarios(id),
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id)
);