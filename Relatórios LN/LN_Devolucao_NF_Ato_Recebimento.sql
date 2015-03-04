SELECT
  tdrec940.t$opfc$l      NUME_CFOP,
  tcemm030.t$euca        NUME_FILIAL,
  tdpur400.t$cbrn        RAMO_ATIV, 
  tccom130.t$fovn$l      CNPJ_FORN,
  tccom100.t$nama        NOME_FORNEC, 
  tdrec940.t$docn$l      NUME_NF,
  tdrec940.t$seri$l      SERI_NF, 
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)        
                         DATA_EMISS,
  tdrec940.t$stat$l      CODE_STATUS, 
                         DESC_DOMAIN_STAT.DESC_STAT, 
  tdrec947.t$rcno$l      CODE_RECEB,
  Trim(tdrec941.t$item$l)CODE_ITEM,
  tdrec941.t$dsca$l      DESC_ITEM,
  tdrec941.t$qnty$l      QUAN_FAT,
  tdrec941.t$pric$l      PREC_ITEM,
  
  ( SELECT tdrec942.t$sbas$l 
      FROM baandb.ttdrec942201 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=1) 
                         VALOR_BASE_ICMS,
 
  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942201 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=3) 
                         VALOR_IPI, 
 
  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942201 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=2) 
                         VALOR_ICMS_ST, 

  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942201 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=5) 
                         VALOR_PIS,

  ( SELECT tdrec942.t$amnt$l 
      FROM baandb.ttdrec942201 tdrec942
     WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
       AND tdrec942.t$line$l=tdrec941.t$line$l
       AND tdrec942.t$brty$l=6) 
                         VALOR_COFINS, 
  
  tdrec940.t$tfda$l      VALO_TOTORD,
  tdrec941.t$tamt$l      VOLO_TOTITEM,
  tcibd001.t$citg        GRUPO_ITEM,
  tcmcs023.t$dsca        DESC_GRUPO_ITEM

FROM baandb.ttdpur400201 tdpur400, 
     baandb.ttdrec940201 tdrec940, 
     baandb.ttdrec940201 tdrec940d,
     ( SELECT d.t$cnst DESC_DOMAIN_STAT, 
              l.t$desc DESC_STAT 
         FROM baandb.tttadv401000 d, 
              baandb.tttadv140000 l 
        WHERE d.t$cpac='td' 
          AND d.t$cdom='rec.stat.l'
          AND d.t$vers='B61U'
          AND d.t$rele='a7'
          AND d.t$cust='glo1'
          AND l.t$clab=d.t$za_clab
          AND l.t$clan='p'
          AND l.t$cpac='td'
          AND l.t$vers=( SELECT max(l1.t$vers) 
                           from baandb.tttadv140000 l1 
                          WHERE l1.t$clab=l.t$clab 
                            AND l1.t$clan=l.t$clan 
                            AND l1.t$cpac=l.t$cpac ) ) DESC_DOMAIN_STAT,
     baandb.ttdrec941201 tdrec941, 
     baandb.ttdrec947201 tdrec947,
     baandb.ttccom100201 tccom100, 
     baandb.ttccom130201 tccom130, 
     baandb.ttcemm124201 tcemm124,
     baandb.ttcemm030201 tcemm030,
     baandb.ttcibd001201 tcibd001,
     baandb.ttcmcs023201 tcmcs023 
  
WHERE tdrec940.t$rfdt$l = 13 
  AND tdrec940.t$rref$l = tdrec940d.t$fire$l 
  AND tdrec940d.t$rfdt$l = 1 
  AND tdrec940.t$fire$l = tdrec947.t$fire$l
  AND tdrec940.t$fire$l = tdrec941.t$fire$l
  AND tdrec941.t$line$l = tdrec947.t$line$l
  AND tccom100.t$bpid = tdpur400.t$otbp 
  AND tccom130.t$cadr = tdpur400.t$otad
  AND tdrec940.t$stat$l = DESC_DOMAIN_STAT.DESC_DOMAIN_STAT
  AND tdrec947.t$orno$l = tdpur400.t$orno
  AND tcemm124.t$cwoc = tdpur400.t$cofc 
  AND tcemm124.t$dtyp = 2 
  AND tcemm030.t$eunt = tcemm124.t$grid
  AND tdrec941.t$item$l = tcibd001.t$item
  AND tcibd001.t$citg = tcmcs023.t$citg
  
  AND Trunc( CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)) between :EmissaoDe AND :EmissaoAte
  AND tdrec940.t$stat$l = (CASE WHEN :StatusNF = 0 THEN tdrec940.t$stat$l ELSE :StatusNF END)
  AND Trim(tcibd001.t$citg) IN (:GrupoItem)
  AND ( (Trim(tccom130.t$fovn$l) like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null) )