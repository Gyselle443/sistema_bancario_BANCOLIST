CREATE TABLE AGENCIA (
    id_agencia VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone_principal VARCHAR(20),
    data_abertura DATE,
    status ENUM('ATIVA', 'INATIVA') DEFAULT 'ATIVA',
    INDEX idx_agencia_status (status)
);

-- Tabela: CLIENTE
CREATE TABLE CLIENTE (
    id_cliente VARCHAR(20) PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(100),
    profissao VARCHAR(50),
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    status ENUM('ATIVO', 'INATIVO', 'BLOQUEADO') DEFAULT 'ATIVO',
    INDEX idx_cliente_cpf (cpf),
    INDEX idx_cliente_status (status)
);

-- Tabela: CONTA
CREATE TABLE CONTA (
    numero_conta VARCHAR(20) PRIMARY KEY,
    id_agencia VARCHAR(10) NOT NULL,
    tipo_conta ENUM('CORRENTE', 'POUPANCA', 'INVESTIMENTO', 'SALARIO') DEFAULT 'CORRENTE',
    saldo DECIMAL(15,2) DEFAULT 0.00,
    limite_credito DECIMAL(15,2) DEFAULT 0.00,
    limite_saque_diario DECIMAL(15,2) DEFAULT 1000.00,
    data_abertura DATE DEFAULT (CURRENT_DATE),
    data_encerramento DATE,
    status ENUM('ATIVA', 'BLOQUEADA', 'ENCERRADA') DEFAULT 'ATIVA',
    FOREIGN KEY (id_agencia) REFERENCES AGENCIA(id_agencia),
    INDEX idx_conta_agencia (id_agencia),
    INDEX idx_conta_status (status),
    INDEX idx_conta_tipo (tipo_conta)
);

-- Tabela: FUNCIONARIO
CREATE TABLE FUNCIONARIO (
    id_funcionario VARCHAR(20) PRIMARY KEY,
    id_agencia VARCHAR(10) NOT NULL,
    nome_completo VARCHAR(100) NOT NULL,
    cargo ENUM('GERENTE', 'CAIXA', 'ATENDENTE', 'ANALISTA') DEFAULT 'ATENDENTE',
    salario DECIMAL(10,2),
    data_admissao DATE DEFAULT (CURRENT_DATE),
    data_demissao DATE,
    status ENUM('ATIVO', 'AFASTADO', 'DEMITIDO') DEFAULT 'ATIVO',
    FOREIGN KEY (id_agencia) REFERENCES AGENCIA(id_agencia),
    INDEX idx_funcionario_agencia (id_agencia),
    INDEX idx_funcionario_cargo (cargo)
);

-- Tabela: TRANSACAO
CREATE TABLE TRANSACAO (
    id_transacao VARCHAR(36) PRIMARY KEY,
    numero_conta_origem VARCHAR(20),
    numero_conta_destino VARCHAR(20),
    valor DECIMAL(15,2) NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('DEPOSITO', 'SAQUE', 'TRANSFERENCIA', 'PAGAMENTO') NOT NULL,
    descricao VARCHAR(200),
    codigo_autenticacao VARCHAR(50) UNIQUE,
    status ENUM('CONCLUIDA', 'PENDENTE', 'CANCELADA') DEFAULT 'CONCLUIDA',
    FOREIGN KEY (numero_conta_origem) REFERENCES CONTA(numero_conta),
    FOREIGN KEY (numero_conta_destino) REFERENCES CONTA(numero_conta),
    INDEX idx_transacao_origem (numero_conta_origem),
    INDEX idx_transacao_destino (numero_conta_destino),
    INDEX idx_transacao_data (data_hora),
    INDEX idx_transacao_tipo (tipo),
    CHECK (valor > 0)
);

-- =============================================
-- TABELAS DE RELACIONAMENTO
-- =============================================

-- Tabela: CLIENTE_CONTA
CREATE TABLE CLIENTE_CONTA (
    id_cliente VARCHAR(20) NOT NULL,
    numero_conta VARCHAR(20) NOT NULL,
    data_associacao DATE DEFAULT (CURRENT_DATE),
    tipo_relacionamento ENUM('TITULAR', 'COTITULAR', 'PROCURADOR') DEFAULT 'TITULAR',
    tipo_titularidade ENUM('INDIVIDUAL', 'CONJUNTA', 'SOLIDARIA') DEFAULT 'INDIVIDUAL',
    assinatura_obrigatoria BOOLEAN DEFAULT FALSE,
    limite_operacao DECIMAL(15,2),
    PRIMARY KEY (id_cliente, numero_conta),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (numero_conta) REFERENCES CONTA(numero_conta) ON DELETE CASCADE,
    INDEX idx_cliente_conta_cliente (id_cliente),
    INDEX idx_cliente_conta_conta (numero_conta)
);

-- =============================================
-- TABELAS AUXILIARES (Correções 1FN)
-- =============================================

-- Tabela: ENDERECO_CLIENTE
CREATE TABLE ENDERECO_CLIENTE (
    id_endereco VARCHAR(36) PRIMARY KEY,
    id_cliente VARCHAR(20) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    tipo ENUM('RESIDENCIAL', 'COMERCIAL', 'COBRANCA') DEFAULT 'RESIDENCIAL',
    endereco_principal BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE CASCADE,
    INDEX idx_end_cliente (id_cliente),
    INDEX idx_end_principal (endereco_principal)
);

-- Tabela: TELEFONE_CLIENTE
CREATE TABLE TELEFONE_CLIENTE (
    id_telefone VARCHAR(36) PRIMARY KEY,
    id_cliente VARCHAR(20) NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,
    tipo ENUM('CELULAR', 'RESIDENCIAL', 'COMERCIAL') DEFAULT 'CELULAR',
    operadora VARCHAR(20),
    telefone_principal BOOLEAN DEFAULT TRUE,
    whatsapp BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE CASCADE,
    INDEX idx_tel_cliente (id_cliente),
    INDEX idx_tel_principal (telefone_principal)
);

-- Tabela: ENDERECO_AGENCIA
CREATE TABLE ENDERECO_AGENCIA (
    id_endereco VARCHAR(36) PRIMARY KEY,
    id_agencia VARCHAR(10) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    ponto_referencia VARCHAR(100),
    FOREIGN KEY (id_agencia) REFERENCES AGENCIA(id_agencia) ON DELETE CASCADE,
    INDEX idx_end_agencia (id_agencia)
);

-- Tabela: TELEFONE_AGENCIA
CREATE TABLE TELEFONE_AGENCIA (
    id_telefone VARCHAR(36) PRIMARY KEY,
    id_agencia VARCHAR(10) NOT NULL,
    numero_telefone VARCHAR(20) NOT NULL,
    ramal VARCHAR(10),
    departamento ENUM('ATENDIMENTO', 'GERENCIA', 'OPERACOES') DEFAULT 'ATENDIMENTO',
    telefone_principal BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_agencia) REFERENCES AGENCIA(id_agencia) ON DELETE CASCADE,
    INDEX idx_tel_agencia (id_agencia)
);

-- Tabela: ENDERECO_FUNCIONARIO
CREATE TABLE ENDERECO_FUNCIONARIO (
    id_endereco VARCHAR(36) PRIMARY KEY,
    id_funcionario VARCHAR(20) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    tipo ENUM('RESIDENCIAL', 'COMERCIAL') DEFAULT 'RESIDENCIAL',
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario) ON DELETE CASCADE,
    INDEX idx_end_funcionario (id_funcionario)
);

-- =============================================
-- TABELAS DE SEGURANÇA E AUDITORIA
-- =============================================

-- Tabela: USUARIO_SISTEMA
CREATE TABLE USUARIO_SISTEMA (
    id_usuario VARCHAR(36) PRIMARY KEY,
    id_funcionario VARCHAR(20) UNIQUE NOT NULL,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil ENUM('ADMIN', 'GERENTE', 'OPERADOR', 'CONSULTA') DEFAULT 'OPERADOR',
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_expiracao_senha DATE,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario),
    INDEX idx_usuario_login (login),
    INDEX idx_usuario_ativo (ativo)
);

-- Tabela: LOG_ACESSO
CREATE TABLE LOG_ACESSO (
    id_log VARCHAR(36) PRIMARY KEY,
    id_usuario VARCHAR(36) NOT NULL,
    data_hora_login DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_hora_logout DATETIME,
    ip_address VARCHAR(45),
    dispositivo VARCHAR(100),
    status_sessao ENUM('ATIVA', 'FINALIZADA', 'EXPIRADA') DEFAULT 'ATIVA',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO_SISTEMA(id_usuario),
    INDEX idx_log_usuario (id_usuario),
    INDEX idx_log_data (data_hora_login)
);

-- Tabela: AUDITORIA_TRANSACAO
CREATE TABLE AUDITORIA_TRANSACAO (
    id_auditoria VARCHAR(36) PRIMARY KEY,
    id_transacao VARCHAR(36) NOT NULL,
    id_usuario VARCHAR(36) NOT NULL,
    data_hora_auditoria DATETIME DEFAULT CURRENT_TIMESTAMP,
    acao ENUM('CRIACAO', 'ALTERACAO', 'CANCELAMENTO') NOT NULL,
    dados_anteriores JSON,
    dados_novos JSON,
    motivo VARCHAR(200),
    FOREIGN KEY (id_transacao) REFERENCES TRANSACAO(id_transacao),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO_SISTEMA(id_usuario),
    INDEX idx_auditoria_transacao (id_transacao),
    INDEX idx_auditoria_usuario (id_usuario),
    INDEX idx_auditoria_data (data_hora_auditoria)
);