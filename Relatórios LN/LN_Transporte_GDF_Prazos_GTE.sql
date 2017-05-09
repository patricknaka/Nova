SELECT
  znfmd067.t$fili$c        ESTAB,
  Trim(znfmd001.t$dsca$c)  DESC_EST,  
  tccom130.t$fovn$l        CNPJ,
  znfmd060.t$cfrw$c        TRANSPORTADOR,
                          
  znfmd060.t$cfrw$c ||    
  ' - '             ||    
  Trim(tcmcs080.t$dsca)    COD_DESC_TRANSPORTADOR,
                          
  znfmd060.t$cono$c        ID_CONTRATO,
  znfmd060.t$cdes$c        NOME_CONTRATO,
  znfmd060.t$tpen$c        TP_ENTREGA,
  znsls002.t$dsca$c        DESCR_TP_ENTREGA,
  znfmd061.t$creg$c        ID_REGIAO,
  znfmd061.t$dzon$c        REGIAO,
  znfmd061.t$tida$c        PZ_REMESSA,
  znfmd061.t$trev$c        PZ_REVERSA,
  znfmd062.t$cepd$c        CEP_INICIAL,
  znfmd062.t$cepa$c        CEP_FINAL,
  znfmd062.t$ativ$c        STATUS_FAIXA,
  STATUS_FAIXA.            DESCR_STATUS_FAIXA,
     
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd062.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
          'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)
                         DATA_HORA

FROM       BAANDB.tznfmd067201 znfmd067
 
LEFT JOIN  BAANDB.tznfmd060201 znfmd060 
       ON  znfmd060.t$cfrw$c = znfmd067.t$cfrw$c 
      AND  znfmd060.t$cono$c = znfmd067.t$cono$c

LEFT JOIN  BAANDB.tznfmd061201 znfmd061 
       ON  znfmd061.t$cfrw$c = znfmd067.t$cfrw$c   
      AND  znfmd061.t$cono$c = znfmd067.t$cono$c

LEFT JOIN  BAANDB.tznfmd062201 znfmd062 
       ON  znfmd062.t$cfrw$c = znfmd061.t$cfrw$c 
      AND  znfmd062.t$cono$c = znfmd061.t$cono$c 
      AND  znfmd062.t$creg$c = znfmd061.t$creg$c
   
INNER JOIN BAANDB.ttcmcs080201 tcmcs080
        ON znfmd060.t$cfrw$c = tcmcs080.t$cfrw

INNER JOIN BAANDB.ttccom100201 tccom100
        ON tccom100.t$bpid = tcmcs080.t$suno 
 
INNER JOIN BAANDB.ttccom130201 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr

LEFT JOIN  BAANDB.tznsls002201 znsls002  
       ON  znsls002.t$tpen$c = znfmd060.t$tpen$c

LEFT JOIN (SELECT d.t$cnst CODE,
                  l.t$desc DESCR_STATUS_FAIXA
             FROM baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            WHERE d.t$cpac = 'zn'                          
              AND d.t$cdom = 'mcs.stat.c'                      
              AND l.t$clan = 'p'
              AND l.t$cpac = 'zn'                
              AND l.t$clab = d.t$za_clab
              AND rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4)) 
                                         from baandb.tttadv401000 l1 
                                        where l1.t$cpac = d.t$cpac 
                                          and l1.t$cdom = d.t$cdom )
              AND rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) || 
                                                  rpad(l1.t$cust,4)) 
                                         from baandb.tttadv140000 l1 
                                        where l1.t$clab = l.t$clab 
                                          and l1.t$clan = l.t$clan 
                                          and l1.t$cpac = l.t$cpac )) STATUS_FAIXA
       ON  STATUS_FAIXA.CODE = znfmd062.t$ativ$c
	   
INNER JOIN BAANDB.tznfmd001201  znfmd001
        ON znfmd001.t$fili$c = znfmd067.t$fili$c 
  
WHERE  znfmd067.t$ativ$c = 1 
       
       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd062.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
           'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE))
       Between :DataDe
           And :DataAte
       
       AND znfmd060.t$cfrw$c IN (:Transportadora)
       
ORDER BY  DATA_HORA, ESTAB, TRANSPORTADOR


=
"SELECT  " &
"  znfmd067.t$fili$c        ESTAB,  " &
"  Trim(znfmd001.t$dsca$c)  DESC_EST,  " &
"  tccom130.t$fovn$l        CNPJ,  " &
"  znfmd060.t$cfrw$c        TRANSPORTADOR,  " &
"  " &
"  znfmd060.t$cfrw$c ||  " &
"  ' - '             ||  " &
"  Trim(tcmcs080.t$dsca)    COD_DESC_TRANSPORTADOR,  " &
"  " &
"  znfmd060.t$cono$c        ID_CONTRATO,  " &
"  znfmd060.t$cdes$c        NOME_CONTRATO,  " &
"  znfmd060.t$tpen$c        TP_ENTREGA,  " &
"  znsls002.t$dsca$c        DESCR_TP_ENTREGA,  " &
"  znfmd061.t$creg$c        ID_REGIAO,  " &
"  znfmd061.t$dzon$c        REGIAO,  " &
"  znfmd061.t$tida$c        PZ_REMESSA,  " &
"  znfmd061.t$trev$c        PZ_REVERSA,  " &
"  znfmd062.t$cepd$c        CEP_INICIAL,  " &
"  znfmd062.t$cepa$c        CEP_FINAL,  " &
"  znfmd062.t$ativ$c        STATUS_FAIXA,  " &
"  STATUS_FAIXA.            DESCR_STATUS_FAIXA,  " &
"  " &
"  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd062.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                         DATA_HORA  " &
"  " &
"FROM       BAANDB.tznfmd067" + Parameters!Compania.Value + " znfmd067  " &
"  " &
"LEFT JOIN  BAANDB.tznfmd060" + Parameters!Compania.Value + " znfmd060  " &
"       ON  znfmd060.t$cfrw$c = znfmd067.t$cfrw$c  " &
"      AND  znfmd060.t$cono$c = znfmd067.t$cono$c  " &
"  " &
"LEFT JOIN  BAANDB.tznfmd061" + Parameters!Compania.Value + " znfmd061  " &
"       ON  znfmd061.t$cfrw$c = znfmd067.t$cfrw$c  " &
"      AND  znfmd061.t$cono$c = znfmd067.t$cono$c  " &
"  " &
"LEFT JOIN  BAANDB.tznfmd062" + Parameters!Compania.Value + " znfmd062  " &
"       ON  znfmd062.t$cfrw$c = znfmd061.t$cfrw$c  " &
"      AND  znfmd062.t$cono$c = znfmd061.t$cono$c  " &
"      AND  znfmd062.t$creg$c = znfmd061.t$creg$c  " &
"  " &
"INNER JOIN BAANDB.ttcmcs080" + Parameters!Compania.Value + " tcmcs080  " &
"        ON znfmd060.t$cfrw$c = tcmcs080.t$cfrw  " &
"  " &
"INNER JOIN BAANDB.ttccom100" + Parameters!Compania.Value + " tccom100  " &
"        ON tccom100.t$bpid = tcmcs080.t$suno  " &
"  " &
"INNER JOIN BAANDB.ttccom130" + Parameters!Compania.Value + " tccom130  " &
"        ON tccom130.t$cadr = tccom100.t$cadr  " &
"  " &
"LEFT JOIN  BAANDB.tznsls002" + Parameters!Compania.Value + " znsls002  " &
"       ON  znsls002.t$tpen$c = znfmd060.t$tpen$c  " &
"  " &
"LEFT JOIN (SELECT d.t$cnst CODE,  " &
"                  l.t$desc DESCR_STATUS_FAIXA  " &
"             FROM baandb.tttadv401000 d,  " &
"                  baandb.tttadv140000 l  " &
"            WHERE d.t$cpac = 'zn'  " &
"              AND d.t$cdom = 'mcs.stat.c'  " &
"              AND l.t$clan = 'p'  " &
"              AND l.t$cpac = 'zn'  " &
"              AND l.t$clab = d.t$za_clab  " &
"              AND rpad(d.t$vers,4) ||  " &
"                  rpad(d.t$rele,2) ||  " &
"                  rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                  rpad(l1.t$rele,2) ||  " &
"                                                  rpad(l1.t$cust,4))  " &
"                                         from baandb.tttadv401000 l1  " &
"                                        where l1.t$cpac = d.t$cpac  " &
"                                          and l1.t$cdom = d.t$cdom )  " &
"              AND rpad(l.t$vers,4) ||  " &
"                  rpad(l.t$rele,2) ||  " &
"                  rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                  rpad(l1.t$rele,2) ||  " &
"                                                  rpad(l1.t$cust,4))  " &
"                                         from baandb.tttadv140000 l1  " &
"                                        where l1.t$clab = l.t$clab  " &
"                                          and l1.t$clan = l.t$clan  " &
"                                          and l1.t$cpac = l.t$cpac )) STATUS_FAIXA  " &
"       ON  STATUS_FAIXA.CODE = znfmd062.t$ativ$c  " &
"	  " &
"INNER JOIN BAANDB.tznfmd001" + Parameters!Compania.Value + "  znfmd001  " &
"        ON znfmd001.t$fili$c = znfmd067.t$fili$c  " &
"  " &
"WHERE  znfmd067.t$ativ$c = 1  " &
"  " &
"       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd062.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataDe  " &
"           And :DataAte  " &
"  " &
"       AND znfmd060.t$cfrw$c IN (:Transportadora)  " &
"  " &
"ORDER BY  DATA_HORA, ESTAB, TRANSPORTADOR  "
