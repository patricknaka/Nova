SELECT
  DISTINCT
    tfacp200.t$ttyp                             TIPO_TRANSACAO,
    to_char(tfacp200.t$docd, 'YYYY')            ANO_EMISSAO, 
    to_char(tfacp200.t$docd, 'MM')              MES_EMISSAO, 
    tfacp200.t$docd                             DATA_EMISSAO, 
    tfacp201.t$odue$l                           DATA_VENCTO_ORIGINAL,
    tfacp200.t$dued                             DATA_VENCTO,
    tccom130.t$fovn$l                           CNPJ_FORNECEDOR,  
    tfacp200.t$ifbp                             NUME_FORNECEDOR,    
    tccom100.t$nama                             DESC_FORNECEDOR,        
    tfacp200.t$ninv                             NUME_DOCUMENTO,
    tfacp201.t$schn                             NUME_PROGRAMACAO,
    tfacp200.t$docn$l                           NUME_NFISCAL,
    tfacp200.t$seri$l                           SERIE_NFISCAL,
    tdrec940.t$fire$l                           NUME_RFISCAL,
    tfacp200.t$ninv                             NUME_TITULO,
    tfacp200.t$amnt                             VLR_TITULO,
    tfacp200.t$balc                             SALD_TITULO,
    CASE WHEN tfcmg101.t$amnt IS NULL or tfcmg101.t$amnt = 0 
           THEN NVL(tfacp201.t$amnt,0)                             
         ELSE  tfcmg101.t$amnt 
     END                                        VALOR_APAGAR,
    tfacp200.t$amnt+tfacp200.t$ramn$l           VALOR_COM_RETIMP,
    CASE WHEN tfacp201.t$pyst$l = 5 
           THEN 'Pago'
         ELSE CASE WHEN tfacp200.t$dued >= TRUNC(SYSDATE) 
                     THEN 'Sim' 
                   ELSE   'Não' 
               END
     END                                        A_VENCER,
    CASE WHEN tfacp201.t$pyst$l = 5 
           THEN 'Pago'
         ELSE CASE WHEN tfacp200.t$dued < TRUNC(SYSDATE) 
                     THEN 'Sim' 
                   ELSE   'Não' 
               END
     END                                        EM_ATRASO,

    tfcmg011.t$baoc$l                           NUME_BANCO,
    tfcmg011.t$agcd$l                           NUME_AGENCIA,
    tfcmg011.t$agdg$l                           DIGI_AGENCIA,
    tfcmg001.t$bano                             NUME_CONTA,
    tfcmg001.t$ofdg$l                           DIGI_CONTA,
  
    tfcmg011b.t$baoc$l                          NUME_BANCO_PARC,
    tfcmg011b.t$agcd$l                          NUME_AGENCIA_PARC,
    tfcmg011b.t$agdg$l                          DIGI_AGENCIA_PARC,
    tccom125.t$bano                             NUME_CONTA_PARC,
    tccom125.t$dacc$d                           DIGI_CONTA_PARC,
    ( SELECT l.t$desc DESCR
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
                                     and l1.t$cpac = l.t$cpac )
         AND d.t$cnst = tfacp201.t$pyst$l )     DESCR_STATUS,  
 
    tfacp201.t$pyst$l                           CODE_STATUS,
    CASE WHEN tfacp201.t$pyst$l = 3 
           THEN 'Sim' 
         ELSE   'Não' 
     END                                        STATUS_PREPARADO_PAGTO,
  
    tfacp201.t$paym                             CODE_METODO_PGTO,
    ( SELECT a.t$desc DS_METODO_PAGAMENTO
        FROM baandb.ttfcmg003301 a
       WHERE a.t$paym = tfacp201.t$paym )       DESCR_METODO_PGTO,
 
    CMG101.LOTE                                 LOTE_PGTO,
    301                                         NUME_CIA


FROM       baandb.ttfacp200301  tfacp200

INNER JOIN baandb.ttfacp201301  tfacp201
        ON tfacp201.t$ttyp = tfacp200.t$ttyp
       AND tfacp201.t$ninv = tfacp200.t$ninv   
   
 LEFT JOIN baandb.ttfcmg001301  tfcmg001
        ON tfcmg001.t$bank = tfacp201.t$brel

 LEFT JOIN baandb.ttccom125301  tccom125
        ON tccom125.t$ptbp = tfacp201.t$ifbp
       AND tccom125.t$cban = tfacp201.t$bank
    
 LEFT JOIN baandb.ttfcmg011301  tfcmg011b
        ON tfcmg011b.t$bank = tccom125.t$brch
          
 LEFT JOIN baandb.ttfcmg011301  tfcmg011
        ON tfcmg011.t$bank = tfcmg001.t$brch
          
 LEFT JOIN baandb.ttccom100301  tccom100 
        ON tccom100.t$bpid = tfacp200.t$ifbp
  
 LEFT JOIN baandb.ttccom130301  tccom130 
        ON tccom130.t$cadr = tccom100.t$cadr
          
 LEFT JOIN baandb.ttdrec940301  tdrec940  
        ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec940.t$invn$l = tfacp200.t$ninv
       AND tfacp200.t$docn$l = tdrec940.t$docn$l    
          
 LEFT JOIN (select max(a.t$btno)  LOTE,
                    a.t$ifbp,
                    a.t$ttyp,
                    a.t$ninv
            from baandb.ttfcmg101301  a
            group by  a.t$ifbp,
                      a.t$ttyp,
                      a.t$ninv ) CMG101
        ON CMG101.t$ifbp = tfacp201.t$ifbp
       AND CMG101.t$ttyp = tfacp201.t$ttyp 
       AND CMG101.t$ninv = tfacp201.t$ninv
       
 LEFT JOIN baandb.ttfcmg101301 tfcmg101
        ON tfcmg101.t$btno = CMG101.LOTE
       AND tfcmg101.t$ifbp = tfacp201.t$ifbp
       AND tfcmg101.t$ttyp = tfacp201.t$ttyp
       AND tfcmg101.t$ninv = tfacp201.t$ninv
  
 LEFT JOIN ( select d.t$cnst iCODE, l.t$desc STATUS_PAGAMENTO 
               from baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              where d.t$cpac = 'tf' 
                and d.t$cdom = 'acp.stap'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) DSTAP
        ON tfacp200.t$stap   = DSTAP.iCODE
            
WHERE tfacp200.t$lino = 0
  AND Trunc(tfacp200.t$docd) <= :EmissaoAte
  AND tfacp201.t$pyst$l IN (:Situacao)
  AND tfacp200.t$ttyp IN (:TipoTransacao)
  AND tfacp200.t$ifbp IN (:PN)
