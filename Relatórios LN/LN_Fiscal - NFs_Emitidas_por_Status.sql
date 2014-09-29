SELECT
  DISTINCT
    301                                     NUME_CIA,
    tcemm030.t$euca                         NUME_FILIAL,
    cisli940.t$docn$l                       NUME_NOTA,
    cisli940.t$seri$l                       NUME_SERIE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                            DATA_EMISSAO,
    tccom130.t$fovn$l                       CNPJ_FORNECEDOR,
    tccom130.t$nama                         NOME_FORNECEDOR,
    cisli940.t$doty$l                       TIPO_DOCTO, DESC_TIPO_DOCTO,
    cisli940.t$fdty$l                       TIPO_ORDEM, DESC_TIPO_ORDEM,
    cisli940.t$ccfo$l                       NUME_CCFO,
    cisli940.t$stat$l                       STATUS_NF, DESC_TIPO_STATUS,
    To_Number(Trim(cisli940.t$cpay$l))      CONDICAO_PAGTO_NR,
    cisli940.t$amnt$l                       VALOR_TOTAL,
    znnfe002.t$logn$c                       USUARIO,  
    cisli940.t$cnfe$l                       CHAVE_ACESSO,
    cisli940.t$fire$l                       REF_FISCAL,
    cisli940.t$cofc$l                       CD_DEPART_FILIAL,
    ( select a.t$dsca
        from baandb.ttcmcs065301 a
       where a.t$cwoc = cisli940.t$cofc$l ) DESCR_DEPART_FILIAL
  
FROM      baandb.ttccom130301  tccom130,
          baandb.ttcemm030301  tcemm030,
          baandb.ttcemm124301  tcemm124,
          baandb.tcisli940301  cisli940
      
LEFT JOIN baandb.tznnfe002301  znnfe002 
       ON znnfe002.t$fire$c = cisli940.t$fire$l,
     
        ( SELECT d.t$cnst CNST, 
                 l.t$desc DESC_TIPO_DOCTO
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'tc' 
             AND d.t$cdom = 'doty.l'
             AND d.t$vers = 'B61U'
             AND d.t$rele = 'a7'
             AND l.t$clab = d.t$za_clab
             AND l.t$clan = 'p'
             AND l.t$cpac = 'tc'
             AND l.t$vers = ( select max(l1.t$vers) 
                                from baandb.tttadv140000 l1 
                               where l1.t$clab = l.t$clab 
                                 and l1.t$clan = l.t$clan 
                                 and l1.t$cpac = l.t$cpac ) ) DGET,
                 
        ( SELECT d.t$cnst CNST, 
                 l.t$desc DESC_TIPO_ORDEM
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'ci' 
             AND d.t$cdom = 'sli.tdff.l'
             AND d.t$vers = 'B61U'
             AND d.t$rele = 'a7'
             AND l.t$clab = d.t$za_clab
             AND l.t$clan = 'p'
             AND l.t$cpac = 'ci'
             AND l.t$vers = ( select max(l1.t$vers) 
                                from baandb.tttadv140000 l1 
                               where l1.t$clab = l.t$clab 
                                 and l1.t$clan = l.t$clan 
                                 and l1.t$cpac = l.t$cpac ) ) FGET,
                 
        ( SELECT d.t$cnst CNST, 
                 l.t$desc DESC_TIPO_STATUS
            FROM baandb.tttadv401000 d, 
                 baandb.tttadv140000 l 
           WHERE d.t$cpac = 'ci' 
             AND d.t$cdom = 'sli.stat'
             AND d.t$vers = 'B61U'
             AND d.t$rele = 'a7'
             AND l.t$clab = d.t$za_clab
             AND l.t$clan = 'p'
             AND l.t$cpac = 'ci'
             AND l.t$vers = ( select max(l1.t$vers) 
                                from baandb.tttadv140000 l1 
                               where l1.t$clab = l.t$clab 
                                 and l1.t$clan = l.t$clan 
                                 and l1.t$cpac = l.t$cpac ) ) SGET
                 
WHERE cisli940.t$doty$l = DGET.CNST 
  AND cisli940.t$fdty$l = FGET.CNST 
  AND cisli940.t$stat$l = SGET.CNST
  AND tccom130.t$cadr = cisli940.t$stoa$l 
  AND tcemm124.t$cwoc = cisli940.t$cofc$l 
  AND tcemm124.t$dtyp = 1 
  AND tcemm030.t$eunt = tcemm124.t$grid
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)) Between :DataEmissaoDe And :DataEmissaoAte
  AND cisli940.t$cofc$l IN (:Depto)
  AND cisli940.t$ccfo$l IN (:CFOP)
  AND cisli940.t$fdty$l IN (:TipoOrdem)
  AND cisli940.t$stat$l IN (:StatusNF)