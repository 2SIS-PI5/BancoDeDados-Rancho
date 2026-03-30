CREATE DATABASE rancho;

USE rancho;

CREATE TABLE usuarios_sistema(
	id_usuario_sistema INT PRIMARY KEY AUTO_INCREMENT,
    
);

CREATE TABLE setores (
    id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome_setor VARCHAR(50) NOT NULL
);

CREATE TABLE usuarios_sistema (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    preferencia_pagamento VARCHAR(10) CHECK (preferencia_pagamento IN ('Pix', 'Dinheiro')),
    data_cadastro DATE NOT NULL
);

CREATE TABLE telefones_funcionario (
    id_telefone INT NOT NULL AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    numero VARCHAR(11) NOT NULL,
	CONSTRAINT fkFuncionarioTelefone FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
	CONSTRAINT pkTelefoneFuncionario PRIMARY KEY (id_telefone, id_funcionario)
);

CREATE TABLE pix_funcionario (
    id_pix INT AUTO_INCREMENT,
    id_funcionario INT,
    banco VARCHAR(20) NOT NULL,
    pix_chave VARCHAR(100) NOT NULL,
    CONSTRAINT fkFuncionarioPix FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
    CONSTRAINT pkPixFuncionario PRIMARY KEY (id_pix, id_funcionario)
);

CREATE TABLE escalas (
    id_escala INT PRIMARY KEY AUTO_INCREMENT,
    data_escala DATE NOT NULL,
    status_escala VARCHAR(20) DEFAULT 'Agendada' CHECK (status_escala IN ('Agendada', 'Concluída', 'Cancelada'))
);

CREATE TABLE escala_funcionarios (
    id_escala_func INT PRIMARY KEY,
    id_escala INT,
    id_funcionario INT,
    id_setor INT,
    valor_combinado DECIMAL(10, 2) NOT NULL,
    compareceu BOOLEAN DEFAULT TRUE,
    horario_entrada TIME,
	horario_saida TIME,
    CONSTRAINT fkFuncionarioFuncionarioEscala FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
    CONSTRAINT fkEscalaEscalaFuncionario FOREIGN KEY (id_escala) REFERENCES escalas(id_escala),
    CONSTRAINT fkSetorEscalaFuncionario FOREIGN KEY (id_setor) REFERENCES setores(id_setor)
);

CREATE TABLE pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    id_escala_func INT NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_pago DECIMAL(10, 2) NOT NULL,
    forma_pagamento_utilizada VARCHAR(10) CHECK (forma_pagamento_utilizada IN ('Pix', 'Dinheiro')),
    status_pagamento VARCHAR(20) DEFAULT 'Pendente' CHECK (status_pagamento IN ('Pendente', 'Pago')),
    CONSTRAINT fkEscalaFuncionarioPagamento FOREIGN KEY (id_escala_func) REFERENCES escala_funcionarios(id_escala_func),
    CONSTRAINT fkFuncionarioPagamento FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario)
);

CREATE TABLE pontuacoes_freelancer (
    id_pontuacao INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    pontos INT NOT NULL, 
    motivo VARCHAR(100) NOT NULL, 
    data_pontuacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_escala_func INT,
    CONSTRAINT fkFuncionarioPontuacao FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),
    CONSTRAINT fkEscalaFuncPontuacao FOREIGN KEY (id_escala_func) REFERENCES escala_funcionarios(id_escala_func)
);
 -- Pontuação de para dia trabalhado
DELIMITER //

CREATE TRIGGER trg_pontuar_presenca
AFTER UPDATE ON pagamentos
FOR EACH ROW
BEGIN
    IF NEW.status_pagamento = 'Pago' AND OLD.status_pagamento = 'Pendente' THEN
        INSERT INTO pontuacoes_freelancer (id_funcionario, pontos_alterados, motivo, id_escala_func)
        VALUES (NEW.id_funcionario, 10, 'Presença Confirmada e Paga', NEW.id_escala_func);
    END IF;
END;
//

DELIMITER ;