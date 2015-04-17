SELECT 
  DISTINCT
    TENT.RN                       TENTATIVA,
    tfcmg103.t$btno               LOTE_PAGTO,
    tfcmg103.t$plan               DATA_PAGTO_PLANEJADO,
    tfcmg103.t$ptbp               COD_PN,
    tccom100.t$nama               PN,
    CASE WHEN tfcmg103.t$paid = 1 
           THEN 'Pago'
         ELSE   'Aberto' 
     END                          SITUACAO,
    iStatSend.DESCR               STATUS_ARQUIVO,
    tflcb230.t$erro$d             DSC_ERRO,
    tfacp200.t$ttyp ||              
    tfacp200.t$ninv               TRANSACAO,
    tfacp200.t$ninv               TITULO,
    tfacp200.t$schn               NRO_PROGRAMACAO,
    tfcmg103.t$amnt               VALOR_TITULO,

    iTABLE.DESC_MODAL             MODALIDADE_PAGAMENTO,
    CASE WHEN tfacp200.t$ttyp = 'PRB' 
           THEN PEDIDO.NUMERO                 
         ELSE   'N/A'  
     END                          PEDIDO,

    tfcmg103.t$basu               CODIGO_CONTA,
    tfcmg011.t$desc               BANCO_PN,
    tccom125.t$brch               FILIAL_BANCARIA,
    tccom125.t$bano               CONTA_PN,
    tccom125.t$dacc$d             DIGITO_CC,
    tfcmg103.t$ttyp || '-' ||
    tfcmg103.t$docn               DOCUMENTO_PAGAMENTO,
    tdrec940.t$fire$l             REFERENCIA_FISCAL
  
FROM  baandb.ttfcmg103301 tfcmg103

 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tfcmg103.t$ptbp
        
 LEFT JOIN baandb.ttfacp200301 tfacp200
        ON tfacp200.t$tdoc = tfcmg103.t$ttyp
       AND tfacp200.t$docn = tfcmg103.t$docn
       
 LEFT JOIN baandb.ttflcb230301 tflcb230
        ON tflcb230.t$ptyp$d = tfcmg103.t$ttyp
       AND tflcb230.t$docn$d = tfcmg103.t$docn
       AND tflcb230.t$ttyp$d = tfacp200.t$ttyp
       AND tflcb230.t$ninv$d = tfacp200.t$ninv
 
 LEFT JOIN baandb.ttccom125301  tccom125
        ON tccom125.t$ptbp = tfcmg103.t$ptbp
       AND tccom125.t$cban = tfcmg103.t$basu
        
 LEFT JOIN baandb.ttdrec940301  tdrec940
        ON tdrec940.t$ttyp$l = tfacp200.t$ttyp
       AND tdrec940.t$invn$l = tfacp200.t$ninv
     
 LEFT JOIN baandb.ttfcmg011301  tfcmg011
      ON tfcmg011.t$bank = tccom125.t$brch
        
 LEFT JOIN ( select iDOMAIN.t$cnst CODE_MODAL, 
                    iLABEL.t$desc DESC_MODAL  
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'cmg.mopa.d'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE
        ON tfcmg103.t$mopa$d = iTABLE.CODE_MODAL
        
 LEFT JOIN ( select -1                        CODE,
                    'Não disponível'          DESCR
               from Dual
           
              union

             select d.t$cnst                  CODE,
                    l.t$desc                  DESCR
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.stat.l'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatSend
        ON iStatSend.CODE = NVL(Trim(tflcb230.T$STAT$D), -1)
 
 LEFT JOIN ( select znsls412.t$ttyp$c,
                    znsls412.t$ninv$c,
                    znsls412.t$pecl$c NUMERO
               from baandb.tznsls412301  znsls412 ) PEDIDO
        ON PEDIDO.t$ttyp$c = tfacp200.t$ttyp
       AND PEDIDO.t$ninv$c = tfacp200.t$ninv 
            
 LEFT JOIN ( SELECT D.T$TTYP$D,
                    D.T$NINV$D,
                    D.T$PTYP$D,
                    D.T$DOCN$D,
                    ROW_NUMBER() OVER 
                    ( PARTITION BY D.T$TTYP$D,
                                   D.T$NINV$D
                          ORDER BY D.T$PAYD$D )  RN
              FROM BAANDB.TTFLCB230301 D )  TENT
        ON TENT.T$TTYP$D = TFACP200.T$TTYP
       AND TENT.T$NINV$D = TFACP200.T$NINV
       AND TENT.T$PTYP$D = TFACP200.T$TDOC
       AND TENT.T$DOCN$D = TFACP200.T$DOCN
   
WHERE tfacp200.t$ttyp IN ('SFA','PFA','PSG','SFS','PFS','PAG','SFT','PRB','PBG','PFR')
  AND tfcmg103.t$plan Between :DataPagtoDe And :DataPagtoAte
  AND ((:TransacaoTodos = 1) OR (tfacp200.t$ttyp || tfacp200.t$ninv IN (:Transacao) AND :TransacaoTodos = 0))
  AND ((:PedidoTodos = 1) OR (CASE WHEN tfacp200.t$ttyp = 'PRB' 
                                     THEN PEDIDO.NUMERO                 
                                   ELSE   'N/A'  
                               END IN (:Pedido) AND :PedidoTodos = 0))
  
ORDER BY COD_PN, 
         TRANSACAO, 
         LOTE_PAGTO, 
         DATA_PAGTO_PLANEJADO
