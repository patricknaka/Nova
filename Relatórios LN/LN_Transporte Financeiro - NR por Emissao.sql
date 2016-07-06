select
   ( SELECT tcemm030.t$euca 
       FROM baandb.ttcemm124301 tcemm124, 
            baandb.ttcemm030301 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
        AND tcemm030.t$eunt=tcemm124.t$grid
        AND tcemm124.t$loco=301
        AND rownum = 1 ) 
                          NOCA_ID_FILIAL,

    tdrec940.t$docn$l || '/' || 
    tdrec940.t$seri$l     NOTA_FORN,
    tdrec947.t$rcno$l     RECEBTO,
    tdrec940.t$cpay$l     CONPAG,
    tcmcs013a.t$dsca      DESCRICAO,
    tdrec940.t$fire$l     NOCA_ID_NR,
    tdrec940.t$fovn$l     CNPJ,
    tdrec940.t$fids$l     NOME,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                          DT_EMISSAO,
    tdrec940.t$opfc$l     ID_NATOPE,
    tdrec940.t$opor$l     SEQ_NATOPE,
    tcmcs940.t$dsca$l     CFO_NOME,
    Trim(tdrec941.t$item$l) 
                          ID_ITEM,
    tdrec941.t$dsca$l     DESC_ITEM,
    tcmcs023.t$dsca       DEPA_NOME,
    tdrec947.t$orno$l     PECD_NUM_PED,
    tdpur400.t$corg       TP_GERACAO,
    ORIGEM.DESCR          DESCR_TP_GERACAO,    
    tdpur400.t$cpay       CONPAG_PED,
    tcmcs013b.t$dsca      CONP_NOME_PED,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$odat, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                          DT_EMISSAO_PED,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdpur400.t$ddat, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                          DT_ENTREGA_PED,
    tdpur400.t$hdst       NOCA_SITUACAO,
    ORDEM.STATUS          DESCR_NOCA_SITUACAO,
      
    tdpur401.t$qidl       QT_RECEBIDA,
    tdpur401.t$qoor       QT_PEDIDA,  
    tdrec941.t$gamt$l     VL_MERC_ITEM,
    tdrec941.t$tamt$l     VL_TOTAL,
 
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=1 ) 
                          VL_ICMS,

    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=5) 
                          VL_PIS,

    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=6) 
                          VL_COFINS,
 
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942301 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=3) 
                          VL_IPI
  
from baandb.ttdrec941301 tdrec941

INNER JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$fire$l = tdrec941.t$fire$l
     
INNER JOIN ( select a.t$orno$l,
                    a.t$pono$l,
                    a.t$rcno$l,
                    a.t$fire$l,
                    a.t$line$l
             from baandb.ttdrec947301 a 
             group by a.t$orno$l,
                      a.t$pono$l,
                      a.t$rcno$l,
                      a.t$fire$l,
                      a.t$line$l ) tdrec947
        ON tdrec947.t$fire$l = tdrec941.t$fire$l 
       AND tdrec947.t$line$l = tdrec941.t$line$l
     
INNER JOIN baandb.ttcmcs940301 tcmcs940
        ON tcmcs940.t$ofso$l = tdrec940.t$opfc$l

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = tdrec941.t$item$l
        
INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
        
INNER JOIN baandb.ttdpur400301 tdpur400
        ON tdpur400.t$orno = tdrec947.t$orno$l
        
INNER JOIN baandb.ttdpur401301 tdpur401
        ON tdpur401.t$orno = tdrec947.t$orno$l 
       AND tdpur401.t$pono = tdrec947.t$pono$l
       AND (tdpur401.t$sqnb = 0 and tdpur401.t$oltp = 1 OR  --1-Total
            tdpur401.t$sqnb = 1 and tdpur401.t$oltp = 4 )   --4-Linha da Ordem
       
  
INNER JOIN baandb.ttcmcs013301 tcmcs013a
        ON tcmcs013a.t$cpay  = tdrec940.t$cpay$l 
        
INNER JOIN baandb.ttcmcs013301 tcmcs013b
        ON tcmcs013b.t$cpay = tdpur400.t$cpay

 LEFT JOIN ( select l.t$desc STATUS,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'pur.hdst'
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
                                            and l1.t$cpac = l.t$cpac ) ) ORDEM
        ON ORDEM.t$cnst = tdpur400.t$hdst 

 LEFT JOIN ( select l.t$desc DESCR,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'pur.corg'
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
                                            and l1.t$cpac = l.t$cpac ) ) ORIGEM
        ON ORIGEM.t$cnst = tdpur400.t$corg
        
where Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataEmissaoNFDe and :DataEmissaoNFAte
        
