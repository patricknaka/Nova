SELECT /*+ use_concat no_cpu_costing */ 
      distinct

       cast(znfmd630.t$fili$c as numeric(10,0))       FILIAL,
       znfmd630.t$docn$c                              NUME_NOTA,
       znfmd630.t$seri$c                              NUME_SERIE,
       znfmd630.t$etiq$c                              ETIQUETA,
       znfmd630.t$pecl$c                              NUME_ENTREGA,
       znfmd630.t$vlfc$c                              FRETE_GTE,
       znfmd637.t$amnt$c                              VALOR_ICMS_FRETE,
       znfmd637_PIS.t$amnt$c                          VALOR_PIS_FRETE,
       znfmd637_COFINS.t$amnt$c                       VALOR_COFINS_FRETE,
       znfmd640_ETR.t$coci$c                          OCORRENCIA,
       znfmd640_ETR.                                  DATA_OCORRENCIA,
       znfmd630.t$cfrw$c                              COD_TRANSP,
       (  select a.t$dsca
          from baandb.ttcmcs080601 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA,
       znfmd630.t$cono$c                              COD_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$refe$c),';',''),'"','')   as varchar(100))  
                                                      ID_EXT_CONTRATO,
       NVL(tcmcs031.t$dsca, 'Pedido Interno')         MARCA,
       ORIGEM.DESCR                                   ORIGEM_ORDEM_FRETE
       
FROM ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)    DATA_OCORRENCIA,
                        
              TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE))   DATA_FILTRO,
              znfmd640.t$etiq$c,                    
              znfmd630.t$pecl$c,
              znfmd640.t$fili$c,
              znfmd640.t$coci$c
       from BAANDB.tznfmd640601 znfmd640
                inner join baandb.tznfmd630601 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'ETR'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_ETR

INNER JOIN baandb.tznfmd630601 znfmd630
        ON znfmd630.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_ETR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_ETR.t$pecl$c
       
LEFT JOIN baandb.tcisli940601  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637601 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637601 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637601 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS

LEFT JOIN BAANDB.tznfmd060601 znfmd060
       ON znfmd060.t$cfrw$c = cisli940.t$cfrw$l      --A transportadora da ordem de frete pode nao ser a correta. SDP 1390455
      AND znfmd060.t$cono$c = znfmd630.t$cono$c

LEFT JOIN (  select a.t$orno$c,
                    a.t$ncia$c,
                    a.t$uneg$c
              from baandb.tznsls004601 a 
              group by a.t$orno$c,
                       a.t$ncia$c,
                       a.t$uneg$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

LEFT JOIN baandb.tznint002601  znint002
       ON znint002.t$ncia$c = znsls004.t$ncia$c
      AND znint002.t$uneg$c = znsls004.t$uneg$c

LEFT JOIN baandb.ttcmcs031301  tcmcs031
       ON znint002.t$cbrn$c = tcmcs031.t$cbrn

LEFT JOIN ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
            FROM baandb.tttadv401000 d,
                 baandb.tttadv140000 l
            WHERE d.t$cpac = 'zn'
              AND d.t$cdom = 'mcs.trans.c'
              AND l.t$clan = 'p'
              AND l.t$cpac = 'zn'
              AND l.t$clab = d.t$za_clab
              AND rpad(d.t$vers,4) || '|' ||
                    rpad(d.t$rele,2) || '|' ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
              AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.CODE = znfmd630.t$torg$c
        
WHERE znfmd640_ETR.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c = 'T01'

UNION

SELECT /*+ use_concat no_cpu_costing */ 
      distinct

       cast(znfmd630.t$fili$c as numeric(10,0))       FILIAL,
       znfmd630.t$docn$c                              NUME_NOTA,
       znfmd630.t$seri$c                              NUME_SERIE,
       znfmd630.t$etiq$c                              ETIQUETA,
       znfmd630.t$pecl$c                              NUME_ENTREGA,
       znfmd630.t$vlfc$c                              FRETE_GTE,
       znfmd637.t$amnt$c                              VALOR_ICMS_FRETE,
       znfmd637_PIS.t$amnt$c                          VALOR_PIS_FRETE,
       znfmd637_COFINS.t$amnt$c                       VALOR_COFINS_FRETE,
       znfmd640_CTR.t$coci$c                          OCORRENCIA,
       znfmd640_CTR.                                  DATA_OCORRENCIA,
       znfmd630.t$cfrw$c                              COD_TRANSP,
       (  select a.t$dsca
          from baandb.ttcmcs080601 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA,
       znfmd630.t$cono$c                              COD_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$refe$c),';',''),'"','')   as varchar(100))  
                                                      ID_EXT_CONTRATO,
       NVL(tcmcs031.t$dsca, 'Pedido Interno')         MARCA,
       ORIGEM.DESCR                                   ORIGEM_ORDEM_FRETE

FROM ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)    DATA_OCORRENCIA,
                        
              TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE))   DATA_FILTRO,
              znfmd640.t$etiq$c,                    
              znfmd630.t$pecl$c,
              znfmd640.t$fili$c,
              znfmd640.t$coci$c
       from BAANDB.tznfmd640601 znfmd640
                inner join baandb.tznfmd630601 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'CTR'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_CTR

INNER JOIN baandb.tznfmd630601 znfmd630
        ON znfmd630.t$fili$c = znfmd640_CTR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_CTR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_CTR.t$pecl$c
       
LEFT JOIN baandb.tcisli940601  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637601 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637601 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637601 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS

LEFT JOIN BAANDB.tznfmd060601 znfmd060
       ON znfmd060.t$cfrw$c = cisli940.t$cfrw$l      --A transportadora da ordem de frete pode nao ser a correta. SDP 1390455
      AND znfmd060.t$cono$c = znfmd630.t$cono$c

LEFT JOIN (  select a.t$orno$c,
                    a.t$ncia$c,
                    a.t$uneg$c
              from baandb.tznsls004601 a 
              group by a.t$orno$c,
                       a.t$ncia$c,
                       a.t$uneg$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

LEFT JOIN baandb.tznint002601  znint002
       ON znint002.t$ncia$c = znsls004.t$ncia$c
      AND znint002.t$uneg$c = znsls004.t$uneg$c

LEFT JOIN baandb.ttcmcs031301  tcmcs031
       ON znint002.t$cbrn$c = tcmcs031.t$cbrn

LEFT JOIN ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
            FROM baandb.tttadv401000 d,
                 baandb.tttadv140000 l
            WHERE d.t$cpac = 'zn'
              AND d.t$cdom = 'mcs.trans.c'
              AND l.t$clan = 'p'
              AND l.t$cpac = 'zn'
              AND l.t$clab = d.t$za_clab
              AND rpad(d.t$vers,4) || '|' ||
                    rpad(d.t$rele,2) || '|' ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
              AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.CODE = znfmd630.t$torg$c
        
WHERE znfmd640_CTR.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c = 'T01'

UNION

SELECT /*+ use_concat no_cpu_costing */ 
      distinct

       cast(znfmd630.t$fili$c as numeric(10,0))       FILIAL,
       znfmd630.t$docn$c                              NUME_NOTA,
       znfmd630.t$seri$c                              NUME_SERIE,
       znfmd630.t$etiq$c                              ETIQUETA,
       znfmd630.t$pecl$c                              NUME_ENTREGA,
       znfmd630.t$vlfc$c                              FRETE_GTE,
       znfmd637.t$amnt$c                              VALOR_ICMS_FRETE,
       znfmd637_PIS.t$amnt$c                          VALOR_PIS_FRETE,
       znfmd637_COFINS.t$amnt$c                       VALOR_COFINS_FRETE,
       znfmd640_SPC.t$coci$c                          OCORRENCIA,
       znfmd640_SPC.                                  DATA_OCORRENCIA,
       znfmd630.t$cfrw$c                              COD_TRANSP,
       (  select a.t$dsca
          from baandb.ttcmcs080601 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA,
       znfmd630.t$cono$c                              COD_CONTRATO,
       cast(replace(replace(own_mis.filtro_mis(znfmd060.t$refe$c),';',''),'"','')   as varchar(100))  
                                                      ID_EXT_CONTRATO,
       NVL(tcmcs031.t$dsca, 'Pedido Interno')         MARCA,
       ORIGEM.DESCR                                   ORIGEM_ORDEM_FRETE

FROM ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE)    DATA_OCORRENCIA,
                        
              TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Max(znfmd640.t$udat$c),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') AS DATE))   DATA_FILTRO,
              znfmd640.t$etiq$c,                    
              znfmd630.t$pecl$c,
              znfmd640.t$fili$c,
              znfmd640.t$coci$c
       from BAANDB.tznfmd640601 znfmd640
                inner join baandb.tznfmd630601 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'SPC'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_SPC

INNER JOIN baandb.tznfmd630601 znfmd630
        ON znfmd630.t$fili$c = znfmd640_SPC.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_SPC.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_SPC.t$pecl$c
       
LEFT JOIN baandb.tcisli940601  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637601 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637601 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637601 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS

LEFT JOIN BAANDB.tznfmd060601 znfmd060
       ON znfmd060.t$cfrw$c = cisli940.t$cfrw$l      --A transportadora da ordem de frete pode nao ser a correta. SDP 1390455
      AND znfmd060.t$cono$c = znfmd630.t$cono$c

LEFT JOIN (  select a.t$orno$c,
                    a.t$ncia$c,
                    a.t$uneg$c
              from baandb.tznsls004601 a 
              group by a.t$orno$c,
                       a.t$ncia$c,
                       a.t$uneg$c ) znsls004
        ON znsls004.t$orno$c = znfmd630.t$orno$c

LEFT JOIN baandb.tznint002601  znint002
       ON znint002.t$ncia$c = znsls004.t$ncia$c
      AND znint002.t$uneg$c = znsls004.t$uneg$c

LEFT JOIN baandb.ttcmcs031301  tcmcs031
       ON znint002.t$cbrn$c = tcmcs031.t$cbrn

LEFT JOIN ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
            FROM baandb.tttadv401000 d,
                 baandb.tttadv140000 l
            WHERE d.t$cpac = 'zn'
              AND d.t$cdom = 'mcs.trans.c'
              AND l.t$clan = 'p'
              AND l.t$cpac = 'zn'
              AND l.t$clab = d.t$za_clab
              AND rpad(d.t$vers,4) || '|' ||
                    rpad(d.t$rele,2) || '|' ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv401000 l1
                                          where l1.t$cpac = d.t$cpac
                                            and l1.t$cdom = d.t$cdom )
              AND rpad(l.t$vers,4) || '|' ||
                    rpad(l.t$rele,2) || '|' ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || '|' ||
                                                    rpad(l1.t$rele,2) || '|' ||
                                                    rpad(l1.t$cust,4))
                                           from baandb.tttadv140000 l1
                                          where l1.t$clab = l.t$clab
                                            and l1.t$clan = l.t$clan
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.CODE = znfmd630.t$torg$c
    
WHERE znfmd640_SPC.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c = 'T01'

ORDER BY FILIAL, NUME_ENTREGA, ETIQUETA
