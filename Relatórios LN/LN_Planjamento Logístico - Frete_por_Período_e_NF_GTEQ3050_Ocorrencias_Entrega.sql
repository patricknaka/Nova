SELECT znfmd640.t$fili$c               FILIAL,
       znfmd630.t$cfrw$c               COD_TRANSPORTADORA,
       tcmcs080.t$dsca                 TRANSPORTADORA,
       znfmd640.t$etiq$c               ETIQUETA,
       znfmd630.t$pecl$c               ENTREGA,
       znfmd630.t$orno$c               ORDEM_VENDA,
       znfmd630.t$docn$c               NF,
       znfmd630.t$seri$c               SERIE,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c,
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_EMISSAO_NF,
       znfmd640.t$coci$c               OCORRENCIA,
       znfmd040.t$dotr$c               DESCRICAO,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c,
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_OCORRENCIA,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c,
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
                                       DATA_INCLUSAO_LN,
      znfmd640.t$ulog$c                USUARIO

FROM  baandb.tznfmd640301 znfmd640

INNER JOIN baandb.tznfmd630301 znfmd630
        ON znfmd630.t$fili$c = znfmd640.t$fili$c
       AND znfmd630.t$etiq$c = znfmd640.t$etiq$c

INNER JOIN baandb.tznfmd040301 znfmd040
        ON znfmd040.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd040.t$ocin$c = znfmd640.t$coci$c

INNER JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
        
  WHERE znfmd640.T$TORG$C = 1     --Origem Vendas
  AND       TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c,
            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE))
           BETWEEN :Dt_Ocorr_Ini
               AND :Dt_Ocorr_Fim
  AND ((:Transportadora = 'T') or (znfmd630.t$cfrw$c IN :Transportadora))

AND znfmd640.t$fili$c = 3
AND znfmd640.t$etiq$c = 'DU423205140BR'
       
ORDER BY FILIAL, TRANSPORTADORA, ETIQUETA, ENTREGA, DATA_OCORRENCIA
