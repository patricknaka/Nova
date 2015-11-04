SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940dev.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
    13 CD_CIA,
	(SELECT tcemm030.t$euca FROM baandb.ttcemm124601 tcemm124, baandb.ttcemm030601 tcemm030
	WHERE tcemm124.t$cwoc=cisli940dev.t$cofc$l
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=601
	AND rownum=1) CD_FILIAL,
  tdrec940rec.t$docn$l NR_NF,									-- Nota fiscal recebimento devolução
  tdrec940rec.t$seri$l NR_SERIE_NF,						-- Serie NF rec. devolucção
	tdrec940rec.t$opfc$l CD_NATUREZA_OPERACAO,
	tdrec940rec.t$opor$l SQ_NATUREZA_OPERACAO,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940org.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_FATURA,
	cisli940org.t$itbp$l CD_CLIENTE_FATURA,
	cisli940org.t$stbp$l CD_CLIENTE_ENTREGA,
	znsls401org.t$sequ$c SQ_ENTREGA,
  CASE WHEN znmcs095.t$sige$c IS NOT NULL THEN
      'Sim' ELSE 'Nao' END  PEDIDO_SIGE,
	znsls401org.t$pecl$c NR_PEDIDO,
	(select znsls410.t$poco$c
	FROM baandb.tznsls410601 znsls410
	WHERE znsls410.t$ncia$c=znsls401dev.t$ncia$c
	AND znsls410.t$uneg$c=znsls401dev.t$uneg$c
	AND znsls410.t$pecl$c=znsls401dev.t$pecl$c
	AND znsls410.t$sqpd$c=znsls401dev.t$sqpd$c
	AND znsls410.t$entr$c=znsls401dev.t$entr$c
	AND znsls410.t$dtoc$c= (SELECT MAX(c.t$dtoc$c)
                          FROM baandb.tznsls410601 c
                          WHERE c.t$ncia$c=znsls410.t$ncia$c
                          AND c.t$uneg$c=znsls410.t$uneg$c
                          AND c.t$pecl$c=znsls410.t$pecl$c
                          AND c.t$sqpd$c=znsls410.t$sqpd$c
                          AND c.t$entr$c=znsls410.t$entr$c)                          
	AND rownum=1) CD_STATUS,
	(SELECT 
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.t$dtoc$c), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)
		FROM baandb.tznsls410601 znsls410
		WHERE znsls410.t$ncia$c=znsls401dev.t$ncia$c
		AND znsls410.t$uneg$c=znsls401dev.t$uneg$c
		AND znsls410.t$pecl$c=znsls401dev.t$pecl$c
		AND znsls410.t$sqpd$c=znsls401dev.t$sqpd$c
		AND znsls410.t$entr$c=znsls401dev.t$entr$c) DT_STATUS,									--#FAF.227.2
	tdrec940rec.t$rfdt$l CD_TIPO_NF,
	tdrec940rec.t$fire$l NR_REFERENCIA_FISCAL_DEVOLUCAO,										-- Ref. Fiscal recebimento devolção
	ltrim(rtrim(znsls401dev.t$item$c)) CD_ITEM,
	znsls401dev.t$qtve$c QT_DEVOLUCAO,
	(SELECT a.t$amnt$l FROM baandb.tcisli943601 a
	WHERE a.t$fire$l=cisli941dev.t$fire$l
	AND a.t$line$l=cisli941dev.t$line$l
	AND a.t$brty$l=1) VL_ICMS,										
	cisli941dev.t$gamt$l VL_PRODUTO,
	cisli941dev.t$fght$l VL_FRETE,
	cisli941dev.t$gexp$l VL_DESPESA,
	cisli941dev.t$tldm$l VL_DESCONTO_INCONDICIONAL,															--#FAF.227.1.n
	cisli941dev.t$amnt$l VL_TOTAL_ITEM,																		--#FAF.223.3.n
	znsls401org.t$orno$c NR_PEDIDO_ORIGINAL,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400org.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_PEDIDO,
	znsls400org.t$idca$c CD_CANAL_VENDAS,
	tccom130.t$ftyp$l CD_TIPO_CLIENTE,
	tccom130.t$ccit CD_CIDADE,
	tccom130.t$ccty CD_PAIS,
	tccom130.t$cste CD_ESTADO,
	q1.mauc VL_CMV,
  CASE WHEN znmcs095.t$sige$c IS NOT NULL THEN  --Pedido SIGE
      znmcs095.t$docn$c     
	ELSE cisli940org.t$docn$l END NR_NF_FATURA,												-- NF fatura entrega org
  CASE WHEN znmcs095.t$sige$c IS NOT NULL THEN  --Pedido SIGE
      znmcs095.t$seri$c
  ELSE cisli940org.t$seri$l END NR_SERIE_NF_FATURA,
  cisli940dev.t$fire$l NR_REF_FISCAL_REMESSA,
  SLI940DEV.STATUS     STATUS_REMESSA,   
	cisli940dev.t$docn$l NR_NF_REMESSA,												-- NF devolução							
	cisli940dev.t$seri$l NR_SERIE_NF_REMESSA,		
	(SELECT a.t$amnt$l FROM baandb.tcisli943601 a
	WHERE a.t$fire$l=cisli941dev.t$fire$l
	AND a.t$line$l=cisli941dev.t$line$l
	AND a.t$brty$l=5) VL_PIS,
	(SELECT a.t$amnt$l FROM baandb.tcisli943601 a
	WHERE a.t$fire$l=cisli941dev.t$fire$l
	AND a.t$line$l=cisli941dev.t$line$l
	AND a.t$brty$l=6) VL_COFINS,
	znsls401dev.t$uneg$c CD_UNIDADE_NEGOCIO,
	CASE WHEN 
	nvl((select	znsls401nr.t$pecl$c
	FROM	baandb.tznsls401601 znsls401nr
	WHERE	znsls401nr.t$ncia$c=znsls401dev.t$ncia$c
	AND		znsls401nr.t$uneg$c=znsls401dev.t$uneg$c
	AND		znsls401nr.t$pecl$c=znsls401dev.t$pecl$c	 
	AND		znsls401nr.t$sqpd$c=znsls401dev.t$sqpd$c
	AND		znsls401nr.t$entr$c>znsls401dev.t$entr$c
  AND   rownum=1),1)=1 then 2
	ELSE 1																									--#FAF.227.2
	END IN_REPOSICAO,
	(SELECT tcemm124.t$grid FROM baandb.ttcemm124601 tcemm124
	WHERE tcemm124.t$cwoc=cisli940dev.t$cofc$l
	AND tcemm124.t$loco=601
	AND rownum=1)	CD_UNIDADE_EMPRESARIAL,
	tdsls406rec.t$rcid NR_REC_DEVOLUCAO,
	znsls401dev.t$lcat$c NM_MOTIVO_CATEGORIA,																--#FAF.140.sn
	znsls401dev.t$lass$c NM_MOTIVO_ASSUNTO,
	znsls401dev.t$lmot$c NM_MOTIVO_ETIQUETA,
	CASE WHEN nvl((	select max(a.t$list$c) from baandb.tznsls405601 a
					where a.t$ncia$c=znsls401dev.t$ncia$c
					and a.t$uneg$c=znsls401dev.t$uneg$c
					and a.t$pecl$c=znsls401dev.t$pecl$c
					and a.t$sqpd$c=znsls401dev.t$sqpd$c
					and a.t$entr$c=znsls401dev.t$entr$c
					and a.t$sequ$c=znsls401dev.t$sequ$c),1)=0 THEN 1 ELSE 2 END ID_FORCADO,					--#FAF.140.en
	to_char(znsls401org.t$entr$c) NR_ENTREGA_ORIGINAL,																--#FAF.227.3.sn
	to_char(znsls401dev.t$entr$c) NR_ENTREGA_DEVOLUCAO,																	
	cisli941dev.t$cwar$l CD_ARMAZEM,
	cisli940org.t$fire$l NR_REFERENCIA_FISCAL_FATURA,																		--#FAF.227.3.en
	to_char(znsls401dev.t$ccat$c) CD_MOTIVO_CATEGORIA,																--#FAF.140.sn
	to_char(znsls401dev.t$cass$c) CD_MOTIVO_ASSUNTO,
	to_char(znsls401dev.t$cmot$c) CD_MOTIVO_ETIQUETA,
  tdsls400.t$orno NR_ORDEM_VENDA_DEVOLUCAO,
  tdsls400.t$hdst CD_STATUS_ORDEM_VDA_DEV,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) DT_ORDEM_VENDA_DEVOLUCAO,
	tcmcs080.t$suno			CD_PARCEIRO_TRANSPORTADORA_FAT,
	cisli941org.t$refr$l 	NR_REFERENCIA_FISCAL
         
FROM
				baandb.tznsls401601 znsls401dev								-- Pedido de devolução
   
  INNER JOIN  baandb.ttdsls400601 tdsls400
  ON tdsls400.t$orno = znsls401dev.t$orno$c
  
	INNER JOIN	baandb.tznsls401601 znsls401org								-- Pedido de venda original
			ON	znsls401org.t$pecl$c=znsls401dev.t$pvdt$c
			AND	znsls401org.t$ncia$c=znsls401dev.t$ncia$c
			AND	znsls401org.t$uneg$c=znsls401dev.t$uneg$c
			AND	znsls401org.t$entr$c=znsls401dev.t$endt$c
			AND	znsls401org.t$sequ$c=znsls401dev.t$sedt$c
	INNER JOIN	baandb.tznsls400601 znsls400org
			ON	znsls400org.t$ncia$c=znsls401org.t$ncia$c
			AND	znsls400org.t$uneg$c=znsls401org.t$uneg$c
			AND	znsls400org.t$pecl$c=znsls401org.t$pecl$c
			AND	znsls400org.t$sqpd$c=znsls401org.t$sqpd$c
	INNER JOIN 	baandb.tcisli245601 cisli245dev								-- Rel Devolução
			ON	cisli245dev.t$ortp=1
			AND	cisli245dev.t$koor=3
			AND	cisli245dev.t$slso=znsls401dev.t$orno$c
			AND	cisli245dev.t$pono=znsls401dev.t$pono$c
	INNER JOIN	baandb.tcisli940601 cisli940dev
			ON	cisli940dev.t$fire$l=cisli245dev.t$fire$l
	INNER JOIN	baandb.tcisli941601 cisli941dev
			ON	cisli941dev.t$fire$l=cisli245dev.t$fire$l
			AND	cisli941dev.t$line$l=cisli245dev.t$line$l
	INNER JOIN 	baandb.tcisli245601 cisli245org								-- Rel ordem orig
			ON	cisli245dev.t$ortp=1
			AND	cisli245dev.t$koor=3
			AND	cisli245org.t$slso=znsls401org.t$orno$c
			AND	cisli245org.t$pono=znsls401org.t$pono$c
	INNER JOIN	baandb.tcisli940601 cisli940org
			ON	cisli940org.t$fire$l=cisli245org.t$fire$l

	INNER JOIN	baandb.tcisli941601 cisli941org
			ON	cisli941org.t$fire$l=cisli245org.t$fire$l
			AND	cisli941org.t$line$l=cisli245org.t$line$l
			
	INNER JOIN	baandb.ttccom130601 tccom130
			ON	tccom130.t$cadr=cisli940org.t$stoa$l
	LEFT JOIN	baandb.ttcmcs080601 tcmcs080
			ON	tcmcs080.t$cfrw = cisli940org.t$cfrw$L			
	LEFT JOIN	baandb.ttdsls406601 tdsls406rec								-- Rec da devolução
			ON	tdsls406rec.t$orno=znsls401dev.t$orno$c
			AND	tdsls406rec.t$pono=znsls401dev.t$pono$c
	LEFT JOIN	baandb.ttdrec947601 tdrec947rec
			ON	tdrec947rec.t$oorg$l=1
			AND	tdrec947rec.t$orno$l=znsls401dev.t$orno$c
			AND	tdrec947rec.t$pono$l=znsls401dev.t$pono$c
	LEFT JOIN	baandb.ttdrec940601 tdrec940rec
			ON	tdrec940rec.t$fire$l=tdrec947rec.t$fire$l
	LEFT JOIN	baandb.ttdrec941601 tdrec941rec
			ON	tdrec941rec.t$fire$l=tdrec947rec.t$fire$l
			AND	tdrec941rec.t$line$l=tdrec947rec.t$line$l
	LEFT JOIN ( SELECT 
				 whwmd217.t$item,
				 whwmd217.t$cwar,
				 case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
				 else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
				 end mauc
				 FROM baandb.twhwmd217601 whwmd217, baandb.twhwmd215601 whwmd215
				 WHERE whwmd215.t$cwar=whwmd217.t$cwar
				 AND whwmd215.t$item=whwmd217.t$item
				 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
	ON q1.t$item = cisli941dev.t$item$l AND q1.t$cwar = cisli941dev.t$cwar$l
  
  LEFT JOIN baandb.tznmcs095601 znmcs095    --Pedidos Sige
         ON znmcs095.t$sige$c = znsls401dev.t$entr$c
  
   LEFT JOIN ( select l.t$desc STATUS,
                      d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.stat'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) SLI940DEV
        ON SLI940DEV.t$cnst = cisli940dev.t$stat$l        
