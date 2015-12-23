SELECT  
        znacr017.t$ttyp$c                       CD_TP_TRANSACAO_BAIXA,
        znacr017.t$docn$c                       NR_TRANSACAO_BAIXA,
        znacr017.T$TINV$C                       CD_TRANSACAO,
        znacr017.T$NINV$C                       NR_DOCUMENTO,
        SUM(znacr017.T$AMNT$C * CASE WHEN znacr017.T$TRAN$C=2 THEN -1
                            ELSE 1 END)         VL_VALOR,
        znacr017.T$TINR$C                       CD_TP_TRANSACAO_REVERSAO,
        znacr017.T$NINR$C                       NR_TRANSACAO_REVERSAO,
        znacr017.T$TINV$C || znacr017.T$NINV$C  CD_CHAVE_PRIMARIA,
        tfgld018b.T$DCDT                        DT_BAIXA,	
        tfgld018r.T$DCDT                        DT_REVERSAO,
		nvl((select a.t$itbp 
			from BAANDB.ttfacr200201 a
			where a.t$tdoc = znacr017.t$ttyp$c
			and a.t$docn = znacr017.t$docn$c
			and rownum=1),
			(select a.t$ifbp 
			from BAANDB.ttfacp200201 a
			where a.t$tdoc = znacr017.t$ttyp$c
			and a.t$docn = znacr017.t$docn$c
			and rownum=1))                            CD_PARCEIRO  

FROM      BAANDB.tznacr017201 znacr017

LEFT JOIN BAANDB.ttfgld018201 tfgld018b											
          ON    tfgld018b.T$TTYP=znacr017.T$TTYP$C										
          AND   tfgld018b.T$DOCN=znacr017.T$DOCN$C
          AND   tfgld018b.T$TTYP!=' '

LEFT JOIN BAANDB.ttfgld018201 tfgld018r											
          ON    tfgld018r.T$TTYP=znacr017.T$TINR$C
          AND   tfgld018r.T$DOCN=znacr017.T$NINR$C
          AND   tfgld018r.T$TTYP!=' '

GROUP BY 		znacr017.t$ttyp$c,
            znacr017.t$docn$c,
            znacr017.T$TINV$C,
            znacr017.T$NINV$C,
            znacr017.T$TINR$C,
            znacr017.T$NINR$C,
            tfgld018b.T$DCDT,	
            tfgld018r.T$DCDT