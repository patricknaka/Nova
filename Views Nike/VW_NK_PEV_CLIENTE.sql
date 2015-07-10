SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
    13 AS  CD_CIA, --znsls400.t$ncia$c																							
    znsls401.t$pecl$c NR_PEDIDO,
    TO_CHAR(znsls401.t$entr$c) NR_ENTREGA,																	
    tdsls400.t$orno NR_ORDEM,
    tdsls400.t$ofbp CD_CLIENTE_FATURA,
    tccom130.t$ftyp$l CD_TIPO_CLIENTE,
    tccom130.t$ccit CD_CIDADE_FATURA,
    tccom130.t$ccty CD_PAIS_FATURA,
    tccom130.t$cste CD_ESTADO_FATURA,
    tccom130.t$pstc CD_CEP_FATURA,
    tccom130.t$namc DS_ENDERECO_FATURA,
    tccom130.t$dist$l DS_BAIRRO_FATURA,
    tccom130.t$hono NR_FATURA,
    znsls400.t$comf$c DS_COMPLEMENTO_FATURA,
    znsls400.t$reff$c DS_REFERENCIA_ENDERECO_FATURA,
    tdsls400.t$stbp CD_CLIENTE_ENTREGA,
    tccom130c.t$ccit CD_CIDADE_ENTREGA,
    tccom130c.t$ccty CD_PAIS_ENTREGA,
    tccom130c.t$cste CD_ESTADO_ENTREGA,
    tccom130c.t$pstc CD_CEP_ENTREGA,
    tccom130c.t$namc DS_ENDERECO_ENTREGA,
    tccom130c.t$dist$l DS_BAIRRO_ENTREGA,
    tccom130c.t$hono NR_ENTREGA_ENDERECO,																		
    znsls401.t$come$c DS_COMPLEMENTO_ENTREGA,
    znsls401.t$refe$c DS_REFERENCIA_ENDERECO_ENTREGA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_EMISSAO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_CHEGADA_PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
    znsls400.t$idli$c NR_LISTA_CASAMENTO																		
FROM baandb.tznsls401601 znsls401 
INNER JOIN baandb.tznsls400601 znsls400 
      ON  znsls400.t$ncia$c = znsls401.t$ncia$c
      AND znsls400.t$uneg$c = znsls401.t$uneg$c
      AND znsls400.t$pecl$c = znsls401.t$pecl$c
      AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
INNER JOIN (select 	znsls004q.t$ncia$c,
                    znsls004q.t$uneg$c,
                    znsls004q.t$pecl$c,
                    znsls004q.t$sqpd$c,
                    znsls004q.t$entr$c,
                    znsls004q.t$sequ$c,
					znsls004q.t$orno$c
			from baandb.tznsls004601 znsls004q
			where znsls004q.t$date$c=(select max(q004.t$date$c) from baandb.tznsls004601 q004
									 where 	q004.t$ncia$c=znsls004q.t$ncia$c
									 and	q004.t$uneg$c=znsls004q.t$uneg$c
									 and	q004.t$pecl$c=znsls004q.t$pecl$c	
									 and	q004.t$sqpd$c=znsls004q.t$sqpd$c										
									 and	q004.t$entr$c=znsls004q.t$entr$c			
									 and	q004.t$sequ$c=znsls004q.t$sequ$c)) znsls004						
		ON  znsls004.t$ncia$c = znsls401.t$ncia$c
        AND znsls004.t$uneg$c = znsls401.t$uneg$c
        AND znsls004.t$pecl$c = znsls401.t$pecl$c
        AND znsls004.t$sqpd$c = znsls401.t$sqpd$c
		AND znsls004.t$entr$c = znsls401.t$entr$c
		AND znsls004.t$sequ$c = znsls401.t$sequ$c		
INNER JOIN baandb.ttdsls400601 tdsls400  on tdsls400.t$orno = znsls004.t$orno$c
INNER JOIN baandb.ttccom130601 tccom130  on tccom130.t$cadr = tdsls400.t$itad
INNER JOIN baandb.ttccom130601 tccom130c on tccom130c.t$cadr = tdsls400.t$stad
GROUP BY 
znsls400.t$ncia$c,
znsls401.t$pecl$c,
TO_CHAR(znsls401.t$entr$c),
tdsls400.t$orno,
tdsls400.t$ofbp,
tccom130.t$ftyp$l,
tccom130.t$ccit,
tccom130.t$ccty,
tccom130.t$cste,
tccom130.t$pstc,
tccom130.t$namc,
tccom130.t$dist$l,
tccom130.t$hono,
znsls400.t$comf$c,
znsls400.t$reff$c,
tdsls400.t$stbp,
tccom130c.t$ccit,
tccom130c.t$ccty,
tccom130c.t$cste,
tccom130c.t$pstc,
tccom130c.t$namc,
tccom130c.t$dist$l,
tccom130c.t$hono,
znsls401.t$come$c,
znsls401.t$refe$c,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
AT time zone 'America/Sao_Paulo') AS DATE),
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
AT time zone 'America/Sao_Paulo') AS DATE),
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
AT time zone 'America/Sao_Paulo') AS DATE),
znsls400.t$idli$c