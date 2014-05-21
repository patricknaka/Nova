SELECT

	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=sls400orig.t$cofc
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) FILIAL_PEDIDO,
	-- MOTIVO_ABERTURA_CHAMADO																*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	-- MOTIVO_DA CLASSIFICACAO_CHAMADO														*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	znsls401.t$idor$c TIPO_INSTANCIA,
	znsls401.t$cdat$c ID_INSTANCIA,
	znsls401.t$trre$c TRANSPORTADORA,
	znsls401.t$trre$c TRANSPORTADORA_COLETA,
	-- DT_OCORRÊNCIA (DT ABERTURA_CHAMADO NO SAC)											*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	-- DT_SITUACAO (DT EM QUE FOI “FORCADA”)												*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	znsls401.t$pecl$c NUM_PEDIDO ,
	znsls401.t$entr$c NUM_ENTREGA,
	CONCAT(TRIM(znsls401.t$pecl$c), TRIM(to_char(znsls401.t$entr$c, '00'))) PEDIDO_ENTREGA, 
	znsls401.t$orno$c ORDEM,
	cisli940.t$docn$l NF_ORIGINAL,
	cisli940.t$seri$l SER_NF_ORIGINAL,
	tdrec940.t$docn$l NF_ENTRADA,
	tdrec940.t$seri$l SER_NF_ENTRADA,
	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) FILIAL_NF_ENTRADA,
	tdrec940.t$bpid$l CLIENTE_NF_ENTRADA,
	tdrec940.t$stat$l SITUACAO_NF_ENTRADA,
	cisli940nr.t$docn$l NR, --(ID_NOTA_ENTRADA QUE SE RELACIONA COM A NF_SAÍDA_VENDA)
	cisli940nr.t$stat$l SITUACAO_NR,
	-- OBSERVACÕES (DESCRICAO_CHAMADO, ENVIADAS PELO RIGHT NOW)								*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	znsls401.t$cepe$c CEP_CLIENTE_ENTREGA,
	znsls401.t$cide$c CIDADE_CLIENTE_ENTREGA,
	znsls401.t$ufen$c ESTADO_CLIENTE_ENTREGA,
	ltrim(rtrim(tdsls401orig.t$item)) ID_ITEM_NF_VENDA,
	tcibd001.t$dsca NOME_ITEM_NF_VENDA,
	tdsls401orig.t$qoor QUANTIDADE_ITENS,
	sls400orig.t$oamt VALOR_TOTAL_ITENS,
	znsls401.t$vlfr$c VALOR_FRETE,
	znsls401.t$idik$c ID_KIT,
	-- PROCESSO (CLASSIFICACAO_CHAMADO)
	-- MOTIVO_FORCADO (MOTIVO_PELA LIBERACAO FORCADA)
	-- NUM_RASTREAMENTO (SOMENTE NO CASO_CORREIOS)
	(select znsls410.t$poco$c
	FROM tznsls410201 znsls410
	WHERE znsls410.t$ncia$c=znsls401.t$ncia$c
	AND znsls410.t$uneg$c=znsls401.t$uneg$c
	AND znsls410.t$pecl$c=znsls401.t$pecl$c
	AND znsls410.t$sqpd$c=znsls401.t$sqpd$c
	AND znsls410.t$entr$c=znsls401.t$entr$c
	AND znsls410.t$dtoc$c= (SELECT MAX(c.t$dtoc$c)
                          FROM tznsls410201 c
                          WHERE c.t$ncia$c=znsls410.t$ncia$c
                          AND c.t$uneg$c=znsls410.t$uneg$c
                          AND c.t$pecl$c=znsls410.t$pecl$c
                          AND c.t$sqpd$c=znsls410.t$sqpd$c
                          AND c.t$entr$c=znsls410.t$entr$c)                          
	AND rownum=1) ULTIMO_PONTO_TRACKING_PED,
	-- TIPO ESTADO (CAPITAL/INTERIOR)														*** DESCONSIDERAR NÃO EXISTE NO LN / SERÁ EXTRAIDO DO SITE ***
	cisli940.t$date$l DT_EMISSAO_NF_VENDA,
	tdrec940.t$idat$l DT_NF_COLETA --(NF_ENTRADA)
FROM
	ttdrec940201 tdrec940,
	ttdrec941201 tdrec941,
	ttdrec947201 tdrec947,
	tznsls401201 znsls401,
	tznsls401201 sls401orig,
	tznsls400201 znsls400,
	ttdsls400201 sls400orig,
	ttccom130201 tccom130,
	ttdsls401201 tdsls401orig,
	tcisli245201 cisli245,
	tcisli940201 cisli940,
	tznsls401201 znsls401nr,
	tcisli245201 cisli245nr,
	tcisli940201 cisli940nr,
	ttcibd001201 tcibd001
WHERE	tdrec947.t$fire$l=tdrec940.t$fire$l
AND		tdrec941.t$fire$l=tdrec941.t$fire$l
AND		tdrec947.t$line$l=tdrec941.t$line$l
AND 	znsls401.t$orno$c=tdrec947.t$orno$l
AND 	znsls401.t$pono$c=tdrec947.t$pono$l
AND		sls401orig.t$ncia$c=znsls401.t$ncia$c
AND		sls401orig.t$uneg$c=znsls401.t$uneg$c
AND		sls401orig.t$pecl$c=znsls401.t$pecl$c
AND		sls401orig.t$sqpd$c=(select min(b.t$sqpd$c) from tznsls401201 b
							 WHERE b.t$ncia$c=sls401orig.t$ncia$c
							 AND   sls401orig.t$uneg$c=sls401orig.t$uneg$c
							 AND   sls401orig.t$pecl$c=sls401orig.t$pecl$c)
AND		sls401orig.t$entr$c=znsls401.t$endt$c
AND		sls401orig.t$sequ$c=znsls401.t$sedt$c
AND		znsls400.t$ncia$c=znsls401.t$ncia$c
AND		znsls400.t$uneg$c=znsls401.t$uneg$c
AND		znsls400.t$pecl$c=znsls401.t$pecl$c	 
AND		znsls400.t$sqpd$c=znsls401.t$sqpd$c	 
AND		sls400orig.t$orno=sls401orig.t$orno$c
AND		tccom130.t$cadr=sls400orig.t$ofad
AND		tdsls401orig.t$orno=sls401orig.t$orno$c
AND		tdsls401orig.t$pono=sls401orig.t$pono$c
AND		cisli245.t$slcp=201
AND		cisli245.t$ortp=1
AND		cisli245.t$koor=3
AND		cisli245.t$slso=tdsls401orig.t$orno
AND		cisli245.t$pono=tdsls401orig.t$pono
AND		cisli940.t$fire$l=cisli245.t$fire$l
AND		znsls401nr.t$ncia$c=znsls401.t$ncia$c
AND		znsls401nr.t$uneg$c=znsls401.t$uneg$c
AND		znsls401nr.t$pecl$c=znsls401.t$pecl$c	 
AND		znsls401nr.t$sqpd$c=znsls401.t$sqpd$c
AND		znsls401nr.t$entr$c>znsls401.t$entr$c
AND		cisli245nr.t$slcp=201
AND		cisli245nr.t$ortp=1
AND		cisli245nr.t$koor=3
AND		cisli245nr.t$slso=znsls401nr.t$orno$c
AND		cisli245nr.t$pono=znsls401nr.t$pono$c
AND		cisli940nr.t$fire$l=cisli245nr.t$fire$l
AND 	tcibd001.t$item=tdsls401orig.t$item