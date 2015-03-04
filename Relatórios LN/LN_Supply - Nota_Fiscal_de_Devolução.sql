SELECT
  DISTINCT 
    tcibd001.t$citg          GRUPO_ITEM,
    tcmcs023.t$dsca          DESCR_GRP_ITEM,
    cisli941.t$ccfo$l        NUM_CFOP,
 
    CASE WHEN cisli940.t$cofc$l IS NULL THEN 'N/A' 
         ELSE cisli940.t$cofc$l 
     END                     CODE_DEPTO,
  
    CASE WHEN tcmcs065.t$dsca IS NULL THEN 'N/A' 
         ELSE tcmcs065.t$dsca 
     END                     DESCR_DEPTO,
  
    cisli940.t$cbrn$c        CODE_RAMO_ATV,
    tcmcs031.t$dsca          DESCR_RAMO_ATV,
    tccom130.t$fovn$l        CNPJ_FORNEC,
    tccom130.t$nama          NOME_FORNEC,
    cisli940.t$docn$l        NUM_NF_DEV,
    cisli940.t$seri$l        SER_NF_DEV,
    tdrec940.t$docn$l        NUM_NF_REC,
    tdrec940.t$seri$l        SER_NF_REC,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                             DATA_FAT,
 
    cisli940.t$stat$l        SIT_NFE, 
    DSTAT.                   DESC_STAT,
    cisli940.t$fire$l        REF_NFD,
    tdrec940.t$fire$l        REF_NFR,
    Trim(cisli941.t$item$l)  ITEM,
    tcibd001.t$dsca          DESCR_ITEM,
    cisli941.t$dqua$l        QUANT,
    cisli941.t$pric$l        PREC_ITEM,
 
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
       WHERE cisli943.t$fire$l = cisli941.t$fire$l
         AND cisli943.t$line$l = cisli941.t$line$l
         AND cisli943.t$brty$l = 3 ) 
                             VLR_IPI,   
  
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
       WHERE cisli943.t$fire$l = cisli941.t$fire$l
         AND cisli943.t$line$l = cisli941.t$line$l
         AND cisli943.t$brty$l = 1 ) 
                             VLR_ICMS,
  
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
       WHERE cisli943.t$fire$l = cisli941.t$fire$l
         AND cisli943.t$line$l = cisli941.t$line$l
         AND cisli943.t$brty$l = 2 ) 
                             VLR_ICMS_ST,
  
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
       WHERE cisli943.t$fire$l = cisli941.t$fire$l
         AND cisli943.t$line$l = cisli941.t$line$l
         AND cisli943.t$brty$l = 5 ) 
                             VLR_PIS,                  
  
    ( SELECT cisli943.t$amnt$l 
        FROM baandb.tcisli943301 cisli943
       WHERE cisli943.t$fire$l = cisli941.t$fire$l
         AND cisli943.t$line$l = cisli941.t$line$l
         AND cisli943.t$brty$l = 6) 
                             VLR_COFINS,
  
    cisli941.t$gamt$l        VLR_TOTAL_MERCADORIA,
    cisli941.t$amnt$l        VLR_TOTAL_NFISCAL,
    cisli940.t$cnfe$l        CHAVE_ACESSO,                    
   
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)    
                             DATA_ORDEM_DEVOLVIDA,
                             
    NVL( ( select Trim(tttxt010.t$text)
             from baandb.ttttxt010301 tttxt010 
            where tttxt010.t$ctxt = cisli940.t$obse$l),' ') 
                             OBS_NF
                      
FROM       baandb.tcisli940301 cisli940

INNER JOIN baandb.tcisli941301 cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l

INNER JOIN baandb.tcisli951301 cisli951
        ON cisli951.t$fire$l = cisli941.t$fire$l 
       AND cisli951.t$line$l = cisli941.t$line$l
  
 LEFT JOIN baandb.ttdpur401301 tdpur401
        ON tdpur401.t$orno = cisli951.t$slso$l 
       AND tdpur401.t$pono = cisli951.t$pono$l
  
 LEFT JOIN baandb.ttdpur400301 tdpur400
        ON tdpur400.t$orno = cisli951.t$slso$l                                
  
 LEFT JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$fire$l = tdpur401.t$fire$l

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = cisli941.t$item$l

INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = cisli940.t$bpid$l
            
 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
      
INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg

INNER JOIN baandb.ttcmcs031301 tcmcs031
        ON tcmcs031.t$cbrn = cisli940.t$cbrn$c

INNER JOIN baandb.ttcmcs065301 tcmcs065
        ON tcmcs065.t$cwoc = cisli940.t$cofc$l
  
INNER JOIN( SELECT d.t$cnst CODE_STAT, 
                   l.t$desc DESC_STAT
             FROM  baandb.tttadv401000 d, 
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
                                           and l1.t$cpac = l.t$cpac )  ) DSTAT
        ON DSTAT.CODE_STAT = cisli940.t$stat$l
                        
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') AS DATE)) 
      BETWEEN NVL(:DtEmissaoDe,CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                  AT time zone 'America/Sao_Paulo') AS DATE)) 
          AND NVL(:DtEmissaoAte,CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                   AT time zone 'America/Sao_Paulo') AS DATE)) 

      AND tccom130.t$fovn$l Like NVL('%'  || (:CNPJ) || '%', tccom130.t$fovn$l)
      AND tcibd001.t$citg IN (:Depto)
      AND ( ((CASE WHEN cisli940.t$cofc$l is null THEN 'N/A' 
                 else Upper(cisli940.t$cofc$l) 
             END) = Upper(:Filial)) or (:Filial is null) )
    AND cisli940.t$stat$l in (:Status)
    AND Trim(cisli941.t$item$l) LIKE '%' || :Item || '%'
  
ORDER BY
    DATA_ORDEM_DEVOLVIDA,
    GRUPO_ITEM,
    CNPJ_FORNEC,
    CODE_DEPTO