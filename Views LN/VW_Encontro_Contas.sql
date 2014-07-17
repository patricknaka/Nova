SELECT  
        znacr017.t$ttyp$c CD_TP_TRANSACAO_BAIXA,
        znacr017.t$docn$c NR_TRANSACAO_BAIXA,
        znacr017.T$TINV$C CD_TRANSACAO,
        znacr017.T$NINV$C NR_DOCUMENTO,
        SUM(znacr017.T$AMNT$C * CASE WHEN znacr017.T$TRAN$C=2 THEN -1
                            ELSE 1 END)  VALOR,
        znacr017.T$TINR$C CD_TP_TRANSACAO_REVERSAO,
        znacr017.T$NINR$C NR_TRANSACAO_REVERSAO,
        znacr017.T$TINV$C || znacr017.T$NINV$C CHAVE
FROM    BAANDB.tznacr017201 znacr017
GROUP BY 		znacr017.t$ttyp$c,
            znacr017.t$docn$c,
            znacr017.T$TINV$C,
            znacr017.T$NINV$C,
            znacr017.T$TINR$C,
            znacr017.T$NINR$C