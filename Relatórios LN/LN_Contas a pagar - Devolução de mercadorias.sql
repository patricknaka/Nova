SELECT DISTINCT

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_EMISSAO_NFD,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli945.t$iutd$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_VENCTO_NFD,
 
    cisli940.t$fire$l            REF_FISCAL_NFD,
    cisli940.t$fdtc$l            COD_TIPO_FISCAL,
   
    cisli940.t$ityp$l            TRANSACAO,
    cisli940.t$idoc$l            NUMERO,

    FILIAL.t$euca                FILIAL,
    cisli940.t$docn$l            NF,
    cisli940.t$seri$l            SERIE,
    cisli940.t$bpid$l            COD_PN,
    tccom100.t$nama              NOME_PN,
 
    CASE WHEN regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') IS NULL
           THEN '00000000000000' 
         WHEN LENGTH(regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')) < 11
           THEN '00000000000000'
         ELSE regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') 
     END                         CNPJ,
 
    CASE WHEN tfacp200.t$balc = 0 
           THEN 'LIQUIDADO' 
         ELSE 'ABERTO' 
     END                         SITUACAO,
  
    tfacp200.t$bloc              BLOQUEADO,
    tfacp200.t$amnt              VLR_TITULO_NFD,
    tfacp200.t$balc              SALDO_TITULO_NFD,
--    tfcmg101d.t$plan             DT_PLAN_PAGTO_NFD,
--    tfacp201d.t$pyst$l           STATUS_PAG_NFD,
--    STATUS_PAG_NFD.              DESCR_STATUS_PAG_NFD,
    cisli951.t$rfir$l            REF_FISCAL_NF_ORIGEM,
    
    tdrec940.t$ttyp$l ||          
    tdrec940.t$invn$l            TRANSACAO_ORIGEM,

    tdrec940.t$docn$l            NF_ORIGEM,
    tdrec940.t$seri$l            SERIE_ORIGEM,
	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_EMISSAO_NF_ORIGEM,
	
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec943.t$icad$l, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_VENCTO_NF_ORIGEM,
	
    tdrec940.t$stat$l            SITUACAO_NF_ORIGEM,
    DESCR_SITUACAO.              DESCR_SITUACAO,

    CASE WHEN tfacp201.t$pyst$l = 3 
           THEN 'Sim' 
         ELSE 'Não' 
     END                         PREPARADO_PAGTO_NF_ORIGEM,
  
    tfcmg101r.t$plan             DT_PLAN_PAGTO_NF,
    tfacp201.t$pyst$l            STATUS_PAG_NF,
    STATUS_PAG_NF.               DESCR_STATUS_PAG_NF,    
    tdrec940.t$bpid$l            COD_PARCEIRO_NF_ORIG,
    tdrec940.t$fids$l            NOME_PARCEIRO_NF_ORIG,
    tfacp200o.t$amnt             VALOR_TITULO_ORIG,
    tfacp200o.t$balc             SALDO_TITULO_ORIG,
    t.t$dsca$l                   DESCR_TIPO_DOC_FISCAL
         
FROM       baandb.tcisli940201 cisli940

INNER JOIN baandb.tcisli951201 cisli951
        ON cisli951.t$fire$l = cisli940.t$fire$l
  
INNER JOIN baandb.tcisli941201 cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l

INNER JOIN baandb.tcisli945201 cisli945
        ON cisli945.t$fire$l = cisli940.t$fire$l

INNER JOIN baandb.ttccom100201 tccom100
        ON tccom100.t$bpid = cisli940.t$bpid$l

INNER JOIN baandb.ttccom130201 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr

INNER JOIN baandb.ttfacp200201 tfacp200
        ON tfacp200.t$ttyp   = cisli940.t$ityp$l 
       AND tfacp200.t$ninv   = cisli940.t$idoc$l 
  
 LEFT JOIN baandb.ttdrec940201 tdrec940
        ON tdrec940.t$fire$l = cisli951.t$rfir$l
  
 LEFT JOIN baandb.ttfacp200201 tfacp200o
        ON tdrec940.t$ttyp$l = tfacp200o.t$ttyp 
       AND tdrec940.t$invn$l = tfacp200o.t$ninv
       AND tfacp200o.t$docn = 0 
    
 LEFT JOIN baandb.ttfacp201201 tfacp201
        ON tdrec940.t$ttyp$l = tfacp201.t$ttyp 
       AND tdrec940.t$invn$l = tfacp201.t$ninv
     
 LEFT JOIN baandb.ttfcmg101201 tfcmg101r
        ON tfcmg101r.t$ttyp = tfacp201.t$ttyp
       AND tfcmg101r.t$ninv = tfacp201.t$ninv
     
 LEFT JOIN baandb.ttdrec943201 tdrec943
        ON tdrec943.t$fire$l = tdrec940.t$fire$l
  
 LEFT JOIN baandb.ttfacp201201 tfacp201d
        ON tfacp200.t$ttyp = tfacp201d.t$ttyp 
       AND tfacp200.t$ninv = tfacp201d.t$ninv

 LEFT JOIN baandb.ttfcmg101201 tfcmg101d
        ON tfcmg101d.t$ttyp = tfacp201d.t$ttyp
       AND tfcmg101d.t$ninv = tfacp201d.t$ninv
    
 LEFT JOIN( SELECT tcemm030.t$euca,
                   tcemm030.t$eunt,
                   tcemm124.t$cwoc 
              FROM baandb.ttcemm124201 tcemm124, 
                   baandb.ttcemm030201 tcemm030
             WHERE tcemm030.t$eunt = tcemm124.t$grid
               AND tcemm124.t$loco = 201 ) FILIAL
        ON FILIAL.t$cwoc = cisli940.t$cofc$l
		
 LEFT JOIN ( SELECT l.t$desc DESCR_STATUS_PAG_NFD,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'acp.pyst.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac) ) STATUS_PAG_NFD
        ON STATUS_PAG_NFD.t$cnst = tfacp201d.t$pyst$l

 LEFT JOIN ( SELECT l.t$desc DESCR_SITUACAO,
                    d.t$cnst
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
                                            and l1.t$cpac = l.t$cpac ) ) DESCR_SITUACAO
        ON DESCR_SITUACAO.t$cnst = tdrec940.t$stat$l

 LEFT JOIN ( SELECT l.t$desc DESCR_STATUS_PAG_NF,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'acp.pyst.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4)  || 
                                                    rpad(l1.t$rele, 2) || 
                                                    rpad(l1.t$cust,4)) 
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
                                            and l1.t$cpac = l.t$cpac) ) STATUS_PAG_NF
        ON STATUS_PAG_NF.t$cnst = tfacp201.t$pyst$l  
    
 LEFT JOIN baandb.ttcmcs966201 t
        ON t.t$fdtc$l = cisli940.t$fdtc$l
  
WHERE cisli940.t$fdty$l = 9 
  AND tfacp200.t$lino   = 0

  AND Trunc(cisli940.t$date$l) Between :DataEmissaoDe And :DataEmissaoAte
  AND FILIAL.t$eunt IN (:Filial)
  AND tfacp201d.t$pyst$l IN (:StatusNFD)
  AND Trim(cisli940.t$ityp$l) IN (:Docto)
  AND ( ( CASE WHEN tfacp201.t$pyst$l = 3 
                 THEN 1 
               ELSE   2 
           END = :PreparadoPagto ) OR (:PreparadoPagto = 0) )
  AND Trim(cisli940.t$bpid$l) IN (:Fornecedor)
  AND ( Upper(cisli940.t$ityp$l || cisli940.t$idoc$l) = Upper(Trim(:Transacao)) OR (:Transacao Is Null))
