SELECT 
  DISTINCT 
    znsls412.t$uneg$c                             UNID_NEGOCIO,
    znint002.t$desc$c                             NM_UNID_NEGOCIO,
    tfacr200.t$itbp                               COD_PN,
    regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')
                                                  CNPJ,
    tccom100.t$nama                               PN,
    CASE WHEN NVL( ( select c.t$styp 
                       from baandb.tcisli205301 c
                      where c.t$styp = 'BL ATC'
                        AND c.t$ityp = tfacr200.t$ttyp
                        AND c.t$idoc = tfacr200.t$ninv
                        AND rownum = 1 ), '0' ) = '0' 
           THEN 'Varejo' 
         ELSE   'Atacado' 
     END                                          FILIAL,
    Concat(tfacr200.t$ttyp, tfacr200.t$ninv)      TRANSACAO,
    tfacr201.t$ninv                               TITULO,
    tfacr201.t$schn                               PARCELA,
    znsls412.t$pecl$c                             PEDIDO,
    tfacr201.t$docd                               DT_EMISSAO,
    tfacr201.t$recd                               DT_VENCIMENTO,
    CASE WHEN tfacr201.t$balc = 0 
           THEN ( SELECT MAX(p.t$docd) 
                    FROM baandb.ttfacr200301 p
                   WHERE p.t$ttyp = tfacr200.t$ttyp 
                     AND p.t$ninv = tfacr200.t$ninv ) 
         ELSE NULL 
     END                                          DT_LIQUID,
    cisli940.t$fire$l                             DOC_FISCAL,
    cisli940.t$docn$l                             NF,
    cisli940.t$seri$l                             SERIE,
    tfacr201.t$rpst$l                             SITUACAO_TITULO,
 
    ( SELECT l.t$desc
        FROM baandb.tttadv401000 d,
             baandb.tttadv140000 l
       WHERE d.t$cpac = 'tf'
         AND d.t$cdom = 'acr.strp.l'
         AND l.t$clan = 'p'
         AND l.t$cpac = 'tf'
         AND l.t$clab = d.t$za_clab
         AND rpad(d.t$vers,4) || 
             rpad(d.t$rele,2) || 
             rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv401000 l1 
                                   where l1.t$cpac = d.t$cpac 
                                     and l1.t$cdom = d.t$cdom )
         AND rpad(l.t$vers,4) || 
             rpad(l.t$rele,2) || 
             rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                             rpad(l1.t$rele,2) || 
                                             rpad(l1.t$cust,4) ) 
                                    from baandb.tttadv140000 l1 
                                   where l1.t$clab = l.t$clab 
                                     and l1.t$clan = l.t$clan 
                                     and l1.t$cpac = l.t$cpac )
         AND d.t$cnst = tfacr201.t$rpst$l 
         AND rownum = 1)                          DESCR_SIT_TIT,
   
    tfacr201.t$amnt                               VALOR_TITULO,
    tfacr201.t$balc                               SALDO_TITULO,
    tfacr201.t$brel                               REL_BANCARIA,
    NVL(TRIM(tfacr201.t$paym), 'N/A')             METODO_REC,
    tfcmg948.t$banu$l                             NOSSO_NUMERO,
    znsls400.t$idca$c                             CANAL_VENDAS,
    znsls402.t$idmp$c                             MEIO_PAGAMENTO,
  
    ( select zncmg007.t$desc$c 
        from baandb.tzncmg007301 zncmg007
       where zncmg007.t$mpgt$c = znsls402.t$idmp$c )  
                                                  DESCR_MEIO_PGTO, 
    znsls401.t$orno$c                             ORDEM_VENDAS
 
FROM      baandb.ttccom100301 tccom100

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr
        
INNER JOIN baandb.ttfacr200301 tfacr200
        ON tccom100.t$bpid   = tfacr200.t$itbp 
       AND tfacr200.t$lino   = 0          

INNER JOIN baandb.ttfacr201301 tfacr201
        ON tfacr201.t$ttyp   = tfacr200.t$ttyp 
       AND tfacr201.t$ninv   = tfacr200.t$ninv

 LEFT JOIN baandb.ttfcmg948301 tfcmg948
        ON tfcmg948.t$ttyp$l = tfacr200.t$ttyp 
       AND tfcmg948.t$ninv$l = tfacr200.t$ninv 
     
 LEFT JOIN baandb.tznsls412301 znsls412
        ON znsls412.t$ttyp$c = tfacr200.t$ttyp 
       AND znsls412.t$ninv$c = tfacr200.t$ninv 
     
 LEFT JOIN baandb.tznint002301 znint002
        ON znint002.t$uneg$c = znsls412.t$uneg$c
     
 LEFT JOIN baandb.tcisli940301 cisli940
        ON cisli940.t$ityp$l = tfacr200.t$ttyp
       AND cisli940.t$idoc$l = tfacr200.t$ninv
       AND cisli940.t$docn$l = tfacr200.t$docn$l
     
 LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls412.t$ncia$c = znsls400.t$ncia$c
       AND znsls412.t$uneg$c = znsls400.t$uneg$c
       AND znsls412.t$pecl$c = znsls400.t$pecl$c
       AND znsls412.t$sqpd$c = znsls400.t$sqpd$c
     
 LEFT JOIN baandb.tznsls401301 znsls401
        ON znsls412.t$ncia$c = znsls401.t$ncia$c
       AND znsls412.t$uneg$c = znsls401.t$uneg$c
       AND znsls412.t$pecl$c = znsls401.t$pecl$c
       AND znsls412.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls412.t$entr$c = znsls401.t$entr$c
       AND znsls412.t$sequ$c = znsls401.t$sequ$c
     
 LEFT JOIN baandb.tznsls402301 znsls402
        ON znsls412.t$ncia$c = znsls402.t$ncia$c
       AND znsls412.t$uneg$c = znsls402.t$uneg$c
       AND znsls412.t$pecl$c = znsls402.t$pecl$c
       AND znsls412.t$sqpd$c = znsls402.t$sqpd$c
    
WHERE tfacr201.t$docd Between :DataEmissaoDe AND :DataEmissaoAte
  AND tfacr201.t$recd Between :DataVenctoDe AND :DataVenctoAte
  AND NVL(znsls412.t$uneg$c, 0) IN (:UniNegocio)
  AND ((:PN = '000') or (tfacr200.t$itbp = :PN))
  AND tfacr201.t$rpst$l IN (:Situacao)
  AND NVL(znsls402.t$idmp$c, 0) IN (:MeioPagto)
  AND NVL(znsls400.t$idca$c, 'XXX') IN (:CanalVendas)
  AND CASE WHEN NVL( ( select c.t$styp 
                         from baandb.tcisli205301 c
                        where c.t$styp = 'BL ATC'
                          AND c.t$ityp = tfacr200.t$ttyp
                          AND c.t$idoc = tfacr200.t$ninv
                          AND rownum = 1 ), 0 ) = 0 
             THEN 2 
           ELSE   3 
       END IN (:Filial)
  AND ((:CNPJ is null) or (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') = :CNPJ))