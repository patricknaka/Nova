SELECT 
  brnfe940.t$fire$l NR_NF_RASCUNHO,
	brnfe941.t$opfc$l CD_NATUREZA_OPERACAO_COMPRA,
	tcmcs940.t$opor$l SQ_NATUREZA_OPERACAO_COMPRA,
  1 CD_CIA,
	case when (SELECT tcemm030.t$euca FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc = tdpur400.t$cofc
	AND tcemm030.t$eunt = tcemm124.t$grid
	AND tcemm124.t$loco = 201
	AND rownum = 1)  =  ' ' then '0' else (SELECT tcemm030.t$euca FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc = tdpur400.t$cofc
	AND tcemm030.t$eunt = tcemm124.t$grid
	AND tcemm124.t$loco = 201
	AND rownum = 1) end CD_FILIAL,  --tratamento para trazer zero quando não tem filial
	tdpur400.t$otbp CD_FORNECEDOR,	
	TO_CHAR(brnfe940.t$docn$l) NR_NF_REFERENCIA,															--#FAF.022.1.n																
	brnfe940.t$seri$l NR_SERIE_NFR_REFERENCIA,											

--foi feito esse tratamento pq no LN existem Referências que estão com a Data de Emissão em branco
--e quando importamos os dados, eles estão vindo como 31/12/4711
  case when to_date(brnfe940.t$idat$l) = to_date('4712-01-01','yyyy-mm-dd HH24:MI:SS')
    then null else to_date(brnfe940.t$idat$l) end DT_EMISSAO_NF,

--  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--		AT time zone 'America/Sao_Paulo') AS DATE)DT_EMISSAO_NF,

  case when to_date(brnfe940.t$idat$l) = to_date('4712-01-01','yyyy-mm-dd HH24:MI:SS')
    then null else to_date(brnfe940.t$idat$l) end DT_SAIDA_NF,

--  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--		AT time zone 'America/Sao_Paulo') AS DATE)DT_SAIDA_NF,
    
	tdpur400.t$orno NR_PEDIDO_COMPRA,
	brnfe940.t$gtam$l VL_PRODUTO,
	brnfe940.t$gexp$l VL_DESPESA,
	brnfe940.t$addc$l VL_DESCONTO,
	brnfe940.t$fght$l VL_FRETE,
	brnfe940.t$insr$l VL_SEGURO,
	(SELECT SUM(i.t$amnt$l)
	FROM baandb.tbrnfe942201 i
	WHERE i.t$fire$l = brnfe940.t$fire$l
	AND i.t$brty$l = 1) VL_ICMS,
	(SELECT SUM(i.t$amnt$l)
	FROM baandb.tbrnfe942201 i
	WHERE i.t$fire$l = brnfe940.t$fire$l
	AND i.t$brty$l = 2) VL_ICMS_ST,
	(SELECT SUM(i.t$amnt$l)
	FROM baandb.tbrnfe942201 i
	WHERE i.t$fire$l = brnfe940.t$fire$l
	AND i.t$brty$l = 3) VL_IPI,
	brnfe940.t$tfda$l VL_TOTAL,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_GERACAO_REGISTRO,
	(select a.t$mess$c from baandb.tznnfe004201 a
	 where a.t$fire$c = brnfe940.t$fire$l
	 and a.t$mess$c! = ' '
	 and rownum = 1) DS_SITUACAO_ANALISE,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(brnfe940.t$fcdt$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) DT_ANALISE,	
	brnfe940.t$stpr$c CD_SITUACAO_RASCUNHO,																
	nvl((select t.t$text from baandb.ttttxt010201 t 
	where t$clan = 'p' AND t.t$ctxt = brnfe940.t$obse$l and rownum = 1),' ') DS_OBSERVACAO,																	
	(select ttdpur451201.t$logn
	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno
	and ttdpur451201.t$trdt = (select min(d.t$trdt)
							 from baandb.ttdpur451201 d 
							 where d.t$orno = ttdpur451201.t$orno) and rownum = 1) CD_USUARIO_INCLUSAO,
	(select 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ttdpur451201.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)																	--#FAF.235.n
	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno) DT_INCLUSAO,
	(select ttdpur451201.t$logn
	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno
	and ttdpur451201.t$trdt = (select max(d.t$trdt)
							 from baandb.ttdpur451201 d 
							 where d.t$orno = ttdpur451201.t$orno) and rownum = 1) CD_USUARIO_ALTERACAO,
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
    GREATEST(brnfe940.t$rcd_utc, tdpur400.t$rcd_utc),
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
--	(select 
--  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(ttdpur451201.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--		AT time zone 'America/Sao_Paulo') AS DATE)																	--#FAF.235.n	
--	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno) DT_ULT_ATUALIZACAO,
	(select ttdpur451201.t$logn
	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno
	and ttdpur451201.t$trdt = (select min(d.t$trdt)
							 from baandb.ttdpur451201 d 
							 where d.t$orno = ttdpur451201.t$orno
							 and d.t$clyn = 1) and rownum = 1 and ttdpur451201.t$clyn = 1) CD_USUARIO_CANCELAMENTO,
	(select 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(ttdpur451201.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)																	--#FAF.235.n	
	from baandb.ttdpur451201 where ttdpur451201.t$orno = tdpur400.t$orno and ttdpur451201.t$clyn = 1) DT_CANCELAMENTO,
	brnfe940.t$opor$l ESPECIE_NOTA_FISCAL_RECEBIDA,														
	brnfe940.t$frec$l NR_NOTA_RECEBIMENTO,																
	tdpur400.t$cwar CD_DEPOSITO,
	tdpur400.t$cpay CD_CONDICAO_PAGAMENTO,
	nvl((SELECT SUM(i.t$amnt$l)
	FROM baandb.tbrnfe942201 i WHERE i.t$fire$l = brnfe940.t$fire$l AND i.t$brty$l = 16),0) VL_IMPOSTO_IMPORTACAO,
	nvl((select sum(r.T$CCHR$L) FROM baandb.ttdrec941201 r
		where r.t$fire$l = brnfe940.t$frec$l),0) VL_DESPESA_ADUANEIRA,
	CASE WHEN tdpur400.t$rfdt$l = 37 THEN brnfe940.t$addc$l ELSE 0 END VL_ADICIONAL_IMPORTACAO,
	CASE WHEN tdpur400.t$rfdt$l = 37 THEN 
		(SELECT SUM(i.t$amnt$l) FROM baandb.tbrnfe942201 i
			WHERE i.t$fire$l = brnfe940.t$fire$l AND i.t$brty$l = 5) ELSE 0 END VL_PIS_IMPORTACAO,
	CASE WHEN tdpur400.t$rfdt$l = 37 THEN
		(SELECT SUM(i.t$amnt$l) FROM baandb.tbrnfe942201 i
			WHERE i.t$fire$l = brnfe940.t$fire$l AND i.t$brty$l = 6) ELSE 0 END VL_COFINS_IMPORTACAO,	
	CASE WHEN
		nvl((select a.t$cdec from baandb.ttdpur400201 a
			where a.t$orno = tdpur400.t$orno and a.t$cdec = '001' and rownum = 1),0) = 0 THEN 0
				ELSE brnfe940.t$fght$l END VL_CIF_IMPORTACAO,
	(SELECT tcemm124.t$grid FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
		WHERE tcemm124.t$cwoc = tdpur400.t$cofc AND tcemm124.t$loco = 201 AND rownum = 1) CD_UNIDADE_EMPRESARIAL
    
FROM baandb.tbrnfe940201 brnfe940
  
INNER JOIN	( select a.t$fire$l, a.t$opfc$l
              from baandb.tbrnfe941201 a
              where a.t$line$l = (	select min(b.t$line$l)
                                  from baandb.tbrnfe941201 b
                                  where b.t$tamt$l  =  (  select max(c.t$tamt$l) 
                                                        from baandb.tbrnfe941201 c
                                                        where c.t$fire$l = b.t$fire$l
                                                        and c.t$opfc$l! = ' ')
                                  and b.t$opfc$l! = ' ')) brnfe941
        ON brnfe941.t$fire$l = brnfe940.t$fire$l
        
INNER JOIN baandb.ttcmcs940201 tcmcs940
        ON 	tcmcs940.t$ofso$l = brnfe941.t$opfc$l
        
INNER JOIN (select distinct tdpur400.t$orno, 
                            znnfe007.t$fire$c, 
                            tdpur400.t$cofc, 
                            tdpur400.t$otbp, 
                            znnfe007.t$refr$c, 
                            tdpur400.t$rfdt$l, 
                            tdpur400.t$cpay, 
                            tdpur400.t$cwar, 
                            tdpur400.t$odat,
                            tdpur400.t$rcd_utc
            from 	baandb.tznnfe007201 znnfe007,
                  baandb.ttdpur400201 tdpur400
            where tdpur400.t$orno = znnfe007.t$orno$c
              and znnfe007.t$oorg$c = 80) tdpur400
      ON tdpur400.t$fire$c = brnfe940.t$fire$l
      
--WHERE
--    brnfe941.t$fire$l = brnfe940.t$fire$l
--AND	tcmcs940.t$ofso$l = brnfe941.t$opfc$l
--AND	tdpur400.t$fire$c = brnfe940.t$fire$l