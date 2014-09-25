SELECT 
DISTINCT
  znfmd630.t$cfrw$c	TRANSPORTADORA,   
                      ( SELECT  COUNT(znfmd630c.t$cfrw$c) 
                        FROM    BAANDB.tznfmd630201 znfmd630c,
                                       tcisli940201 cisli940c
                        WHERE   znfmd630c.t$cfrw$c = znfmd630.t$cfrw$c
                        AND     znfmd630c.t$fili$c = znfmd630.t$fili$c
                        AND     znfmd630c.t$fire$c = cisli940c.t$fire$l
                        AND     cisli940c.t$fdty$l = cisli940.t$fdty$l ) 	  
                    QTDE_ENTREGAS,
                      ( SELECT  SUM(znfmd630s.t$vlfr$c) 
                      FROM    BAANDB.tznfmd630201 znfmd630s,
                                     tcisli940201 cisli940s 
                      WHERE   znfmd630s.t$cfrw$c = znfmd630.t$cfrw$c
                      AND     znfmd630s.t$fili$c = znfmd630.t$fili$c    
                      AND     znfmd630s.t$fire$c = cisli940s.t$fire$l
                      AND     cisli940s.t$fdty$l = cisli940.t$fdty$l) 	  
                    FRETE_APAGAR,
  cisli940.t$fdty$l	TIPO_DOCTO, DESC_TIPO_DOCTO,
  znfmd630.t$fili$c	FILIAL

FROM
  BAANDB. tznfmd630201  znfmd630, 
          tcisli940201  cisli940,
          ( SELECT d.t$cnst CNST, l.t$desc DESC_TIPO_DOCTO
            FROM  tttadv401000 d, tttadv140000 l 
            WHERE d.t$cpac='ci' 
            AND   d.t$cdom='sli.tdff.l'
            AND   d.t$vers='B61U'
            AND   d.t$rele='a7'
            AND   l.t$clab=d.t$za_clab
            AND   l.t$clan='p'
            AND   l.t$cpac='ci'
            AND   l.t$vers=(  SELECT  max(l1.t$vers) 
                              from    tttadv140000 l1 
                              WHERE   l1.t$clab=l.t$clab 
                              AND     l1.t$clan=l.t$clan 
                              AND     l1.t$cpac=l.t$cpac)) FGET        
                   
WHERE
  znfmd630.t$fire$c = cisli940.t$fire$l 
AND 
  cisli940.t$fdty$l = FGET.CNST  