SELECT DISTINCT
    tfcmg101.t$btno               LOTE_PAGTO,                               --01
    tccom130.t$fovn$l             CNPJ_PN,                                  --02
    tfcmg101.t$ifbp               COD_PN,                                   --03
    Trim(tccom100.t$nama)         PARCEIRO_NEGOCIOS,                        --04
    ACONSELHAMENTO.               DESCR_TIPO_ACONSELHAMENTO,                --05
    tfcmg002.t$desc               MOTIVO_PAGTO,                             --06
    tfcmg101.t$basu               CODE_CONTA_BANCO_PN,                      --07
    tccom125.t$brch               FILIAL_BANCARIA_BANCO_PN,                 --08
    tccom125.t$bano               CONTA_BANCARIA_BANCO_PN,                  --09
    tccom125.t$dacc$d             DIGITO_CONTA_BANCARIA_BANCO_PN,           --10
    tfcmg101.t$paym               METODO_PAGTO,                             --11
    tfcmg001.t$desc               RELACAO_BANCARIA,                         --12
    tfcmg101.t$amnt               VALOR_ADIANTAMENTO,                       --13
    tfcmg101.t$ptyp || '-' ||
    TO_CHAR(tfcmg101.t$pdoc)      DOCUMENTO_PAGAMENTO,                      --14
    ADIANTAMENTO.                 DT_EMISSAO,                               --15
    ADIANTAMENTO.                 VL_ADIANTADO,                             --16
    ADIANTAMENTO.BALC -
    NVL(ADIANTAMENTO.BALA,0)      VL_ADIANTADO_SALDO,                       --17
    TIPO_DOC.DESCR                TIPO_DOCUMENTO,                           --18
    PREST_CONTAS.TRANS || '-' ||
    TO_CHAR(PREST_CONTAS.DOCTO)   LINK_ADIANTAMETNO,                        --19
    PREST_CONTAS.PN               COD_PN_PREST_CONTAS,                      --20
    tccom130pt.t$fovn$l           CNPJ_PN_PREST_CONTAS,                     --21
    tccom100pt.t$nama             PN_PREST_CONTAS,                          --22
    TRANS_PREST_CONTAS.TRANS || '-' ||
    TRANS_PREST_CONTAS.DOCTO      TRANS_PREST_CONTAS,                       --23
    PREST_CONTAS.TIPO_DOC         TIPO_DOC_PREST_CONTAS,                    --24
    PREST_CONTAS.VALOR            VALOR_TRANS_PREST_CONTAS,                 --25
    PREST_CONTAS.BALC -
    NVL(PREST_CONTAS.BALA,0)      SALDO_TRANS_PREST_CONTAS,                 --26
    tfcmg101.t$refr               REFERENCIA                                --EXCEL
 
FROM       baandb.ttccom100201  tccom100

  LEFT JOIN baandb.ttccom130201  tccom130
         ON tccom130.t$cadr   = tccom100.t$cadr

  LEFT JOIN baandb.ttfcmg101201  tfcmg101  
         ON tccom100.T$BPID   = tfcmg101.t$ifbp

  LEFT JOIN baandb.ttccom125201 tccom125
         ON tccom125.t$ptbp = tfcmg101.t$ifbp
        AND tccom125.t$cban = tfcmg101.t$basu
  
  LEFT JOIN baandb.ttfcmg001201 tfcmg001 
         ON tfcmg001.t$bank = tfcmg101.t$bank
         
  LEFT JOIN baandb.ttfcmg002201 tfcmg002
         ON tfcmg002.t$reas = tfcmg101.t$reas
    
  LEFT JOIN ( select  a.t$docd DT_EMISSAO,
                      a.t$tpay TP_DOCTO,
                      a.t$amnt VL_ADIANTADO,
                      a.t$balc BALC,
                      a.t$bala BALA,
                      a.t$ttyp,
                      a.t$ninv
              from    baandb.ttfacp200201 a
              where   a.t$tpay = 9  ) ADIANTAMENTO
         ON ADIANTAMENTO.t$ttyp = tfcmg101.t$ptyp
        AND ADIANTAMENTO.t$ninv = tfcmg101.t$pdoc
  
    
  LEFT JOIN ( select  a.t$tdoc TRANS,
                      a.t$docn DOCTO,
                      a.t$ifbp PN,
                      a.t$tpay TIPO_DOC,
                      a.t$amnt VALOR,
                      a.t$balc BALC,
                      a.t$bala BALA,
                      a.t$ttyp,
                      a.t$ninv
              from    baandb.ttfacp200201 a
              where   a.t$tpay = 14  ) PREST_CONTAS
         ON PREST_CONTAS.t$ttyp = tfcmg101.t$ptyp
        AND PREST_CONTAS.t$ninv = tfcmg101.t$pdoc

  LEFT JOIN baandb.ttccom100201 tccom100pt        --PN de Prestação de Contas
         ON tccom100pt.t$bpid = PREST_CONTAS.PN
         
  LEFT JOIN baandb.ttccom130201 tccom130pt    
         ON tccom130pt.t$cadr = tccom100pt.t$cadr 
  
  LEFT JOIN ( select  a.t$ttyp TRANS,
                      a.t$ninv DOCTO,
                      a.t$tdoc,
                      a.t$docn
              from    baandb.ttfacp200201 a
              where   a.t$tpay = 14  ) TRANS_PREST_CONTAS
         ON TRANS_PREST_CONTAS.t$tdoc = PREST_CONTAS.TRANS
        AND TRANS_PREST_CONTAS.t$docn = PREST_CONTAS.DOCTO
        AND TRANS_PREST_CONTAS.TRANS != PREST_CONTAS.t$ttyp
        AND TRANS_PREST_CONTAS.DOCTO != PREST_CONTAS.t$ninv
  
  LEFT JOIN ( SELECT iDOMAIN.t$cnst CODE_MODAL, 
                    iLABEL.t$desc DESC_MODAL  
              FROM baandb.tttadv401000 iDOMAIN, 
                   baandb.tttadv140000 iLABEL 
             WHERE iDOMAIN.t$cpac = 'tf' 
               AND iDOMAIN.t$cdom = 'cmg.mopa.d'
               AND iLABEL.t$clan = 'p'
               AND iLABEL.t$cpac = 'tf'
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
                                                and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE
        ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL

  LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_ACONSELHAMENTO,
                    d.t$cnst
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
                                            and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO
        ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv

  LEFT JOIN ( SELECT iDOMAIN.t$cnst CODE, 
                   iLABEL.t$desc DESCR  
              FROM baandb.tttadv401000 iDOMAIN, 
                   baandb.tttadv140000 iLABEL 
             WHERE iDOMAIN.t$cpac = 'tf' 
               AND iDOMAIN.t$cdom = 'acp.tpay'
               AND iLABEL.t$clan = 'p'
               AND iLABEL.t$cpac = 'tf'
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
                                                and l1.t$cpac = iLABEL.t$cpac ) ) TIPO_DOC
        ON TIPO_DOC.CODE = ADIANTAMENTO.TP_DOCTO
        
Where tfcmg101.t$tadv = 5   --Pagamento Adiantado
        
