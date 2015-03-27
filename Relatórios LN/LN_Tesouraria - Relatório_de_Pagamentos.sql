SELECT 
  DISTINCT
    tfcmg011.t$baoc$l       CODE_BANCO,
    tfcmg011.t$agcd$l       CODE_AGENCIA,
    tfcmg001.t$bano         CODE_CONTA,
    tfcmg103.t$docd         DATA_PAGTO, 
    NVL(tfcmg103.t$paym,
        '- Não Definido -') CODE_METODO_PGTO, 
    tfcmg003.               t$desc,  
    tfcmg103.t$docn         NUME_TITULO,
    tfacp200a.t$tpay        TIPO_DOCTO,  
    tfacp200a.t$docd        DATA_EMISSAO,  
    tfcmg103.t$dued$l       DATA_VENCTO,
    tfacp200a.t$amnt        VLR_TITULO,
    tfcmg103.t$amnt         VLR_PAGTO,
    tfcmg103.t$ptbp         CODE_FORNECEDOR, 
    tccom100.t$nama         DESC_FORNECEDOR,
    NVL(tfcmg109.t$stpp,0)  SITUACAO_PAGTO, 
    iSTPP.                  DESC_PAGTO,  
    tfacp200a.t$leac        CTA_CONTABIL,
    tfcmg103.t$btno         NUME_LOTE,
    
    tfacp200.t$ttyp ||
    tfacp200.t$ninv         TRANSACAO,
    tfacp200.t$ninv         TITULO,
    CASE WHEN tdpur094.t$dsca IS NULL 
           THEN tdpur094a.t$dsca
         ELSE   tdpur094.t$dsca 
    END                     TIPO_ORDEM,
        
    CASE WHEN tdrec952.t$leac$l IS NULL 
           THEN CASE WHEN tdrec952a.t$leac$l IS NULL 
                       THEN CASE WHEN ( select count(*) 
                                          from baandb.ttfgld106301 a1
                                         where a1.t$otyp = tfacp200a.t$ttyp
                                           and a1.t$odoc = tfacp200a.t$ninv ) = 2 
                                   THEN ( select a2.t$leac 
                                            from baandb.ttfgld106301 a2
                                           where a2.t$otyp = tfacp200a.t$ttyp
                                             and a2.t$odoc = tfacp200a.t$ninv
                                             and a2.t$leac != tfacp200a.t$leac )
                                   ELSE NULL 
                             END                                
                       ELSE tdrec952a.t$leac$l 
                END
           ELSE tdrec952.t$leac$l 
    END COD_CONTA_DESTINO,
      
    CASE WHEN tdrec952.t$leac$l IS NULL 
      THEN
        CASE WHEN tdrec952a.t$leac$l IS NULL 
          THEN
            CASE WHEN ( select count(*) 
                          from baandb.ttfgld106301 a1
                         where a1.t$otyp = tfacp200a.t$ttyp
                           and a1.t$odoc = tfacp200a.t$ninv ) = 2 
                   THEN ( select b1.t$desc 
                            from baandb.ttfgld106301 a2,
                                 baandb.ttfgld008301 b1
                           where a2.t$otyp = tfacp200a.t$ttyp
                             and a2.t$odoc = tfacp200a.t$ninv
                             and a2.t$leac != tfacp200a.t$leac 
                             and a2.t$leac = b1.t$leac )
                   ELSE NULL 
             END                                
          ELSE DESCR_CONTA_DESTINOa.DESCR 
        END
      ELSE DESCR_CONTA_DESTINO.DESCR 
    END                       DESCR_CONTA_DESTINO
  
FROM       baandb.ttfacp200301 tfacp200

INNER JOIN baandb.ttfacp600301 tfacp600
        ON tfacp200.t$tdoc = tfacp600.t$payt
       AND tfacp200.t$docn = tfacp600.t$payd
       AND tfacp200.t$lino = tfacp600.t$payl
 
 LEFT JOIN baandb.ttfcmg109301 tfcmg109  
        ON tfcmg109.t$btno = tfacp600.t$pbtn
 
 LEFT JOIN baandb.ttfcmg103301 tfcmg103  
        ON tfcmg103.T$BTNO = tfcmg109.T$BTNO
       AND tfcmg103.t$ttyp = tfacp200.t$tdoc 
       AND tfcmg103.t$docn = tfacp200.t$docn
 
 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfcmg103.t$ptbp

 LEFT JOIN BAANDB.ttfcmg003301 tfcmg003
        ON tfcmg003.t$paym = tfcmg103.t$paym

 LEFT JOIN baandb.ttfcmg001301 tfcmg001  
        ON tfcmg001.t$bank = tfacp600.t$bank
 
 LEFT JOIN baandb.ttfcmg001301 tfcmg001f 
        ON tfcmg001f.t$bank = tfacp600.t$basu
 
 LEFT JOIN baandb.ttfcmg011301 tfcmg011  
        ON tfcmg011.t$bank = tfcmg001.t$brch
 
 LEFT JOIN baandb.ttfcmg011301 tfcmg011f 
        ON tfcmg011f.t$bank = tfcmg001f.t$brch
  
 LEFT JOIN baandb.ttfacp200301 tfacp200a 
        ON tfacp200a.t$ttyp = tfacp200.t$ttyp 
       AND tfacp200a.t$ninv = tfacp200.t$ninv
       AND tfacp200a.t$lino = 0

 LEFT JOIN ( select d.t$cnst CODE_PAGTO, 
                    l.t$desc DESC_PAGTO
               from baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              where d.t$cpac = 'tf' 
                and d.t$cdom = 'cmg.stpp'
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
                                            and l1.t$cpac = l.t$cpac )) iSTPP
        ON tfcmg109.t$stpp = iSTPP.CODE_PAGTO 

 LEFT JOIN baandb.ttdrec940301 tdrec940
        ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec940.t$invn$l = tfacp200.t$ninv
        
 LEFT JOIN baandb.ttdrec947301 tdrec947
        ON tdrec947.t$fire$l=tdrec940.t$fire$l
       AND ROWNUM = 1        -- o tipo de ordem de compra será igual para todas as ordens
  
 LEFT JOIN baandb.ttdpur400301 tdpur400
        ON tdpur400.t$orno = tdrec947.t$orno$l
        
 LEFT JOIN baandb.ttdpur094301 tdpur094
        ON tdpur094.t$potp = tdpur400.t$cotp
  
 LEFT JOIN baandb.ttdrec952301 tdrec952
        ON tdrec952.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec952.t$invn$l = tfacp200.t$ninv
       AND tdrec952.t$fire$l = tdrec940.t$fire$l
       AND tdrec952.t$dbcr$l = 1
       AND tdrec952.t$trtp$l = 2
       AND tdrec952.t$brty$l = 0

 LEFT JOIN ( select a.t$leac,
                    a.t$desc DESCR
               from baandb.ttfgld008301 a ) DESCR_CONTA_DESTINO
        ON DESCR_CONTA_DESTINO.t$leac = tdrec952.t$leac$l
        
 LEFT JOIN baandb.ttfacp936301  tfacp936          --Títulos agrupados para pagamento  
        ON tfacp936.t$ttyp$l = tfacp200.t$ttyp
       AND tfacp936.t$ninv$l = tfacp200.t$ninv
       AND ROWNUM = 1
   
 LEFT JOIN baandb.ttdrec940301 tdrec940a
        ON tdrec940a.t$ttyp$l = tfacp936.t$tty2$l
       AND tdrec940a.t$invn$l = tfacp936.t$nin2$l
        
 LEFT JOIN baandb.ttdrec947301 tdrec947a
        ON tdrec947a.t$fire$l=tdrec940a.t$fire$l
       AND ROWNUM = 1        -- o tipo de ordem de compra será igual para todas as ordens
  
 LEFT JOIN baandb.ttdpur400301 tdpur400a
        ON tdpur400a.t$orno = tdrec947a.t$orno$l
        
 LEFT JOIN baandb.ttdpur094301 tdpur094a
        ON tdpur094a.t$potp = tdpur400a.t$cotp
        
 LEFT JOIN baandb.ttdrec952301 tdrec952a
        ON tdrec952a.t$ttyp$l = tfacp936.t$tty2$l
       AND tdrec952a.t$invn$l = tfacp936.t$nin2$l
       AND tdrec952a.t$fire$l = tdrec940a.t$fire$l
       AND tdrec952a.t$dbcr$l = 1
       AND tdrec952a.t$trtp$l = 2
       AND tdrec952a.t$brty$l = 0

 LEFT JOIN ( select a.t$leac,
                    a.t$desc DESCR
               from baandb.ttfgld008301 a ) DESCR_CONTA_DESTINOa
        ON DESCR_CONTA_DESTINOa.t$leac = tdrec952a.t$leac$l
   
WHERE tfcmg103.t$docd BETWEEN NVL(:DtPagtoDe, tfcmg103.t$docd) AND NVL(:DtPagtoAte, tfcmg103.t$docd)
  AND NVL(tfcmg103.t$paym, '- Não Definido -') IN (:Modalidade)
  AND NVL(tfcmg109.t$stpp, 0) IN (:Situacao)
  AND tfcmg011.t$baoc$l = NVL(:Banco, tfcmg011.t$baoc$l)
  AND tfcmg103.t$btno = NVL(:Lote, tfcmg103.t$btno)

ORDER BY TRANSACAO