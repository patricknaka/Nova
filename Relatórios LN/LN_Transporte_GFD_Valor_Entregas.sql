SELECT
  DISTINCT
   znfmd630.t$pecl$c NUM_ENTREGA,
   cisli940.t$gamt$l VALOR,
-- cisli940.t$docn$l NUM_NFISCAL, **** Campos abaixo para filtro
   CONCAT(CONCAT(znfmd630.t$fili$c, '  '),  
          znfmd001.t$dsca$c)  
                     FILIAL,
   CONCAT(CONCAT(znfmd630.t$cfrw$c, '  '),  
          tcmcs080.t$dsca)   
                     TRANSPORTADORA,
   CONCAT(CONCAT(znsls401.t$uneg$c, '  '),  
          znint002.t$desc$c)   
                     UNIDADE_NEGOCIO
 
FROM       BAANDB.tcisli940301 cisli940
     
INNER JOIN BAANDB.tznfmd630301 znfmd630
        ON znfmd630.t$fire$c = cisli940.t$fire$l 
       AND znfmd630.t$docn$c = cisli940.t$docn$l 
       AND znfmd630.t$seri$c = cisli940.t$seri$l 
     
 LEFT JOIN BAANDB.tznfmd001301 znfmd001
        ON znfmd001.t$fili$c = znfmd630.t$fili$c

 LEFT JOIN BAANDB.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
  
INNER JOIN BAANDB.tznfmd640301 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c 
  
INNER JOIN BAANDB.tznsls401301 znsls401
        ON to_char(znsls401.t$entr$c) = znfmd630.t$pecl$c
  
 LEFT JOIN BAANDB.tznint002301 znint002
        ON znint002.t$ncia$c = znsls401.t$ncia$c
       AND znint002.t$uneg$c = znsls401.t$uneg$c

WHERE UPPER(znfmd640.t$coci$c) = 'ETR'
  --AND cisli940.t$doty$l = 9   -- (NFS)
  AND znfmd630.t$fili$c IN (:FILIAL)
  AND znfmd630.t$cfrw$c IN (:TRANSPORTADORA)
  AND znsls401.t$uneg$c IN (:UniNEGOCIO)