--  CREATE OR REPLACE FORCE VIEW "OWN_MIS"."VW_NFV_CAB" ("CD_CIA", "CD_FILIAL", "NR_NF", "NR_SERIE_NF", "CD_NATUREZA_OPERACAO", "SQ_NATUREZA_OPERACAO", "CD_TIPO_NF", "DT_EMISSAO_NF", "HR_EMISSAO_NF", "CD_CLIENTE_FATURA", "CD_CLIENTE_ENTREGA", "NR_PEDIDO", "NR_ENTREGA", "NR_ORDEM", "VL_ICMS", "VL_ICMS_ST", "VL_IPI", "VL_PRODUTO", "VL_FRETE", "VL_SEGURO", "VL_DESPESA", "VL_IMPOSTO_IMPORTACAO", "VL_DESCONTO", "VL_TOTAL_NF", "NR_NF_FATURA", "NR_SERIE_NF_FATURA", "NR_NF_REMESSA", "NR_SERIE_NF_REMESSA", "DT_SITUACAO_NF", "CD_SITUACAO_NF", "VL_DESPESA_FINANCEIRA", "VL_PIS", "VL_COFINS", "VL_CSLL", "VL_DESCONTO_INCONDICIONAL", "VL_DESPESA_ADUANEIRA", "VL_ADICIONAL_IMPORTACAO", "VL_PIS_IMPORTACAO", "VL_COFINS_IMPORTACAO", "VL_CIF_IMPORTACAO", "DT_ULT_ATUALIZACAO", "CD_UNIDADE_EMPRESARIAL", "CD_UNIDADE_NEGOCIO", "NR_REFERENCIA_FISCAL", "CD_TIPO_DOCUMENTO_FISCAL", "CD_STATUS_SEFAZ", "CD_TIPO_ORDEM_VENDA", "NR_PROTOCOLO", "NR_CHAVE_ACESSO_NFE", "NR_CHAVE_ACESSO_NFE_FATURA") AS 
  SELECT
    1                                                     CD_CIA,
    case when ( SELECT tcemm030.t$euca 
                FROM baandb.ttcemm124301 tcemm124, 
                     baandb.ttcemm030301 tcemm030
                WHERE tcemm124.t$cwoc = cisli940.t$cofc$l
                  AND tcemm030.t$eunt = tcemm124.t$grid
                  AND tcemm124.t$loco = 301
                  AND rownum=1) = ' ' then
              ( SELECT substr(tcemm124.t$grid,-2,2) 
                FROM  baandb.ttcemm124301 tcemm124
                WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
                  AND tcemm124.t$loco = 301
                  AND rownum=1) else 
              ( SELECT tcemm030.t$euca F
                FROM baandb.ttcemm124301 tcemm124, 
                     baandb.ttcemm030301 tcemm030
                WHERE tcemm124.t$cwoc = cisli940.t$cofc$l
                  AND tcemm030.t$eunt = tcemm124.t$grid
                  AND tcemm124.t$loco = 301
                  AND rownum=1) end as                    CD_FILIAL, 
		cisli940.t$docn$l                                     NR_NF,
		cisli940.t$seri$l                                     NR_SERIE_NF,
		cisli940.t$ccfo$l                                     CD_NATUREZA_OPERACAO,
		cisli940.t$opor$l                                     SQ_NATUREZA_OPERACAO,
		cisli940.t$fdty$l                                     CD_TIPO_NF,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)          DT_EMISSAO_NF,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)          HR_EMISSAO_NF,

		cisli940.t$itbp$l                                     CD_CLIENTE_FATURA,
		cisli940.t$stbp$l                                     CD_CLIENTE_ENTREGA,
		znsls004.t$pecl$c                                     NR_PEDIDO,
		TO_CHAR(znsls004.t$entr$c)                            NR_ENTREGA,
		cisli245.t$slso                                       NR_ORDEM,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=1)                              VL_ICMS,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=2)                              VL_ICMS_ST,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=3)                              VL_IPI,
		cisli940.t$gamt$l                                     VL_PRODUTO,
		cisli940.t$fght$l                                     VL_FRETE,
		cisli940.t$insr$l                                     VL_SEGURO,
		cisli940.t$gexp$l                                     VL_DESPESA,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l = cisli940.t$fire$l
		AND cisli942.t$brty$l = 16)                           VL_IMPOSTO_IMPORTACAO,
		(SELECT sum(cisli941.t$ldam$l) FROM baandb.tcisli941301 cisli941
		WHERE cisli941.t$fire$l = cisli940.t$fire$l)          VL_DESCONTO,
		cisli940.t$amnt$l                                     VL_TOTAL_NF,
    CASE WHEN cisli940.t$fdty$l = 15 then
              cisli940_triang.t$docn$l
    else CASE WHEN cisli940.t$fdty$l = 16 then
              cisli940.t$docn$l
         else 0 end
    end                                                   NR_NF_FATURA,
       CASE WHEN cisli940.t$fdty$l = 15 then
              cisli940_triang.t$seri$l
          else CASE WHEN cisli940.t$fdty$l = 16 then
                    cisli940.t$seri$l
                else ' ' end
          end                                             NR_SERIE_NF_FATURA, 
        CASE WHEN cisli940.t$fdty$l = 16 then
              cisli940_triang.t$docn$l
          else CASE WHEN cisli940.t$fdty$l = 15 then
                    cisli940.t$docn$l
               else 0 end
          end                                             NR_NF_REMESSA,
        CASE WHEN cisli940.t$fdty$l = 16 then
            cisli940_triang.t$seri$l
          else CASE WHEN cisli940.t$fdty$l = 15 then
                    cisli940.t$seri$l
               else ' ' end
          end                                             NR_SERIE_NF_REMESSA,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE) DT_SITUACAO_NF,
		cisli940.t$stat$l                                     CD_SITUACAO_NF,
		cisli940.t$amfi$l                                     VL_DESPESA_FINANCEIRA,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=5)                              VL_PIS,
		(SELECT cisli942.t$amnt$l FROM baandb.tcisli942301 cisli942
		WHERE cisli942.t$fire$l=cisli940.t$fire$l
		AND cisli942.t$brty$l=6)                              VL_COFINS,
        Nvl((SELECT sum(cisli943.t$amnt$l) from baandb.tcisli943301 cisli943
             WHERE  cisli943.t$fire$l=cisli940.t$fire$l
             AND    cisli943.t$brty$l=13),0)              VL_CSLL,
		znsls401.t$vldi$c                                     VL_DESCONTO_INCONDICIONAL,
		cisli940.t$cchr$l                                     VL_DESPESA_ADUANEIRA,
		nvl((select sum(l.t$gexp$l) from baandb.tcisli941301 l
		where	l.t$fire$l = cisli940.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)),0)                VL_ADICIONAL_IMPORTACAO,
		nvl((select sum(li.t$amnt$l) from baandb.tcisli943301 li, baandb.tcisli941301 l
		where	l.t$fire$l = cisli940.t$fire$l
		and li.t$fire$l=l.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)
		and li.t$brty$l=5),0)                                 VL_PIS_IMPORTACAO, 
		nvl((select sum(li.t$amnt$l) from baandb.tcisli943301 li, baandb.tcisli941301 l
		where	l.t$fire$l = cisli940.t$fire$l
		and li.t$fire$l=l.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)
		and li.t$brty$l=6),0)                                 VL_COFINS_IMPORTACAO,
		nvl((select sum(l.t$fght$l) from baandb.tcisli941301 l
		where	l.t$fire$l = cisli940.t$fire$l
		and (l.t$sour$l=2 or l.t$sour$l=8)),0)                VL_CIF_IMPORTACAO,
    
    CASE WHEN cisli940.t$fdty$l IN (15,16) then
        case when cisli940.t$rcd_utc > cisli940_triang.t$rcd_utc then
              cisli940.t$rcd_utc
        else cisli940_triang.t$rcd_utc end
    else cisli940.t$rcd_utc end                 
                                                          DT_ULT_ATUALIZACAO,
   (SELECT tcemm124.t$grid FROM baandb.ttcemm124301 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=301
    AND rownum=1)                                         CD_UNIDADE_EMPRESARIAL,
	znsls004.t$uneg$c                                       CD_UNIDADE_NEGOCIO,
	cisli940.t$fire$l                                       NR_REFERENCIA_FISCAL,
	cisli940.t$fdtc$l                                       CD_TIPO_DOCUMENTO_FISCAL,
	cisli940.t$nfes$l                                       CD_STATUS_SEFAZ,

  (SELECT tdsls400.t$sotp
   FROM   baandb.ttdsls400301 tdsls400            
   WHERE  tdsls400.t$orno = cisli245.t$slso
   group by tdsls400.t$sotp)                              CD_TIPO_ORDEM_VENDA,

  cisli940.t$prot$l as                                    NR_PROTOCOLO,
  cisli940.t$cnfe$l as                                    NR_CHAVE_ACESSO_NFE,

       CASE WHEN cisli940.t$fdty$l=15 then
          (select a.t$cnfe$l from baandb.tcisli940301 a, baandb.tcisli941301 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l
          and rownum=1
          group by a.t$cnfe$l)
          else ' '
          end                                             NR_CHAVE_ACESSO_NFE_FATURA

FROM baandb.tcisli940301 cisli940
          
LEFT JOIN ( select a.t$fire$l,
                   a.t$slso,
                   min(a.t$pono) t$pono
            from  baandb.tcisli245301 a
            where a.t$ortp = 1  --ordem/programacao de venda
              and a.t$koor = 3  --venda
            group by a.t$fire$l,
                     a.t$slso ) cisli245
       ON cisli245.t$fire$l = cisli940.t$fire$l

LEFT JOIN ( select	a.t$orno$c,
                    a.t$pono$c,
                    a.t$ncia$c, 
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c
            from  baandb.tznsls004301 a
            group by  a.t$orno$c,
                      a.t$pono$c,
                      a.t$ncia$c, 
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$sequ$c ) znsls004
    ON znsls004.t$orno$c = cisli245.t$slso
   AND znsls004.t$pono$c = cisli245.t$pono
                 
LEFT JOIN ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   SUM(a.t$vldi$c) t$vldi$c
            from baandb.tznsls401301 a 
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c ) znsls401 
       ON znsls401.t$ncia$c = znsls004.t$ncia$c
      AND znsls401.t$uneg$c = znsls004.t$uneg$c
      AND znsls401.t$pecl$c = znsls004.t$pecl$c
      AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
    
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$loco = 301
      AND   tcemm124.t$dtyp = 1
      AND   tcemm124.t$cwoc = cisli940.t$cofc$l
      
LEFT JOIN baandb.ttcemm030301 tcemm030
       ON tcemm030.t$eunt = tcemm124.t$grid

LEFT JOIN ( select  b.t$fire$l,
                    a.t$docn$l,
                    a.t$seri$l,
                    max(a.t$rcd_utc) t$rcd_utc 
            from  baandb.tcisli940301 a, 
                  baandb.tcisli941301 b
            where a.t$fire$l = b.t$refr$l
            group by  b.t$fire$l,
                      a.t$docn$l,
                      a.t$seri$l ) cisli940_triang
       ON cisli940_triang.t$fire$l = cisli940.t$fire$l

;
