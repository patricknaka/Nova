select distinct
  (select 
  CAST((FROM_TZ(CAST(TO_CHAR(min(o.T$DATE$C), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) 
  from BAANDB.TZNFMD640201 o
  where o.T$COCI$C='ROT'
  and o.T$ETIQ$C=znfmd630.T$ETIQ$C) DT_DOFI_SAIDA_ENTREGA, -- Fazer relacionamentoa
  CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
    AT time zone sessiontimezone) AS DATE) DT_DOFI_PROMETIDA,
  znfmd630.t$vlft$c VL_DOFI_FRETE_PAGAR_GTE,
  znfmd630.t$vlfr$c VL_ATDO_FRETE_CLI,
  znfmd630.t$vlfa$c VL_ATDO_FRETE_CLI_ORI,
  TO_CHAR(znsls401.t$cepe$c) CD_ATDO_CEP_DEST,
  znsls401.t$cide$c NM_ATDO_CIDADE_DESTINATARIO,
  znsls401.t$ufen$c NM_ATDO_UF_DESTINATARIO,
  znfmd630.t$docn$c NR_DOFI_NF,
  znfmd630.t$seri$c NR_DOFI_SERIE_NF,
  znfmd630.T$FILI$C CD_DOFI_FILIAL,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else 0
    end NR_NFCA_NOTA_FATURA,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
    where b.t$fire$l=cisli940.t$fire$l
    and a.t$fire$l=b.t$refr$l)
    else ' '
    end NR_NFCA_SERIE_FATURA,
  201 CD_DOFI_CIA,
  pesovol.vol VL_ATDO_VOLUME_M3,
  pesovol.peso VL_ATDO_PESO, 
  pesovol.vol*300 VL_ATDO_PESO_CUBADO,
  znfmd630.T$CFRW$C CD_DOFI_TRANSPORTADORA,
  znfmd060.T$REFE$C DS_PEDC_OBS_ROMANEIO,
  znfmd630.T$PECL$C NR_ENTREGA
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