SELECT 
  DISTINCT
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_EMISSAO_NFD,

    tfacp201.t$payd              DT_VENCTO_NFD,
    tdrec940.t$fire$l            REF_FISCAL_NFD,
    tdrec940.t$fdtc$l            COD_TIPO_FISCAL,
    tdrec940.t$ttyp$l            TRANSACAO,
    tdrec940.t$invn$l            NUMERO,
    FILIAL.t$euca                FILIAL,
    tdrec940.t$docn$l            NF,
    tdrec940.t$seri$l            SERIE,
    tdrec940.t$bpid$l            COD_PN,
    Trim(tdrec940.t$fids$l)      NOME_PN,
 
    CASE WHEN regexp_replace(tdrec940.t$fovn$l, '[^0-9]', '') IS NULL
           THEN '00000000000000' 
         WHEN LENGTH(regexp_replace(tdrec940.t$fovn$l, '[^0-9]', '')) < 11
           THEN '00000000000000'
         ELSE regexp_replace(tdrec940.t$fovn$l, '[^0-9]', '') 
     END                         CNPJ,
 
    CASE WHEN tfacp200.t$balc = 0 
           THEN 'LIQUIDADO' 
         ELSE 'ABERTO' 
     END                         SITUACAO,
  
    tfacp200.t$bloc              BLOQUEADO,
    ABS(tfacp200.t$amnt)         VLR_TITULO_NFD,
    ABS(tfacp200.t$balc)         SALDO_TITULO_NFD,
    tdrec940.t$rref$l            REF_FISCAL_NF_ORIGEM,
    
    tdrec940o.t$ttyp$l ||          
    tdrec940o.t$docn$l           TRANSACAO_ORIGEM,

    tdrec940o.t$docn$l           NF_ORIGEM,
    tdrec940o.t$seri$l           SERIE_ORIGEM,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940o.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_EMISSAO_NF_ORIGEM,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec943.t$icad$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                 DT_VENCTO_NF_ORIGEM,

    tdrec940o.t$stat$l           SITUACAO_NF_ORIGEM,        
    DESCR_SITUACAO.              DESCR_SITUACAO,

    CASE WHEN tfacp201.t$pyst$l = 3 
           THEN 'Sim' 
         ELSE   'Não' 
     END                         PREPARADO_PAGTO_NF_ORIGEM,
  
    tfcmg101r.t$plan             DT_PLAN_PAGTO_NF,
    tfacp201.t$pyst$l            STATUS_PAG_NF,
    STATUS_PAG_NF.               DESCR_STATUS_PAG_NF,    
    tdrec940o.t$bpid$l           COD_PARCEIRO_NF_ORIG,
    Trim(tdrec940o.t$fids$l)     NOME_PARCEIRO_NF_ORIG,
    tfacp200o.t$amnt             VALOR_TITULO_ORIG,
    tfacp200o.t$balc             SALDO_TITULO_ORIG,
    cisli940.t$fire$l            REF_FISCAL_DEVOLUCAO,
    cisli940.T$DOCN$L            NFD,
    cisli940.T$SERI$L            SERIE_NFD,
    DESCR_TIPO_DOC_FIS           TIPO_DOCTO_FISCAL 
    
FROM       baandb.ttdrec940201 tdrec940
 
 LEFT JOIN baandb.ttdrec940201 tdrec940o
        ON tdrec940o.t$fire$l=tdrec940.t$rref$l
 
 LEFT JOIN baandb.ttdrec941201  tdrec941o
        ON tdrec941o.t$fire$l = tdrec940o.t$fire$l
       AND tdrec941o.T$RFDV$C != ' '
       AND ROWNUM = 1
       
 LEFT JOIN baandb.tcisli940201 cisli940
        ON cisli940.t$fire$l=tdrec941o.T$RFDV$C
        
 LEFT JOIN baandb.ttfacp200201 tfacp200
        ON tfacp200.t$ttyp = tdrec940.t$ttyp$l 
       AND tfacp200.t$ninv = tdrec940.t$invn$l 
  
 LEFT JOIN baandb.ttfacp200201 tfacp200o
        ON tdrec940o.t$ttyp$l = tfacp200o.t$ttyp 
       AND tdrec940o.t$invn$l = tfacp200o.t$ninv
       AND tfacp200o.t$docn = 0 
    
 LEFT JOIN baandb.ttfacp201201 tfacp201
        ON tdrec940.t$ttyp$l = tfacp201.t$ttyp 
       AND tdrec940.t$invn$l = tfacp201.t$ninv
     
 LEFT JOIN baandb.ttfcmg101201 tfcmg101r
        ON tfcmg101r.t$ttyp = tfacp201.t$ttyp
       AND tfcmg101r.t$ninv = tfacp201.t$ninv
     
 LEFT JOIN baandb.ttdrec943201 tdrec943
        ON tdrec943.t$fire$l = tdrec940o.t$fire$l
  
-- LEFT JOIN baandb.ttfacp201201 tfacp201d
--        ON tfacp200.t$ttyp = tfacp201d.t$ttyp 
--       AND tfacp200.t$ninv = tfacp201d.t$ninv

-- LEFT JOIN baandb.ttfcmg101201 tfcmg101d
--        ON tfcmg101d.t$ttyp = tfacp201d.t$ttyp
--       AND tfcmg101d.t$ninv = tfacp201d.t$ninv
    
 LEFT JOIN ( select tcemm030.t$euca,
                    tcemm030.t$eunt,
                    tcemm124.t$cwoc 
               from baandb.ttcemm124201 tcemm124, 
                    baandb.ttcemm030201 tcemm030
              where tcemm030.t$eunt = tcemm124.t$grid
                and tcemm124.t$loco = 201 ) FILIAL
        ON FILIAL.t$cwoc = tdrec940.t$cofc$l

-- LEFT JOIN ( select l.t$desc DESCR_STATUS_PAG_NFD,
--                    d.t$cnst
--               from baandb.tttadv401000 d,
--                    baandb.tttadv140000 l
--              where d.t$cpac = 'tf'
--                and d.t$cdom = 'acp.pyst.l'
--                and l.t$clan = 'p'
--                and l.t$cpac = 'tf'
--                and l.t$clab = d.t$za_clab
--                and rpad(d.t$vers,4) || 
--                    rpad(d.t$rele,2) || 
--                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
--                                                    rpad(l1.t$rele,2) || 
--                                                    rpad(l1.t$cust,4)) 
--                                           from baandb.tttadv401000 l1 
--                                          where l1.t$cpac = d.t$cpac 
--                                            and l1.t$cdom = d.t$cdom )
--                and rpad(l.t$vers,4) || 
--                    rpad(l.t$rele,2) || 
--                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
--                                                    rpad(l1.t$rele,2) || 
--                                                    rpad(l1.t$cust,4)) 
--                                           from baandb.tttadv140000 l1 
--                                          where l1.t$clab = l.t$clab 
--                                            and l1.t$clan = l.t$clan 
--                                            and l1.t$cpac = l.t$cpac) ) STATUS_PAG_NFD
--        ON STATUS_PAG_NFD.t$cnst = tfacp201d.t$pyst$l
          
 LEFT JOIN ( select l.t$desc DESCR_SITUACAO,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) DESCR_SITUACAO
        ON DESCR_SITUACAO.t$cnst = tdrec940o.t$stat$l

 LEFT JOIN ( select l.t$desc DESCR_STATUS_PAG_NF,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'acp.pyst.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4)  || 
                                                    rpad(l1.t$rele, 2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                
                
            
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac) ) STATUS_PAG_NF
        ON STATUS_PAG_NF.t$cnst = tfacp201.t$pyst$l  
    
 LEFT JOIN ( select l.t$desc DESCR_TIPO_DOC_FIS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.trfd.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac) ) TIPO_DOC_FIS
        ON TIPO_DOC_FIS.t$cnst = tdrec940.t$rfdt$l
        
WHERE tdrec940.t$rfdt$l = 14    --nota de débito
  AND tfacp200.t$lino   = 0

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)) 
      Between :DataEmissaoDe 
          And :DataEmissaoAte
  AND FILIAL.t$eunt IN (:Filial)
  AND tfacp201d.t$pyst$l IN (:StatusNFD)
  AND Trim(tdrec940.t$ttyp$l) IN (:Docto)
  AND ( ( CASE WHEN tfacp201.t$pyst$l = 3 
                 THEN 1 
               ELSE   2 
           END = :PreparadoPagto ) OR (:PreparadoPagto = 0) )
  AND Trim(tdrec940.t$bpid$l) IN (:Fornecedor)
  AND ( Upper(tdrec940.t$ttyp$l || tdrec940.t$docn$l) = Upper(Trim(:Transacao)) OR (:Transacao Is Null))
