select distinct
  (select 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(min(o.T$DATE$C), 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
        from BAANDB.TZNFMD640201 o
        where o.T$COCI$C='ETR'
        and o.T$ETIQ$C=znfmd630.T$ETIQ$C)                         DT_SAIDA_ENTREGA, -- Fazer relacionamentoa
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(pesovol.t$prdt, 
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
      AT time zone 'America/Sao_Paulo') AS DATE)                  DT_ULT_ATUALIZACAO,              --#MAR.258.en
  znfmd630.t$etiq$c                                               NR_ETIQUETA,
  regiao.t$dzon$c                                                 DS_REGIAO,
  regiao.t$creg$c                                                 DS_CAPITAL_INTERIOR, 
  znfmd630.t$ncar$c                                               NR_CARGA,

  case when to_char(to_date(znfmd630.t$dtco$c), 'yyyy') = 1969 then null 
       when to_char(to_date(znfmd630.t$dtco$c), 'yyyy') = 1970 then null 
  else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE) end               DT_AJUSTADA,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone 'America/Sao_Paulo') AS DATE)                   DT_PREVISTA,

  znsls401.t$tele$c                                              NR_TELEFONE,
  znsls401.t$te1e$c                                              NR_TELEFONE1,
  znsls401.t$te2e$c                                              NR_TELEFONE2,
  znsls401.t$idpa$c                                              NR_PERIODO,
  znfmd630.t$qvol$c                                              QT_VOLUME,
  znfmd630.t$cono$c                                              NR_CONTRATO,
  znfmd630.t$cfrw$c                                              ID_TRANSP,
  znfmd170.t$vplt$c                                              DS_PLACA
  
from  baandb.tznfmd630201 znfmd630

LEFT JOIN baandb.tznfmd170201 znfmd170
       on znfmd170.t$cfrw$c = znfmd630.t$cfrw$c
      and znfmd170.t$nent$c = znfmd630.t$nent$c

INNER JOIN baandb.ttcmcs080201 tcmcs080
        ON tcmcs080.t$cfrw=znfmd630.T$CFRW$C
        
INNER JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid=tcmcs080.t$suno
        
INNER JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr=tccom100.t$cadr
        
INNER JOIN baandb.tznsls401201 znsls401
        ON znsls401.T$ORNO$C=znfmd630.T$ORNO$C
 
LEFT JOIN (select  tdsls401.t$orno, tdsls401.t$prdt,
                    sum(whwmd400.t$hght * whwmd400.t$wdth * whwmd400.T$DPTH) vol,
                    sum(tcibd001.t$wght) peso
            from  baandb.twhwmd400201 whwmd400,
                  baandb.ttdsls401201 tdsls401,
                  baandb.ttcibd001201 tcibd001
            where tdsls401.t$item=whwmd400.t$item
            and   tcibd001.t$item=tdsls401.t$item
            group by  tdsls401.t$orno, tdsls401.t$prdt) pesovol
      ON  pesovol.t$orno=znsls401.T$ORNO$C
      
INNER JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l=znfmd630.t$fire$c
        
INNER JOIN baandb.tznfmd060201 znfmd060
        ON znfmd060.T$CFRW$C=znfmd630.T$CFRW$C
       AND znfmd060.T$CONO$C=znfmd630.t$cono$c 
      
LEFT JOIN (select znfmd062.t$creg$c, znfmd061.t$dzon$c,
                  znfmd062.t$cfrw$c, znfmd062.t$cono$c, 
                  znfmd062.t$cepd$c, znfmd062.t$cepa$c,
                  max(znfmd061.t$udat$c) t$udat$c
           from   baandb.tznfmd062201 znfmd062, 
                  baandb.tznfmd061201 znfmd061 
           where  znfmd061.t$cfrw$c = znfmd062.t$cfrw$c --Código da Transportadora
           and    znfmd061.t$cono$c = znfmd062.t$cono$c --Número do Contrato
           and    znfmd061.t$creg$c = znfmd062.t$creg$c --Regiao
           and    znfmd061.t$ativ$c = 1    -- Ativo
           and    znfmd062.t$ativ$c = 1    -- Ativo
           group by znfmd062.t$creg$c, 
                    znfmd061.t$dzon$c, 
                    znfmd062.t$cfrw$c, 
                    znfmd062.t$cono$c, 
                    znfmd062.t$cepd$c, 
                    znfmd062.t$cepa$c) regiao
        ON regiao.t$cfrw$c = znfmd630.t$cfrw$c 
       AND regiao.t$cono$c = znfmd630.t$cono$c 
       AND regiao.t$cepd$c <= tccom130.t$pstc 
       AND regiao.t$cepa$c >= tccom130.t$pstc

--where znfmd630.T$PECL$C = '5025701401'