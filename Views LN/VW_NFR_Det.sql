-- #FAF.021 - 27-mai-2014, Fabio Ferreira, 	Correções de pendencias funcionais da área fiscal	
-- #FAF.051 - 27-mai-2014, Fabio Ferreira, 	Adicionado o campo CNPJ_CPF_ENTREGA					
--************************************************************************************************************************************************************
SELECT
  tdrec941.t$fire$l REF_FISCAL,
  201 COMPANHIA,
  (SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm030.t$eunt=tcemm124.t$grid
  AND tcemm124.t$loco=201
  AND rownum=1) FILIAL,
  (SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm124.t$loco=201
  AND rownum=1) UNID_EMPRESARIAL,
	(SELECT tdrec947.t$rcno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) RECEBIMENTO,
  tdrec940.t$docn$l NUM_NOTA_RECEB,
  tdrec941.t$line$l SEQ_ITEM_NOTA_RECEB,
  rtrim(ltrim(tdrec941.t$item$l)) COD_ITEM,
  tcibd936.t$frat$l COD_NBM,
  tcibd936.t$ifgc$l SEQL_NBM,
  tdrec941.t$cwar$l COD_DEPOSITO,
  tdrec941.t$qnty$l QTD_NOMINAL_NOTA_FISCAL,
  	(SELECT sum(tdrec947.t$qnty$l) FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) QTD_RECEBIDA,
  tdrec941.t$pric$l PRECO_UNITARIO,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) PERCENTUAL_IPI,
  tdrec941.t$gamt$l VALOR_MERCADORIA,
  (SELECT tdrec942.t$sbas$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VALOR_BASE_ICMS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) PERCENTUAL_ICMS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VALOR_ICMS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=2) VALOR_ICMS_ST,
	nvl((SELECT tdrec942.t$amnt$l FROM ttdrec949201 tdrec949, ttdrec942201 tdrec942
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec942.t$fire$l=tdrec949.t$fire$l
	AND tdrec942.t$brty$l=tdrec949.t$brty$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec949.T$ISCO$C=1
	AND tdrec949.t$brty$l=2),0) VALOR_ICMS_ST_SEM_CONVENIO,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VALOR_IPI,
  
   (SELECT tdrec942.t$amnr$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VALOR_IPI_DESTACADO,
 
  nvl((	select sum(a.t$tamt$l) from ttdrec941201 a, ttcibd001201 b
		where a.t$fire$l=tdrec941.t$fire$l
		and b.t$item=a.t$item$l
		and b.t$kitm=5),0) VALOR_SERVICOS, 
  
  tdrec941.t$gexp$l VALOR_DESPESAS,
  tdrec941.t$addc$l VALOR_DESCONTO,
  tdrec941.t$fght$l VALOR_FRETE,
  0 VALOR_DESPESA_ACESSORIA,            -- *** DUVIDA ***
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) PERCENTUAL_ISS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) VALOR_ISS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) PERCENTUAL_IRPF,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) VALOR_IRRF,
  0 NUM_NOTA_RECEB_REF,              -- *** DUVIDA ***
  0 NUM_ITEM_NOTA_RECEB_REF,            -- *** DUVIDA ***
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VALOR_PIS,


  (SELECT tdrec942.t$fbex$l + tdrec942.t$fbot$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) BASE_ICMS_NAO_REDUTOR,  



  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VALOR_ICMS_MERCADORIA,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=1),0) VALOR_ICMS_FRETE,
  

  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=1),0) VALOR_ICM_OUTROS,  
  
  
  
  
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VALOR_COFINS,
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VALOR_COFINS_MERCADORIA,
  0 VALOR_COFINS_FRETE,
  0 VALOR_COFINS_OUTRO,
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VALOR_PIS_MERCADORIA,
  0 VALOR_PIS_FRETE,
  0 VALOR_PIS_OUTROS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) PERCENTUAL_PIS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) PERCENTUAL_COFINS,
  
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) PERCENTUAL_CSLL,  

  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VALOR_CSLL,
  
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VALOR_CSLL_MERCADORIA,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=13),0) VALOR_CSLL_FRETE,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=13),0) VALOR_CSLL_OUTROS, 
  

  -- VALOR_DESCONTO_CONDICIONAL,            *** DESCONSIDERAR ****
  tdrec941.t$addc$l VALOR_DESCONTO_INCONDICIONAL,
  tdrec941.t$rtin$l QTD_NAO_RECEB_SER_DEVOLVIDA,     
  (SELECT tdrec942.t$base$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) BASE_IPI,
  (SELECT tdrec942.t$rdam$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) PERCENTUAL_REDUTOR_ICMS,
  tdrec941.t$tamt$l VALOR_TOTAL_ITEM_NOTA,
  tdrec941.t$ikit$c COD_ITEM_KIT,
  tdrec941.t$opfc$l COD_NATUREZA_OPERACAO,
  tdrec941.t$opor$l SEQ_NATUREZA_OPERACAO,
  (SELECT tdrec942.t$base$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) BASE_IMPOSTO_IMPOTACAO,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) VALOR_IMPOSTO_IMPOTACAO,
  tdrec941.t$cchr$l VALOR_DESPESA_ADUANEIRA,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8
  THEN tdrec941.t$gexp$l ELSE 0
  END VALOR_ADICIONAL_IMPOTACAO,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5)
  ELSE 0 END VALOR_PIS_IMPOTACAO,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) 
  ELSE 0 END VALOR_COFINS_IMPOTACAO, 
  
  CASE WHEN tdrec941.t$crpd$l=1 and (tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8) 
  THEN tdrec941.t$fght$l ELSE 0 END VALOR_CIF_IMPOTACAO,
  
  
	CAST((FROM_TZ(CAST(TO_CHAR(GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, tdrec940.t$odat$l, tdrec940.t$adat$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_HR_ATUALIZACAO,   

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
  THEN tdrec941.t$copr$l ELSE 0 END VALOR_CUSTO_IMPOTACAO, 

  
 (SELECT tdrec942.t$amnr$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VALOR_ICMS_DESTACADO, 
			

  tdrec941.t$qnty$l+tdrec941.t$saof$l QTD_RECEBIDA_FISICA,
  	(SELECT tdrec947.t$orno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1)  NUM_PEDIDO_COMPRA,
	CASE WHEN tdrec940.t$stoa$l=' ' THEN
	tdrec940.t$ctno$l ELSE
	(select e.t$fovn$l from ttccom130201 e
	 where e.t$cadr=tdrec940.t$stoa$l)
	END CNPJ_CPF_ENTREGA 
	
FROM
  ttdrec941201 tdrec941,
  ttdrec940201 tdrec940,
  ttcibd001201 tcibd001,
  ttcibd936201 tcibd936
WHERE
  tcibd001.t$item=tdrec941.t$item$l
AND tcibd936.t$ifgc$l=tcibd001.t$ifgc$l
AND tdrec940.t$fire$l=tdrec941.t$fire$l
AND tdrec940.t$rfdt$l not in (3,5,8,13,16,22,33)
AND tdrec940.t$stat$l>3