SELECT 
DISTINCT 
  tcibd001.t$citg    GRUPO_ITEM,
  tcmcs023.t$dsca    DESCR_GRP_ITEM,
  cisli941.t$ccfo$l  NUM_CFOP,
  CASE WHEN cisli940.t$cofc$l is null THEN 'N/A' 
       else cisli940.t$cofc$l 
   END               CODE_DEPTO,
  CASE WHEN tcmcs065.t$dsca is null THEN 'N/A' 
       else tcmcs065.t$dsca 
   END               DESCR_DEPTO,
  cisli940.t$cbrn$c  CODE_RAMO_ATV,
  tcmcs031.t$dsca    DESCR_RAMO_ATV,
  tccom130.t$fovn$l  CNPJ_FORNEC,
  tccom130.t$nama    NOME_FORNEC,
  cisli940.t$docn$l  NUM_NF_DEV,
  cisli940.t$seri$l  SER_NF_DEV,
  tdrec940.t$docn$l  NUM_NF_REC,
  tdrec940.t$seri$l  SER_NF_REC,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)
                     DATA_FAT,
  cisli940.t$stat$l  SIT_NFE, DESC_STAT  ,
  cisli940.t$fire$l  REF_NFD,
  tdrec940.t$fire$l  REF_NFR,
  Trim(cisli941.t$item$l)  
                     ITEM,
  tcibd001.t$dsca    DESCR_ITEM,
  cisli941.t$dqua$l  QUANT,
  cisli941.t$pric$l  PREC_ITEM,
  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=3) 
                     VLR_IPI,   

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=1) 
                     VLR_ICMS,

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=2) 
                     VLR_ICMS_ST,

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=5) 
                     VLR_PIS,                  

  ( SELECT cisli943.t$amnt$l 
      FROM baandb.tcisli943201 cisli943
     WHERE cisli943.t$fire$l=cisli941.t$fire$l
       AND cisli943.t$line$l=cisli941.t$line$l
       AND cisli943.t$brty$l=6) 
                     VLR_COFINS,

  cisli941.t$gamt$l  VLR_TOTAL_MERCADORIA,
  cisli941.t$amnt$l  VLR_TOTAL_NFISCAL,
  cisli940.t$cnfe$l  CHAVE_ACESSO, 
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)    
                     DATA_ORDEM_DEVOLVIDA,

  nvl( ( select Trim(tttxt010.t$text)
           from baandb.ttttxt010201	tttxt010 
          where tttxt010.t$ctxt = cisli940.t$obse$l),' ') 
                     OBS_NF
                    
FROM      baandb.tcisli940201  cisli940,
          baandb.tcisli941201  cisli941,
          baandb.tcisli951201  cisli951  

LEFT JOIN baandb.ttdpur401201  tdpur401
       ON tdpur401.t$orno = cisli951.t$slso$l 
      AND tdpur401.t$pono = cisli951.t$pono$l

LEFT JOIN baandb.ttdpur400201  tdpur400
       ON tdpur400.t$orno = cisli951.t$slso$l                                

LEFT JOIN baandb.ttdrec940201  tdrec940
       ON tdrec940.t$fire$l = tdpur401.t$fire$l,

          baandb.ttcibd001201  tcibd001,
          baandb.ttccom100201  tccom100
          
LEFT JOIN baandb.ttccom130201  tccom130
       ON tccom130.t$cadr = tccom100.t$cadr,    
	   
          baandb.ttcmcs023201  tcmcs023,
          baandb.ttcmcs031201  tcmcs031,  
          baandb.ttcmcs065201  tcmcs065,

        ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_STAT
            FROM  baandb.tttadv401000 d, tttadv140000 l 
           WHERE d.t$cpac='ci' 
             AND d.t$cdom='sli.stat'
             AND d.t$vers='B61U'
             AND d.t$rele='a7'
             AND d.t$cust='glo1'
             AND l.t$clab=d.t$za_clab
             AND l.t$clan='p'
             AND l.t$cpac='ci'
             AND l.t$vers=( SELECT max(l1.t$vers) 
                              from baandb.tttadv140000 l1 
                             WHERE l1.t$clab=l.t$clab 
                               AND l1.t$clan=l.t$clan 
                               AND l1.t$cpac=l.t$cpac) ) DSTAT
                      
WHERE cisli940.t$stat$l   = DSTAT.CODE_STAT  
  AND cisli941.t$fire$l = cisli940.t$fire$l
  AND tcibd001.t$item   = cisli941.t$item$l
  AND cisli951.t$fire$l = cisli941.t$fire$l 
  AND cisli951.t$line$l = cisli941.t$line$l
  AND tcmcs023.t$citg   = tcibd001.t$citg
  AND tcmcs031.t$cbrn   = cisli940.t$cbrn$c 
  AND tcmcs065.t$cwoc   = cisli940.t$cofc$l
  AND tccom100.t$bpid   = cisli940.t$bpid$l

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone sessiontimezone) AS DATE)) 
        BETWEEN NVL(:DtEmissaoDe,CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE)) 
        AND NVL(:DtEmissaoAte,CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone sessiontimezone) AS DATE)) 
  AND tccom130.t$fovn$l Like NVL('%'  || (:CNPJ) || '%', tccom130.t$fovn$l)
  AND tcibd001.t$citg IN (:Depto)
  AND ( ((CASE WHEN cisli940.t$cofc$l is null THEN 'N/A' 
               else Upper(cisli940.t$cofc$l) 
           END) = Upper(:Filial)) or (:Filial is null) )
  AND cisli940.t$stat$l in (:Status)
  AND Trim(cisli941.t$item$l) LIKE '%' || :Item || '%'

order by 
  tdpur400.t$odat,
  tcibd001.t$citg,
  tccom130.t$fovn$l,
  CODE_DEPTO