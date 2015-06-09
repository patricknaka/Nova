CREATE VIEW VW_CAP_TITULOS_GERAL

SELECT
  DISTINCT
    Concat(tfacp200.t$ttyp, tfacp200.t$ninv)    TRANSCAO,
    tfacp200.t$ninv                             NUME_TITULO,
    tfacp200.t$ttyp                             CODE_TRANS,
    tdrec940.t$fire$l                           CODE_REFER,
    tfacp200.t$docn$l                           NUME_NF,
    tfacp200.t$seri$l                           SERI_NF,
    TO_NUMBER((regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')))
                                                CNPJ_FORN,
    tccom100.t$nama                             NOME_FORN,
    tfacp200.t$docd                             DATA_EMISSAO,
    tfacp201.t$schn                             NO_PROGRAMACAO,
    tfacp201.t$payd                             DATA_VENCTO,
    tfacp200.t$amnt                             VALO_TITULO,  
    tfacp200.t$balc                             SALD_TITULO,
    301                                         CODE_CIA,             

    CASE WHEN (tfacp200.t$balc - tfacp200.t$bala) = 0 
           THEN 1
         ELSE   2 
     END                                        DESC_SITUA1,

    CASE WHEN tfacp201.t$pyst$l !=   3 
           THEN 2
         ELSE   1 
     END                                        CODE_SITUA2,

    CASE WHEN tfacp201.t$pyst$l !=   3
           THEN 'Não' 
         ELSE 'Sim' 
     END                                        DESC_SITUA2,

    tfcmg101.t$plan                             DATA_PLAN_PAGTO,
    NVL(Trim(tfacp200.t$bloc), '000')           STATUS_BLOQUEIO,
    NVL(BLOQUEIO.DSC_STATUS_BLOQUEIO, 'Sem bloqueio') 
                                                DESC_STATUS_BLOQUEIO,

    CASE WHEN tfcmg101.t$amnt IS NULL 
           THEN tfacp201.t$balc
         ELSE   tfcmg101.t$amnt 
     END                                        VALOR_APAGAR,

    CASE WHEN tfacp201.t$brel = ' ' 
           THEN tfcmg101.t$bank
         ELSE   tfacp201.t$brel  
     END                                        NUM_REL_BANCARIA,
    
    CASE WHEN tfcmg001_CMG.t$desc IS NULL 
           THEN tfcmg001_ACP.t$desc
         ELSE tfcmg001_CMG.t$desc 
     END                                        DESC_REL_BANCARIA,

    CASE WHEN tfcmg101.t$bank IS NULL 
           THEN CASE WHEN tfacp201.t$brel IS NULL 
                       THEN ' '
                     ELSE   tfacp201.t$brel || '-' || tfcmg001_ACP.t$desc  
                 END
           ELSE tfcmg101.t$bank || '-' || tfcmg001_CMG.t$desc 
     END                                        REL_BANCARIA,
    
    CASE WHEN tfcmg101.t$paym = ' ' 
           THEN NVL(TRIM(tfacp201.t$paym), 'N/A')
         ELSE NVL(TRIM(tfcmg101.t$paym), 'N/A') 
     END                                        METODO_PAGTO,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfacp201.t$bank
         ELSE tfcmg101.t$basu 
     END                                        BANCO_PARCEIRO,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$agcd$l                           
         ELSE   tfcmg011_CMG.t$agcd$l 
     END                                        NUME_AGENCIA,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$agdg$l                           
         ELSE   tfcmg011_CMG.t$agdg$l 
     END                                        DIGI_AGENCIA,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$desc                         
         ELSE   tfcmg011_CMG.t$desc 
     END                                        DESC_AGENCIA,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tccom125_ACP.t$bano                             
         ELSE   tccom125_CMG.t$bano 
     END                                        NUME_CONTA,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tccom125_ACP.t$dacc$d                           
         ELSE   tccom125_CMG.t$dacc$d 
     END                                        DIGI_CONTA,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfacp201.t$bank
         ELSE   tfcmg101.t$basu 
     END                                        COD_BANCO_PN,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$desc                             
         ELSE   tfcmg011_CMG.t$desc 
     END                                        BANCO_PN,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$agcd$l                          
         ELSE   tfcmg011_CMG.t$agcd$l 
     END                                        AG_BANCO_PN,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tfcmg011_ACP.t$agdg$l                     
         ELSE   tfcmg011_CMG.t$agdg$l 
     END                                        DIG_AG_PN,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tccom125_ACP.t$bano                   
         ELSE   tccom125_CMG.t$bano 
     END                                        CONTA_BANCO_PN,
    
    CASE WHEN tfcmg101.t$basu IS NULL 
           THEN tccom125_ACP.t$dacc$d                 
         ELSE   tccom125_CMG.t$dacc$d 
     END                                        DIG_CONTA_BANCO_PN,
                   
    tfcmg101.t$btno                             LOTE_PAGTO,
    tdrec940.t$fire$l                           NUM_RFISCAL,
    tdrec940.t$rfdt$l                           NUM_CFISCAL, 
    DTRFD.DESC_CODIGO_FISCAL                    DESC_CODIGO_FISCAL,        
    tdrec940.t$fdtc$l                           COD_TIPO_DOC_FISCAL,             -- antes TIPO_ORDEM,
    tcmcs966.t$dsca$l                           DESC_TIPO_DOC_FISCAL,            -- antes DESC_TIPO_ORDEM,       
    tdrec947.t$orno$l                           NUM_ORDEM,
    tfacp201.t$mopa$d                           CODE_MODAL_PGTO,
    
    DESC_MODAL_PGTO.                            DESC_MODAL_PGTO,
    
    OCORRENCIA.                                 OCORRENCIA1,
    OCORRENCIA.                                 OCORRENCIA2,
    OCORRENCIA.                                 OCORRENCIA3,
    OCORRENCIA.                                 OCORRENCIA4,
              
    tfacp200.t$ifbp                             CODE_PN,
    tccom100.t$nama                             DESC_PN,

    Concat(Concat(tfacp200.t$ifbp, ' - '), 
           tccom100.t$nama)                     COD_DESC_PEN,
                                                                                            
    CASE WHEN znacp005.t$canc$c = 1 
           THEN 99
         WHEN znacp005.t$canc$c = 2 
           THEN 98
         WHEN (tfacp200.t$asst$l = 2 AND tfacp201.t$pyst$l IS NULL) 
           THEN 97
         ELSE   NVL(tfacp201.t$pyst$l, 1)
     END                                        STAT_PRG,
    
    CASE WHEN znacp005.t$canc$c = 1 
           THEN 'Cancelado'
         WHEN znacp005.t$canc$c = 2 
           THEN 'Agrupado'
         WHEN (tfacp200.t$asst$l = 2 AND tfacp201.t$pyst$l IS NULL) 
           THEN 'Associado'
         ELSE   iSTAT.DESCR
     END                                        DESCR_STAT_PRG,
  
    CONCAT(znacp005.t$ttyp$c,znacp005.t$ninv$c) TITULO_AGRUPADOR,
    OrdemCompra.                                COD_TIPO_ORDEM,          --tipo de ordem de compra
    OrdemCompra.                                DECR_TIPO_ORDEM,         --descrição tipo ordem de compra
    tfacp200.t$leac                             COD_CONTA_CONTROLE,
    tfgld008.t$desc                             DESCR_CONTA_CONTROLE,
    tdrec952.t$leac$l                           COD_CONTA_DESTINO,
  
    DESCR_CONTA_DESTINO.                        DESCR_CONTA_DESTINO,
    
    CASE WHEN tflcb230.t$send$d = 0 
           THEN tflcb230.t$stat$d
         ELSE tflcb230.t$send$d 
     END                                        CODE_STAT_ARQ,
  
    tflcb230.t$lach$d                           DATA_STAT_ARQ,
 
    CASE WHEN tflcb230.t$send$d = 0 
           THEN NVL(iStatArq.DESCR,  'Arquivo não vinculado') 
         ELSE   NVL(iStatArq2.DESCR, 'Arquivo não vinculado') 
     END                                        DESCR_STAT_ARQ, 
  
    OrdemCompra.REFA                            REF_ORDEM_COMPRA,
    tfacp200.t$refr                             REF_TITULO,
    TIPO_ACONS.DESCR                            TIPO_ACONSELHAMENTO,
    tfcmg004.t$desc                             TIPO_PAGAMENTO,
    tfcmg002.t$desc                             MOTIVO_PAGAMENTO
    
FROM       baandb.ttfacp200301   tfacp200  

 LEFT JOIN ( select m.t$bloc COD_STATUS_BLOQUEIO,
                    m.t$desc DSC_STATUS_BLOQUEIO
               from baandb.ttfacp002301 m ) BLOQUEIO
        ON BLOQUEIO.COD_STATUS_BLOQUEIO = tfacp200.t$bloc

 LEFT JOIN baandb.ttfgld008301 tfgld008
        ON tfgld008.t$leac = tfacp200.t$leac
   
 LEFT JOIN ( SELECT a.t$ptyp$d,
                    a.t$docn$d,
                    a.t$ttyp$d, 
                    a.t$ninv$d,
                    a.t$lach$d,
                    max(a.t$stat$d) t$stat$d,
                    max(a.t$send$d) t$send$d
               FROM baandb.ttflcb230301 a
              WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230301 b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d )
           GROUP BY a.t$ptyp$d,
                    a.t$docn$d,
                    a.t$ttyp$d, 
                    a.t$ninv$d, 
                    a.t$lach$d ) tflcb230
        ON tflcb230.t$ttyp$d = tfacp200.t$ttyp
       AND tflcb230.t$ninv$d = tfacp200.t$ninv

 LEFT JOIN baandb.ttfacp201301  tfacp201
        ON tfacp201.t$ttyp = tfacp200.t$ttyp
       AND tfacp201.t$ninv = tfacp200.t$ninv

 LEFT JOIN baandb.ttfcmg101301 tfcmg101
        ON tfcmg101.t$ttyp = tfacp201.t$ttyp
       AND tfcmg101.t$ninv = tfacp201.t$ninv
       AND tfcmg101.t$schn = tfacp201.t$schn
    
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq2
        ON iStatArq2.CODE = tflcb230.t$send$d

  LEFT JOIN baandb.ttccom100301 tccom100
         ON tccom100.t$bpid = tfacp200.t$ifbp
    
 LEFT JOIN baandb.ttccom130301 tccom130
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
 
 LEFT JOIN baandb.ttcmcs966301  tcmcs966
        ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l
           
 LEFT JOIN baandb.ttfcmg001301  tfcmg001_ACP
        ON tfcmg001_ACP.t$bank = tfacp201.t$brel
 
  LEFT JOIN baandb.ttfcmg001301  tfcmg001_CMG
        ON tfcmg001_CMG.t$bank = tfcmg101.t$bank

 LEFT JOIN baandb.ttccom125301  tccom125_ACP
        ON tccom125_ACP.t$ptbp = tfacp201.t$ifbp
       AND tccom125_ACP.t$cban = tfacp201.t$bank
 
  LEFT JOIN baandb.ttccom125301  tccom125_CMG
        ON tccom125_CMG.t$ptbp = tfcmg101.t$ifbp
       AND tccom125_CMG.t$cban = tfcmg101.t$basu
       
 LEFT JOIN baandb.ttfcmg011301  tfcmg011_ACP
        ON tfcmg011_ACP.t$bank = tccom125_ACP.t$brch
 
 LEFT JOIN baandb.ttfcmg011301  tfcmg011_CMG
        ON tfcmg011_CMG.t$bank = tccom125_CMG.t$brch
 
 LEFT JOIN ( SELECT d.t$cnst CODE,
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
        ON iSTAT.CODE = NVL(tfacp201.t$pyst$l, 1)
                                            
 LEFT JOIN ( SELECT l.t$desc DESC_MODAL_PGTO,
                    d.t$cnst COD_MODAL_PGTO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.mopa.d'
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
                                            and l1.t$cpac = l.t$cpac ) )  DESC_MODAL_PGTO
        ON DESC_MODAL_PGTO.COD_MODAL_PGTO = tfacp201.t$mopa$d 
   
 LEFT JOIN ( select a.t$leac,
                    a.t$desc DESCR_CONTA_DESTINO
               from baandb.ttfgld008301 a ) DESCR_CONTA_DESTINO
        ON DESCR_CONTA_DESTINO.t$leac = tdrec952.t$leac$l
        
 LEFT JOIN ( SELECT tflcb231a.t$ocr1$d OCORRENCIA1,
                    tflcb231a.t$ocr2$d OCORRENCIA2,
                    tflcb231a.t$ocr3$d OCORRENCIA3,
                    tflcb231a.t$ocr4$d OCORRENCIA4,
                    tflcb231a.t$ttyp$d,
                    tflcb231a.t$ninv$d
               FROM baandb.ttflcb231301  tflcb231a
              WHERE tflcb231a.t$dare$d = ( SELECT MAX(tflcb231b.t$dare$d)
                                             FROM baandb.ttflcb231301  tflcb231b
                                            WHERE tflcb231b.t$ttyp$d = tflcb231a.t$ttyp$d
                                              AND tflcb231b.t$ninv$d = tflcb231a.t$ninv$d ) ) OCORRENCIA
        ON OCORRENCIA.t$ttyp$d = tfacp200.t$ttyp
       AND OCORRENCIA.t$ninv$d = tfacp200.t$ninv

 LEFT JOIN baandb.tznacp004301 znacp004
        ON znacp004.t$bpid$c = tfacp200.t$ifbp
       AND znacp004.t$tty1$c = tfacp200.t$ttyp
       AND znacp004.t$nin1$c = tfacp200.t$ninv
      
 LEFT JOIN baandb.tznacp005301 znacp005
        ON znacp005.t$bpid$c = tfacp200.t$ifbp
       AND znacp005.t$ttyp$c = znacp004.t$ttyp$c
       AND znacp005.t$ninv$c = znacp004.t$ninv$c
      
 LEFT JOIN ( select tdpur400.t$cotp  COD_TIPO_ORDEM,          --tipo de ordem de compra
                    tdpur094.t$dsca  DECR_TIPO_ORDEM,         --descrição tipo ordem de compra
                    tdpur400.t$refa  REFA,
                    tdpur400.t$orno,
                    tdpur400.t$cotp,
                    tdpur094.t$potp
               from baandb.ttdpur400301  tdpur400
          left join baandb.ttdpur094301  tdpur094
                 on tdpur094.t$potp = tdpur400.t$cotp ) OrdemCompra
        ON OrdemCompra.t$orno = tdrec947.t$orno$l

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.tadv'
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
                                            and l1.t$cpac = l.t$cpac ) ) TIPO_ACONS
        ON TIPO_ACONS.CODE = tfcmg101.t$tadv

  LEFT JOIN baandb.ttfcmg004301 tfcmg004
         ON tfcmg004.t$topy = tfcmg101.t$topy

  LEFT JOIN baandb.ttfcmg002301 tfcmg002
         ON tfcmg002.t$reas = tfcmg101.t$reas
         
WHERE tfacp200.t$docn = 0
  AND not exists (  select tfacp601.t$payt, tfacp601.t$payd, tfacp601.t$payl, tfacp601.t$pays
                      from baandb.ttfacp601301  tfacp601
                     where tfacp601.t$icom = 301 
                       and tfacp601.t$ityp = tfacp200.t$ttyp
                       and tfacp601.t$idoc = tfacp200.t$ninv
                       and tfacp601.t$step = 20 )