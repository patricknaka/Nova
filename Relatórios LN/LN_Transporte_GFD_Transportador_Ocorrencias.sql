SELECT DISTINCT
  znfmd067.t$fili$c        FILIAL,
  Trim(znfmd001.t$dsca$c)  DESC_FILIAL,   
 
  znfmd040.t$cfrw$c        TRAS_ID_TRANSP,
 
  znfmd040.t$cfrw$c ||    
  ' - '             ||    
  Trim(tcmcs080.t$dsca)    COD_DESC_TRANSPORTADOR,
  
  tcmcs080.t$seak          TRAS_APELIDO,
  znfmd040.t$octr$c        OCORRENCIA,
  znfmd040.t$dotr$c        DESCR_OCORRENCIA,
  znfmd040.t$ocin$c        COD_INTERNO,
  znfmd030.t$dsci$c        DESCR_COD_INTERNO,
    
  CASE WHEN znfmd040.t$actt$c = 1 THEN 'Sim'      
       WHEN znfmd040.t$actt$c = 2 THEN 'Não'
       ELSE NULL END AS    ALTERA_TTIME,
    
  znfmd040.t$acid$c        PZ_ACRESC_TTIME,
  
  CASE WHEN znfmd040.t$pfre$c = 1 THEN 'Sim'      
       WHEN znfmd040.t$pfre$c = 2 THEN 'Não'
       ELSE NULL END AS    PAGA_FRETE,
  
  znfmd040.t$nmxr$c        MAX_REPET,
  znfmd040.t$stat$c        SITUACAO,
  DOMSIT.DESCR             DESC_SITUACAO, 
  znfmd040.t$pzeh$c        PZ_ENVIO,
  znfmd040.t$logn$c        USUARIO_ULT_ALT,
  znfmd040.t$date$c        DATA_ULT_ALT

FROM       BAANDB.tznfmd040201 znfmd040
    
LEFT JOIN  BAANDB.tznfmd030201 znfmd030 
       ON  znfmd040.t$ocin$c = znfmd030.t$ocin$c
     
INNER JOIN BAANDB.tznfmd067201 znfmd067
        ON znfmd067.t$cfrw$c = znfmd040.t$cfrw$c
  
INNER JOIN BAANDB.ttcmcs080201 tcmcs080
        ON tcmcs080.t$cfrw = znfmd040.t$cfrw$c

INNER JOIN BAANDB.tznfmd001201  znfmd001
        ON znfmd001.t$fili$c = znfmd067.t$fili$c
  
LEFT JOIN  ( SELECT d.t$cnst, 
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac='zn'
                AND d.t$cdom='mcs.stat.c'
                AND l.t$clan='p'
                AND l.t$cpac='zn'
                AND l.t$clab=d.t$za_clab
                AND rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = (select max(rpad(l1.t$vers,4) || 
                                                   rpad(l1.t$rele,2) || 
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac=d.t$cpac 
                                           AND l1.t$cdom=d.t$cdom)
               
                AND rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = (select max(rpad(l1.t$vers,4) || 
                                                   rpad(l1.t$rele,2) || 
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab=l.t$clab 
                                           AND l1.t$clan=l.t$clan 
                                           AND l1.t$cpac=l.t$cpac)) DOMSIT 
       ON DOMSIT.t$cnst = znfmd040.t$stat$c

WHERE  znfmd040.t$cfrw$c IN (:Transportadora)
           
ORDER BY FILIAL, TRAS_ID_TRANSP