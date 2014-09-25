SELECT  
  tcibd001.t$item   NUM_ITEM_PRINCIPAL,
  tcibd001.t$dsca	  DESC_ITEM_PRINCIPAL,
  tibom010.t$sitm	  NUM_ITEM_COMPONENTE,
  tcibd001a.t$dsca	DESC_ITEM_COMPONENTE,
  tcibd001.t$espe$c	TIPO_ITEM, DESC_TIPO_ITEM,
  tibom010.t$qana	  QUANTIDADE,
  tibom010.t$cwar	  ARMAZÉM,
  tibom010.t$ipri$c	ITEM_PRINCIPAL,
  tcibd001a.t$citg	GRUPO_ITEM_COMP,
  tcmcs023a.t$dsca	DESC_GRP_ITEM_COMP
FROM
  ttcibd001201  tcibd001,
  ttibom010201  tibom010
  LEFT  JOIN
  ttcibd001201  tcibd001a
        ON      tcibd001a.t$item = tibom010.t$sitm
  LEFT JOIN
  ttcmcs023201 tcmcs023a ON tcmcs023a.t$citg=tcibd001a.t$citg,
  ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_TIPO_ITEM
    FROM  tttadv401000 d, tttadv140000 l 
    WHERE d.t$cpac='zn' 
    AND   d.t$cdom='ibd.espe.c'
    AND   d.t$vers='B61U'
    AND   d.t$rele='a7'
    AND   l.t$clab=d.t$za_clab
    AND   l.t$clan='p'
    AND   l.t$cpac='zn'
    AND   l.t$vers=(  SELECT  max(l1.t$vers) 
                      from    tttadv140000 l1 
                      WHERE   l1.t$clab=l.t$clab 
                      AND     l1.t$clan=l.t$clan 
                      AND     l1.t$cpac=l.t$cpac)) iTABLE        
        
WHERE
  tibom010.t$mitm = tcibd001.t$item
AND
  tcibd001.t$espe$c = iTABLE.CODE_STAT
  