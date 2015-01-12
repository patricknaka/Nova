SELECT DISTINCT
  znfmd067.t$fili$c        FILIAL,
  Trim(znfmd001.t$dsca$c)  DESC_FILIAL,  
  tccom130.t$fovn$l        CNPJ_FORNECEDOR,
  tcmcs080.t$seak          APELIDO,
  znfmd064.t$rono$c        ID_CONTRATO,
  znfmd060.t$cdes$c        NOME_CONTRATO,
  znfmd060.t$tpen$c        TP_ENTREGA,
  znsls002.t$dsca$c        DESC_TP_ENTREGA

FROM       BAANDB.tznfmd064201 znfmd064
 
LEFT JOIN  BAANDB.tznfmd060201 znfmd060 
       ON  znfmd060.t$cfrw$c = znfmd064.t$rfrw$c 
      AND  znfmd060.t$cono$c = znfmd064.t$rono$c
 
LEFT JOIN  BAANDB.tznfmd067201 znfmd067 
       ON  znfmd067.t$cfrw$c = znfmd060.t$cfrw$c 
      AND  znfmd067.t$cono$c = znfmd060.t$cono$c
										  
LEFT JOIN  BAANDB.tznsls002201 znsls002 
       ON  znsls002.t$tpen$c = znfmd060.t$tpen$c
  
LEFT JOIN  BAANDB.ttcmcs080201 tcmcs080 
       ON  znfmd060.t$cfrw$c = tcmcs080.t$cfrw
  
LEFT JOIN  BAANDB.ttccom130201 tccom130 
       ON  tcmcs080.t$cadr$l = tccom130.t$cadr

INNER JOIN BAANDB.tznfmd001201  znfmd001
        ON znfmd001.t$fili$c = znfmd067.t$fili$c 

WHERE      znfmd064.t$ativ$c = 1
       AND znfmd060.t$cfrw$c IN (:Transportadora)
	   
ORDER BY   DESC_FILIAL, CNPJ_FORNECEDOR