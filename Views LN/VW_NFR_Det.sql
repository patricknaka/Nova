-- #FAF.021 - 27-mai-2014, Fabio Ferreira, 	Corre��es de pendencias funcionais da �rea fiscal	
-- #FAF.051 - 27-mai-2014, Fabio Ferreira, 	Adicionado o campo CNPJ_CPF_ENTREGA					
--************************************************************************************************************************************************************
SELECT
  tdrec941.t$fire$l NR_REFERENCIA_FISCAL,
  201 CD_CIA,
  (SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm030.t$eunt=tcemm124.t$grid
  AND tcemm124.t$loco=201
  AND rownum=1) CD_FILIAL,
  (SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm124.t$loco=201
  AND rownum=1) CD_UNIDADE_EMPRESARIAL,
	(SELECT tdrec947.t$rcno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) RECEBIMENTO,
  tdrec940.t$docn$l NR_NF_RECEBIDA,
  tdrec941.t$line$l SQ_ITEM_NF_RECEBIDA,
  rtrim(ltrim(tdrec941.t$item$l)) CD_ITEM,
  tcibd936.t$frat$l CD_NBM,
  tcibd936.t$ifgc$l SQ_NBM,
  tdrec941.t$cwar$l CD_DEPOSITO,
  tdrec941.t$qnty$l QT_NOMINAL_NF,
  	(SELECT sum(tdrec947.t$qnty$l) FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) QT_RECEBIDA,
  tdrec941.t$pric$l VL_UNITARIO,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_PERCENTUAL_IPI,
  tdrec941.t$gamt$l VL_MERCADORIA,
  (SELECT tdrec942.t$sbas$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_BASE_ICMS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_PERCENTUAL_ICMS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=2) VL_ICMS_ST,
	nvl((SELECT tdrec942.t$amnt$l FROM ttdrec949201 tdrec949, ttdrec942201 tdrec942
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec942.t$fire$l=tdrec949.t$fire$l
	AND tdrec942.t$brty$l=tdrec949.t$brty$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec949.T$ISCO$C=1
	AND tdrec949.t$brty$l=2),0) VL_ICMS_ST_SEM_CONVENIO,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_IPI,
  
   (SELECT tdrec942.t$amnr$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_IPI_DESTACADO,
 
  nvl((	select sum(a.t$tamt$l) from ttdrec941201 a, ttcibd001201 b
		where a.t$fire$l=tdrec941.t$fire$l
		and b.t$item=a.t$item$l
		and b.t$kitm=5),0) VL_SERVICO, 
  
  tdrec941.t$gexp$l VL_DESPESA,
  tdrec941.t$addc$l VL_DESCONTO,
  tdrec941.t$fght$l VL_FRETE,
  0 VL_DESPESA_ACESSORIA,            -- *** DUVIDA ***
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) VL_PERCENTUAL_ISS,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) VL_ISS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) VL_PERCENTUAL_IRPF,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) VL_IRPF,
  0 NR_NFR_REFERENCIA,              -- *** DUVIDA ***
  0 NR_ITEM_NFR_REFERENCIA,            -- *** DUVIDA ***
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PIS,


  (SELECT tdrec942.t$fbex$l + tdrec942.t$fbot$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_BASE_ICMS_NAO_REDUTOR,  



  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS_MERCADORIA,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=1),0) VL_ICMS_FRETE,
  

  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=1),0) VL_ICM_OUTROS,  
  
  
  
  
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_COFINS,
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_COFINS_MERCADORIA,
  0 VL_COFINS_FRETE,
  0 VL_COFINS_OUTROS,
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PIS_MERCADORIA,
  0 VL_PIS_FRETE,
  0 VL_PIS_OUTROS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PERCENTUAL_PIS,
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_PERCENTUAL_COFINS,
  
  (SELECT tdrec942.t$rate$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_PERCENTUAL_CSLL,  

  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_CSLL,
  
  (SELECT tdrec942.t$amni$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_CSLL_MERCADORIA,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=13),0) VL_CSLL_FRETE,
  
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM 	ttdrec942201 tdrec942, 
											ttdrec941201 tdrec941b,
											ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=13),0) VL_CSLL_OUTROS, 
  

  tdrec941.t$addc$l VL_DESCONTO_INCONDICIONAL,
  tdrec941.t$rtin$l QT_NAO_RECEBIDA_DEVOLUCAO,     
  (SELECT tdrec942.t$base$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_BASE_IPI,
  (SELECT tdrec942.t$rdam$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_PERCENTUAL_REDUTOR_ICMS,
  tdrec941.t$tamt$l VL_TOTAL_ITEM_NF,
  tdrec941.t$ikit$c CD_ITEM_KIT,
  tdrec941.t$opfc$l VL_ICMS_ST1,
  tdrec941.t$opor$l SQ_NATUREZA_OPERACAO,
  (SELECT tdrec942.t$base$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) VL_BASE_IMPOSTO_IMPORTACAO,
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
  tdrec941.t$cchr$l VL_DESPESA_ADUANEIRA,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8
  THEN tdrec941.t$gexp$l ELSE 0
  END VL_ADICIONAL_IMPORTACAO,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5)
  ELSE 0 END VL_PIS_IMPORTACAO,
  
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) 
  ELSE 0 END VL_COFINS_IMPORTACAO, 
  
  CASE WHEN tdrec941.t$crpd$l=1 and (tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8) 
  THEN tdrec941.t$fght$l ELSE 0 END VL_CIF_IMPORTACAO,
  
  
	CAST((FROM_TZ(CAST(TO_CHAR(GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, tdrec940.t$odat$l, tdrec940.t$adat$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
			AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,   

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
  THEN tdrec941.t$copr$l ELSE 0 END VL_CUSTO_IMPORTACAO, 

  
 (SELECT tdrec942.t$amnr$l FROM ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS_DESTACADO, 
			

  tdrec941.t$qnty$l+tdrec941.t$saof$l QT_RECEBIDA_FISICA,
  	(SELECT tdrec947.t$orno$l FROM ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1)  NR_PEDIDO_COMPRA,
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