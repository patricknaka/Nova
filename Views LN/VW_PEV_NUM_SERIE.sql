SELECT
    to_char(cisli245.t$slso)    NR_ORDEM,
    cisli245.t$pono             NR_LINHA_ORDEM,
    to_char(znsls004.t$entr$c)  NR_ENTREGA,
    to_char(znsls401.t$item$c)  CD_ITEM,
    to_char(whinh433.t$cser)    NR_SERIE_PRODUTO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                DT_EMISSAO_NF
    
FROM  baandb.tcisli245201   cisli245

LEFT JOIN baandb.tcisli940201 cisli940
      on cisli940.t$fire$l = cisli245.t$fire$l

LEFT JOIN baandb.ttdsls401201 tdsls401
       ON tdsls401.t$orno = cisli245.t$slso
      AND tdsls401.t$pono = cisli245.t$pono
      
LEFT JOIN baandb.tznsls004201 znsls004
       ON znsls004.t$orno$c = cisli245.t$slso
      AND znsls004.t$pono$c = cisli245.t$pono

LEFT JOIN baandb.tznsls401201 znsls401
       ON znsls401.t$orno$c = znsls004.t$orno$c
      AND znsls401.t$pono$c = znsls004.t$pono$c
      AND znsls401.t$entr$c = znsls004.t$entr$c
      
LEFT JOIN baandb.twhinh433201 whinh433
       ON whinh433.t$shpm = cisli245.t$shpm
      AND whinh433.t$pono = cisli245.t$shln

WHERE whinh433.t$cser IS NOT NULL