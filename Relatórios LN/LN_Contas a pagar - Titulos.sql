SELECT
  DISTINCT
    Concat(tfacp200.t$ttyp, tfacp200.t$ninv)    TRANSCAO,
    tfacp200.t$ninv                             NUME_TITULO,
    tfacp200.t$ttyp                             CODE_TRANS,
    tdrec940.t$fire$l                           CODE_REFER,
    tfacp200.t$docn$l                           NUME_NF,
    tfacp200.t$seri$l                           SERI_NF,
    tccom130.t$fovn$l                           CNPJ_FORN,
    tccom100.t$nama                             NOME_FORN,
    tfacp200.t$docd                             DATA_EMISSAO,
    tfacp200.t$dued                             DATA_VENCTO,
    tfacp200.t$amnt                             VALO_TITULO,  
    tfacp200.t$balc                             SALD_TITULO,
    '201'                                       CODE_CIA,             

    CASE  WHEN (tfacp200.t$balc - tfacp200.t$bala) = 0 THEN 1 
          ELSE 2 
     END                                        DESC_SITUA1,

    CASE  WHEN tfacp201.t$pyst$l ! =  3 THEN 2 
          ELSE 1 
     END                                        CODE_SITUA2,

    CASE  WHEN tfacp201.t$pyst$l ! =  3 THEN 'Não' 
          ELSE 'Sim' 
     END                                        DESC_SITUA2,

    tfcmg101.t$plan                             DATA_PLAN_PAGTO,
    NVL(Trim(tfacp200.t$bloc), '000')           STATUS_BLOQUEIO,
    NVL(BLOQUEIO.DSC_STATUS_BLOQUEIO, 'Sem bloqueio') 
                                                DESC_STATUS_BLOQUEIO,
    
    tfacp201.t$balc-tfacp200.t$bala             VALOR_APAGAR,
    tfacp201.t$brel                             NUM_REL_BANCARIA, 
    tfcmg001.t$desc                             DESC_REL_BANCARIA,

    case when (    (tfacp201.t$brel = null or trim(tfacp201.t$brel) = '') 
               and (tfcmg001.t$desc = null or trim(tfcmg001.t$desc) = '') ) then ''
         else Concat(Concat(tfacp201.t$brel, ' - '), tfcmg001.t$desc) 
     end                                        REL_BANCARIA,

    NVL(TRIM(tfacp201.t$paym), 'N/A')           METODO_PAGTO,
    tfacp201.t$bank                             BANCO_PARCEIRO,
    tfcmg011.t$agcd$l                           NUME_AGENCIA,
    tfcmg011.t$agdg$l                           DIGI_AGENCIA,
    tfcmg011.t$desc                             DESC_AGENCIA,
    tccom125.t$bano                             NUME_CONTA,
    tccom125.t$dacc$d                           DIGI_CONTA,  
    Trim(tfcmg011.t$desc  || ' ' ||
          'AG ' || tfcmg011.t$agcd$l || '-' || 
                   tfcmg011.t$agdg$l || '   ' || 'CC ' || 
                   tccom125.t$bano || '-' || 
                   tccom125.t$dacc$d )          CONTA_PN,
                   
    ( select max(a.t$btno) 
        from baandb.ttfcmg101301 a
       where a.t$ttyp = tfacp200.t$ttyp
         and a.t$ninv = tfacp200.t$ninv)          LOTE_PAGTO,
    
    tdrec940.t$fire$l                           NUM_RFISCAL,
    tdrec940.t$rfdt$l                           NUM_CFISCAL, 
    DTRFD.DESC_CODIGO_FISCAL                    DESC_CODIGO_FISCAL,        
    tdrec940.t$fdtc$l                           COD_TIPO_DOC_FISCAL,             -- antes TIPO_ORDEM,
    tcmcs966.t$dsca$l                           DESC_TIPO_DOC_FISCAL,             -- antes DESC_TIPO_ORDEM,       
    tdrec947.t$orno$l                           NUM_ORDEM,
    tfacp201.t$mopa$d                           CODE_MODAL_PGTO,
    
    ( SELECT l.t$desc DESCR
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tf'
         AND d.t$cdom = 'cmg.mopa.d'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tf'
         AND l.t$clab = d.t$za_clab
         AND d.t$cnst = tfacp201.t$mopa$d 
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
                                     and l1.t$cpac = l.t$cpac ) )       
                                                DESC_MODAL_PGTO,
    
    ( SELECT tflcb231a.t$ocr1$d 
        FROM baandb.ttflcb231301  tflcb231a
       WHERE tflcb231a.t$ttyp$d = tfacp200.t$ttyp
         AND tflcb231a.t$ninv$d = tfacp200.t$ninv  
         AND tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                      FROM baandb.ttflcb231301  tflcb231b
                                     WHERE tflcb231b.t$ttyp$d = tfacp200.t$ttyp
                                       AND tflcb231b.t$ninv$d = tfacp200.t$ninv) AND rownum = 1 ) 
                                                OCORRENCIA1,
              
    ( SELECT tflcb231a.t$ocr2$d 
        FROM baandb.ttflcb231301  tflcb231a
       WHERE tflcb231a.t$ttyp$d = tfacp200.t$ttyp
         AND tflcb231a.t$ninv$d = tfacp200.t$ninv  
         AND tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                      FROM baandb.ttflcb231301  tflcb231b
                                     WHERE tflcb231b.t$ttyp$d = tfacp200.t$ttyp
                                       AND tflcb231b.t$ninv$d = tfacp200.t$ninv) AND rownum = 1 ) 
                                                OCORRENCIA2,
              
    ( SELECT tflcb231a.t$ocr3$d 
        FROM baandb.ttflcb231301  tflcb231a
       WHERE tflcb231a.t$ttyp$d = tfacp200.t$ttyp
         AND tflcb231a.t$ninv$d = tfacp200.t$ninv  
         AND tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                      FROM baandb.ttflcb231301  tflcb231b
                                     WHERE baandb.tflcb231b.t$ttyp$d = tfacp200.t$ttyp
                                       AND baandb.tflcb231b.t$ninv$d = tfacp200.t$ninv) AND rownum = 1 )
                                                OCORRENCIA3,
              
    ( SELECT tflcb231a.t$ocr4$d 
        FROM baandb.ttflcb231301  tflcb231a
       WHERE tflcb231a.t$ttyp$d = tfacp200.t$ttyp
         AND tflcb231a.t$ninv$d = tfacp200.t$ninv  
         AND tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                      FROM baandb.ttflcb231301  tflcb231b
                                     WHERE tflcb231b.t$ttyp$d = tfacp200.t$ttyp
                                       AND tflcb231b.t$ninv$d = tfacp200.t$ninv) AND rownum = 1 )
                                                OCORRENCIA4,
              
    tfacp200.t$ifbp                             CODE_PN,
    tccom100.t$nama                             DESC_PN,

    Concat(Concat(tfacp200.t$ifbp, ' - '), tccom100.t$nama) 
                                                COD_DESC_PEN,
    nvl(tfacp201.t$pyst$l, 1)                   STAT_PRG,
    iSTAT.DESCR                                 DESCR_STAT_PRG,
    tdpur400.t$cotp                             COD_TIPO_ORDEM,          --tipo de ordem de compra
    tdpur094.t$dsca                             DECR_TIPO_ORDEM,         --descrição tipo ordem de compra
    tfacp200.t$leac                             COD_CONTA_CONTROLE,
    tfgld008.t$desc                             DESCR_CONTA_CONTROLE,
    tdrec952.t$leac$l                           COD_CONTA_DESTINO,
  
    (select a.t$desc 
       from baandb.ttfgld008301 a
      where a.t$leac = tdrec952.t$leac$l )      DESCR_CONTA_DESTINO,
    
    tflcb230.t$stat$d                           CODE_STAT_ARQ,
    tflcb230.t$lach$d                           DATA_STAT_ARQ,
    NVL(iStatArq.DESCR,'Arquivo não vinculado') DESCR_STAT_ARQ
  
  
FROM      baandb.ttfacp200301  tfacp200  

LEFT JOIN ( select m.t$bloc COD_STATUS_BLOQUEIO,
                   m.t$desc DSC_STATUS_BLOQUEIO
              from baandb.ttfacp002301 m ) BLOQUEIO
       ON BLOQUEIO.COD_STATUS_BLOQUEIO = tfacp200.t$bloc

LEFT JOIN baandb.ttfgld008301 tfgld008
       ON tfgld008.t$leac = tfacp200.t$leac
  
LEFT JOIN ( SELECT a.t$ttyp$d, 
                   a.t$ninv$d,
                   a.t$lach$d,
                   max(a.t$stat$d) t$stat$d
              FROM baandb.ttflcb230301 a
             WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                  from baandb.ttflcb230301 b
                                 where b.t$ttyp$d = a.t$ttyp$d
                                   and b.t$ninv$d = a.t$ninv$d )
          GROUP BY a.t$ttyp$d, 
                   a.t$ninv$d, 
                   a.t$lach$d ) tflcb230
       ON tflcb230.t$ttyp$d = tfacp200.t$ttyp
      AND tflcb230.t$ninv$d = tfacp200.t$ninv

LEFT JOIN baandb.ttfcmg101301 tfcmg101
       ON tfcmg101.t$ttyp = tfacp200.t$ttyp
      AND tfcmg101.t$ninv = tfacp200.t$ninv
   
LEFT JOIN ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
              FROM baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             WHERE d.t$cpac = 'tf'
               AND d.t$cdom = 'cmg.stat.l'
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
                                           and l1.t$cpac = l.t$cpac ) ) iStatArq 
       ON iStatArq.CODE = tflcb230.t$stat$d

  
INNER JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfacp200.t$ifbp
    
INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
          
LEFT JOIN baandb.ttdrec940301  tdrec940
       ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
      AND tdrec940.t$invn$l = tfacp200.t$ninv

LEFT JOIN baandb.ttdrec952301 tdrec952
       ON tdrec952.t$ttyp$l = tfacp200.t$ttyp
      AND tdrec952.t$invn$l = tfacp200.t$ninv
      AND tdrec952.t$fire$l = tdrec940.t$fire$l
      AND tdrec952.t$dbcr$l = 1
      AND tdrec952.t$trtp$l = 2
      AND tdrec952.t$brty$l = 0 
   
LEFT JOIN ( SELECT iDOMAIN.t$cnst iCODE, iLABEL.t$desc DESC_CODIGO_FISCAL 
              FROM baandb.tttadv401000 iDOMAIN, 
                   baandb.tttadv140000 iLABEL 
             WHERE iDOMAIN.t$cpac = 'td'
               AND iDOMAIN.t$cdom = 'rec.trfiDOMAIN.l'
               AND iLABEL.t$clan = 'p'
               AND iLABEL.t$cpac = 'td'
               AND iLABEL.t$clab = iDOMAIN.t$za_clab
               AND rpad(iDOMAIN.t$vers,4) ||
                   rpad(iDOMAIN.t$rele,2) ||
                   rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv401000 l1 
                                               where l1.t$cpac = iDOMAIN.t$cpac 
                                                 and l1.t$cdom = iDOMAIN.t$cdom )
               AND rpad(iLABEL.t$vers,4) ||
                   rpad(iLABEL.t$rele,2) ||
                   rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                        rpad(l1.t$rele,2) ||
                                                        rpad(l1.t$cust,4)) 
                                               from baandb.tttadv140000 l1 
                                              where l1.t$clab = iLABEL.t$clab 
                                                and l1.t$clan = iLABEL.t$clan 
                                                and l1.t$cpac = iLABEL.t$cpac ) ) DTRFD
       ON tdrec940.t$rfdt$l = DTRFD.iCODE 
        
  
LEFT JOIN baandb.ttdrec947301  tdrec947
       ON tdrec947.t$fire$l = tdrec940.t$fire$l

LEFT JOIN baandb.ttdpur400301  tdpur400
       ON  tdpur400.t$orno = tdrec947.t$orno$l
    
LEFT JOIN baandb.ttdpur094301  tdpur094
       ON  tdpur094.t$potp = tdpur400.t$cotp
       
LEFT JOIN baandb.ttcmcs966301  tcmcs966
       ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l,
          
          baandb.ttfacp201301  tfacp201
                 
LEFT JOIN baandb.ttfcmg001301  tfcmg001
       ON tfcmg001.t$bank = tfacp201.t$brel

LEFT JOIN baandb.ttccom125301  tccom125
       ON tccom125.t$ptbp = tfacp201.t$ifbp
      AND tccom125.t$cban = tfacp201.t$bank

LEFT JOIN baandb.ttfcmg011301  tfcmg011
       ON tfcmg011.t$bank = tccom125.t$brch,

          ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
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
                                           and l1.t$cpac = l.t$cpac ) ) iSTAT
                                           
WHERE tfacp201.t$ttyp = tfacp200.t$ttyp
  AND tfacp201.t$ninv = tfacp200.t$ninv
  AND tfacp200.t$docn = 0 
  AND iSTAT.CODE = tfacp201.t$pyst$l

  AND tfacp200.t$docd BETWEEN :EmissaoDe AND :EmissaoAte
  AND tfacp200.t$dued between :VencimentoDe AND :VencimentoAte
  AND tfacp200.t$ttyp IN (:TipoTransacao)
  AND NVL(Trim(tfacp200.t$bloc), '000') IN (:Bloqueado)
  AND tfacp200.t$ifbp IN (:ParceiroNegocio)
  AND ((tfacp200.t$afpy ! =  2 and :PrepPagto = 1)or(tfacp200.t$afpy = 2 and :PrepPagto = 2)or(:PrepPagto = 0))
  AND NVL(TRIM(tfacp200.t$paym), 'N/A') IN (:MetodoPagto)
  AND NVL(tfacp201.t$pyst$l, 1) IN (:Situacao)
  AND NVL(tflcb230.t$stat$d, 0) IN (:StatusArquivo)
  AND ((UPPER(tdrec947.t$orno$l) like '%' || UPPER(:OrdemCompra) || '%') OR (:OrdemCompra is null))
  AND ((tdrec940.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null))
  AND ((Upper(Concat(Trim(tfacp200.t$ttyp), tfacp200.t$ninv)) =  Upper(Trim(:Transacao))) OR (:Transacao is null))