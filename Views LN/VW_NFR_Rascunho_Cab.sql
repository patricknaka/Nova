-- #FAF.022 - 27-mai-2014, Fabio Ferreira, 	Correções e alteração da origem da informação para os dados da pré-nota			
--************************************************************************************************************************************************************
SELECT 
	brnfe940.t$fire$l NUM_RASCUNHO,
	
	brnfe941.t$opfc$l COD_NATUREZA_OPERACAO_COMPRA,
	tcmcs940.t$opor$l SEQ_NATUREZA_OPR_COMPRA,
    201 COD_CIA,
	(SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdpur400.t$cofc
	AND tcemm030.t$eunt=tcemm124.t$grid
	AND tcemm124.t$loco=201
	AND rownum=1) COD_FILIAL,
	(SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
	WHERE tcemm124.t$cwoc=tdpur400.t$cofc
	AND tcemm124.t$loco=201
	AND rownum=1) UNID_EMPRESARIAL,	
	tdpur400.t$otbp COD_FORNECEDOR,	

	
	brnfe940.t$docn$l NUM_NOTA_FISCAL_REFERENCIA,	
	brnfe940.t$seri$l SÉRIE_NOTA_FISCAL_REFERENCIA,											
	brnfe940.t$idat$l DT_EMISSAO_NOTA_FISCAL,													
	brnfe940.t$iodt$l DT_SAIDA_NOTA_FISCAL,													
	tdpur400.t$orno NUM_PEDIDO_COMPRA,
	brnfe940.t$gtam$l VALOR_PRODUTO,
	brnfe940.t$gexp$l VALOR_DESPESA,
	brnfe940.t$addc$l VALOR_DESCONTO,
	brnfe940.t$fght$l VALOR_FRETE,
	brnfe940.t$insr$l VALOR_SEGURO,
	-- VALOR_DESCONTO_CONDICIONAL																		-- *** DESCONSIDERAR ****
	brnfe940.t$addc$l VALOR_DESCONTO_INCONDICIONAL,														-- *** Não existe no LN na pré nota a separação da despes e despesa incondicional
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=1) VALOR_ICMS,
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=2) VALOR_ICMS_ST,
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=3) VALOR_IPI,
	brnfe940.t$tfda$l VALOR_TOTAL ,
	
	CAST((FROM_TZ(CAST(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DT_GERACAO_REGISTRO,
	
	 
	(select a.t$mess$c from tznnfe004201 a
	 where a.t$fire$c=brnfe940.t$fire$l
	 and a.t$mess$c!=' '
	 and rownum=1) SITUACAO_ANALISE,
	
	CAST((FROM_TZ(CAST(TO_CHAR(brnfe940.t$fcdt$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
		AT time zone sessiontimezone) AS DATE) DATA_ANALISE,	
	

	brnfe940.t$stpr$c SITUACAO_RASCUNHO,																
	nvl((select t.t$text from ttttxt010201 t 
	where t$clan='p'
	AND t.t$ctxt=brnfe940.t$obse$l
	and rownum=1),' ') OBSERVACAO,																	
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno
	and ttdpur451201.t$trdt=(select min(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno)
	and rownum=1) COD_USUARIO_INCLUSAO,
	(select min(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno) DT_INCLUSAO,
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno
	and ttdpur451201.t$trdt=(select max(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno)
	and rownum=1) COD_USUARIO_ALTERACAO,
	(select max(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno) DT_ALTERACAO,
	(select ttdpur451201.t$logn
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno
	and ttdpur451201.t$trdt=(select min(d.t$trdt)
							 from ttdpur451201 d 
							 where d.t$orno=ttdpur451201.t$orno
							 and d.t$clyn=1)
	and rownum=1
	and ttdpur451201.t$clyn=1) COD_USUARIO_CANCELAMENTO,
	(select min(ttdpur451201.t$trdt)
	from ttdpur451201 
	where ttdpur451201.t$orno=tdpur400.t$orno
	and ttdpur451201.t$clyn=1) DT_CANCELAMENTO,
	brnfe940.t$opor$l ESPÉCIE_NOTA_FISCAL_RECEBIDA,														
	brnfe940.t$frec$l NUM_NOTA_RECEBIMENTO,																
	tdpur400.t$cwar COD_DEPOSITO,
	tdpur400.t$cpay COD_CONDICAO_PAGAMENTO,
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=16) VALOR_IMPOSTO_IMPORTACAO,
	nvl((select sum(r.T$CCHR$L) FROM ttdrec941201 r
  where r.t$fire$l=brnfe940.t$frec$l),0)   VALOR_DESPESA_ADUANEIRO,
  

	CASE WHEN tdpur400.t$rfdt$l=37 THEN brnfe940.t$addc$l ELSE 0 END VALOR_ADICIONAL_IMPORTACAO,

	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=5)
	ELSE 0 END VALOR_PIS_IMPORTACAO,
	
	CASE WHEN tdpur400.t$rfdt$l=37 THEN
	(SELECT SUM(i.t$amnt$l)
	FROM tbrnfe942201 i
	WHERE i.t$fire$l=brnfe940.t$fire$l
	AND i.t$brty$l=6)
	ELSE 0 END VALOR_COFINS_IMPORTACAO,	


	CASE WHEN
	nvl((select a.t$cdec from ttdpur400201 a
		where a.t$orno=tdpur400.t$orno
		and a.t$cdec='001'
		and rownum=1),0)=0 THEN 0
	ELSE brnfe940.t$fght$l
	END VALOR_CIF_IMPORTACAO	
FROM
	tbrnfe940201 brnfe940,
	
	(select a.t$fire$l, a.t$opfc$l
	from tbrnfe941201 a
	where a.t$line$l=(	select min(b.t$line$l)
						from tbrnfe941201 b
						where b.t$tamt$l = (select max(c.t$tamt$l) from tbrnfe941201 c
											where c.t$fire$l=b.t$fire$l
											and c.t$opfc$l!=' ')
						and b.t$opfc$l!=' ')) brnfe941,
	
	ttcmcs940201 tcmcs940,
	(select distinct tdpur400.t$orno, znnfe007.t$fire$c, tdpur400.t$cofc, tdpur400.t$otbp, znnfe007.t$refr$c, tdpur400.t$rfdt$l, tdpur400.t$cpay, tdpur400.t$cwar, tdpur400.t$odat
	 from 	tznnfe007201 znnfe007,
			ttdpur400201 tdpur400
	 where tdpur400.t$orno=znnfe007.t$orno$c
	 and znnfe007.t$oorg$c=80) tdpur400

						 
WHERE
    brnfe941.t$fire$l=brnfe940.t$fire$l
AND	tcmcs940.t$ofso$l=brnfe941.t$opfc$l
AND	tdpur400.t$fire$c=brnfe940.t$fire$l
	

