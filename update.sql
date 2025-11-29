- Verificar saldo para saques e transferências
    IF p_tipo IN ('SAQUE', 'TRANSFERENCIA') THEN
        SELECT saldo INTO v_saldo_origem 
        FROM CONTA 
        WHERE numero_conta = p_numero_conta_origem
        FOR UPDATE;
        
        IF v_saldo_origem < p_valor THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
        END IF;
        
        -- Debitar conta origem
        UPDATE CONTA 
        SET saldo = saldo - p_valor 
        WHERE numero_conta = p_numero_conta_origem;
    END IF;
    
    -- Creditar conta destino para depósitos e transferências
    IF p_tipo IN ('DEPOSITO', 'TRANSFERENCIA') THEN
        UPDATE CONTA 
        SET saldo = saldo + p_valor 
        WHERE numero_conta = p_numero_conta_destino;
    END IF;
    
    -- Registrar transação
    INSERT INTO TRANSACAO (
        id_transacao, numero_conta_origem, numero_conta_destino, 
        valor, tipo, descricao, codigo_autenticacao
    ) VALUES (
        p_id_transacao, p_numero_conta_origem, p_numero_conta_destino,
        p_valor, p_tipo, p_descricao, UUID()
    );
    
    COMMIT;
END//
DELIMITER ;