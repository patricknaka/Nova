SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
--**********************************************************************************************************************************************************
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
    602 AS CD_CIA, --znsls400.t$ncia$c
    tdsls400.t$orno NR_ORDEM,
    TRIM(sls401q.t$pecl$c) NR_PEDIDO,
    TO_CHAR(sls401q.t$entr$c) NR_ENTREGA, 																
    znsls402.t$sequ$c  SQ_PAGAMENTO,
    znsls402.t$idmp$c  CD_MEIO_PAGAMENTO,
    CASE WHEN (znsls402.t$idmp$c = 4) THEN 0 ELSE znsls402.t$cccd$c END CD_BANDEIRA,
    CASE WHEN (znsls402.t$idmp$c = 4) THEN 0 ELSE znsls402.t$idbc$c END CD_BANCO,
    znsls402.t$nupa$c  NR_PARCELA,
    cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlmr$c as numeric(12,2)) VL_PAGAMENTO,																															--#FAF.317.n
    znsls402.t$stat$c  CD_STATUS_PAGAMENTO,
    CASE WHEN (znsls402.t$idmp$c = 4 and znsls400.t$idli$c!=0) THEN 1 ELSE 2 END IN_VALE_LISTA_CASAMENTO,							
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_EMISSAO_PEDIDO,
    znsls402.t$uneg$c  CD_UNIDADE_NEGOCIO,	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_APROVACAO,
    znsls402.t$valo$c  VL_ORIGINAL,
    cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlja$c as numeric(12,2))  VL_JUROS_ADMINISTRADORA,
    CASE WHEN znsls402.t$vlja$c!=0 THEN 1
      ELSE 2
      END IN_JUROS_ADMINISTRADORA,
    (select 
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(a.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
        from baandb.ttdsls451602 a
        where a.t$orno=tdsls400.t$orno) DT_APROVACAO_PAGAMENTO_ERP,
    cast((sls401q.VL_PGTO_ENTR/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c  as numeric(12,2))  VL_JUROS,
    ' ' CD_CICLO_PAGAMENTO,            -- *** NÃO EXISTE ESTA INFORMAÇÃO NO LN / PENDENTE DE DUVIDA ***
    znsls402.t$cone$c  NR_TABELA_NEGOCIACAO,
    znsls402.t$ncam$c  NR_BIN_CARTAO_CREDITO,
    znsls402.t$nctf$c  NR_NSU_TRANSACAO_CARTAO,
    znsls402.t$nsua$c  NR_NSU_AUTOR_CARTAO,
    znsls402.t$auto$c  CD_AUTOR_CARTAO_CREDITO,
    znsls402.t$maqu$c  NR_MAQUINETA,
    TO_CHAR(znsls402.t$nute$c)  NR_TERMINAL,															
    znsls402.t$mrep$c  CD_MOTIVO_REPROVACAO,
    znsls402.t$txrp$c  DS_MOTIVO_REPROVACAO,															
    znsls402.t$idag$c  NR_AGENCIA,
    znsls402.t$idct$c  NR_CONTA_CORRENTE,
	znsls402.t$idad$c CD_ADQUIRENTE,																		
	znsls402.t$bopg$c NR_BPAG
FROM  baandb.tznsls400602 znsls400,
    (select distinct 
		znsls401.t$ncia$c      	t$ncia$c,
		znsls401.t$uneg$c       t$uneg$c,
		znsls401.t$pecl$c       t$pecl$c,
		znsls401.t$sqpd$c       t$sqpd$c,
		znsls401.t$entr$c       t$entr$c,
		znsls401.t$orno$c      	t$orno$c,
		sum((znsls401.t$vlun$c*znsls401.t$qtve$c)+znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c) VL_PGTO_ENTR		
    from baandb.tznsls401602 znsls401
	group by
		znsls401.t$ncia$c,																								
		znsls401.t$uneg$c,
		znsls401.t$pecl$c,
		znsls401.t$sqpd$c,
		znsls401.t$entr$c,
		znsls401.t$orno$c) sls401q,																						
		
    (select distinct 																									
		znsls401.t$ncia$c      	t$ncia$c,
		znsls401.t$uneg$c       t$uneg$c,
		znsls401.t$pecl$c       t$pecl$c,
		znsls401.t$sqpd$c       t$sqpd$c,
		sum((znsls401.t$vlun$c*znsls401.t$qtve$c)+znsls401.t$vlfr$c-znsls401.t$vldi$c+znsls401.t$vlde$c) VL_PGTO_PED		
    from baandb.tznsls401602 znsls401
	group by
		znsls401.t$ncia$c,																				
		znsls401.t$uneg$c,
		znsls401.t$pecl$c,
		znsls401.t$sqpd$c) sls401p,																						
    baandb.ttdsls400602 tdsls400,
    baandb.tznsls402602 znsls402
where
	   sls401q.t$ncia$c=znsls400.t$ncia$c
and    sls401q.t$uneg$c=znsls400.t$uneg$c
and    sls401q.t$pecl$c=znsls400.t$pecl$c
and    sls401q.t$sqpd$c=znsls400.t$sqpd$c
and	   sls401p.t$ncia$c=znsls400.t$ncia$c																				
and    sls401p.t$uneg$c=znsls400.t$uneg$c
and    sls401p.t$pecl$c=znsls400.t$pecl$c
and    sls401p.t$sqpd$c=znsls400.t$sqpd$c																				
and    sls401q.t$orno$c=tdsls400.t$orno
and    znsls402.t$ncia$c=znsls400.t$ncia$c
and    znsls402.t$uneg$c=znsls400.t$uneg$c
and    znsls402.t$pecl$c=znsls400.t$pecl$c
and    znsls402.t$sqpd$c=znsls400.t$sqpd$c