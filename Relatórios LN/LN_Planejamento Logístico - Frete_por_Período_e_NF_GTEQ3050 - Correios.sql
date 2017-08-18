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
          from baandb.ttcmcs080301 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA

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
       from BAANDB.tznfmd640301 znfmd640
                inner join baandb.tznfmd630301 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'ETR'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_ETR

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_ETR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_ETR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_ETR.t$pecl$c
       
LEFT JOIN baandb.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637301 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637301 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637301 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS
    
WHERE znfmd640_ETR.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c in ('T70','T72','T73','A46')

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
          from baandb.ttcmcs080301 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA

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
       from BAANDB.tznfmd640301 znfmd640
                inner join baandb.tznfmd630301 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'CTR'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_CTR

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_CTR.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_CTR.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_CTR.t$pecl$c
       
LEFT JOIN baandb.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637301 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637301 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637301 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS
    
WHERE znfmd640_CTR.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c in ('T70','T72','T73','A46')

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
          from baandb.ttcmcs080301 a
          where a.t$cfrw = znfmd630.t$cfrw$c)         TRANSPORTADORA

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
       from BAANDB.tznfmd640301 znfmd640
                inner join baandb.tznfmd630301 znfmd630
                       on znfmd640.t$fili$c = znfmd630.t$fili$c
                      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
       where znfmd640.t$coci$c = 'SPC'
         and znfmd640.t$udat$c between trunc(to_date(:data_ini)) and trunc(to_date(:data_fim))+1.99999
       group by znfmd630.t$pecl$c,
                znfmd640.t$fili$c,
                znfmd640.t$etiq$c,
                znfmd640.t$coci$c ) znfmd640_SPC

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640_SPC.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640_SPC.t$etiq$c
       AND znfmd630.t$pecl$c = znfmd640_SPC.t$pecl$c
       
LEFT JOIN baandb.tcisli940301  cisli940
       ON cisli940.t$fire$l = znfmd630.t$fire$c
        
LEFT JOIN baandb.tznfmd637301 znfmd637
       ON znfmd637.t$txre$c = znfmd630.t$txre$c
      AND znfmd637.t$line$c = znfmd630.t$line$c
      AND znfmd637.t$brty$c = 1  --ICMS
            
LEFT JOIN baandb.tznfmd637301 znfmd637_PIS
       ON znfmd637_PIS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_PIS.t$line$c = znfmd630.t$line$c
      AND znfmd637_PIS.t$brty$c = 5  --PIS
       
LEFT JOIN baandb.tznfmd637301 znfmd637_COFINS
       ON znfmd637_COFINS.t$txre$c = znfmd630.t$txre$c
      AND znfmd637_COFINS.t$line$c = znfmd630.t$line$c
      AND znfmd637_COFINS.t$brty$c = 6  --COFINS
    
WHERE znfmd640_SPC.DATA_FILTRO between :data_ini and :data_fim
  AND znfmd630.t$cfrw$c in ('T70','T72','T73','A46')

ORDER BY FILIAL, NUME_ENTREGA, ETIQUETA
