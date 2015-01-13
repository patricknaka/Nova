<<<<<<< HEAD
SELECT DISTINCT
=======
SELECT 
  DISTINCT
>>>>>>> parent of cf75d17... Relatório R078
  znfmd630.t$fili$c  FILIAL,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)      
                     DT_HR_EXPEDICAO, 
<<<<<<< HEAD

=======
        
>>>>>>> parent of cf75d17... Relatório R078
  znfmd630.t$docn$c     NUME_NOTA,
  znfmd630.t$seri$c     NUME_SERIE,  
  znsls401.t$entr$c     NUME_ENTREGA,
  znsls002.t$dsca$c     DESC_TIPO_ENTREGA_NOME,
  znfmd630.t$wght$c     PESO,
  znfmd630.t$qvol$c     VOLUME,
  znsls401.t$vlun$c     VL_SEM_FRETE,
  znfmd630.t$vlft$c     FRETE_GTE,
  znfmd630.t$vlmr$c     VLR_TOTAL_NF,
  znsls400.t$cepf$c     CEP,
  znsls400.t$cidf$c     CIDADE, 
  NVL(REGIAO.DSC,'BR')  REGIAO,
  znsls400.t$uffa$c     UF,  
  znfmd067.t$fate$c     ID_ESTAB,
  znfmd067.t$cfrw$c     ID_TRANSP,
  
  tcmcs080.t$cfrw   ||    
  ' - '             ||    
  Trim(tcmcs080.t$dsca) COD_DESC_TRANSPORTADOR,
  
  tcmcs080.t$seak       APELID_TRAN,
  znfmd630.t$cono$c     CONTRATO,
  znfmd060.t$cdes$c     NOME_CONTRATO,
  znfmd630.t$etiq$c     ETIQUETA  
 
<<<<<<< HEAD
FROM       baandb.ttcmcs080301 tcmcs080

INNER JOIN baandb.tznfmd630301 znfmd630
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c 
      
INNER JOIN baandb.tznsls401301 znsls401
        ON TO_CHAR(znsls401.t$entr$c) = TO_CHAR(znfmd630.t$pecl$c)  
       AND znsls401.t$orno$c = znfmd630.t$orno$c 
    
INNER JOIN baandb.tznsls400301 znsls400
=======
FROM       baandb.ttcmcs080201 tcmcs080

INNER JOIN baandb.tznfmd630201 znfmd630
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c 
      
INNER JOIN baandb.tznsls401201 znsls401
        ON TO_CHAR(znsls401.t$entr$c) = TO_CHAR(znfmd630.t$pecl$c)  
       AND znsls401.t$orno$c = znfmd630.t$orno$c 
    
INNER JOIN baandb.tznsls400201 znsls400
>>>>>>> parent of cf75d17... Relatório R078
        ON znsls400.t$ncia$c = znsls401.t$ncia$c 
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls400.t$pecl$c = znsls401.T$pecl$c 
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c

<<<<<<< HEAD
 LEFT JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
   
 LEFT JOIN baandb.tznfmd067301  znfmd067
=======
INNER JOIN baandb.tznsls004201 znsls004
        ON znsls004.t$ncia$c = znsls401.t$ncia$c 
       AND znsls004.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls004.t$pecl$c = znsls401.T$pecl$c 
       AND znsls004.t$sqpd$c = znsls401.T$sqpd$c 
       AND znsls004.t$orno$c = znsls401.T$orno$c
       AND znsls004.t$pono$c = znsls401.T$pono$c   

 LEFT JOIN baandb.tznsls002201 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
   
 LEFT JOIN baandb.tznfmd067201  znfmd067
>>>>>>> parent of cf75d17... Relatório R078
        ON znfmd067.t$cfrw$c = znfmd630.t$cfrw$c 
       AND znfmd067.t$cono$c = znfmd630.t$cono$c
       AND znfmd067.t$fili$c = znfmd630.t$fili$c  

<<<<<<< HEAD
 LEFT JOIN baandb.tznfmd640301 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c 
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
    
LEFT JOIN  BAANDB.tznfmd060301 znfmd060 
=======
 LEFT JOIN baandb.tznfmd640201 znfmd640
        ON znfmd640.t$fili$c = znfmd630.t$fili$c 
       AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
    
LEFT JOIN  BAANDB.tznfmd060201 znfmd060 
>>>>>>> parent of cf75d17... Relatório R078
       ON  znfmd060.t$cfrw$c = znfmd067.t$cfrw$c 
      AND  znfmd060.t$cono$c = znfmd067.t$cono$c

 LEFT JOIN ( SELECT znfmd006.t$creg$c DSC,
                    TO_NUMBER(znfmd006.t$fpst$c) t$fpst$c,
                    TO_NUMBER(znfmd006.t$tpst$c) t$tpst$c
<<<<<<< HEAD
               FROM baandb.tznfmd006301  znfmd006
=======
               FROM baandb.tznfmd006201  znfmd006
>>>>>>> parent of cf75d17... Relatório R078
              WHERE znfmd006.t$creg$c != 'BR' AND ROWNUM = 1 ) REGIAO
        ON REGIAO.t$fpst$c < = znsls401.t$cepe$c 
       AND REGIAO.t$tpst$c > = znsls401.t$cepe$c 
                               
<<<<<<< HEAD
WHERE (   (znfmd640.t$date$c is null) 
       OR (znfmd640.t$date$c = ( select max(oc.t$date$c) 
                                   from baandb.tznfmd640301 oc
                                  where oc.t$fili$c = znfmd640.t$fili$c
                                    and oc.t$etiq$c = znfmd640.t$etiq$c )) )

=======
WHERE  znfmd640.t$date$c = ( select max(oc.t$date$c) 
                              from baandb.tznfmd640201 oc
                             where oc.t$fili$c = znfmd640.t$fili$c
                               and oc.t$etiq$c = znfmd640.t$etiq$c )
>>>>>>> parent of cf75d17... Relatório R078
   AND znsls401.t$itpe$c IN (:TipoEntrega)
   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone sessiontimezone) AS DATE)) 
       BETWEEN :DtExpIni
           AND :DtExpFim
   AND tcmcs080.t$cfrw = CASE WHEN :Transportadora = 'T' THEN tcmcs080.t$cfrw ELSE :Transportadora END