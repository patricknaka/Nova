SELECT 
  DISTINCT
    znsls401.t$entr$c   ENTREGA,
 
    ( select znfmd640.t$coci$c 
        from BAANDB.tznfmd640301 znfmd640
       where znfmd640.t$date$c = ( SELECT max(znfmd640b.t$date$c) 
                                     FROM BAANDB.tznfmd640301 znfmd640b
                                    WHERE znfmd640b.t$fili$c = znfmd640.t$fili$c 
                                      AND znfmd640b.t$etiq$c = znfmd640.t$etiq$c )
         and znfmd640.t$fili$c = znfmd630.t$fili$c 
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c) 
                        INSTANCIA, 
   
    cisli940v.t$docn$l  NFS,
    cisli940v.t$seri$l  SERIE_NFS,
    cisli940d.t$docn$l  NFE,
    cisli940d.t$seri$l  SERIE_NFE,
    znsls401.t$pecl$c   PEDIDO,
    tcmcs080.t$dsca     TRANSPORTADOR,
    cisli245d.t$slso    ID_DEVOLUCAO,
    cisli940d.t$fire$l  ID_NR,
    cisli940d.t$stat$l  DEV_SITUACAO, DESC_STAT,
 
    ( select max(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640b.t$date$c, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone sessiontimezone) AS DATE)) 
        from BAANDB.tznfmd640301 znfmd640b
       where znfmd640b.t$fili$c = znfmd630.t$fili$c 
         and znfmd640b.t$etiq$c = znfmd630.t$etiq$c )
                        DATA_SITUACAO
  
FROM       baandb.tcisli940301  cisli940v

INNER JOIN baandb.tcisli245301  cisli245v
        ON cisli940v.t$fire$l = cisli245v.t$fire$l

 LEFT JOIN BAANDB.tznfmd630301  znfmd630
        ON znfmd630.t$fire$c = cisli940v.t$fire$l 

 LEFT JOIN baandb.ttcmcs080301  tcmcs080
        ON tcmcs080.t$cfrw = cisli940v.T$cfrw$l

INNER JOIN baandb.ttdsls401301  tdsls401
        ON tdsls401.t$orno = cisli245v.t$slso
       AND tdsls401.t$pono = cisli245v.t$pono
       
INNER JOIN BAANDB.ttdsls401301 tdsls401d
        ON  tdsls401d.t$fire$l=cisli940v.t$fire$l
    
INNER JOIN baandb.tcisli245301  cisli245d  
        ON cisli245d.t$slso = tdsls401d.t$orno
       AND cisli245d.t$pono = tdsls401d.t$pono
 
INNER JOIN baandb.tcisli940301  cisli940d
        ON cisli940d.t$fire$l = cisli245d.t$fire$l

 LEFT JOIN baandb.tznsls401301  znsls401
        ON tdsls401.t$orno = znsls401.t$orno$c
       AND tdsls401.t$pono = znsls401.t$pono$c
    
 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESC_STAT
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTABLE
        ON cisli940d.t$stat$l = iTABLE.CODE_STAT
  
WHERE cisli940d.t$fdty$l = 14

  AND znsls401.t$entr$c in (:NumEntrega)