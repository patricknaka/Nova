SELECT
    tdsls094.t$sotp   COD_TIPO_ORDEM_VENDA,
    tdsls094.t$dsca   DESCR_TIPO_ORDEM_VENDA,
    tdsls094.t$wrhp   COD_TIPO_ORDEM_ARMAZEM,
    whinh010.t$dsca   DESCR_TIPO_ORDEM_ARMAZEM,
    tdsls094.t$reto   ORDEM_DEVOLUCAO,
    tdsls094.t$fdty$l TIPO_DOCUMENTO_FISCAL
FROM
    baandb.ttdsls094201 tdsls094
    LEFT JOIN baandb.twhinh010201 whinh010 ON whinh010.t$otyp = tdsls094.t$wrhp
    
