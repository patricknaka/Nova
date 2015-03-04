SELECT
  DISTINCT
    301                                     NUME_CIA,
    tcemm030.t$euca                         NUME_FILIAL,
    cisli940.t$docn$l                       NUME_NOTA,
    cisli940.t$seri$l                       NUME_SERIE,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE) 
                                            DATA_EMISSAO,
    tccom130.t$fovn$l                       CNPJ_FORNECEDOR,
    tccom130.t$nama                         NOME_FORNECEDOR,
    cisli940.t$doty$l                       TIPO_DOCTO, DESC_TIPO_DOCTO,
    cisli940.t$fdty$l                       TIPO_ORDEM, DESC_TIPO_ORDEM,
    cisli940.t$ccfo$l                       NUME_CCFO,
    cisli940.t$stat$l                       STATUS_NF, DESC_TIPO_STATUS,
    To_Number(Trim(cisli940.t$cpay$l))      CONDICAO_PAGTO_NR,
    cisli940.t$amnt$l                       VALOR_TOTAL,
    Usuario.t$logn$c                        USUARIO,  
    cisli940.t$cnfe$l                       CHAVE_ACESSO,
    cisli940.t$fire$l                       REF_FISCAL,
    cisli940.t$cofc$l                       CD_DEPART_FILIAL,
    ( select a.t$dsca
        from baandb.ttcmcs065301 a
       where a.t$cwoc = cisli940.t$cofc$l ) DESCR_DEPART_FILIAL
  
FROM      baandb.ttccom130301  tccom130

INNER JOIN baandb.tcisli940301  cisli940
        ON cisli940.t$stoa$l = tccom130.t$cadr

INNER JOIN baandb.ttcemm124301  tcemm124
        ON tcemm124.t$cwoc = cisli940.t$cofc$l 
       AND tcemm124.t$dtyp = 1
     
INNER JOIN baandb.ttcemm030301  tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

 LEFT JOIN ( SELECT znnfe002. t$fire$c, 
                    znnfe002.t$logn$c
               FROM baandb.tznnfe002301 znnfe002 
              WHERE znnfe002.t$datg$c = ( SELECT MAX(znnfe002A.t$datg$c)
                                            FROM baandb.tznnfe002301 znnfe002A
                                           WHERE znnfe002A.T$fire$c = znnfe002.T$fire$c ) ) Usuario
        ON Usuario.t$fire$c = cisli940.t$fire$l
     
 LEFT JOIN ( SELECT d.t$cnst CNST, 
                    l.t$desc DESC_TIPO_DOCTO
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
                                            and l1.t$cpac = l.t$cpac ) ) DGET
        ON cisli940.t$doty$l = DGET.CNST 
                 
 LEFT JOIN ( SELECT d.t$cnst CNST, 
                    l.t$desc DESC_TIPO_ORDEM
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
                                            and l1.t$cpac = l.t$cpac ) ) FGET
        ON cisli940.t$fdty$l = FGET.CNST 
                 
 LEFT JOIN ( SELECT d.t$cnst CNST, 
                    l.t$desc DESC_TIPO_STATUS
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
                                            and l1.t$cpac = l.t$cpac ) ) SGET
        ON cisli940.t$stat$l = SGET.CNST
                       
WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$datg$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataEmissaoDe And :DataEmissaoAte
  AND cisli940.t$cofc$l IN (:Depto)
  AND cisli940.t$ccfo$l IN (:CFOP)
  AND cisli940.t$fdty$l IN (:TipoOrdem)
  AND cisli940.t$stat$l IN (:StatusNF)