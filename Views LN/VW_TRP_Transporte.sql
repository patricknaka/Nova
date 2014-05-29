select distinct
  (select 
  CAST((FROM_TZ(CAST(TO_CHAR(min(o.T$DATE$C), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) 
  from BAANDB.TZNFMD640201 o
  where o.T$COCI$C='ROT'
  and o.T$ETIQ$C=znfmd630.T$ETIQ$C) dofi_dt_saida_entrega, -- Fazer relacionamentoa
  CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) dofi_dt_prometida,
  znfmd630.t$vlft$c dofi_vl_frete_pagar_gte,
  znfmd630.t$vlfr$c atdo_vl_frete_cli,
  znfmd630.t$vlfa$c atdo_vl_frete_cli_ori,
  znsls401.t$cepe$c atdo_cep_dest,
  znsls401.t$cide$c atdo_cidade_destinatario,
  znsls401.t$ufen$c atdo_uf_destinatario,
  znfmd630.t$docn$c dofi_nu_nf,
  znfmd630.t$seri$c dofi_sr_nf,
  znfmd630.T$FILI$C dofi_filial,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else 0
    end nfca_id_nota_fatura,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else ' '
    end nfca_serie_fatura,
  201 dofi_cia,
  pesovol.vol atdo_volume_m3,
  pesovol.peso atdo_peso, 
  pesovol.vol*300 atdo_peso_cubado,
  znfmd630.T$CFRW$C dofi_id_transportadora,
  znfmd060.T$REFE$C pedc_obs_romaneio,
  znfmd630.T$PECL$C
from  BAANDB.TZNFMD630201 znfmd630,
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
