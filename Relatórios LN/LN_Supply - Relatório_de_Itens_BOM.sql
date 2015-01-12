SELECT  
  trim(tcibd001.t$item)  NUM_ITEM_PRINCIPAL,
  tcibd001.t$dsca        DESC_ITEM_PRINCIPAL,
  trim(tibom010.t$sitm)  NUM_ITEM_COMPONENTE,
  tcibd001a.t$dsca       DESC_ITEM_COMPONENTE,
  tcibd001.t$espe$c      TIPO_ITEM, 
  iTABLE.                DESC_TIPO_ITEM,
  tibom010.t$qana        QUANTIDADE,
  tibom010.t$cwar        ARMAZÉM,
  tibom010.t$ipri$c      ITEM_PRINCIPAL,
  tcibd001a.t$citg       GRUPO_ITEM_COMP,
  tcmcs023a.t$dsca       DESC_GRP_ITEM_COMP

FROM       baandb.ttcibd001301 tcibd001

INNER JOIN baandb.ttibom010301 tibom010
        ON tibom010.t$mitm   = tcibd001.t$item

 LEFT JOIN baandb.ttcibd001301 tcibd001a
        ON tcibd001a.t$item  = tibom010.t$sitm
 
 LEFT JOIN baandb.ttcmcs023301 tcmcs023a 
        ON tcmcs023a.t$citg  = tcibd001a.t$citg
  
 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESC_TIPO_ITEM
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'zn' 
                AND d.t$cdom = 'ibd.espe.c'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTABLE
        ON iTABLE.CODE_STAT = tcibd001.t$espe$c

ORDER BY NUM_ITEM_PRINCIPAL