-- VIEW: VW_PEV_PAGAMENTO
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega, adicionado o campo NUM_ENTREGA
-- #FAF.047 - 22-mai-2014, Fabio Ferreira, 	Retirado campo ENTREGA
-- #FAF.049 - 22-mai-2014, Fabio Ferreira, 	Alterado o campo FLAG_VALE_LISTA_CASAMENTO para trazer sim(1) quando existe lista de casmento ou não (2)
-- #FAF.076 - 23-mai-2014, Fabio Ferreira, 	Incluida a descrição do COD_MOTIVO_REPROVACAO
-- #FAF.047.1 - 23-mai-2014, Fabio Ferreira, 	Campo ENTREGA convertido para String
-- #FAF.085 - 23-mai-2014, Fabio Ferreira, 	Inclusão do campo ID_ADQUIRENTE
-- #FAF.089 - 28-mai-2014,	Fabio Ferreira,	NUN_TERMINAL convertido em String
-- #FAF.088 - 28-mai-2014,	Fabio Ferreira, conversão de timezone no campo DT_APROVACAO_PAGAMENTO_ERP 
--***************************************************************************************************************************************************************
select
    tdsls400.t$rcd_utc  DT_ULTIMA_ATUALIZACAO_PEDIDO,
    201 CD_CIA,
    tdsls400.t$orno NR_ORDEM,
	TRIM(sls401q.t$pecl$c) NR_PEDIDO,
    TO_CHAR(sls401q.t$entr$c) NR_ENTREGA, 																--#FAF.047.1.n
    znsls402.t$sequ$c  SQ_PAGAMENTO,
    znsls402.t$idmp$c  CD_MEIO_PAGAMENTO,
    znsls402.t$cccd$c  CD_BANDEIRA,
    znsls402.t$idbc$c  CD_BANCO,
    znsls402.t$nupa$c  NR_PARCELAS,
    znsls402.t$vlmr$c  VL_PAGAMENTO,
    znsls402.t$stat$c  CD_STATUS_PAGAMENTO,
	CASE WHEN znsls400.t$idli$c!=0 THEN 1 ELSE 2 END IN_VALE_LISTA_CASAMENTO,							--#FAF.049.n
	CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_EMISSAO_PEDIDO,
    znsls402.t$uneg$c  CD_UNIDADE_NEGOCIO,	
	CAST((FROM_TZ(CAST(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_APROVACAO,
    znsls402.t$valo$c  VL_ORIGINAL,
    znsls402.t$vlja$c  VL_JUROS_ADMINISTRADORA,
    CASE WHEN znsls402.t$vlja$c!=0 THEN 1
	ELSE 2
	END IN_JUROS_ADMINISTRADORA,
    (select 
	CAST((FROM_TZ(CAST(TO_CHAR(min(a.t$trdt), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 				--#FAF.088.n
			AT time zone sessiontimezone) AS DATE)	
	from baandb.ttdsls451201 a
    where a.t$orno=tdsls400.t$orno) DT_APROVACAO_PAGAMENTO_ERP,
    znsls402.t$vlju$c  VL_JUROS,
    ' ' CD_CICLO_PAGAMENTO,            -- *** NÃO EXISTE ESTA INFORMAÇÃO NO LN / PENDENTE DE DUVIDA ***
    znsls402.t$cone$c  NR_TABELA_NEGOCIACAO,
    znsls402.t$ncam$c  NR_BIN_CARTAO_CREDITO,
    znsls402.t$nctf$c  NR_NSU_TRANSACAO_CARTAO,
    znsls402.t$nsua$c  NR_NSU_AUTOR_CARTAO,
    znsls402.t$auto$c  CD_AUTOR_CARTAO_CREDITO,
    znsls402.t$maqu$c  NR_MAQUINETA,
    TO_CHAR(znsls402.t$nute$c)  NR_TERMINAL,															--#FAF.089.n
    znsls402.t$mrep$c  CD_MOTIVO_REPROVACAO,
	znsls402.t$txrp$c  DS_MOTIVO_REPROVACAO,															--#FAF.076.n
    znsls402.t$idag$c  NR_AGENCIA,
    znsls402.t$idct$c  NR_CONTA_CORRENTE,
	znsls402.t$idad$c CD_ADQUIRENTE																	--#FAF.085.n
FROM  baandb.tznsls400201 znsls400,
    (select distinct 
      znsls401.t$ncia$c      t$ncia$c,
          znsls401.t$uneg$c       t$uneg$c,
          znsls401.t$pecl$c       t$pecl$c,
          znsls401.t$sqpd$c       t$sqpd$c,
          znsls401.t$entr$c       t$entr$c,
      znsls401.t$orno$c      t$orno$c
    from baandb.tznsls401201 znsls401) sls401q,
    baandb.ttdsls400201 tdsls400,
    baandb.tznsls402201 znsls402
where
      sls401q.t$ncia$c=znsls400.t$ncia$c
and    sls401q.t$uneg$c=znsls400.t$uneg$c
and    sls401q.t$pecl$c=znsls400.t$pecl$c
and    sls401q.t$sqpd$c=znsls400.t$sqpd$c
and    sls401q.t$orno$c=tdsls400.t$orno
and    znsls402.t$ncia$c=znsls400.t$ncia$c
and    znsls402.t$uneg$c=znsls400.t$uneg$c
and    znsls402.t$pecl$c=znsls400.t$pecl$c
and    znsls402.t$sqpd$c=znsls400.t$sqpd$c