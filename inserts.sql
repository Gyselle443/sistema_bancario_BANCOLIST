- Inserir agências
INSERT INTO AGENCIA (id_agencia, nome, telefone_principal, data_abertura) VALUES
('001', 'Agência Centro', '(11) 3333-0001', '2020-01-15'),
('002', 'Agência Zona Sul', '(11) 3333-0002', '2020-03-20');

-- Inserir clientes
INSERT INTO CLIENTE (id_cliente, cpf, nome_completo, data_nascimento, email, profissao) VALUES
('CLI001', '123.456.789-00', 'João Silva Santos', '1985-05-15', 'joao.silva@email.com', 'Engenheiro'),
('CLI002', '987.654.321-00', 'Maria Oliveira Souza', '1990-08-22', 'maria.oliveira@email.com', 'Advogada'),
('CLI003', '111.222.333-44', 'Carlos Pereira Lima', '1978-12-10', 'carlos.pereira@email.com', 'Médico');

-- Inserir funcionários
INSERT INTO FUNCIONARIO (id_funcionario, id_agencia, nome_completo, cargo, salario) VALUES
('FUNC001', '001', 'Ana Costa Rodrigues', 'GERENTE', 8500.00),
('FUNC002', '001', 'Pedro Almeida Santos', 'CAIXA', 3200.00),
('FUNC003', '002', 'Juliana Martins Lima', 'GERENTE', 8200.00);

-- Inserir contas usando a stored procedure
CALL CriarNovaConta('12345-1', '001', 'CORRENTE', 'CLI001', 'INDIVIDUAL');
CALL CriarNovaConta('23456-2', '001', 'POUPANCA', 'CLI002', 'INDIVIDUAL');
CALL CriarNovaConta('34567-3', '002', 'CORRENTE', 'CLI003', 'INDIVIDUAL');

-- Inserir endereços
INSERT INTO ENDERECO_CLIENTE (id_endereco, id_cliente, cep, logradouro, numero, bairro, cidade, estado) VALUES
(UUID(), 'CLI001', '01234-567', 'Rua das Flores', '123', 'Centro', 'São Paulo', 'SP'),
(UUID(), 'CLI002', '04567-890', 'Avenida Paulista', '456', 'Bela Vista', 'São Paulo', 'SP');

-- Inserir telefones
INSERT INTO TELEFONE_CLIENTE (id_telefone, id_cliente, numero_telefone, tipo, telefone_principal, whatsapp) VALUES
(UUID(), 'CLI001', '(11) 99999-1111', 'CELULAR', TRUE, TRUE),
(UUID(), 'CLI002', '(11) 98888-2222', 'CELULAR', TRUE, TRUE);