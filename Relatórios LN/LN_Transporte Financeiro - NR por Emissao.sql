select
   ( SELECT tcemm030.t$euca 
       FROM baandb.ttcemm124201 tcemm124, 
            baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
        AND tcemm030.t$eunt=tcemm124.t$grid
        AND tcemm124.t$loco=201
        AND rownum = 1 ) 
                      NOCA_ID_FILIAL,

    tdrec940.t$docn$l || '/' || 
    tdrec940.t$seri$l NOTA_FORN,
    tdrec947.t$rcno$l RECEBTO,
    tdrec940.t$cpay$l CONPAG,
    tcmcs013a.t$dsca  DESCRICAO,
    tdrec940.t$fire$l NOCA_ID_NR,
    tdrec940.t$fovn$l CNPJ,
    tdrec940.t$fids$l NOME,
    tdrec940.t$idat$l DT_EMISSAO,
    tdrec940.t$opfc$l ID_NATOPE,
    tdrec940.t$opor$l SEQ_NATOPE,
    tcmcs940.t$dsca$l CFO_NOME,
    Trim(tdrec941.t$item$l) 
                      ID_ITEM,
    tdrec941.t$dsca$l DESC_ITEM,
    tcmcs023.t$dsca   DEPA_NOME,
    tdrec947.t$orno$l PECD_NUM_PED,
    tdpur400.t$corg   TP_GERACAO,
    
    ( SELECT l.t$desc DS_TIPO_CADASTRO
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac='td'
         AND d.t$cdom='pur.corg'
         AND d.t$vers='B61U'
         AND d.t$rele='a'
         AND d.t$cust='stnd'
         AND l.t$clab=d.t$za_clab
         AND l.t$clan='p'
         AND l.t$cpac='td'
         AND l.t$vers='B61'
         AND l.t$rele='a'
         AND l.t$cust=' '
         AND d.t$cnst=tdpur400.t$corg ) 
                      DESCR_TP_GERACAO,    
    tdpur400.t$cpay   CONPAG_PED,
    tcmcs013b.t$dsca  CONP_NOME_PED,
    tdpur400.t$odat   DT_EMISSAO_PED,
    tdpur400.t$ddat   DT_ENTREGA_PED,
    tdpur400.t$hdst   NOCA_SITUACAO,
    
    ( SELECT l.t$desc DS_SITUACAO_PEDIDO
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac='td'
         AND d.t$cdom='pur.hdst'
         AND d.t$vers='B61U'
         AND d.t$rele='a'
         AND d.t$cust='stnd'
         AND l.t$clab=d.t$za_clab
         AND l.t$clan='p'
         AND l.t$cpac='td'
         AND l.t$vers=( select max(l1.t$vers) 
                          from baandb.tttadv140000 l1 
                         where l1.t$clab=l.t$clab 
                           AND l1.t$clan=l.t$clan 
                           AND l1.t$cpac=l.t$cpac )
         AND d.t$cnst=tdpur400.t$hdst) 
                      DESCR_NOCA_SITUACAO,
      
    tdpur401.t$qidl   QT_RECEBIDA,
    tdpur401.t$qoor   QT_PEDIDA,  
    tdrec941.t$gamt$l VL_MERC_ITEM,
    tdrec941.t$tamt$l VL_TOTAL,
 
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942201 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=1 ) 
                      VL_ICMS,

    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942201 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=5) 
                      VL_PIS,

    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942201 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=6) 
                      VL_COFINS,
 
    ( SELECT tdrec942.t$amnt$l 
        FROM baandb.ttdrec942201 tdrec942
       WHERE tdrec942.t$fire$l=tdrec941.t$fire$l
         AND tdrec942.t$line$l=tdrec941.t$line$l
         AND tdrec942.t$brty$l=3) 
                      VL_IPI
  
from baandb.ttdrec940201 tdrec940,
     baandb.ttdrec941201 tdrec941,
     baandb.ttdrec947201 tdrec947,
     baandb.ttcmcs940201 tcmcs940,
     baandb.ttcmcs023201 tcmcs023,
     baandb.ttcibd001201 tcibd001,
     baandb.ttdpur400201 tdpur400,
     baandb.ttdpur401201 tdpur401,
     baandb.ttcmcs013201 tcmcs013a,
     baandb.ttcmcs013201 tcmcs013b

where tdrec947.t$fire$l = tdrec941.t$fire$l 
  and tdrec947.t$line$l = tdrec941.t$line$l
  and tcmcs940.t$ofso$l = tdrec940.t$opfc$l
  and tcmcs023.t$citg   = tcibd001.t$citg
  and tcibd001.t$item   = tdrec941.t$item$l
  and tdpur400.t$orno   = tdrec947.t$orno$l
  and tdpur401.t$orno   = tdrec947.t$orno$l 
  and tdpur401.t$pono   = tdrec947.t$pono$l
  and tcmcs013a.t$cpay  = tdrec940.t$cpay$l 
  and tcmcs013b.t$cpay  = tdpur400.t$cpay
  
  and Trunc(tdrec940.t$idat$l) Between &DataEmissaoNFDe and &DataEmissaoNFAte