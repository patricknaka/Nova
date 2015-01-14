select 

Q1.DATA_EMISSAO,
Q1.FILIAL,
Q1.ENTREGA,
Q1.CONTRATO,
Q1.DESCR_CONTRATO,
Q1.NOTA,
Q1.SERIE,
sum(Q1.PESO) PESO,
sum(Q1.VOLUME_M3) VOLUME_M3 ,
Q1.VLR_TOTAL_NF,
Q1.VLR_FRETE_CLIENTE,
Q1.ALIQUOTA,
sum(Q1.PESO_VOLUME) PESO_VOLUME,
Q1.AD_VALOREM,
Q1.PEDAGIO,
Q1.ADICIONAIS,
Q1.CNPJ_TRANS,
Q1.APELIDO,
Q1.ID_CONHECIMENTO,
Q1.ID_NR,
Q1.DATA_DEV_EMISS_NR,
Q1.CPF_DESTINATARIO,
Q1.CEP,
Q1.MUNICIPIO,
Q1.UF,
Q1.REGIAO,
Q1.ID_OCORRENCIA,
Q1.DATA_OCORRENCIA,
Q1.TIPO_DOCUMENTO_FIS,
Q1.DESCR_TIPO_DOC_FIS,
Q1.TIPO_NF,
Q1.CODE_TIPO_DOC,
Q1.DESCR_TIPO_DOC,
Q1.CFO_ENTREGA,
DESC_CFO_ENTREGA,

       Round( (sum(Q1.PESO_VOLUME) + Q1.AD_VALOREM + Q1.PEDAGIO + Q1.ADICIONAIS) /
              (1-(ALIQUOTA/100)) -
              (sum(Q1.PESO_VOLUME) + Q1.AD_VALOREM + Q1.PEDAGIO + Q1.ADICIONAIS), 4 )   VLR_ICMS, 
       Round( (sum(Q1.PESO_VOLUME) + Q1.AD_VALOREM + Q1.PEDAGIO + Q1.ADICIONAIS) /
              (1-(ALIQUOTA/100)) -
              (sum(Q1.PESO_VOLUME) + Q1.AD_VALOREM + Q1.PEDAGIO + Q1.ADICIONAIS) +
              (Q1.AD_VALOREM + Q1.PEDAGIO + Q1.ADICIONAIS + sum(Q1.PESO_VOLUME)), 4 )   FRETE_TOTAL
  
from ( SELECT DISTINCT
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$date$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE)
                                             DATA_EMISSAO, 
              znfmd630.t$fili$c              FILIAL,
              znfmd630.t$pecl$c              ENTREGA,
              znfmd630.t$cono$c              CONTRATO,
              znfmd060.t$cdes$c              DESCR_CONTRATO,  
              znfmd630.t$docn$c              NOTA,
              znfmd630.t$seri$c              SERIE, 
              znfmd630.t$wght$c              PESO, 
              
              nvl( ( select sum(wmd.t$hght   * 
                                wmd.t$wdth   * 
                                wmd.t$dpth   * 
                                sli.t$dqua$l * 
                                znmcs.t$cuba$c)
                       from baandb.tcisli941301 sli,
                            baandb.twhwmd400301 wmd, 
                            baandb.tznmcs080301 znmcs
                      where sli.t$fire$l = cisli940.t$fire$l
                        and wmd.t$item = sli.t$item$l
                        and znmcs.t$cfrw$c = znfmd630.t$cfrw$c ), 0 ) 
                                             VOLUME_M3,
                                             
              cisli940.t$amnt$l              VLR_TOTAL_NF,
              znfmd630.t$vlfr$c              VLR_FRETE_CLIENTE,

              ( select al.t$pvat$l
                  from baandb.tznfmd001301 fl
            inner join baandb.ttcmcs065301 df 
                    on df.t$cwoc = fl.t$cofc$c
            inner join baandb.ttccom130301 ef 
                    on ef.t$cadr = df.t$cadr, baandb.ttcmcs080301 tr
            inner join baandb.ttccom130301 et 
                    on et.t$cadr = tr.t$cadr$l, baandb.ttcmcs951301 al
                 where al.t$rfdt$l = 22
                   and al.t$stfr$l = et.t$cste
                   and al.t$stto$l = ef.t$cste
                   and fl.t$fili$c = znfmd630.t$fili$c
                   and TR.T$CFRW   = znfmd630.t$cfrw$c
                   and rownum = 1 )          ALIQUOTA,           
                                             
              znfmd630.t$vlfc$c              PESO_VOLUME,
              znfmd068.t$adva$c *
              ( cisli940.t$amnt$l / 100 )    AD_VALOREM,
              znfmd068.t$peda$c              PEDAGIO, 
              NVL(znfmd660.valor_adic,0)     ADICIONAIS, 
              znfmd170.t$fovn$c              CNPJ_TRANS, 
              tcmcs080.t$seak                APELIDO, 
              znfmd630.t$ncte$c              ID_CONHECIMENTO, 
              cisli940.t$fire$l              ID_NR,
              
              CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE)
                                             DATA_DEV_EMISS_NR, 
          
              tccom130.t$fovn$l              CPF_DESTINATARIO, 
              tccom130.t$pstc                CEP,
              tccom130.t$dsca                MUNICIPIO,
              tccom130.t$cste                UF,
              
              ( select znfmd061.t$dzon$c
                  from baandb.tznfmd062301 znfmd062, 
                       baandb.tznfmd061301 znfmd061
                 where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c 
                   and znfmd062.t$cono$c = znfmd630.t$cono$c
                   and znfmd062.t$cepd$c <= tccom130.t$pstc
                   and znfmd062.t$cepa$c >= tccom130.t$pstc
                   and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
                   and znfmd061.t$cono$c = znfmd062.t$cono$c
                   and znfmd061.t$creg$c = znfmd062.t$creg$c
                   and rownum = 1 )          REGIAO,
           
              ( select max(znfmd640.t$coci$c)
                  from BAANDB.tznfmd640301 znfmd640
                 where znfmd640.t$date$c = ( select max(znfmd640b.t$date$c) 
                                               from BAANDB.tznfmd640301 znfmd640b
                                              where znfmd640b.t$fili$c = znfmd640.t$fili$c 
                                                AND znfmd640b.t$etiq$c = znfmd640.t$etiq$c )
                   and znfmd640.t$fili$c = znfmd630.t$fili$c 
                   and znfmd640.t$etiq$c = znfmd630.t$etiq$c )       
                                             ID_OCORRENCIA,
                  
              ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c), 
                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                          AT time zone sessiontimezone) AS DATE)
                  FROM baandb.tznfmd640301 znfmd640
                 WHERE znfmd640.t$fili$c = znfmd630.t$fili$c
                   AND znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                                             DATA_OCORRENCIA,
  
              cisli940.t$fdty$l              TIPO_DOCUMENTO_FIS, 
              TIPO_DOC_FIS.                  DESCR_TIPO_DOC_FIS,
              
              CASE
                WHEN cisli940.t$fdty$l = 14 
                  THEN 'NFE' 
                ELSE   'NFS' 
               END AS                        TIPO_NF,
              
              cisli940.t$doty$l              CODE_TIPO_DOC,
              TIPO_DOC.                      DESCR_TIPO_DOC,
              cisli940.t$ccfo$l              CFO_ENTREGA,
              tcmcs940.t$dsca$l              DESC_CFO_ENTREGA  
    
   FROM       BAANDB.tznfmd630301 znfmd630 
  
   INNER JOIN BAANDB.ttcmcs080301 tcmcs080
           ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c 
     
    LEFT JOIN BAANDB.tcisli940301 cisli940
           ON cisli940.t$fire$l = znfmd630.t$fire$c
   
    LEFT JOIN BAANDB.tznfmd060301 znfmd060
           ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
          AND znfmd060.t$cono$c = znfmd630.t$cono$c
              
    LEFT JOIN BAANDB.tznfmd068301 znfmd068
           ON znfmd068.t$cfrw$c = znfmd630.t$cfrw$c 
          AND znfmd068.t$cono$c = znfmd630.t$cono$c
    
    LEFT JOIN BAANDB.tznfmd170301 znfmd170
           ON znfmd170.t$fili$c = znfmd630.t$fili$c 
          AND znfmd170.t$cfrw$c = znfmd630.t$cfrw$c
          AND znfmd170.t$nent$c = znfmd630.t$nent$c
   
    LEFT JOIN BAANDB.ttcmcs940301 tcmcs940
           ON tcmcs940.t$ofso$l = cisli940.t$ccfo$l 
                                    
    LEFT JOIN BAANDB.ttccom130301 tccom130
           ON tccom130.t$cadr = cisli940.t$stoa$l
       
    LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_DOC_FIS,
                       d.t$cnst
                  FROM baandb.tttadv401000 d,
                       baandb.tttadv140000 l
                 WHERE d.t$cpac = 'ci'
                   AND d.t$cdom = 'sli.tdff.l'
                   AND l.t$clan = 'p'
                   AND l.t$cpac = 'ci'
                   AND l.t$clab = d.t$za_clab
                   AND rpad(d.t$vers,4) || 
                       rpad(d.t$rele,2) || 
                       rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                       rpad(l1.t$rele,2) || 
                                                       rpad(l1.t$cust,4) ) 
                                              from baandb.tttadv401000 l1 
                                             where l1.t$cpac = d.t$cpac 
                                               and l1.t$cdom = d.t$cdom )
                   AND rpad(l.t$vers,4) || 
                       rpad(l.t$rele,2) || 
                       rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                       rpad(l1.t$rele,2) || 
                                                       rpad(l1.t$cust,4) ) 
                                              from baandb.tttadv140000 l1 
                                             where l1.t$clab = l.t$clab 
                                               and l1.t$clan = l.t$clan 
                                               and l1.t$cpac = l.t$cpac ) ) TIPO_DOC_FIS
           ON TIPO_DOC_FIS.t$cnst = cisli940.t$fdty$l
       
    LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_DOC,
                       d.t$cnst
                  FROM baandb.tttadv401000 d,
                       baandb.tttadv140000 l
                 WHERE d.t$cpac = 'tc'
                   AND d.t$cdom = 'doty.l'
                   AND l.t$clan = 'p'
                   AND l.t$cpac = 'tc'
                   AND l.t$clab = d.t$za_clab
                   AND rpad(d.t$vers,4) || 
                       rpad(d.t$rele,2) || 
                       rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                       rpad(l1.t$rele,2) || 
                                                       rpad(l1.t$cust,4) ) 
                                              from baandb.tttadv401000 l1 
                                             where l1.t$cpac = d.t$cpac 
                                               and l1.t$cdom = d.t$cdom )
                   AND rpad(l.t$vers,4) || 
                       rpad(l.t$rele,2) || 
                       rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                       rpad(l1.t$rele,2) || 
                                                       rpad(l1.t$cust,4) ) 
                                              from baandb.tttadv140000 l1 
                                             where l1.t$clab = l.t$clab 
                                               and l1.t$clan = l.t$clan 
                                               and l1.t$cpac = l.t$cpac ) ) TIPO_DOC
           ON TIPO_DOC.t$cnst = cisli940.t$doty$l
    
    LEFT JOIN ( select a.t$cfrw$c,
                       a.t$cono$c,
                       a.t$fili$c,
                       a.t$ngai$c,
                       a.t$etiq$c,
                       sum(a.t$vafr$c) valor_adic
                  from baandb.tznfmd660301 a
              group by a.t$cfrw$c,
                       a.t$cono$c,
                       a.t$fili$c,
                       a.t$ngai$c,
                       a.t$etiq$c ) znfmd660 
           ON ZNFMD660.t$cfrw$c = ZNFMD630.t$cfrw$c
          AND ZNFMD660.t$cono$c = ZNFMD630.t$cono$c
          AND ZNFMD660.t$fili$c = ZNFMD630.t$fili$c
          AND ZNFMD660.t$ngai$c = ZNFMD630.t$ngai$c
          AND ZNFMD660.t$etiq$c = ZNFMD630.t$etiq$c  )  Q1
		  
WHERE TIPO_NF IN (:TipoNF)
 AND TRUNC(DATA_EMISSAO)
     BETWEEN :DataDe 
         AND :DataAte
 AND ( (CNPJ_TRANS like '%' || :CNPJ  || '%') OR (:CNPJ is null) )


         
group by

Q1.DATA_EMISSAO,
Q1.FILIAL,
Q1.ENTREGA,
Q1.CONTRATO,
Q1.DESCR_CONTRATO,
Q1.NOTA,
Q1.SERIE,
Q1.VLR_TOTAL_NF,
Q1.VLR_FRETE_CLIENTE,
Q1.ALIQUOTA,
Q1.AD_VALOREM,
Q1.PEDAGIO,
Q1.ADICIONAIS,
Q1.CNPJ_TRANS,
Q1.APELIDO,
Q1.ID_CONHECIMENTO,
Q1.ID_NR,
Q1.DATA_DEV_EMISS_NR,
Q1.CPF_DESTINATARIO,
Q1.CEP,
Q1.MUNICIPIO,
Q1.UF,
Q1.REGIAO,
Q1.ID_OCORRENCIA,
Q1.DATA_OCORRENCIA,
Q1.TIPO_DOCUMENTO_FIS,
Q1.DESCR_TIPO_DOC_FIS,
Q1.TIPO_NF,
Q1.CODE_TIPO_DOC,
Q1.DESCR_TIPO_DOC,
Q1.CFO_ENTREGA,
DESC_CFO_ENTREGA

ORDER BY DATA_EMISSAO, 
         ENTREGA