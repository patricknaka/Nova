select distinct
      znfmd630.t$pecl$c NR_ENTREGA,
      (select min(o.t$date$c) from baandb.tznfmd640201 o
			where o.t$coci$c='ent'and o.t$etiq$c=znfmd630.t$etiq$c) DT_ENTREGA_REALIZADA,
      case when znfmd630.t$stat$c='f' then 'FINALIZADO' else 'EM PROCESSO' end NM_TIPO_ESTAGIO,
      (select o.t$coci$c from baandb.tznfmd640201 o
			where o.t$date$c=(select max(o1.t$date$c) from baandb.tznfmd640201 o1 where o1.t$etiq$c=o.t$etiq$c)
			and o.t$etiq$c=znfmd630.t$etiq$c and rownum=1) CD_OCORRENCIA_INTERNA,
      (select c.t$dsci$c from baandb.tznfmd640201 o, baandb.tznfmd030201 c
			where o.t$date$c=(select max(o1.t$date$c) from baandb.tznfmd640201 o1 where o1.t$etiq$c=o.t$etiq$c)
			and o.t$etiq$c=znfmd630.t$etiq$c and c.t$ocin$c=o.t$coci$c and rownum=1) DS_OCORRENCIA_INTERNA,
      (select max(o.t$date$c) from baandb.tznfmd640201 o, baandb.tznfmd030201 c
			where o.t$etiq$c=znfmd630.t$etiq$c and c.t$ocin$c=o.t$coci$c) DT_OCORRENCIA,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(
		GREATEST(znfmd630.t$udat$c, znfmd060.t$udat$c, tdsls401.t$rcd_utc, tdsls400.t$rcd_utc, cisli940.t$rcd_utc,
				nvl((select max(o.t$udat$c) from baandb.tznfmd640201 o, baandb.tznfmd030201 c
				 where o.t$etiq$c=znfmd630.t$etiq$c and c.t$ocin$c=o.t$coci$c),TO_DATE('01-01-2000', 'DD-MM-YYYY'))),
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO
from  baandb.tznfmd630201 znfmd630,
      baandb.tznsls401201 znsls401,
      baandb.tznsls400201 znsls400,
      baandb.tznfmd061201 znfmd061,
      baandb.tznfmd060201 znfmd060,
      baandb.ttdsls401201 tdsls401,
      baandb.ttdsls400201 tdsls400,
      baandb.ttcmcs080201 tcmcs080,
      baandb.tznint002201 znint002,
      baandb.tznsls002201 znsls002,
      baandb.tznfmd001201 znfmd001,
      baandb.tcisli940201 cisli940
where   znsls401.t$orno$c=znfmd630.t$orno$c
and     znsls400.t$ncia$c=znsls401.t$ncia$c
and     znsls400.t$uneg$c=znsls401.t$uneg$c
and     znsls400.t$pecl$c=znsls401.t$pecl$c
and     znsls400.t$sqpd$c=znsls401.t$sqpd$c
and     znfmd061.t$cfrw$c=znfmd630.t$cfrw$c
and     znfmd061.t$cono$c=znfmd630.t$cono$c
and     znfmd060.t$cfrw$c=znfmd630.t$cfrw$c
and     znfmd060.t$cono$c=znfmd630.t$cono$c
and     tdsls401.t$orno=znsls401.t$orno$c
and     tdsls401.t$pono=znsls401.t$pono$c
and     tdsls400.t$orno=tdsls401.t$orno
and     tcmcs080.t$cfrw=znfmd630.t$cfrw$c
and     znint002.t$ncia$c=znsls400.t$ncia$c
and     znint002.t$uneg$c=znsls400.t$uneg$c
and     znsls002.t$tpen$c=znsls401.t$itpe$c
and    cisli940.t$fire$l=znfmd630.t$fire$c