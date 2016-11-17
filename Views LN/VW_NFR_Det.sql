SELECT
  1                                                                           CD_CIA,

  CASE WHEN (SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124301 tcemm124, 
           baandb.ttcemm030301 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
      AND tcemm030.t$eunt=tcemm124.t$grid
      AND tcemm124.t$loco=301
      AND rownum=1) = ' ' 
  THEN '0' 
  ELSE (SELECT tcemm030.t$euca 
          FROM baandb.ttcemm124301 tcemm124, 
               baandb.ttcemm030301 tcemm030
          WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
          AND tcemm030.t$eunt=tcemm124.t$grid
          AND tcemm124.t$loco=301
          AND rownum=1) END                                                   CD_FILIAL,

  tdrec940.t$docn$l                                                           NR_NF_RECEBIDA,
  tdrec941.t$line$l                                                           SQ_ITEM_NF_RECEBIDA,
  rtrim(ltrim(tdrec941.t$item$l))                                             CD_ITEM,
  tcibd936.t$frat$l                                                           CD_NBM,
  tcibd936.t$ifgc$l                                                           SQ_NBM,
  tdrec941.t$cwar$l                                                           CD_DEPOSITO,
  tdrec941.t$qnty$l                                                           QT_NOMINAL_NF,

  (SELECT sum(tdrec947.t$qnty$l) 
      FROM baandb.ttdrec947301 tdrec947
	    WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	    AND tdrec947.t$line$l=tdrec941.t$line$l
	    )                                                           QT_RECEBIDA,

  tdrec941.t$pric$l                                                           VL_UNITARIO,

  (SELECT tdrec942.t$rate$l 
      FROM baandb.ttdrec942301 tdrec942
      WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
      AND tdrec942.t$line$l=tdrec941.t$line$l
      AND tdrec942.t$brty$l=3)                                                VL_PERCENTUAL_IPI,

  tdrec941.t$gamt$l                                                           VL_MERCADORIA,

  (SELECT tdrec942.t$sbas$l 
      FROM baandb.ttdrec942301 tdrec942
      WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
      AND tdrec942.t$line$l=tdrec941.t$line$l
      AND tdrec942.t$brty$l=1)                                                VL_BASE_ICMS,

  (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 VL_PERCENTUAL_ICMS,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 VL_ICMS,

  (SELECT tdrec942.t$rdbc$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 PERC_REDUCAO_BASE_ICMS,
     
  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=2)                                                 VL_ICMS_ST,

  (SELECT tdrec942.t$base$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=2
     AND tdrec942.t$amnt$l != 0)                                              BASE_ICMS_ST,
 
   (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=2
     AND tdrec942.t$amnt$l != 0)                                               ALIQ_ICMS_ST,

   (SELECT tdrec942.t$nmra$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=2)                                                 MARGEM_LUCRO_AJUSTADO,
     
	nvl((SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec949301 tdrec949, 
          baandb.ttdrec942301 tdrec942
	   WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
	   AND tdrec942.t$fire$l=tdrec949.t$fire$l
	   AND tdrec942.t$brty$l=tdrec949.t$brty$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec949.T$ISCO$C=1
	   AND tdrec949.t$brty$l=2),0)                                              VL_ICMS_ST_SEM_CONVENIO,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=3)                                                 VL_IPI,

  (SELECT tdrec942.t$amnr$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=3)                                                 VL_IPI_DESTACADO,

  nvl((	select sum(a.t$tamt$l) 
     from baandb.ttdrec941301 a, 
          baandb.ttcibd001301 b
		 where a.t$fire$l=tdrec941.t$fire$l
		 and b.t$item=a.t$item$l
		 and b.t$kitm=5),0)                                                       VL_SERVICO, 

  tdrec941.t$gexp$l                                                           VL_DESPESA,
  tdrec941.t$addc$l                                                           VL_DESCONTO,

  CAST(tdrec941.t$fght$l AS DECIMAL(18,2))                                    VL_FRETE,
  0                                                                           VL_DESPESA_ACESSORIA,            -- *** DUVIDA ***

  (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=7)                                                 VL_PERCENTUAL_ISS,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=7)                                                 VL_ISS,

  (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
     AND tdrec942.t$amnt$l>0
     AND rownum=1)                                                            VL_PERCENTUAL_IRPF,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND (tdrec942.t$brty$l=9 OR tdrec942.t$brty$l=10)
     AND tdrec942.t$amnt$l>0
     AND rownum=1)                                                            VL_IRPF,

  0                                                                           NR_NFR_REFERENCIA,              -- *** DUVIDA ***
  0                                                                           NR_ITEM_NFR_REFERENCIA,            -- *** DUVIDA ***

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=5)                                                 VL_PIS,

  cast((SELECT CASE WHEN tdrec942.t$rdbc$l!=0 then tdrec942.t$base$l 
     else 0 end FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1) as numeric (12,2))                              VL_BASE_ICMS_NAO_REDUTOR,  

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 VL_ICMS_MERCADORIA,

  nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
     AND	tcibd001b.t$item=tdrec941b.t$item$l
     AND	tcibd001b.t$ctyp$l=2
     AND 	tdrec942.t$brty$l=1),0)                                             VL_ICMS_FRETE,

  nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND 	tdrec941b.t$fire$l=tdrec941.t$fire$l
     AND	tcibd001b.t$item=tdrec941b.t$item$l
     AND	tcibd001b.t$kitm>3
     AND	tcibd001b.t$ctyp$l!=2
     AND 	tdrec942.t$brty$l=1),0)                                             VL_ICM_OUTROS,  

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=6)                                                 VL_COFINS,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=6)                                                 VL_COFINS_MERCADORIA,

	nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
     WHERE tdrec942.t$fire$l=tdrec941b.t$fire$l
		 AND tdrec941b.t$fire$l=tdrec941.t$fire$l
		 AND tcibd001b.t$item=tdrec941b.t$item$l
		 AND tdrec942.t$line$l=tdrec941b.t$line$l												
		 AND tcibd001b.t$ctyp$l=2
		 AND tdrec942.t$brty$l=6),0)                                              VL_COFINS_FRETE,

	nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 					
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
		 WHERE tdrec942.t$fire$l=tdrec941b.t$fire$l
		 AND tdrec941b.t$fire$l=tdrec941.t$fire$l
		 AND tcibd001b.t$item=tdrec941b.t$item$l
		 AND tdrec942.t$line$l=tdrec941b.t$line$l												
		 AND tcibd001b.t$kitm>3
		 AND tcibd001b.t$ctyp$l!=2
		 AND tdrec942.t$brty$l=6),0)                                              VL_COFINS_OUTROS,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=5)                                                 VL_PIS_MERCADORIA,
  
	nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942,
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
		 WHERE tdrec942.t$fire$l=tdrec941b.t$fire$l
		 AND tdrec941b.t$fire$l=tdrec941.t$fire$l
		 AND tcibd001b.t$item=tdrec941b.t$item$l
		 AND tdrec942.t$line$l=tdrec941b.t$line$l												
		 AND tcibd001b.t$ctyp$l=2
		 AND tdrec942.t$brty$l=5),0)                                              VL_PIS_FRETE,
		
	nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 					
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
		 WHERE tdrec942.t$fire$l=tdrec941b.t$fire$l
		 AND tdrec941b.t$fire$l=tdrec941.t$fire$l
		 AND tcibd001b.t$item=tdrec941b.t$item$l
		 AND tdrec942.t$line$l=tdrec941b.t$line$l												
		 AND tcibd001b.t$kitm>3
		 AND tcibd001b.t$ctyp$l!=2
		 AND tdrec942.t$brty$l=5),0)                                              VL_PIS_OUTROS,

  (SELECT tdrec942.t$rate$l
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=5)                                                 VL_PERCENTUAL_PIS,

  (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=6)                                                 VL_PERCENTUAL_COFINS,

  (SELECT tdrec942.t$rate$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=13)                                                VL_PERCENTUAL_CSLL,  

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=13)                                                VL_CSLL,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=13)                                                VL_CSLL_MERCADORIA,

  nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec941b.t$fire$l=tdrec941.t$fire$l
     AND tcibd001b.t$item=tdrec941b.t$item$l
     AND tcibd001b.t$ctyp$l=2
     AND tdrec942.t$brty$l=13),0)                                             VL_CSLL_FRETE,

  nvl((SELECT sum(tdrec942.t$amnt$l) 
     FROM baandb.ttdrec942301 tdrec942, 
					baandb.ttdrec941301 tdrec941b,
					baandb.ttcibd001301 tcibd001b
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec941b.t$fire$l=tdrec941.t$fire$l
     AND tcibd001b.t$item=tdrec941b.t$item$l
     AND tcibd001b.t$kitm>3
     AND tcibd001b.t$ctyp$l!=2
     AND tdrec942.t$brty$l=13),0)                                             VL_CSLL_OUTROS, 

  tdrec941.t$rtin$l                                                           QT_NAO_RECEBIDA_DEVOLUCAO,     

  (SELECT tdrec942.t$base$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=3)                                                 VL_BASE_IPI,

  (SELECT tdrec942.t$rdbc$l 
     FROM baandb.ttdrec942301 tdrec942											
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 VL_PERCENTUAL_REDUTOR_ICMS,

  tdrec941.t$tamt$l                                                           VL_TOTAL_ITEM_NF,
  rtrim(ltrim(tdrec941.t$ikit$c))                                             CD_ITEM_KIT,
  tdrec941.T$OPFC$L                                                           CD_NATUREZA_OPERACAO,
  tdrec941.t$opor$l                                                           SQ_NATUREZA_OPERACAO,

  (SELECT tdrec942.t$base$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=16)                                                VL_BASE_IMPOSTO_IMPORTACAO,

  (SELECT tdrec942.t$amnt$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=16)                                                VL_IMPOSTO_IMPORTACAO,

  tdrec941.t$cchr$l                                                           VL_DESPESA_ADUANEIRA,

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8
     THEN tdrec941.t$gexp$l ELSE 0
     END                                                                      VL_ADICIONAL_IMPORTACAO,

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
     THEN (SELECT tdrec942.t$amnt$l 
             FROM baandb.ttdrec942301 tdrec942
             WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
             AND tdrec942.t$line$l=tdrec941.t$line$l
             AND tdrec942.t$brty$l=5)
     ELSE 0 END                                                               VL_PIS_IMPORTACAO,

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
     THEN (SELECT tdrec942.t$amnt$l 
             FROM baandb.ttdrec942301 tdrec942
             WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
             AND tdrec942.t$line$l=tdrec941.t$line$l
             AND tdrec942.t$brty$l=6) 
     ELSE 0 END                                                               VL_COFINS_IMPORTACAO, 

  CASE WHEN tdrec941.t$crpd$l=1 and (tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8) 
     THEN tdrec941.t$fght$l ELSE 0 END                                        VL_CIF_IMPORTACAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
       AT time zone 'America/Sao_Paulo') AS DATE)                             DT_ULT_ATUALIZACAO,   

  CASE WHEN tdrec941.t$sour$l=2 or tdrec941.t$sour$l=8 
     THEN tdrec941.t$copr$l 
     ELSE 0 END                                                               VL_CUSTO_IMPORTACAO, 

  (SELECT tdrec942.t$amnr$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=1)                                                 VL_ICMS_DESTACADO, 

   nvl((select sum(ra.t$qrec) 
     from baandb.twhinh312301 ra, 
          baandb.ttdrec947301 rr
		 where rr.t$fire$l=tdrec941.t$fire$l
		 and rr.t$line$l=tdrec941.t$line$l
		 and ra.t$rcno=rr.t$rcno$l
		 and ra.t$rcln=rr.t$rcln$l),0)                                            QT_RECEBIDA_FISICA,

  (SELECT tdrec947.t$orno$l 
     FROM baandb.ttdrec947301 tdrec947
	   WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	   AND tdrec947.t$line$l=tdrec941.t$line$l
	   AND rownum=1)                                                            NR_PEDIDO_COMPRA,

  (SELECT tdrec947.t$pono$l 
     FROM baandb.ttdrec947301 tdrec947
	   WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	   AND tdrec947.t$line$l=tdrec941.t$line$l
	   AND rownum=1)                                                            NR_LINHA_PEDIDO_COMPRA,

  (SELECT tcemm124.t$grid 
     FROM baandb.ttcemm124301 tcemm124, 
          baandb.ttcemm030301 tcemm030
     WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
     AND tcemm124.t$loco=301
     AND rownum=1)                                                            CD_UNIDADE_EMPRESARIAL,

  tdrec941.t$fire$l                                                           NR_REFERENCIA_FISCAL,
  tdrec940.t$stat$l                                                           CD_STATUS_NF,

  (SELECT tdrec947.t$rcno$l 
     FROM baandb.ttdrec947301 tdrec947
	   WHERE tdrec947.t$fire$l=tdrec941.t$fire$l
	   AND tdrec947.t$line$l=tdrec941.t$line$l
	   AND rownum=1)                                                            NR_NFR,

	CASE WHEN tdrec940.t$stoa$l=' ' THEN
     CASE WHEN regexp_replace(tdrec940.t$ctno$l, '[^0-9]', '') IS NULL
		   THEN '00000000000000' 
		   WHEN LENGTH(regexp_replace(tdrec940.t$ctno$l, '[^0-9]', ''))<11
		     THEN '00000000000000'
		     ELSE regexp_replace(tdrec940.t$ctno$l, '[^0-9]', '') 
         END	
	   ELSE
		   (select 
         CASE WHEN regexp_replace(e.t$fovn$l, '[^0-9]', '') IS NULL
		       THEN '00000000000000' 
		       WHEN LENGTH(regexp_replace(e.t$fovn$l, '[^0-9]', ''))<11
		         THEN '00000000000000'
		         ELSE regexp_replace(e.t$fovn$l, '[^0-9]', '')
             END
        from baandb.ttccom130301 e
	      where e.t$cadr=tdrec940.t$stoa$l)
	   END                                                                      NR_CNPJ_CPF_ENTREGA ,

  nvl((SELECT tdrec942.t$nmrg$l 
     FROM baandb.ttdrec942301 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
     AND tdrec942.t$line$l=tdrec941.t$line$l
     AND tdrec942.t$brty$l=2),0)                                              VL_IVA

FROM
  baandb.ttdrec941301 tdrec941,
  baandb.ttdrec940301 tdrec940,
  baandb.ttcibd001301 tcibd001,
  baandb.ttcibd936301 tcibd936
          
WHERE tcibd001.t$item=tdrec941.t$item$l
AND tcibd936.t$ifgc$l=tcibd001.t$ifgc$l
AND tdrec940.t$fire$l=tdrec941.t$fire$l
AND tdrec940.t$rfdt$l not in (5,16,22,33) --(3,8,13)
AND tdrec940.t$stat$l>3
;
