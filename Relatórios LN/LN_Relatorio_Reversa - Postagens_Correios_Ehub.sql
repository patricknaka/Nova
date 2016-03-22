select * from
(SELECT 
  DISTINCT
  	znint002.t$desc$c                         	UNIDADE_NEGOCIO,
    znfmd630.t$etiq$c 							COD_POSTAGEM,
    znsls401.t$entr$c 							ENTREGA,
    CASE WHEN cisli940.t$docn$l = 0 
           THEN NULL
         ELSE cisli940.t$docn$l 
    END                                      	NOTA,
    CASE WHEN cisli940.t$docn$l = 0 
           THEN NULL
         ELSE cisli940.t$seri$l 
    END                                       	SERIE,
    CASE WHEN cisli940.t$fdty$l = 14 --Retorno de Mercadoria de Cliente
           THEN 'Entrada' 
         ELSE   'Saida'  
    END                                         TIPO,
    Trim(tcibd001.t$item)                     	ITEM,
    tcibd001.t$dscb$c 							DESCR_ITEM,
    NVL(cisli941.t$dqua$l, 
        ABS(znsls401.t$qtve$c) )              	QTDE_ITEM,
    cisli941.t$amnt$l                         	VL_TOTAL_ITEM

FROM 	baandb.tznsls401301 znsls401

LEFT JOIN 	baandb.tcisli245301 cisli245
       ON 	cisli245.t$slso = znsls401.t$orno$c       
      AND 	cisli245.t$pono = znsls401.t$pono$c

inner JOIN 	baandb.tcisli940301 cisli940
       ON 	cisli940.t$fire$l = cisli245.t$fire$l  

LEFT JOIN 	baandb.tcisli941301 cisli941
       ON 	cisli941.t$fire$l = cisli245.t$fire$l
      AND 	cisli941.t$line$l = cisli245.t$line$l

inner JOIN	baandb.tznfmd630301	znfmd630
	   ON 	znfmd630.t$fire$c = cisli940.t$fire$l

LEFT JOIN baandb.ttdsls400301 tdsls400_2
       ON tdsls400_2.t$orno = znsls401.t$orno$c

 LEFT JOIN baandb.ttcibd001301 tcibd001
        ON TRIM(tcibd001.t$item) = TRIM(znsls401.t$item$c)
        
LEFT JOIN baandb.ttdsls094301 tdsls094
       ON tdsls094.t$sotp = tdsls400_2.t$sotp

LEFT JOIN baandb.tznint002301 znint002
       ON znint002.t$ncia$c = znsls401.t$ncia$c
      AND znint002.t$uneg$c = znsls401.t$uneg$c

WHERE 	TRIM(znsls401.t$idor$c) = 'TD'  -- Troca / Devolução
/*  AND 	znsls401.t$qtve$c < 0           -- Devolução
  AND 	tdsls094.t$reto in (1, 3)       -- Ordem Devolução, Ordem Devolução Rejeitada
  AND 	znsls401.t$itpe$c in (9, 15)    -- Postagem, Reversa*/
  ) q1
WHERE (:SENTIDO = 'E' and q1.TIPO = 'Entrada') or (:SENTIDO = 'S' and q1.TIPO = 'Saida')
  		
