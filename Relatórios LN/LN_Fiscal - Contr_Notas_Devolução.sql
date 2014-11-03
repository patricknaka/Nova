SELECT 
  DISTINCT
    301                                     CODE_CIA,
    tccom130b.t$fovn$l                      NUME_FILIAL,
    cisli940.t$docn$l                       NUME_NF,
    cisli940.t$seri$l                       SERI_NF,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_EMISSA,
    cisli940.t$ccfo$l                       COD_CFOP,
    cisli245.t$slso                         ORDEM,
    tdsls400.t$sotp                         TIPO_ORD_VENDA_DEV,
    tccom130.t$fovn$l                       CPF_CNPJ,
    cisli940.t$itbn$l                       NOME_PARCEI,
    tccom130.t$cste                         UF_PARCEI,
    cisli940.t$amnt$l                       VALO_NFD,
    Usuario.t$logn$c                        USUARIO,
    cisli940.t$cnfe$l                       CHAVE_NFD,
    cisli940.t$stat$l                       STATUS, iTABLE.DESC_STAT,
    cisli940.t$fire$l                       REF_FISCAL,
    NVL(cisli940d.t$docn$l, znmcs092.t$docn$c)    NOTA_NF_VENDA,  
    NVL(cisli940d.t$seri$l, znmcs092.t$seri$c)    SERI_NF_VENDA,
    NVL(cisli940d.t$cnfe$l, znmcs092.t$cnfe$c)    CHAVE_NF_VENDA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(NVL(cisli940d.t$date$l, znmcs092.t$trdt$c), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                                            DATA_NF_VENDA,                                        
    NVL(cisli940d.t$amnt$l, znmcs092.t$amnt$c)    VALO_NF_VENDA,
    cisli245d.t$slso                        NUME_OV,
    cisli940.t$fdty$l                       COD_TIPO_DOC_FISCAL,
    iTIPODOCFIS.DESCR                       DESC_TIPO_DOC_FISCAL,
    tdrec940.t$stat$l                       CODE_STAT_NF_ORIG,      -- Status ref fiscal
    iSTATRECFIS.DESCR                       DESCR_STAT_NF_ORIG,     -- Descric Staus Rf fiscal
    tdrec940.t$fire$l                       REFFIS_REC,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                                            DATA_REC,
                                             
    tdrec940.t$logn$l                       USER_REC,
    cisli940d.t$stat$l                      STATUS_NFD,
    DESCR_STATUS_NFD.DS_SITUACAO_NF         DESCR_STATUS_NFD
  
FROM       baandb.tcisli940301  cisli940 

INNER JOIN baandb.tcisli245301  cisli245
        ON cisli940.t$fire$l = cisli245.t$fire$l

INNER JOIN baandb.ttdsls401301  tdsls401
        ON tdsls401.t$orno   = cisli245.t$slso
       AND tdsls401.t$pono   = cisli245.t$pono
 
 LEFT JOIN baandb.tcisli245301  cisli245d
        ON cisli245d.t$fire$l = tdsls401.t$fire$l
       AND cisli245d.t$line$l = tdsls401.t$line$l
       AND cisli245d.t$fire$l != ' '

 LEFT JOIN baandb.tcisli940301  cisli940d
        ON cisli940d.t$fire$l = cisli245d.t$fire$l
     
INNER JOIN baandb.ttdsls400301  tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
    
INNER JOIN baandb.ttdrec947301  tdrec947
        ON tdrec947.t$orno$l = tdsls401.t$orno
       AND tdrec947.t$pono$l = tdsls401.t$pono

INNER JOIN baandb.ttdrec940301  tdrec940
        ON tdrec940.t$fire$l = tdrec947.t$fire$l
    
INNER JOIN baandb.ttcemm124301  tcemm124
        ON tcemm124.t$cwoc = cisli940.t$cofc$l

INNER JOIN baandb.ttcemm030301  tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.ttccom130301  tccom130
        ON tccom130.t$cadr = cisli940.t$itoa$l 
    
 LEFT JOIN ( SELECT znnfe002. t$fire$c, 
                    znnfe002.t$logn$c
               FROM baandb.tznnfe002301 znnfe002 
              WHERE znnfe002.t$datg$c = ( SELECT MAX(znnfe002A.t$datg$c)
                                            FROM baandb.tznnfe002301 znnfe002A
                                           WHERE znnfe002A.T$fire$c = znnfe002.T$fire$c ) ) Usuario
        ON Usuario.t$fire$c = cisli940.t$fire$l

 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_STAT
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'ci' 
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) iTABLE
        ON iTABLE.CODE_STAT = cisli940.t$stat$l
             
 LEFT JOIN ( SELECT d.t$cnst COD, l.t$desc DESCR 
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
                                            and l1.t$cpac  =  l.t$cpac ) ) iTIPODOCFIS
        ON iTIPODOCFIS.COD = cisli940.t$fdty$l

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'td'
                AND d.t$cdom = 'rec.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) iSTATRECFIS
        ON iSTATRECFIS.CODE = tdrec940.t$stat$l
  
 LEFT JOIN ( SELECT l.t$desc  DS_SITUACAO_NF,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'ci'
                AND d.t$cdom = 'sli.stat'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) DESCR_STATUS_NFD
        ON DESCR_STATUS_NFD.t$cnst = cisli940d.t$stat$l
        
INNER JOIN baandb.ttccom130301 tccom130B
        ON tccom130B.t$cadr = cisli940.t$sfra$l

LEFT  JOIN  baandb.tznmcs096301   znmcs096
        ON  znmcs096.t$orno$c=cisli245.t$slso
       AND  znmcs096.t$pono$c=cisli245.t$pono
       AND  znmcs096.t$ncmp$c=2
       AND  ROWNUM=1
       
LEFT  JOIN  baandb.tznmcs092301   znmcs092
        ON  znmcs092.t$ncmp$c=znmcs096.t$ncmp$c
       AND  znmcs092.t$cref$c=znmcs096.t$cref$c
       AND  znmcs092.t$cfoc$c=znmcs096.t$cfoc$c
       AND  znmcs092.t$docn$c=znmcs096.t$docn$c
       AND  znmcs092.t$seri$c=znmcs096.t$seri$c
       AND  znmcs092.t$doty$c=znmcs096.t$doty$c
       AND  znmcs092.t$trdt$c=znmcs096.t$trdt$c
       AND  znmcs092.t$creg$c=znmcs096.t$creg$c
       AND  znmcs092.t$cfov$c=znmcs096.t$cfov$c
       
WHERE cisli940.t$fdty$l = 14
  AND tcemm124.t$dtyp = 1 
  AND tdrec947.t$oorg$l = 1 --Venda
  --AND cisli245d.t$fire$l != ' '       --humberto.o

  AND tcemm030.T$EUNT IN (:Filial)
  AND tdrec940.t$stat$l IN(:StatusRefFiscal)
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE)) BETWEEN :EmissaoDE AND :EmissaoATE
  AND tdrec940.t$opfc$l IN (:COD_CFOP)
