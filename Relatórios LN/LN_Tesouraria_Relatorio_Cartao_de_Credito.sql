SELECT 
  DISTINCT
    tfacr200.t$docd                       DATA_DE_VENDA,
    tfacr200.t$ninv                       TITULO,
    tfacr200.t$ttyp                       TIPO_TRANSACAO,
    znsls402.t$maqu$c                     MAQUINETA,
    tfacr201.t$schn                       PARCELA,
    tfacr201.t$amnt                       VALOR_TITULO,
    (tfacr201.t$balc - tfacr201.t$bala)   SALDO_TITULO,
    STATUS.Descr                          STATUS,
    tfacr201.t$recd                       VENCIMENTO,
    znsls402.t$nctf$c                     NSU_CTF,
    znsls402.t$nsua$c                     NSU_AUT,
    znsls402.t$idad$c                     ID_ADQUIRENTE,
    tccom100.t$nama                       NOME_ADQUIRENTE,
    znsls402.t$cccd$c                     ID_BANDEIRA,
    zncmg009.t$desc$c                     DESCR_BANDEIRA,
    znsls402.t$auto$c                     ID_AUTORIZACAO,
    znsls402.t$pecl$c                     PEDIDO,
    znsls402.t$ncam$c                     CARTAO_MASCARADO

FROM      baandb.ttfacr200301   tfacr200

LEFT JOIN baandb.ttfacr201301   tfacr201
       ON tfacr201.t$ttyp = tfacr200.t$ttyp
      AND tfacr201.t$ninv = tfacr200.t$ninv
      
LEFT JOIN baandb.tznsls412301 znsls412
       ON znsls412.t$ttyp$c = tfacr200.t$ttyp
      AND znsls412.t$ninv$c = tfacr200.t$ninv

LEFT JOIN baandb.tznsls402301   znsls402
       ON znsls402.t$ncia$c = znsls412.t$ncia$c
      AND znsls402.t$uneg$c = znsls412.t$uneg$c
      AND znsls402.t$pecl$c = znsls412.t$pecl$c
      AND znsls402.t$sqpd$c = znsls412.t$sqpd$c
   
LEFT JOIN baandb.tzncmg008301 zncmg008
       ON zncmg008.t$cias$c = znsls402.t$ncia$c
       AND zncmg008.t$adqs$c = znsls402.t$idad$c
  
LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid = zncmg008.t$adqu$c

LEFT JOIN baandb.tzncmg009301 zncmg009
       ON zncmg009.t$cias$c = znsls402.t$ncia$c
      AND zncmg009.t$bnds$c = znsls402.t$cccd$c
  
LEFT JOIN ( select l.t$desc DESCR,
                   d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'tf'
               and d.t$cdom = 'acr.strp.l'
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
                                           and l1.t$cpac = l.t$cpac ) ) STATUS
       ON STATUS.t$cnst = tfacr201.T$RPST$L

                
WHERE tfacr200.t$lino = 0
  AND znsls402.t$idmp$c = 1       --Meio de Pagamento Cartão de Crédito
  
  AND TRUNC(tfacr200.t$docd) BETWEEN :DataDe AND :DataAte
  AND TRUNC(tfacr201.t$recd) BETWEEN :VencimentoDe AND :VencimentoAte
  AND NVL(STATUS.t$cnst,0) IN (:Status)
  AND ( (:NSUTodos = 0) OR (znsls402.t$nctf$c IN (:NSU) AND (:NSUTodos = 1)) )
  AND ( (:NSUAutTodos = 0) OR (znsls402.t$nsua$c IN (:NSUAut) AND (:NSUAutTodos = 1)) )

  AND zncmg009.t$bnds$c in (:Bandeira)
  AND ( (:AdquirenteTodos = 0) OR (znsls402.t$idad$c in (:Adquirente) and :AdquirenteTodos = 1))
  AND ( (:AutorizacaoTodos = 0) OR (znsls402.t$auto$c in (:Autorizacao) and :AutorizacaoTodos = 1))
  AND ( (:PedidoTodos = 0) OR (znsls402.t$pecl$c in (:Pedido) and :PedidoTodos = 1))
  
ORDER BY tfacr200.T$TTYP, 
         tfacr200.T$NINV, 
         tfacr201.t$schn
      
