select 
    znsls401.T$ENTR$C ENTREGA,
    znsls400.t$dtem$c DT_EMISSAO,
    znsls400.T$DTIN$C DT_INCLUSAO,
    tdsls400.t$orno   ORDEM_VENDA,
    Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) DATA_ORDEM
    
from baandb.tznsls401301 znsls401

	INNER JOIN baandb.tznsls400301 znsls400
			ON znsls400.t$ncia$c = znsls401.t$ncia$c
		   AND znsls400.t$uneg$c = znsls401.t$uneg$c
		   AND znsls400.t$pecl$c = znsls401.t$pecl$c
		   AND znsls400.t$sqpd$c = znsls401.t$sqpd$c


left join baandb.ttdsls400301 tdsls400
    on tdsls400.t$orno = znsls401.t$orno$c
    
     where  
 ((:EntregaTodos = 1  and znsls401.T$ENTR$C IN (:Entrega))
	OR (:EntregaTodos = 0))
AND  Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) 
      Between nvl(:DataDe,tdsls400.t$odat) 
          And nvl(:DataAte,tdsls400.t$odat)
