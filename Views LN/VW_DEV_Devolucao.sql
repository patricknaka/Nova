SELECT
	GREATEST(tdrec940.t$date$l,tdrec940.t$idat$l,tdrec940.t$odat$l) ULTIMA_ATUALIZ_NF,
    201 CD_CIA,
	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) CD_FILIAL, 
	tdrec940.t$docn$l NR_NF,
	tdrec940.t$seri$l NR_SERIE_NF,
	tdrec940.t$opfc$l CD_NATUREZA_OPERACAO,
	tdrec940.t$opor$l SQ_NATUREZA_OPERACAO,
	tdrec940.t$date$l DT_FATURA,
	cisli940.t$itbp$l CD_CLIENTE_FATURA,
	cisli940.t$stbp$l CD_CLIENTE_ENTREGA,
	znsls401.t$sequ$c SQ_ENTREGA,
	znsls401.t$pecl$c NR_PEDIDO,
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
	AND rownum=1) CD_STATUS,
	(SELECT MAX(znsls410.t$dtoc$c)
	FROM tznsls410201 znsls410
	WHERE znsls410.t$ncia$c=znsls401.t$ncia$c
	AND znsls410.t$uneg$c=znsls401.t$uneg$c
	AND znsls410.t$pecl$c=znsls401.t$pecl$c
	AND znsls410.t$sqpd$c=znsls401.t$sqpd$c
	AND znsls410.t$entr$c=znsls401.t$entr$c) DT_STATUS,
	tdrec940.t$rfdt$l CD_TIPO_NF,
	tdrec947.t$rcno$l NR_NFR_DEVOLUCAO,
	ltrim(rtrim(tdrec941.t$item$l)) CD_ITEM,
	tdrec941.t$qnty$l QT_DEVOLUCAO,
	(SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
	WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
	AND tdrec942.t$line$l=tdrec941.t$line$l
	AND tdrec942.t$brty$l=1) VL_ICMS,
	tdrec941.t$gamt$l VL_PRODUTO,
	tdrec941.t$fght$l VL_FRETE,
	tdrec941.t$gexp$l VL_DESPESA,
	tdrec941.t$addc$l VL_DESCONTO_INCONDICIONAL,
	tdrec941.t$tamt$l VL_TOTAL_ITEM,
	sls401orig.t$orno$c NR_PEDIDO_ORIGINAL,
	znsls400.t$dtin$c DT_PEDIDO,
	znsls400.t$idca$c CD_CANAL_VENDAS,
	tccom130.t$ftyp$l CD_TIPO_CLIENTE,
	tccom130.t$ccit CD_CIDADE,
	tccom130.t$ccty CD_PAIS,
	tccom130.t$cste CD_ESTADO,
	q1.mauc VL_CMV,												
	cisli940.t$docn$l NR_NF_FATURA,
	cisli940.t$seri$l NR_SERIE_NF_FATURA,
	  (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
	  where b.t$fire$l=tdrec940.t$fire$l
	  and a.t$fire$l=b.t$refr$l) NR_NF_REMESSA,									
	  (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
	  where b.t$fire$l=tdrec940.t$fire$l
	  and a.t$fire$l=b.t$refr$l) NR_SERIE_NF_REMESSA,		
	(SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
	WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
	AND tdrec942.t$line$l=tdrec941.t$line$l
	AND tdrec942.t$brty$l=5) VL_PIS,
	(SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
	WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
	AND tdrec942.t$line$l=tdrec941.t$line$l
	AND tdrec942.t$brty$l=6) VL_COFINS,
	znsls401.t$uneg$c CD_UNIDADE_NEGOCIO,
	CASE WHEN 
	nvl((select	znsls401nr.t$pecl$c
	FROM	tznsls401201 znsls401nr
	WHERE	znsls401nr.t$ncia$c=znsls401.t$ncia$c
	AND		znsls401nr.t$uneg$c=znsls401.t$uneg$c
	AND		znsls401nr.t$pecl$c=znsls401.t$pecl$c	 
	AND		znsls401nr.t$sqpd$c=znsls401.t$sqpd$c
	AND		znsls401nr.t$entr$c>znsls401.t$entr$c),1)=1 then 1
	ELSE 2
	END IN_REPOSICAO,
	(SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124
	WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
	AND tcemm124.t$loco=201
	AND rownum=1)	CD_UNIDADE_EMPRESARIAL,
	(select a.t$rcno from twhinh312201 a
		where a.t$oorg=1
		and a.t$orno=znsls401.t$orno$c
		and a.t$pono=znsls401.t$pono$c) NR_REC_DEVOLUCAO
FROM
	ttdrec940201 tdrec940,
	ttdrec941201 tdrec941
	LEFT JOIN ( SELECT 
				 whwmd217.t$item,
				 whwmd217.t$cwar,
				 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
				 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
				 end mauc
				 FROM twhwmd217201 whwmd217, twhwmd215201 whwmd215
				 WHERE whwmd215.t$cwar=whwmd217.t$cwar
				 AND whwmd215.t$item=whwmd217.t$item
				 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
	ON q1.t$item = tdrec941.t$item$l AND q1.t$cwar = tdrec941.t$cwar$l,
	ttdrec947201 tdrec947,
	tznsls401201 znsls401,
	tznsls401201 sls401orig,
	tznsls400201 znsls400,
	ttdsls400201 sls400orig,
	ttccom130201 tccom130,
	ttdsls401201 tdsls401orig,
	tcisli245201 cisli245,
	tcisli940201 cisli940
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