SELECT
  tccom130.t$fovn$l             CNPJ,
  tcmcs080.t$dsca               RAZAO_SOCIAL,
  tcmcs080.t$seak               APELIDO,
  znfmd064.t$prio$c             PRIORIDADE,
  znfmd064.t$rono$c             ID_CONTRATO_REVERSA,
  CONTRATO_REVERSA.             DS_CONTRATO_REVERSA,
  znfmd064.t$ativ$c             COD_SITUACAO_CONTRATO_REVERSA,
  SITUACAO_CONTRATO_REVERSA.    DS_SITUACAO_CONTRATO_REVERSA,
  znfmd064.t$cono$c             ID_CONTRATO,
  znfmd060.t$cdes$c             CONTRATO_NOME,
  tccom100.t$prst               SITUACAO_CONTRATO_CNPJ,
  CONTRATO_CNPJ.                DS_SITUACAO_CONTRATO_CNPJ  
  
FROM       BAANDB.tznfmd064301  znfmd064

INNER JOIN BAANDB.tznfmd060301  znfmd060
        ON znfmd064.t$cfrw$c = znfmd060.t$cfrw$c
       AND znfmd064.t$cono$c = znfmd060.t$cono$c
     
INNER JOIN BAANDB.ttcmcs080301  tcmcs080
        ON znfmd064.t$cfrw$c = tcmcs080.t$cfrw
  
INNER JOIN BAANDB.ttccom100301  tccom100
        ON tccom100.t$bpid   = tcmcs080.t$suno
  
INNER JOIN BAANDB.ttccom130301  tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr
    
 LEFT JOIN ( SELECT d.t$cnst CD_SITUACAO_CONTRATO_REVERSA,
                    l.t$desc DS_SITUACAO_CONTRATO_REVERSA
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'mcs.stat.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) SITUACAO_CONTRATO_REVERSA
        ON SITUACAO_CONTRATO_REVERSA.CD_SITUACAO_CONTRATO_REVERSA = znfmd064.t$ativ$c
    
 LEFT JOIN ( SELECT d.t$cnst CD_SITUACAO_CONTRATO_CNPJ,
                    l.t$desc DS_SITUACAO_CONTRATO_CNPJ
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tc'
                AND d.t$cdom = 'com.prst'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tc'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) CONTRATO_CNPJ
        ON CONTRATO_CNPJ.CD_SITUACAO_CONTRATO_CNPJ = tccom100.t$prst
		
 LEFT JOIN ( select a.t$cdes$c  DS_CONTRATO_REVERSA,
                    a.t$cfrw$c,
                    a.t$cono$c
               from baandb.tznfmd060301 a ) CONTRATO_REVERSA
        ON CONTRATO_REVERSA.t$cfrw$c = znfmd064.t$rfrw$c 
       AND CONTRATO_REVERSA.t$cono$c = znfmd064.t$rono$c

WHERE znfmd064.t$ativ$c = 1 
  AND znfmd064.t$ativ$c IN (:ContratoReversa)
  AND tccom100.t$prst IN (:ContratoCNPJ)
  
ORDER BY
   1, 2
