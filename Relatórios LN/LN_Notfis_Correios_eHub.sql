SELECT
    znfmd630.t$cfrw$c               COD_TRANSP,
    tcmcs080.t$dsca                 NOME_TRANSP,
    znfmd630.t$cono$c               NUMERO_CONTRATO,
    znfmd065.t$admi$c               CODIGO_ADMINISTRATIVO,
    tccom130_c.t$pstc               CEP_DESTINO,
    znfmd065.t$cser$c               CODIGO_SERVICO,
    znfmd630.t$vlmr$c               VALOR_DECLARADO,
    znfmd630.t$etiq$c               NUMERO_ETIQUETA,
    znfmd610.t$wght$c               PESO,
    znfmd065.t$post$c               N_CARTAO_POSTAGEM,
    znfmd630.t$docn$c               NOTA_FISCAL,
    SUBSTR(znfmd630.t$etiq$c,1,2)   SIGLA_SERVICO,
    SUM(whwmd400.t$dpth)            COMPRIMENTO,
    SUM(whwmd400.t$wdth)            LARGURA,
    SUM(whwmd400.t$hght)            ALTURA,
    cisli940.t$fids$l               NOME_DESTINATARIO,
    znfmd630.t$qvol$c               QTD_VOLUMES,
    znfmd630.t$ncar$c               CARGA,
    znfmd630.t$pecl$c               ENTREGA,
    tccom130_t.t$fovn$l             CNPJ_TRANSPORTADOR,
    'ETR'                           PONTO_ETR,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)  DATA_ETR
          
FROM  baandb.tznfmd630601 znfmd630

 LEFT JOIN baandb.tznfmd060601 znfmd060
        ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd630.t$cono$c
 
 LEFT JOIN baandb.tznfmd065601 znfmd065
        ON znfmd065.t$cfrw$c = znfmd060.t$cfrw$c
       AND znfmd065.t$cono$c = znfmd060.t$cono$c
       AND znfmd065.t$iden$c = znfmd060.t$refe$c
       
 LEFT JOIN baandb.tcisli940601 cisli940
        ON cisli940.t$fire$l = znfmd630.t$fire$c
        
 LEFT JOIN baandb.ttccom130601 tccom130_c         --End.Cliente
        ON tccom130_c.t$cadr = cisli940.t$stoa$l
        
 LEFT JOIN baandb.tznsls401601 znsls401
        ON znsls401.t$orno$c = znfmd630.t$orno$c
       AND  TO_CHAR(znsls401.t$entr$c) = TO_CHAR(znfmd630.t$pecl$c)
        
 LEFT JOIN baandb.twhwmd400601 whwmd400
        ON TRIM(TO_CHAR(whwmd400.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))
 
 LEFT JOIN baandb.ttcmcs080601 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
        
 LEFT JOIN baandb.ttccom130601 tccom130_t       --End.Transportadora
        ON tccom130_t.t$cadr = tcmcs080.t$cadr$l
             
 LEFT JOIN baandb.tznfmd610601 znfmd610
        ON znfmd610.t$fili$c = znfmd630.t$fili$c
       AND znfmd610.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd610.t$ngai$c = znfmd630.t$ngai$c
       AND znfmd610.t$etiq$c = znfmd630.t$etiq$c
       
 INNER JOIN ( Select znfmd640.t$fili$c,
                    znfmd640.t$etiq$c,
                    max(znfmd640.t$date$c) t$date$c
               from baandb.tznfmd640601 znfmd640
               where znfmd640.t$coct$c = 'ETR'
           group by znfmd640.t$fili$c,
                    znfmd640.t$etiq$c ) znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c 

WHERE znfmd630.T$CFRW$C = :Trasmportadora
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataSaidaDe
          And :DataSaidaAte
          
GROUP BY

    znfmd630.t$cfrw$c,
    tcmcs080.t$dsca,
    znfmd630.t$cono$c,
    znfmd065.t$admi$c,
    tccom130_c.t$pstc,
    znfmd065.t$cser$c,
    znfmd630.t$vlmr$c,
    znfmd630.t$etiq$c,
    znfmd610.t$wght$c,
    znfmd065.t$post$c,
    znfmd630.t$docn$c,
    SUBSTR(znfmd630.t$etiq$c,1,2),
    cisli940.t$fids$l,
    znfmd630.t$qvol$c,
    znfmd630.t$ncar$c,
    znfmd630.t$pecl$c,
    tccom130_t.t$fovn$l,
    'ETR',
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
