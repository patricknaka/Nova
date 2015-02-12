SELECT DISTINCT
  znsls400.t$ncia$c                               CD_CIA,
  CASE WHEN (	SELECT tcemm030.t$euca FROM baandb.ttcemm124301 tcemm124, baandb.ttcemm030301 tcemm030
  WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
  AND tcemm030.t$eunt=tcemm124.t$grid
  AND tcemm124.t$loco=301
  AND rownum=1) = ''
THEN
  (	SELECT substr(tcemm124.t$grid,-2,2) FROM baandb.ttcemm124301 tcemm124
  WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
  AND tcemm124.t$loco=301
  AND rownum=1)
ELSE (	SELECT tcemm030.t$euca FROM baandb.ttcemm124301 tcemm124, baandb.ttcemm030301 tcemm030
        WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
        AND tcemm030.t$eunt=tcemm124.t$grid
        AND tcemm124.t$loco=301
        AND rownum=1)
  END AS                                        CD_FILIAL,


  znsls401.t$pecl$c                             NR_PEDIDO,
  TO_CHAR(znsls401.t$entr$c)                    NR_ENTREGA,
  znsls401.t$sequ$c                             NR_SEQ_ENTREGA,
  cisli940.t$docn$l                             NR_NF,
  cisli940.t$seri$l                             NR_SERIE_NF,
  cisli941f.t$fire$l                            NR_REFERENCIA_FISCAL,
  cisli941f.t$line$l                            NR_LINHA_REF_FISCAL,
  ltrim(rtrim(cisli941f.t$item$l))              CD_ITEM,
  cisli941f.t$dqua$l                            QT_FATURADA,
  cisli941f.t$gamt$l                            VL_PRODUTO,
  znsls401.t$vlfr$c                             VL_FRETE_CLIENTE,
  nvl((select sum(f.t$vlfc$c) from baandb.tznfmd630301 f where f.t$fire$c=cisli940.t$fire$l),0) * (cisli941f.t$gamt$l/nvl((select sum(cisli941b.t$gamt$l)
                              from baandb.tcisli941301 cisli941b, baandb.ttcibd001301 tcibd001b
                              where cisli941b.t$fire$l=cisli941f.t$fire$l
                              and cisli941b.t$line$l=cisli941f.t$line$l
                              and tcibd001b.T$ITEM=cisli941b.t$item$l
                              and cisli941b.t$gamt$l!=0
                              and tcibd001b.t$kitm<3),1)) 
  AS                                            VL_FRETE_CIA

FROM baandb.tcisli940301 cisli940,
     baandb.tcisli941301 cisli941,	
     baandb.tcisli941301 cisli941f,
     baandb.tcisli245301 cisli245,
     baandb.ttdsls401301 tdsls401,
     baandb.tznsls004301 znsls004,
     baandb.tznsls401301 znsls401,
     baandb.tznsls400301 znsls400,
     baandb.tznfmd630301 znfmd630,
     baandb.ttdsls400301 tdsls400

WHERE cisli941f.t$fire$l=cisli940.t$fire$l
  AND cisli245.t$fire$l=cisli941.t$fire$l
  AND cisli245.t$line$l=cisli941.t$line$l
  AND tdsls401.t$orno = cisli245.t$slso
  AND tdsls401.t$pono = cisli245.t$pono
  AND	znsls004.t$orno$c=tdsls401.t$orno
  AND	znsls004.t$pono$c=tdsls401.t$pono
  AND	znsls401.t$ncia$c=znsls004.t$ncia$c	
  AND znsls401.t$uneg$c=znsls004.t$uneg$c
  AND znsls401.t$pecl$c=znsls004.t$pecl$c
  AND znsls401.t$sqpd$c=znsls004.t$sqpd$c
  AND	znsls401.t$entr$c=znsls004.t$entr$c
  AND	znsls401.t$sequ$c=znsls004.t$sequ$c
  AND	ltrim(rtrim(tdsls401.t$item))=ltrim(rtrim(znsls401.t$item$c))
  AND znsls400.t$ncia$c=znsls401.t$ncia$c
  AND znsls400.t$uneg$c=znsls401.t$uneg$c
  AND znsls400.t$pecl$c=znsls401.t$pecl$c
  AND znsls400.t$sqpd$c=znsls401.t$sqpd$c
  AND ltrim(rtrim(znfmd630.t$pecl$c))=ltrim(rtrim((znsls401.t$entr$c)))
  AND ltrim(rtrim(znfmd630.t$fire$c))=ltrim(rtrim((cisli940.t$fire$l)))
  AND znfmd630.t$fire$c != ' '
  and ((cisli941.T$fire$L= cisli941f.T$REFR$L and (cisli940.t$fdty$l=15 or cisli940.t$fdty$l=16))
        or cisli941.T$fire$L= cisli941f.T$fire$L)
  and ((cisli941.T$line$L= cisli941f.T$rfdl$L and (cisli940.t$fdty$l=15 or cisli940.t$fdty$l=16))
        or cisli941.T$line$L= cisli941f.T$line$l)
    and cisli940.t$stat$l IN (5,6) and cisli940.t$nfes$l IN (1,2,5)
 AND tdsls400.t$fdty$l=1

