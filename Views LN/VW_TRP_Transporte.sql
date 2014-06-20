--	FAF.136 - 13-jun-2014, Fabio Ferreira, 	CNPJ Transportadora
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--**********************************************************************************************************************************************************
select distinct
  (select 
  CAST((FROM_TZ(CAST(TO_CHAR(min(o.T$DATE$C), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) 
  from BAANDB.TZNFMD640201 o
  where o.T$COCI$C='ROT'
  and o.T$ETIQ$C=znfmd630.T$ETIQ$C) DT_SAIDA_ENTREGA, -- Fazer relacionamentoa
  CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) DT_PROMETIDA,
  znfmd630.t$vlft$c VL_FRETE_PAGAR_GARANTIA,
  znfmd630.t$vlfr$c VL_FRETE_CLIENTE,
  znfmd630.t$vlfa$c VL_FRETE_CLIENTE_ORIGINAL,
  TO_CHAR(znsls401.t$cepe$c) CD_CEP_DESTINATARIO,
  znsls401.t$cide$c NM_CIDADE_DESTINATARIO,
  znsls401.t$ufen$c NM_UF_DESTINATARIO,
  znfmd630.t$docn$c NR_NOTA_FISCAL,
  znfmd630.t$seri$c NR_SERIE_NOTA_FISCAL,
  znfmd630.T$FILI$C CD_FILIAL,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else 0
    end NR_NOTA_FATURA,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else ' '
    end NR_SERIE_NOTA_FATURA,
  201 CD_CIA,
  pesovol.vol VL_VOLUME_M3,
  pesovol.peso VL_PESO, 
  pesovol.vol*300 VL_PESO_CUBADO,
  --znfmd630.T$CFRW$C CD_DOFI_TRANSPORTADORA,
 
        CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
		WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
		ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END NR_CNPJ_TRANSPORTADORA,					--#FAF.151.n
  
  
  znfmd060.T$REFE$C DS_OBS_ROMANEIO,
  znfmd630.T$PECL$C NR_ENTREGA
from  BAANDB.TZNFMD630201 znfmd630,
	  ttcmcs080201 tcmcs080,	
	  ttccom100201 tccom100,
	  ttccom130201 tccom130,
      BAANDB.TZNSLS401201 znsls401,
      (select
        tdsls401.t$orno,
        sum(whwmd400.t$hght * whwmd400.t$wdth * whwmd400.T$DPTH) vol,
        sum(tcibd001.t$wght) peso
      from  twhwmd400201 whwmd400,
            ttdsls401201 tdsls401,
            ttcibd001201 tcibd001
      where tdsls401.t$item=whwmd400.t$item
      and   tcibd001.t$item=tdsls401.t$item
      group by tdsls401.t$orno) pesovol,
      tcisli940201 cisli940,
      tznfmd060201 znfmd060
WHERE znsls401.T$ORNO$C=znfmd630.T$ORNO$C
AND pesovol.t$orno=znsls401.T$ORNO$C
AND cisli940.t$fire$l=znfmd630.t$fire$c
AND znfmd060.T$CFRW$C=znfmd630.T$CFRW$C
AND znfmd060.T$CONO$C=znfmd630.t$cono$c
AND tcmcs080.t$cfrw=znfmd630.T$CFRW$C
AND tccom100.t$bpid=tcmcs080.t$suno
AND tccom130.t$cadr=tccom100.t$cadr