select distinct
  (select 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(o.T$DATE$C), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
        from BAANDB.TZNFMD640201 o
        where o.T$COCI$C='ETR'
        and o.T$ETIQ$C=znfmd630.T$ETIQ$C)                         DT_SAIDA_ENTREGA, -- Fazer relacionamentoa
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)                  DT_PROMETIDA,
  znfmd630.t$vlft$c                                               VL_FRETE_PAGAR_GARANTIA,
  znfmd630.t$vlfr$c                                               VL_FRETE_CLIENTE,
  znfmd630.t$vlfa$c                                               VL_FRETE_CLIENTE_ORIGINAL,
  TO_CHAR(znsls401.t$cepe$c)                                      CD_CEP_DESTINATARIO,
  znsls401.t$cide$c                                               NM_CIDADE_DESTINATARIO,
  znsls401.t$ufen$c                                               NM_UF_DESTINATARIO,
  TO_CHAR(znfmd630.t$docn$c)                                      NR_NOTA_FISCAL,
  znfmd630.t$seri$c                                               NR_SERIE_NOTA_FISCAL,
  TO_CHAR(znfmd630.T$FILI$C)                                      CD_FILIAL,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$docn$l 
      from baandb.tcisli940201 a, 
           baandb.tcisli941201 b
      where b.t$fire$l=cisli940.t$fire$l
      and a.t$fire$l=b.t$refr$l)
    else NULL end                                                 NR_NOTA_FATURA,
  CASE WHEN cisli940.t$fdty$l=16 then
    (select distinct a.t$seri$l 
      from baandb.tcisli940201 a, 
           baandb.tcisli941201 b
      where b.t$fire$l=cisli940.t$fire$l
      and a.t$fire$l=b.t$refr$l)
      else NULL end                                               NR_SERIE_NOTA_FATURA,
  1 CD_CIA,
  pesovol.vol                                                     VL_VOLUME_M3,
  znfmd630.t$wght$c                                               VL_PESO,
  pesovol.vol*300                                                 VL_PESO_CUBADO,
   
  CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
		THEN '00000000000000' 
  WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', ''))<11
		THEN '00000000000000'
  ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') END        NR_CNPJ_TRANSPORTADORA,					--#FAF.151.n
    
  znfmd060.T$REFE$C                                               DS_OBS_ROMANEIO,
  znfmd630.T$PECL$C                                               NR_ENTREGA,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)                  DT_ULT_ATUALIZACAO,                                         --#MAR.258.en
  znfmd630.t$etiq$c                                               NR_ETIQUETA,
  (select znfmd061.t$dzon$c 
   from  baandb.tznfmd062201 znfmd062, 
         baandb.tznfmd061201 znfmd061 
   where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
     and znfmd062.t$cono$c = znfmd630.t$cono$c 
     and znfmd062.t$cepd$c <= tccom130.t$pstc 
     and znfmd062.t$cepa$c >= tccom130.t$pstc 
     and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c 
     and znfmd061.t$cono$c = znfmd062.t$cono$c 
     and znfmd061.t$creg$c = znfmd062.t$creg$c and rownum = 1 )   DS_REGIAO,

  (select znfmd062.t$creg$c
   from  baandb.tznfmd062201 znfmd062, 
         baandb.tznfmd061201 znfmd061 
   where znfmd061.t$cfrw$c = znfmd062.t$cfrw$c --Código da Transportadora
     and znfmd061.t$cono$c = znfmd062.t$cono$c --Número do Contrato
     and znfmd061.t$creg$c = znfmd062.t$creg$c --Regiao
     and znfmd062.t$cfrw$c = znfmd630.t$cfrw$c --Código da Transportadora
     and znfmd062.t$cono$c = znfmd630.t$cono$c --Número do Contrato
     and znfmd062.t$cepd$c <= tccom130.t$pstc 
     and znfmd062.t$cepa$c >= tccom130.t$pstc 
     and rownum = 1 )                                            DS_CAPITAL_INTERIOR,
    znfmd630.t$ncar$c                                            NR_CARGA,

  case when to_char(to_date(znsls401.t$dtre$c), 'yyyy') = 1969 then null 
       when to_char(to_date(znsls401.t$dtre$c), 'yyyy') = 1970 then null 
  else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtre$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) end               DT_AJUSTADA,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(pesovol.t$ddta, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)                   DT_PREVISTA,
  znsls401.t$tele$c                                              NR_TELEFONE,
  znsls401.t$te1e$c                                              NR_TELEFONE1,
  znsls401.t$te2e$c                                              NR_TELEFONE2,
  znsls401.t$idpa$c                                              NR_PERIODO
  
from  baandb.tznfmd630201 znfmd630,
      baandb.ttcmcs080201 tcmcs080,	
      baandb.ttccom100201 tccom100,
      baandb.ttccom130201 tccom130,
      baandb.tznsls401201 znsls401,
 
      (select tdsls401.t$orno,tdsls401.t$ddta,
        sum(whwmd400.t$hght * whwmd400.t$wdth * whwmd400.T$DPTH) vol,
        sum(tcibd001.t$wght) peso
      from  baandb.twhwmd400201 whwmd400,
            baandb.ttdsls401201 tdsls401,
            baandb.ttcibd001201 tcibd001
      where tdsls401.t$item=whwmd400.t$item
      and   tcibd001.t$item=tdsls401.t$item
      group by tdsls401.t$orno, 
               tdsls401.t$ddta) pesovol,

      baandb.tcisli940201 cisli940,
      baandb.tznfmd060201 znfmd060

WHERE znsls401.T$ORNO$C=znfmd630.T$ORNO$C
AND pesovol.t$orno=znsls401.T$ORNO$C
AND cisli940.t$fire$l=znfmd630.t$fire$c
AND znfmd060.T$CFRW$C=znfmd630.T$CFRW$C
AND znfmd060.T$CONO$C=znfmd630.t$cono$c
AND tcmcs080.t$cfrw=znfmd630.T$CFRW$C
AND tccom100.t$bpid=tcmcs080.t$suno
AND tccom130.t$cadr=tccom100.t$cadr

