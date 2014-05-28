-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo Pedido_Entrega, adicionado o campo NUM_ENTREGA
-- #FAF.047 - 22-mai-2014, Fabio Ferreira, 	Retirado campo ENTREGA
-- #FAF.049 - 22-mai-2014, Fabio Ferreira, 	Alterado o campo FLAG_VALE_LISTA_CASAMENTO para trazer sim(1) quando existe lista de casmento ou não (2)
-- #FAF.076 - 23-mai-2014, Fabio Ferreira, 	Incluida a descrição do COD_MOTIVO_REPROVACAO
-- #FAF.047.1 - 23-mai-2014, Fabio Ferreira, 	Campo ENTREGA convertido para String
-- #FAF.085 - 23-mai-2014, Fabio Ferreira, 	Inclusão do campo ID_ADQUIRENTE
--***************************************************************************************************************************************************************
select
    tdsls400.t$rcd_utc  DT_ULTIMA_ATUALIZ_PEDIDO,
    201 COMPANHIA,
    tdsls400.t$orno ORDEM,
--    CONCAT(TRIM(sls401q.t$pecl$c), TRIM(to_char(sls401q.t$entr$c))) PEDIDO_ENTREGA, 					--#FAF.007.o
    TO_CHAR(sls401q.t$entr$c) NUM_ENTREGA, 																--#FAF.047.1.n
--    sls401q.t$entr$c NUM_ENTREGA, 																	--#FAF.007.o	#FAF.047.1.o
	TRIM(sls401q.t$pecl$c) PEDIDO,
--	sls401q.t$entr$c ENTREGA,																			--#FAF.047.o
    znsls402.t$sequ$c  SEQ_PAGAMENTO,
    znsls402.t$idmp$c  COD_MEIO_PAGAMENTO,
    znsls402.t$cccd$c  COD_BANDEIRA,
    znsls402.t$idbc$c  COD_BANCO,
    znsls402.t$nupa$c  NUM_PARCELAS,
    znsls402.t$vlmr$c  VALOR_PAGAMENTO,
    znsls402.t$stat$c  STATUS_PAGAMENTO,
--    znsls400.t$idli$c  FLAG_VALE_LISTA_CASAMENTO,														--#FAF.049.o
	CASE WHEN znsls400.t$idli$c!=0 THEN 1 ELSE 2 END FLAG_VALE_LISTA_CASAMENTO,							--#FAF.049.n
	CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_EMISSAO_PEDIDO,
    znsls402.t$uneg$c  COD_UNIDADE_NEGOCIO,	
	CAST((FROM_TZ(CAST(TO_CHAR(znsls402.t$dtra$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_APROVACAO,
    znsls402.t$valo$c  VALOR_ORIGINAL_PAGAMENTO,
    znsls402.t$vlja$c  VALOR_JUROS_ADMINISTRADORA,
    CASE WHEN znsls402.t$vlja$c!=0 THEN 1
	ELSE 2
	END FLAG_JUROS_ADMINISTRADORA,
    (select min(a.t$trdt) from ttdsls451201 a
    where a.t$orno=tdsls400.t$orno) DT_APROVACAO_PAGAMENTO_ERP,
    znsls402.t$vlju$c  VALOR_JUROS,
    ' ' COD_CICLO_PAGAMENTO,            -- *** NÃO EXISTE ESTA INFORMAÇÃO NO LN / PENDENTE DE DUVIDA ***
    znsls402.t$cone$c  NUM_TABELA_NEGOCIACAO,
    znsls402.t$ncam$c  BIN_CARTAO_CREDITO,
    znsls402.t$nctf$c  NSU_TRANSACAO_CARTAO_CREDITO,
    znsls402.t$nsua$c  NSU_AUTOR_CARTAO_CREDITO,
    znsls402.t$auto$c  COD_AUTOR_CARTAO_CREDITO,
    znsls402.t$maqu$c  NUM_MAQUINETA,
    znsls402.t$nute$c  NUM_TERMINAL,
    znsls402.t$mrep$c  COD_MOTIVO_REPROVACAO,
	znsls402.t$txrp$c  DESC_MOTIVO_REPROVACAO,															--#FAF.076.n
    znsls402.t$idag$c  NUM_AGENCIA_DEBITO,
    znsls402.t$idct$c  NUM_CONTA_DEBITO,
	znsls402.t$idad$c COD_ADQUIRENTE																	--#FAF.085.n
FROM  tznsls400201 znsls400,
    (select distinct 
      znsls401.t$ncia$c      t$ncia$c,
          znsls401.t$uneg$c       t$uneg$c,
          znsls401.t$pecl$c       t$pecl$c,
          znsls401.t$sqpd$c       t$sqpd$c,
          znsls401.t$entr$c       t$entr$c,
      znsls401.t$orno$c      t$orno$c
    from tznsls401201 znsls401) sls401q,
    ttdsls400201 tdsls400,
    tznsls402201 znsls402
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
