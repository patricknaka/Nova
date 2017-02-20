select Q1.* from ( SELECT znfmd630.t$cfrw$c                 CODI_TRANS,
                          Trim(tcmcs080.t$dsca)             DESC_TRANS,
                          znfmd630.t$cfrw$c ||
                          ' - '             ||
                          Trim(tcmcs080.t$dsca)             COD_DESC_TRANS,
                          znfmd630.t$pecl$c                 ENTREGA,
                          SUM(znfmd630.t$vlfC$c)            FRETE_APAGAR,
                          CASE WHEN cisli940.t$fdty$l = 14 
                                 THEN 'NFE'
                               ELSE   'NFS' 
                           END                              TIPO_NF,
                          znfmd630.t$fili$c                 FILIAL
                      
                      FROM BAANDB.tznfmd630301  znfmd630
                      
                INNER JOIN BAANDB.tcisli940301  cisli940
                        ON znfmd630.t$fire$c = cisli940.t$fire$l
                
                INNER JOIN baandb.ttcmcs080301  tcmcs080
                        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
                
                     WHERE ( SELECT a.t$coci$c 
                               FROM baandb.tznfmd640301 a
                              WHERE a.t$fili$c = znfmd630.t$fili$c
                                AND a.t$etiq$c = znfmd630.t$etiq$c
                                AND a.t$coci$c IN ('ETR', 'ENT')
                                AND rownum = 1 ) IS NOT NULL  
                    
                       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
                                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                     AT time zone 'America/Sao_Paulo') AS DATE)) 
                           BETWEEN :DataDe 
                               AND :DataAte
                
                  GROUP BY znfmd630.t$cfrw$c,
                           Trim(tcmcs080.t$dsca),
                           znfmd630.t$cfrw$c,
                           Trim(tcmcs080.t$dsca),
                           CASE WHEN cisli940.t$fdty$l = 14 
                                  THEN 'NFE'
                                ELSE   'NFS' 
                            END,
                           znfmd630.t$fili$c,
		  	   znfmd630.t$pecl$c
                         
                  ORDER BY FILIAL,DESC_TRANS,TIPO_NF ) Q1
	 
           where Q1.tipo_nf in (:TipoNF)
