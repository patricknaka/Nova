SELECT
    cisli245.t$slso           NUM_OV,
    cisli245.t$pono           LINHA_OV,
    znsls004.t$entr$c         NUM_ENTREGA,
    znsls401.t$item$c         COD_ITEM,
    whinh433.t$cser           NUM_SERIE
    
FROM  baandb.tcisli245201   cisli245

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
