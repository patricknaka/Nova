
--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_NFV_CAB" ("CD_CIA", "CD_FILIAL", "NR_NF", "NR_SERIE_NF", "CD_NATUREZA_OPERACAO", "SQ_NATUREZA_OPERACAO", "CD_TIPO_NF", "DT_EMISSAO_NF", "HR_EMISSAO_NF", "CD_CLIENTE_FATURA", "CD_CLIENTE_ENTREGA", "NR_PEDIDO", "NR_ENTREGA", "NR_ORDEM", "VL_ICMS", "VL_ICMS_ST", "VL_IPI", "VL_PRODUTO", "VL_FRETE", "VL_SEGURO", "VL_DESPESA", "VL_IMPOSTO_IMPORTACAO", "VL_DESCONTO", "VL_TOTAL_NF", "NR_NF_FATURA", "NR_SERIE_NF_FATURA", "NR_NF_REMESSA", "NR_SERIE_NF_REMESSA", "DT_SITUACAO_NF", "CD_SITUACAO_NF", "VL_DESPESA_FINANCEIRA", "VL_PIS", "VL_COFINS", "VL_CSLL", "VL_DESCONTO_INCONDICIONAL", "VL_DESPESA_ADUANEIRA", "VL_ADICIONAL_IMPORTACAO", "VL_PIS_IMPORTACAO", "VL_COFINS_IMPORTACAO", "VL_CIF_IMPORTACAO", "DT_ULT_ATUALIZACAO", "CD_UNIDADE_EMPRESARIAL", "CD_UNIDADE_NEGOCIO", "NR_REFERENCIA_FISCAL", "CD_TIPO_DOCUMENTO_FISCAL", "CD_STATUS_SEFAZ", "CD_TIPO_ORDEM_VENDA", "NR_PROTOCOLO", "NR_CHAVE_ACESSO_NFE") AS 
  SELECT
    1 CD_CIA,
    case when (SELECT tcemm030.t$euca FROM baandb.ttcemm124301 tcemm124, baandb.ttcemm030301 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=301
    AND rownum=1) = ' ' then
    (SELECT substr(tcemm124.t$grid,-2,2) FROM baandb.ttcemm124301 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=301
    AND rownum=1)else 
    (SELECT tcemm030.t$euca FROM baandb.ttcemm124301 tcemm124, baandb.ttcemm030301 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=301
    AND rownum=1) end as                                        CD_FILIAL, 
		cisli940.t$docn$l                                           NR_NF,
		cisli940.t$seri$l                                           NR_SERIE_NF,
		cisli940.t$ccfo$l                                           CD_NATUREZA_OPERACAO,
		cisli940.t$opor$l                                           SQ_NATUREZA_OPERACAO,
		cisli940.t$fdty$l                                           CD_TIPO_NF,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)                DT_EMISSAO_NF,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)                HR_EMISSAO_NF,

		cisli940.t$itbp$l                                           CD_CLIENTE_FATURA,
		cisli940.t$stbp$l                                           CD_CLIENTE_ENTREGA,
		entr.t$pecl$c                                               NR_PEDIDO,
		TO_CHAR(entr.t$entr$c)                                      NR_ENTREGA,																	--#FAF.098.n
		entr.t$orno$c                                               NR_ORDEM,
    ICMS.t$amnt$l                                               VL_ICMS,
    ICMS_ST.t$amnt$l                                            VL_ICMS_ST,
    IPI.t$amnt$l                                                VL_IPI,
		cisli940.t$gamt$l                                           VL_PRODUTO,
		cisli940.t$fght$l                                           VL_FRETE,
		cisli940.t$insr$l                                           VL_SEGURO,
		cisli940.t$gexp$l                                           VL_DESPESA,
    IMPORTACAO.t$amnt$l                                         VL_IMPOSTO_IMPORTACAO,
    cisli941.desconto                                           VL_DESCONTO,
		cisli940.t$amnt$l                                           VL_TOTAL_NF,
    CASE WHEN cisli940.t$fdty$l=15 then
          NF_FAT_REM.t$docn$l                                          
    ELSE 0 END                                                  NR_NF_FATURA,
    CASE WHEN cisli940.t$fdty$l=15 then
          NF_FAT_REM.t$seri$l
    ELSE ' ' END                                                NR_SERIE_NF_FATURA, 
    CASE WHEN cisli940.t$fdty$l=16 then
          NF_FAT_REM.t$docn$l
    ELSE 0 END                                                  NR_NF_REMESSA,
    CASE WHEN cisli940.t$fdty$l=16 then
          NF_FAT_REM.t$seri$l
    else ' ' end                                                 NR_SERIE_NF_REMESSA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)                DT_SITUACAO_NF,
		cisli940.t$stat$l                                           CD_SITUACAO_NF,
		cisli940.t$amfi$l                                           VL_DESPESA_FINANCEIRA,
    PIS.t$amnt$l                                                VL_PIS,
    COFINS.t$amnt$l                                             VL_COFINS,
    CSLL.t$amnt$l                                               VL_CSLL,
		entr.t$vldi$c                                               VL_DESCONTO_INCONDICIONAL,
		cisli940.t$cchr$l                                           VL_DESPESA_ADUANEIRA,
    IMPORT_ADIC.t$gexp$l                                        VL_ADICIONAL_IMPORTACAO,
    PIS_IMPORT.t$amnt$l                                         VL_PIS_IMPORTACAO, 
    COFINS_IMPORT.t$amnt$l                                      VL_COFINS_IMPORTACAO,
    IMPORT_ADIC.t$fght$l                                        VL_CIF_IMPORTACAO,
	GREATEST(																									--#FAF.286.sn
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE),
	nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c1.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE) from baandb.tcisli941301 c1 
			where c1.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
	nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c2.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE) from baandb.tcisli943301 c2 
			where c2.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY'))) 
                                                              DT_ULT_ATUALIZACAO,		--#FAF.286.en                           
  tcemm124.t$grid                                             CD_UNIDADE_EMPRESARIAL,
	entr.t$uneg$c                                               CD_UNIDADE_NEGOCIO,														--#FAF.098.n
	cisli940.t$fire$l                                           NR_REFERENCIA_FISCAL,													--#FAF.109.n
	cisli940.t$fdtc$l                                           CD_TIPO_DOCUMENTO_FISCAL,
	cisli940.t$nfes$l                                           CD_STATUS_SEFAZ,															--#FAF.248.n        
  tdsls400.t$sotp                                             CD_TIPO_ORDEM_VENDA,        --#MAT.308.en 

  cisli940.t$prot$l as                                        NR_PROTOCOLO,
  cisli940.t$cnfe$l as                                        NR_CHAVE_ACESSO_NFE

FROM baandb.tcisli940301 cisli940

		LEFT JOIN (SELECT 	znsls401.t$entr$c, 
							cisli245.t$fire$l, 
							znsls401.t$pecl$c, 
							cisli245.t$slso t$orno$c, 
							znsls401.t$uneg$c, 
							SUM(znsls401.t$vldi$c) t$vldi$c 
					FROM
					 baandb.tcisli245301 cisli245
					 LEFT JOIN (select	r.t$ncia$c, 
										r.t$uneg$c,
										r.t$pecl$c,
										r.t$sqpd$c,
										r.t$entr$c,
										r.t$sequ$c,
										r.t$orno$c,
										r.t$pono$c
								 from baandb.tznsls004301  r
								 where r.t$entr$c=( select  r0.t$entr$c 
                                    from baandb.tznsls004301  r0
                                    where r0.t$orno$c=r.t$orno$c
                                    and rownum=1
                                    and r0.t$date$c=  (select max(r1.t$date$c)
                                                         from baandb.tznsls004301  r1
                                                         where r1.t$orno$c=r0.t$orno$c))) znsls004 
															ON	znsls004.t$orno$c=cisli245.t$slso
					                                        AND znsls004.t$pono$c=cisli245.t$pono
					 LEFT JOIN baandb.tznsls401301 znsls401 ON   znsls401.t$ncia$c=znsls004.t$ncia$c
					                                        AND   znsls401.t$uneg$c=znsls004.t$uneg$c
					                                        AND   znsls401.t$pecl$c=znsls004.t$pecl$c
					                                        AND   znsls401.t$sqpd$c=znsls004.t$sqpd$c
					                                        AND   znsls401.t$entr$c=znsls004.t$entr$c
					                                        AND   znsls401.t$sequ$c=znsls004.t$sequ$c
					group by
							znsls401.t$entr$c, 
							cisli245.t$fire$l, 
							znsls401.t$pecl$c ,
							cisli245.t$slso, 
							znsls401.t$uneg$c) entr ON entr.t$fire$l=cisli940.t$fire$l
    
    LEFT JOIN baandb.tcisli942301 ICMS
           ON ICMS.t$fire$l = cisli940.t$fire$l
          AND ICMS.t$brty$l = 1
    
    LEFT JOIN baandb.tcisli942301 ICMS_ST
           ON ICMS_ST.t$fire$l = cisli940.t$fire$l
          AND ICMS_ST.t$brty$l = 2
    
    LEFT JOIN baandb.tcisli942301 IPI
           ON IPI.t$fire$l = cisli940.t$fire$l
          AND IPI.t$brty$l = 3

    LEFT JOIN baandb.tcisli942301 IMPORTACAO
           ON IMPORTACAO.t$fire$l = cisli940.t$fire$l
          AND IMPORTACAO.t$brty$l = 16

		LEFT JOIN ( SELECT a.t$fire$l,
                       sum(a.t$ldam$l) desconto
                FROM   baandb.tcisli941301 a
                group by a.t$fire$l ) cisli941
           ON cisli941.t$fire$l = cisli940.t$fire$l

    LEFT JOIN ( select  b.t$fire$l,
                        a.t$docn$l,
                        a.t$seri$l
                from baandb.tcisli940301 a, 
                     baandb.tcisli941301 b
                where a.t$fire$l=b.t$refr$l
                group by  b.t$fire$l,
                          a.t$docn$l,
                          a.t$seri$l ) NF_FAT_REM
          ON NF_FAT_REM.t$fire$l = cisli940.t$fire$l

    LEFT JOIN baandb.tcisli942301 PIS
           ON PIS.t$fire$l = cisli940.t$fire$l
          AND PIS.t$brty$l = 5
    
    LEFT JOIN baandb.tcisli942301 COFINS
           ON COFINS.t$fire$l = cisli940.t$fire$l
          AND COFINS.t$brty$l = 6
    
    LEFT JOIN ( select  a.t$fire$l,
                        sum(a.t$amnt$l) t$amnt$l
                from    baandb.tcisli943301 a
                where a.t$brty$l = 13
                group by a.t$fire$l ) CSLL
           ON CSLL.t$fire$l = cisli940.t$fire$l
 
 		LEFT JOIN ( select  a.t$fire$l,
                        sum(a.t$gexp$l) t$gexp$l,           --VL_ADICIONAL_IMPORTACAO
                        sum(a.t$fght$l) t$fght$l            --VL_CIF_IMPORTACAO,
                from baandb.tcisli941301 a
                where (a.t$sour$l=2 or a.t$sour$l=8)
                group by a.t$fire$l ) IMPORT_ADIC                    
          ON IMPORT_ADIC.t$fire$l = cisli940.t$fire$l
    
		LEFT JOIN ( select a.t$fire$l,
                       sum(b.t$amnt$l) t$amnt$l
                from   baandb.tcisli941301 a,
                       baandb.tcisli943301 b 
                where b.t$fire$l = a.t$fire$l
                  and (a.t$sour$l = 2 or a.t$sour$l = 8 )
                  and b.t$brty$l = 5 
                group by a.t$fire$l )  PIS_IMPORT                      --VL_PIS_IMPORTACAO
           ON	PIS_IMPORT.t$fire$l = cisli940.t$fire$l
    
		LEFT JOIN ( select a.t$fire$l, 
                      sum(b.t$amnt$l) t$amnt$l 
                from  baandb.tcisli941301 a,
                      baandb.tcisli943301 b
                where b.t$fire$l=a.t$fire$l
                  and (a.t$sour$l=2 or a.t$sour$l=8)
                  and b.t$brty$l=6
                group by a.t$fire$l ) COFINS_IMPORT                    --VL_COFINS_IMPORTACAO
          ON	COFINS_IMPORT.t$fire$l = cisli940.t$fire$l

   LEFT JOIN baandb.ttdsls400301 tdsls400            
          ON tdsls400.t$orno = entr.t$orno$c

    INNER JOIN baandb.ttcemm124301 tcemm124
            ON tcemm124.t$cwoc = cisli940.t$cofc$l
           AND tcemm124.t$loco = 301
           AND tcemm124.t$dtyp = 1
           
    INNER JOIN baandb.ttcemm030301 tcemm030
            ON tcemm030.t$eunt = tcemm124.t$grid

--AND 	     trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
--          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) between to_date('22-10-2016', 'DD-MM-YYYY') and to_date('28-10-2016', 'DD-MM-YYYY')
;
