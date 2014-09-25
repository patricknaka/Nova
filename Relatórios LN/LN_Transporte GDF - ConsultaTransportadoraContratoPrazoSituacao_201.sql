SELECT 
  DISTINCT
    tccom130.t$fovn$l    CNPJ_TRANSP,
    znfmd060.t$cfrw$c    CODI_TRANSP,  
    tcmcs080.t$dsca      DESC_TRANSP,
    znfmd060.t$cono$c    NUME_CONTRATO,
    znfmd060.t$cdes$c    DESC_CONTRATO,  
    znfmd061.t$creg$c    CODI_ZONA_REGIAO,
    znfmd005.t$dsca$c    DESC_ZONA_REGIAO,  
    znfmd061.t$mrot$c    CODI_MEGA_ROTA,    
    znfmd061.t$drot$c    DESC_MEGA_ROTA,      
    znfmd061.t$tida$c    PRAZO_IDA,      
    znfmd061.t$tvol$c    PRAZO_VOLTA,      
    znfmd061.t$trev$c    PRAZO_REVERSA,
    znfmd062.t$cepd$c    CEP_DE,
    znfmd062.t$cepa$c    CEP_ATE,
    znfmd060.t$ativ$c    SITUACAO, DESC_ATIV_TMS

FROM      baandb.tznfmd060201  znfmd060,
          baandb.tznfmd061201  znfmd061  

LEFT JOIN baandb.tznfmd005201  znfmd005
       ON znfmd005.t$creg$c = znfmd061.t$creg$c,
    
          baandb.tznfmd062201  znfmd062,
          baandb.ttcmcs080201  tcmcs080  

LEFT JOIN baandb.ttccom130201  tccom130
       ON tccom130.t$cadr = tcmcs080.t$cadr$l,
    
        ( SELECT d.t$cnst CNST, 
                 l.t$desc DESC_ATIV_TMS
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'zn' 
             AND d.t$cdom = 'mcs.stat.c'
             AND d.t$vers = 'B61U'
             AND d.t$rele = 'a7'
             AND l.t$clab = d.t$za_clab
             AND l.t$clan = 'p'
             AND l.t$cpac = 'zn'
             AND l.t$vers = ( select max(l1.t$vers) 
                                from baandb.tttadv140000 l1 
                               where l1.t$clab = l.t$clab 
                                 and l1.t$clan = l.t$clan 
                                 and l1.t$cpac = l.t$cpac ) ) iATIV

WHERE znfmd060.t$ativ$c = iATIV.CNST
  AND tcmcs080.t$cfrw = znfmd060.t$cfrw$c
  AND znfmd061.t$cfrw$c = znfmd060.t$cfrw$c 
  AND znfmd061.t$cono$c = znfmd060.t$cono$c  
  AND znfmd062.t$cfrw$c = znfmd061.t$cfrw$c 
  AND znfmd062.t$creg$c = znfmd061.t$creg$c 
  AND znfmd062.t$cono$c = znfmd061.t$cono$c

  AND znfmd060.t$cfrw$c In (:Transp)