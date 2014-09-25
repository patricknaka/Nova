SELECT
  znfmd067.t$fili$c   ID_EST,
  znfmd001.t$dsca$c   DESC_EST,
  znfmd060.t$cfrw$c   ID_TRANSP,
  tcmcs080.t$dsca     TRAN_NOME,
  tcmcs080.t$seak     APELIDO,
  znfmd060.t$cono$c   CONTRATO,
  znfmd060.t$cdes$c   CONTRATO_NOME,
  znfmd060.t$sdat$c   DT_INICIO,
  znfmd060.t$edat$c   DT_FIM,
  znfmd060.t$tpen$c   TP_ENTREGA,
  znsls002.t$dsca$c   DESC_TP_ENTREGA,
  znfmd060.t$ttra$c   TP_TRANSP,
  
  ( SELECT l.t$desc DESCR
      FROM baandb.tttadv401000 d,
           baandb.tttadv140000 l
     WHERE d.t$cpac = 'zn'
       AND d.t$cdom = 'mcs.tptr.c'
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
                                   and l1.t$cpac = l.t$cpac )
       AND d.t$cnst = znfmd060.t$ttra$c )
                      DESC_TP_TRANSP,
            
  CASE WHEN znfmd060.t$crem$c = 1 THEN 'Sim' 
       ELSE 'Não' 
   END                REMESSA
  
FROM BAANDB.tznfmd060301  znfmd060,
     BAANDB.tznfmd067301  znfmd067,
     BAANDB.ttcmcs080301  tcmcs080,
     BAANDB.tznsls002301  znsls002,
     BAANDB.tznfmd001301  znfmd001
  
WHERE znfmd060.t$cfrw$c = tcmcs080.t$cfrw   
  AND znfmd067.t$cfrw$c = znfmd060.t$cfrw$c 
  AND znfmd067.t$cono$c = znfmd060.t$cono$c 
  AND znsls002.t$tpen$c = znfmd060.t$tpen$c 
  AND znfmd001.t$fili$c = znfmd067.t$fili$c 
  AND znfmd067.t$ativ$c = 1 
  
  AND Trunc(znfmd060.t$sdat$c) Between NVL(:DataInicioDe, znfmd060.t$sdat$c) 
  AND NVL(:DataInicioAte, znfmd060.t$sdat$c) 
  AND Trunc(znfmd060.t$edat$c) Between NVL(:DataFimDe, znfmd060.t$edat$c) 
  AND NVL(:DataFimAte, znfmd060.t$edat$c) 
  AND znfmd060.t$cfrw$c IN (:Transportadora)
  
ORDER BY 1, 2