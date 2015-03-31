SELECT 
  DISTINCT
    znint002.t$desc$c             UNIN_NOME,
    znsls400.t$idca$c             PEDC_ID_CANAL,
    znsls400.t$cven$c             PEDC_ID_VENREP,
    tccom130r.t$fovn$l            PEDC_ID_CLIENTE,
    cisli940r.t$fids$l            CLIE_NOME,
    znsls401.t$pecl$c             PEDC_PED_CLIENTE,
    znsls401.t$entr$c             PEDC_ID_PEDIDO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                  PEDC_DT_EMISSAO,
    Trim(cisli941f.t$item$l)      PEDD_ID_ITEM,
    cisli941f.t$desc$l            ITEG_NOME,
    cisli941f.t$dqua$l            QTD_ITEM,
    cisli941f.t$pric$l            PEDD_PR_FINAL,
    cisli941f.t$ldam$l            PEDD_VL_DESC_INC_UNIT,
    cisli941f.t$fght$l            VL_FRETE_ITEM,
    cisli941f.t$tldm$l            VL_DESC_INC_TOT,
    cisli941f.t$amnt$l            VL_TOTAL_ITEM,
    cisli941f.t$disc$l            PERC_DESC_ITEM
  
FROM       baandb.tznsls401201  znsls401

INNER JOIN baandb.tznsls400201 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c

INNER JOIN baandb.tznint002201  znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c

INNER JOIN baandb.tcisli245201 cisli245
        ON cisli245.t$slso = znsls401.t$orno$c
       AND cisli245.t$pono = znsls401.t$pono$c

INNER JOIN baandb.tcisli940201 cisli940r            -- capa nota remessa
        ON cisli940r.t$fire$l = cisli245.t$fire$l

INNER JOIN baandb.tcisli941201 cisli941r           -- linha nota remessa
        ON cisli941r.t$fire$l = cisli245.t$fire$l
       AND cisli941r.t$line$l = cisli245.t$line$l

INNER JOIN baandb.tcisli940201 cisli940f           -- capa nota fatura
        ON cisli940f.t$fire$l = cisli941r.t$refr$l

INNER JOIN baandb.tcisli941201 cisli941f           -- linha nota fatura
        ON cisli941f.t$fire$l = cisli941r.t$refr$l
       AND cisli941f.t$line$l = cisli941r.t$line$l
      
INNER JOIN baandb.ttccom130201 tccom130r            -- endereço remessa
        ON tccom130r.t$cadr = cisli940r.t$stoa$l

INNER JOIN baandb.ttccom139201 tccom139r
        ON tccom139r.t$ccty = tccom130r.t$ccty
       AND tccom139r.t$cste = tccom130r.t$cste
       AND tccom139r.t$city = tccom130r.t$ccit

WHERE znsls400.t$idca$c = 'B2B'
  AND znsls401.t$idor$c = 'LJ'
  AND cisli940f.t$stat$l IN (5, 6)

  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
      Between :DataEmissaoDe
          And :DataEmissaoAte

ORDER BY PEDC_DT_EMISSAO, PEDD_ID_ITEM