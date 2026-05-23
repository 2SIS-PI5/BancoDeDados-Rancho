CREATE DATABASE rancho;

USE rancho;

CREATE TABLE setores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_setor VARCHAR(50) NOT NULL
);

CREATE TABLE usuarios_sistema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

CREATE TABLE areas(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    ddd VARCHAR(2) NoT NULL,
    numero VARCHAR(11) NOT NULL,
	cep VARCHAR(8) NOT NULL,
	pix_chave VARCHAR(250) NOT NULL,
    id_area INT,
    valor_diaria DOUBLE(10,2),
    custo_transporte BOOLEAN DEFAULT FALSE,
    distancia FLOAT(10,2) NOT NULL,
    data_cadastro DATE NOT NULL,
    CONSTRAINT FkAreasFuncionarios FOREIGN KEY (id_area) REFERENCES areas(id)
);

CREATE TABLE escalas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_escala DATE NOT NULL,
    status_escala VARCHAR(20) DEFAULT 'Agendada' CHECK (status_escala IN ('Agendada', 'Concluída', 'Cancelada'))
);

CREATE TABLE escala_funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_escala INT,
    id_funcionario INT,
    id_setor INT,
    compareceu BOOLEAN DEFAULT NULL,
    CONSTRAINT fkFuncionarioFuncionarioEscala FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id),
    CONSTRAINT fkEscalaEscalaFuncionario FOREIGN KEY (id_escala) REFERENCES escalas(id),
    CONSTRAINT fkSetorEscalaFuncionario FOREIGN KEY (id_setor) REFERENCES setores(id)
);

CREATE TABLE pagamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    id_escala_func INT NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(10, 2) NOT NULL,
    forma_pagamento_utilizada VARCHAR(10) CHECK (forma_pagamento_utilizada IN ('Pix', 'Dinheiro')),
    status_pagamento VARCHAR(20) DEFAULT 'Pendente' CHECK (status_pagamento IN ('Pendente', 'Pago')),
    CONSTRAINT fkEscalaFuncionarioPagamento FOREIGN KEY (id_escala_func) REFERENCES escala_funcionarios(id),
    CONSTRAINT fkFuncionarioPagamento FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id)
);

CREATE TABLE pontuacoes_funcionario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    pontos INT NOT NULL,
    motivo VARCHAR(100) NOT NULL,
    data_pontuacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_escala_func INT,
    CONSTRAINT fkFuncionarioPontuacao FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id),
    CONSTRAINT fkEscalaFuncPontuacao FOREIGN KEY (id_escala_func) REFERENCES escala_funcionarios(id)
);