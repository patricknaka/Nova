-- 	FAF.229 - 23-jul-2014, Fabio Ferreira,	Inclusão dos campos data de criação do doc de baixa e reversão
--****************************************************************************************************************************************************************
SELECT  
        znacr017.t$ttyp$c CD_TP_TRANSACAO_BAIXA,
        znacr017.t$docn$c NR_TRANSACAO_BAIXA,
        znacr017.T$TINV$C CD_TRANSACAO,
        znacr017.T$NINV$C NR_DOCUMENTO,
        SUM(znacr017.T$AMNT$C * CASE WHEN znacr017.T$TRAN$C=2 THEN -1
                            ELSE 1 END)  VL_VALOR,
        znacr017.T$TINR$C CD_TP_TRANSACAO_REVERSAO,
        znacr017.T$NINR$C NR_TRANSACAO_REVERSAO,
        znacr017.T$TINV$C || znacr017.T$NINV$C CD_CHAVE_PRIMARIA,
        tfgld018b.T$DCDT DT_BAIXA,												--#FAF.229.n
        tfgld018b.T$DCDT DT_REVERSAO											--#FAF.229.n
FROM    BAANDB.tznacr017201 znacr017,
        BAANDB.ttfgld018201 tfgld018b,											--#FAF.229.n
        BAANDB.ttfgld018201 tfgld018r											--#FAF.229.n
WHERE   tfgld018b.T$TTYP=znacr017.T$TTYP$C										--#FAF.229.sn
AND     tfgld018b.T$DOCN=znacr017.T$DOCN$C
AND     tfgld018r.T$TTYP=znacr017.T$TINR$C
AND     tfgld018r.T$DOCN=znacr017.T$NINR$C										--#FAF.229.en
GROUP BY 		znacr017.t$ttyp$c,
            znacr017.t$docn$c,
            znacr017.T$TINV$C,
            znacr017.T$NINV$C,
            znacr017.T$TINR$C,
            znacr017.T$NINR$C,
            tfgld018b.T$DCDT,													--#FAF.229.n	
            tfgld018b.T$DCDT													--#FAF.229.n