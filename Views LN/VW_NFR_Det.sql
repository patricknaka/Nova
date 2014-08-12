-- #FAF.021 - 27-mai-2014, Fabio Ferreira, 	Correções de pendencias funcionais da área fiscal	
-- #FAF.051 - 27-mai-2014, Fabio Ferreira, 	Adicionado o campo CNPJ_CPF_ENTREGA	
-- #FAF.114 - 07-jun-2014, Fabio Ferreira, 	Correção QTD_FISICA_RECEBIDA
-- #FAF.119 - 09-jun-2014, Fabio Ferreira, 	Inclusão do campo IVA (margem)	
-- #FAF.119 - 09-jun-2014, Fabio Ferreira, 	Retirado campo VL_ICMS_ST1
-- #FAF.151 - 20-jun-2014, Fabio Ferreira,	Tratamento para o CNPJ			
-- #MAT.001 - 31-jul-2014, Marcia A. Torres, Correção do campo DT_ATUALIZACAO
-- #FAF.242 - 04-ago-2014, Fabio Ferreira,	Correções	
-- #FAF.279 - 12-ago-2014, Fabio Ferreira,	Correções ICMS não redutor
--************************************************************************************************************************************************************
SELECT
  201 CD_CIA,
  (SELECT tcemm030.t$euca FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm030.t$eunt=tcemm124.t$grid
  AND tcemm124.t$loco=201
  AND rownum=1) CD_FILIAL,
  tdrec940.t$docn$l NR_NF_RECEBIDA,
  tdrec941.t$line$l SQ_ITEM_NF_RECEBIDA,
  rtrim(ltrim(tdrec941.t$item$l)) CD_ITEM,
  tcibd936.t$frat$l CD_NBM,
  tcibd936.t$ifgc$l SQ_NBM,
  tdrec941.t$cwar$l CD_DEPOSITO,
  tdrec941.t$qnty$l QT_NOMINAL_NF,
  	(SELECT sum(tdrec947.t$qnty$l) FROM baandb.ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) QT_RECEBIDA,
  tdrec941.t$pric$l VL_UNITARIO,
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_PERCENTUAL_IPI,
  tdrec941.t$gamt$l VL_MERCADORIA,
  (SELECT tdrec942.t$sbas$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_BASE_ICMS,
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_PERCENTUAL_ICMS,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=2) VL_ICMS_ST,
	nvl((SELECT tdrec942.t$amnt$l FROM baandb.ttdrec949201 tdrec949, baandb.ttdrec942201 tdrec942
	WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	AND tdrec942.t$fire$l=tdrec949.t$fire$l
	AND tdrec942.t$brty$l=tdrec949.t$brty$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec949.T$ISCO$C=1
	AND tdrec949.t$brty$l=2),0) VL_ICMS_ST_SEM_CONVENIO,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_IPI,
   (SELECT tdrec942.t$amnr$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_IPI_DESTACADO,
  nvl((	select sum(a.t$tamt$l) from baandb.ttdrec941201 a, baandb.ttcibd001201 b
		where a.t$fire$l=tdrec941.t$fire$l
		and b.t$item=a.t$item$l
		and b.t$kitm=5),0) VL_SERVICO, 
  tdrec941.t$gexp$l VL_DESPESA,
  tdrec941.t$addc$l VL_DESCONTO,
  tdrec941.t$fght$l VL_FRETE,
  0 VL_DESPESA_ACESSORIA,            -- *** DUVIDA ***
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) VL_PERCENTUAL_ISS,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=7) VL_ISS,
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) VL_PERCENTUAL_IRPF,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
  AND tdrec942.t$amnt$l>0
  AND rownum=1) VL_IRPF,
  0 NR_NFR_REFERENCIA,              -- *** DUVIDA ***
  0 NR_ITEM_NFR_REFERENCIA,            -- *** DUVIDA ***
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PIS,
--  (SELECT tdrec942.t$fbex$l + tdrec942.t$fbot$l FROM baandb.ttdrec942201 tdrec942						--#FAF.279.o
  (SELECT CASE WHEN tdrec942.t$rdbc$l!=0 then tdrec942.t$base$l/tdrec942.t$rdbc$l else 0 end			--#FAF.279.n
  FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_BASE_ICMS_NAO_REDUTOR,  
  (SELECT tdrec942.t$amni$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS_MERCADORIA,
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 
											baandb.ttdrec941201 tdrec941b,
											baandb.ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=1),0) VL_ICMS_FRETE,
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 
											baandb.ttdrec941201 tdrec941b,
											baandb.ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=1),0) VL_ICM_OUTROS,  
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_COFINS,
  (SELECT tdrec942.t$amni$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_COFINS_MERCADORIA,
--  0 VL_COFINS_FRETE,																		--#FAF.242.o
  
  
	nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 					--#FAF.242.sn
												baandb.ttdrec941201 tdrec941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	tdrec942.t$fire$l=tdrec941b.t$fire$l
		AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
		AND		tcibd001b.t$item=tdrec941b.t$item$l
		AND   	tdrec942.t$line$l=tdrec941b.t$line$l												
		AND		tcibd001b.t$ctyp$l=2
		AND 	tdrec942.t$brty$l=6),0) VL_COFINS_FRETE,

--  0 VL_COFINS_OUTROS,																		--#FAF.242.o
	nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 					
												baandb.ttdrec941201 tdrec941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	tdrec942.t$fire$l=tdrec941b.t$fire$l
		AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
		AND		tcibd001b.t$item=tdrec941b.t$item$l
		AND   	tdrec942.t$line$l=tdrec941b.t$line$l												
		AND		tcibd001b.t$kitm>3
		AND		tcibd001b.t$ctyp$l!=2
		AND 	tdrec942.t$brty$l=6),0) VL_COFINS_OUTROS,									--#FAF.242.en
  (SELECT tdrec942.t$amni$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PIS_MERCADORIA,
  
  
	nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 					--#FAF.242.sn
												baandb.ttdrec941201 tdrec941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	tdrec942.t$fire$l=tdrec941b.t$fire$l
		AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
		AND		tcibd001b.t$item=tdrec941b.t$item$l
		AND   	tdrec942.t$line$l=tdrec941b.t$line$l												
		AND		tcibd001b.t$ctyp$l=2
		AND 	tdrec942.t$brty$l=5),0) VL_PIS_FRETE,
		
	nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 					
												baandb.ttdrec941201 tdrec941b,
												baandb.ttcibd001201 tcibd001b
		WHERE 	tdrec942.t$fire$l=tdrec941b.t$fire$l
		AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
		AND		tcibd001b.t$item=tdrec941b.t$item$l
		AND   	tdrec942.t$line$l=tdrec941b.t$line$l												
		AND		tcibd001b.t$kitm>3
		AND		tcibd001b.t$ctyp$l!=2
		AND 	tdrec942.t$brty$l=5),0) VL_PIS_OUTROS,									--#FAF.242.en
  
--  0 VL_PIS_FRETE,																			--#FAF.242.o
--  0 VL_PIS_OUTROS,																		--#FAF.242.o
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5) VL_PERCENTUAL_PIS,
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) VL_PERCENTUAL_COFINS,
  (SELECT tdrec942.t$rate$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_PERCENTUAL_CSLL,  
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_CSLL,
  (SELECT tdrec942.t$amni$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=13) VL_CSLL_MERCADORIA,
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 
											baandb.ttdrec941201 tdrec941b,
											baandb.ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$ctyp$l=2
  AND 	tdrec942.t$brty$l=13),0) VL_CSLL_FRETE,
  nvl((SELECT sum(tdrec942.t$amnt$l) FROM baandb.ttdrec942201 tdrec942, 
											baandb.ttdrec941201 tdrec941b,
											baandb.ttcibd001201 tcibd001b
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
  AND	tcibd001b.t$item=tdrec941b.t$item$l
  AND	tcibd001b.t$kitm>3
  AND	tcibd001b.t$ctyp$l!=2
  AND 	tdrec942.t$brty$l=13),0) VL_CSLL_OUTROS, 
--  tdrec941.t$addc$l VL_DESCONTO_INCONDICIONAL,														--#FAF.242.o
  tdrec941.t$rtin$l QT_NAO_RECEBIDA_DEVOLUCAO,     
  (SELECT tdrec942.t$base$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=3) VL_BASE_IPI,
--  (SELECT tdrec942.t$rdam$l FROM baandb.ttdrec942201 tdrec942											--#FAF.279.o
  (SELECT tdrec942.t$rdbc$l FROM baandb.ttdrec942201 tdrec942											--#FAF.279.n
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_PERCENTUAL_REDUTOR_ICMS,
  tdrec941.t$tamt$l VL_TOTAL_ITEM_NF,
  tdrec941.t$ikit$c CD_ITEM_KIT,
--  tdrec941.t$opfc$l VL_ICMS_ST1,*********																--#FAF.126.o
  tdrec941.T$OPFC$L CD_NATUREZA_OPERACAO,
  tdrec941.t$opor$l SQ_NATUREZA_OPERACAO,
  (SELECT tdrec942.t$base$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) VL_BASE_IMPOSTO_IMPORTACAO,
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=16) VL_IMPOSTO_IMPORTACAO,
  tdrec941.t$cchr$l VL_DESPESA_ADUANEIRA,
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8
  THEN tdrec941.t$gexp$l ELSE 0
  END VL_ADICIONAL_IMPORTACAO,
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=5)
  ELSE 0 END VL_PIS_IMPORTACAO,
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 THEN
  (SELECT tdrec942.t$amnt$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=6) 
  ELSE 0 END VL_COFINS_IMPORTACAO, 
  CASE WHEN tdrec941.t$crpd$l=1 and (tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8) 
  THEN tdrec941.t$fght$l ELSE 0 END VL_CIF_IMPORTACAO,
--  CAST((FROM_TZ(CAST(TO_CHAR(GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, tdrec940.t$odat$l, tdrec940.t$adat$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT')  --#MAT.001.o
    CAST((FROM_TZ(CAST(TO_CHAR(tdrec940.t$rcd_utc, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT')  --#MAT.001.n
    AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,   
  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
  THEN tdrec941.t$copr$l ELSE 0 END VL_CUSTO_IMPORTACAO, 
 (SELECT tdrec942.t$amnr$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=1) VL_ICMS_DESTACADO, 
  --tdrec941.t$qnty$l+tdrec941.t$saof$l QT_RECEBIDA_FISICA,													--#FAF.114.o
	nvl((select sum(ra.t$qrec) from baandb.twhinh312201 ra, baandb.ttdrec947201 rr
		 where rr.t$fire$l=tdrec941.t$fire$l
		 and rr.t$line$l=tdrec941.t$line$l
		 and ra.t$rcno=rr.t$rcno$l
		 and ra.t$rcln=rr.t$rcln$l),0) QT_RECEBIDA_FISICA,													--#FAF.114.n
  	(SELECT tdrec947.t$orno$l FROM baandb.ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1)  NR_PEDIDO_COMPRA,
  (SELECT tcemm124.t$grid FROM baandb.ttcemm124201 tcemm124, baandb.ttcemm030201 tcemm030
  WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
  AND tcemm124.t$loco=201
  AND rownum=1) CD_UNIDADE_EMPRESARIAL,
  tdrec941.t$fire$l NR_REFERENCIA_FISCAL,
  (SELECT tdrec947.t$rcno$l FROM baandb.ttdrec947201 tdrec947
	WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	AND tdrec947.t$line$l=tdrec941.t$line$l
	AND rownum=1) NR_NFR,
	CASE WHEN tdrec940.t$stoa$l=' ' THEN
	
        CASE WHEN regexp_replace(tdrec940.t$ctno$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tdrec940.t$ctno$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tdrec940.t$ctno$l, '[^0-9]', '') END													--#FAF.151.n	
	ELSE
	--tdrec940.t$ctno$l ELSE																						--FAF.151.o
	(select 
        CASE WHEN regexp_replace(e.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(e.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(e.t$fovn$l, '[^0-9]', '') END															--FAF.151.n
	 --e.t$fovn$l 																									--FAF.151.o
	 from baandb.ttccom130201 e
	 where e.t$cadr=tdrec940.t$stoa$l)
	END NR_CNPJ_CPF_ENTREGA ,
  nvl((SELECT tdrec942.t$nmrg$l FROM baandb.ttdrec942201 tdrec942
  WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
  AND tdrec942.t$line$l=tdrec941.t$line$l
  AND tdrec942.t$brty$l=2),0) VL_IVA																				--#FAF.119.n
FROM
  baandb.ttdrec941201 tdrec941,
  baandb.ttdrec940201 tdrec940,
  baandb.ttcibd001201 tcibd001,
  baandb.ttcibd936201 tcibd936
WHERE
  tcibd001.t$item=tdrec941.t$item$l
AND tcibd936.t$ifgc$l=tcibd001.t$ifgc$l
AND tdrec940.t$fire$l=tdrec941.t$fire$l
AND tdrec940.t$rfdt$l not in (3,5,8,13,16,22,33)
AND tdrec940.t$stat$l>3