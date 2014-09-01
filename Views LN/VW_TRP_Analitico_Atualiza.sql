select distinct
      znfmd630.T$pecl$C NR_ENTREGA,
      (select min(o.T$DATE$C)
      from BAANDB.TZNFMD640201 o
      where o.T$COCI$C='ENT'
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C) DT_ENTREGA_REALIZADA,
      CASE WHEN znfmd630.t$stat$c='F' THEN 'FINALIZADO' ELSE 'EM PROCESSO' END NM_TIPO_ESTAGIO,
      (select o.T$COCI$C
      from BAANDB.TZNFMD640201 o
      where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and rownum=1) CD_OCORRENCIA_INTERNA,
      (select c.t$dsci$c
      from BAANDB.TZNFMD640201 o,
      BAANDB.TZNFMD030201 c
      where o.T$date$c=(select max(o1.T$date$c) from BAANDB.TZNFMD640201 o1 where o1.T$ETIQ$C=o.T$ETIQ$C)
      and o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C
      and rownum=1) DS_OCORRENCIA_INTERNA,
      (select max(o.T$DATE$C)
      from BAANDB.TZNFMD640201 o,
           BAANDB.TZNFMD030201 c
      where o.T$ETIQ$C=znfmd630.T$ETIQ$C
      and   c.t$ocin$c=o.T$COCI$C) DT_OCORRENCIA
from  BAANDB.TZNFMD630201 znfmd630,
      BAANDB.TZNSLS401201 znsls401,
      BAANDB.TZNSLS400201 znsls400,
      BAANDB.TZNFMD061201 znfmd061,
      BAANDB.TZNFMD060201 znfmd060,
      BAANDB.ttdsls401201 tdsls401,
      BAANDB.ttdsls400201 tdsls400,
      BAANDB.ttcmcs080201 tcmcs080,
      BAANDB.tznint002201 znint002,
      BAANDB.tznsls002201 znsls002,
      BAANDB.tznfmd001201 znfmd001,
      BAANDB.tcisli940201 cisli940
WHERE   znsls401.T$ORNO$C=znfmd630.T$ORNO$C
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
AND     znfmd061.T$CFRW$C=znfmd630.T$CFRW$C
AND     znfmd061.T$CONO$C=znfmd630.t$cono$c
AND     znfmd060.T$CFRW$C=znfmd630.T$CFRW$C
AND     znfmd060.T$CONO$C=znfmd630.t$cono$c
AND     tdsls401.t$orno=znsls401.T$ORNO$C
AND     tdsls401.t$pono=znsls401.T$PONO$C
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcmcs080.t$cfrw=znfmd630.T$CFRW$C
AND     znint002.T$NCIA$C=znsls400.T$NCIA$C
AND     znint002.T$UNEG$C=znsls400.t$uneg$c
AND     znsls002.T$TPEN$C=znsls401.t$itpe$c
AND    cisli940.t$fire$l=znfmd630.t$fire$c