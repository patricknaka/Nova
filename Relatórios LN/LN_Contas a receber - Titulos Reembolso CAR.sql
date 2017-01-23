SELECT 
  DISTINCT 
    NVL(znsls412.t$uneg$c,znsls412rem.t$uneg$c)      UNID_NEGOCIO,
    NVL(znint002.t$desc$c,znint002rem.t$desc$c)      NM_UNID_NEGOCIO,
    tfacr200.t$itbp                                  COD_PN,
    regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')
                                                      CNPJ,
    tccom100.t$nama                                   PN,
     
    CASE WHEN NVL( ( select c.t$styp 
                       from baandb.tcisli205301 c
                      where c.t$styp = 'BL ATC'
                        AND c.t$ityp = tfacr200.t$ttyp
                        AND c.t$idoc = tfacr200.t$ninv
                        AND rownum = 1 ), '0' ) = '0' 
           THEN 'Varejo' 
         ELSE   'Atacado' 
     END                                          FILIAL,

    Concat(tfacr201.t$ttyp, tfacr201.t$ninv)      TRANSACAO,
    tfacr201.t$ninv                               TITULO,
    tfacr201.t$schn                               PARCELA,
    NVL(znsls412.t$pecl$c,znsls412rem.t$pecl$c)   PEDIDO,
    NVL(znsls401.t$entr$c,znsls401rem.t$entr$c)   ENTREGA,
    NVL(znsls410.t$poco$c,znsls410rem.t$poco$c)   STATUS_ENTREGA,
    NVL(znmcs002.t$desc$c,znmcs002rem.t$desc$c)   DESCRICAO,
    tfacr201.t$docd                               DT_EMISSAO,
    tfacr201.t$recd                               DT_VENCIMENTO,

    CASE WHEN tfacr201.t$rpst$l IN (3,4) THEN  --PARCIALMENTE PAGO 0U PAGO
      CASE WHEN tfacr201.t$balc = 0 
             THEN ( SELECT MAX(p.t$docd) 
                      FROM baandb.ttfacr200301 p
                     WHERE p.t$ttyp = tfacr200.t$ttyp 
                       AND p.t$ninv = tfacr200.t$ninv
                       AND p.t$line = tfacr200.t$line
                       AND p.t$tdoc != ' '
                       AND p.t$docn != 0
                       AND p.t$lino != 0 ) 
             ELSE ( SELECT MAX(p.t$docd) 
                      FROM baandb.ttfacr200301 p
                     WHERE p.t$ttyp = tfacr200.t$ttyp 
                       AND p.t$ninv = tfacr200.t$ninv
                       AND p.t$line = tfacr200.t$line
                       AND p.t$tdoc != ' '
                       AND p.t$docn != 0
                       AND p.t$lino != 0 ) END
       ELSE NULL END                              DT_LIQUID,

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
    --tfacr200.t$amti                               SALDO_TITULO,
    tfacr201.t$brel                               REL_BANCARIA,
    NVL(TRIM(tfacr201.t$paym), 'N/A')             METODO_REC,
    tfcmg948.t$banu$l                             NOSSO_NUMERO,
    NVL(znsls400.t$idca$c,znsls400rem.t$idca$c)   CANAL_VENDAS,
    NVL(znsls402.t$idmp$c,znsls402rem.t$idmp$c)   MEIO_PAGAMENTO,
    NVL(zncmg007.t$desc$c,zncmg007rem.t$desc$c)   DESCR_MEIO_PGTO, 
    NVL(znsls401.t$orno$c,znsls401rem.t$orno$c)   ORDEM_VENDAS,
    NVL(DEV.DOCTO_TRANSACAO_DEV ||
    DEV.TITULO_DEV,' ')                           TITULO_DEV,
    NVL(DEV.VL_TITULO_DEV,0)                      VL_TITULO_DEV,
    tfacr200.t$docd                               DATA_DE_EMISSÃO_DEV,
    status.DESC_STATUS                            STATUS_DEV,
    NVL(TITULO_CAP.TITULO,NVL(TITULO_CAP_rem.TITULO,' '))             TITULO_CAP,
    NVL(TITULO_CAP.t$amnt,NVL(TITULO_CAP_rem.t$amnt,0))               VL_TITULO_CAP,
    NVL(TITULO_CAP.t$pyst$l,NVL(TITULO_CAP_rem.t$pyst$l,0))           STATUS_TITULO_CAP,
    
    nvl(    ( SELECT l.t$desc
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
         AND d.t$cnst = NVL(TITULO_CAP.t$pyst$l,TITULO_CAP_rem.t$pyst$l)
         AND rownum = 1) , ' ')                         DESCR_SIT_TIT_CAP

FROM      baandb.ttccom100301 tccom100

INNER JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr   = tccom100.t$cadr
        
INNER JOIN baandb.ttfacr200301 tfacr200
        ON tccom100.t$bpid   = tfacr200.t$itbp 
       AND tfacr200.t$lino   = 0          

INNER JOIN baandb.ttfacr201301 tfacr201
        ON tfacr201.t$ttyp   = tfacr200.t$ttyp 
       AND tfacr201.t$ninv   = tfacr200.t$ninv

 left JOIN baandb.ttfcmg948301 tfcmg948
        ON tfcmg948.t$ttyp$l = tfacr201.t$ttyp 
       AND tfcmg948.t$ninv$l = tfacr201.t$ninv 
       AND to_char(tfcmg948.t$sern$l) = to_char(tfacr201.t$schn)
 
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
       
 left JOIN baandb.tznsls402301 znsls402
        ON znsls401.t$ncia$c = znsls402.t$ncia$c
       AND znsls401.t$uneg$c = znsls402.t$uneg$c
       AND znsls401.t$pecl$c = znsls402.t$pecl$c
       AND znsls401.t$sqpd$c = znsls402.t$sqpd$c
       and znsls412.t$sequ$c = znsls402.t$sequ$c

 LEFT JOIN baandb.tzncmg007301 zncmg007
         ON zncmg007.t$mpgt$c = znsls402.t$idmp$c  

LEFT JOIN (select distinct 
              znsls412.t$ncia$c,
              znsls412.t$uneg$c,
              znsls412.t$pecl$c, 
              znsls412.t$sqpd$c,
              znsls412.t$sequ$c,
              znsls412.t$ttyp$c, 
              znsls412.t$ninv$c,
              Concat(tfacp200.t$ttyp, tfacp200.t$ninv) TITULO,
              tfacp200.t$amnt,
              tfacp201.t$pyst$l
              
          from baandb.tznsls402301 znsls402
          inner join baandb.tzncmg007301 zncmg007
          on zncmg007.t$mpgt$c = znsls402.t$idmp$c
          and zncmg007.t$ctmp$c in (5,6)
          
          inner join baandb.tznsls412301 znsls412
          on znsls412.t$ncia$c = znsls402.t$ncia$c
          and znsls412.t$uneg$c = znsls402.t$uneg$c
          and znsls412.t$pecl$c = znsls402.t$pecl$c
          and znsls412.t$sqpd$c = znsls402.t$sqpd$c
          
          inner join baandb.ttfacp200301 tfacp200
          on tfacp200.t$ttyp = znsls412.t$ttyp$c
          and tfacp200.t$ninv = znsls412.t$ninv$c

          inner join baandb.ttfacp201301 tfacp201
          on tfacp201.t$ttyp = tfacp200.t$ttyp
          and tfacp201.t$ninv = tfacp200.t$ninv

          where znsls402.t$vlmr$c < 0 
          and znsls412.t$ttyp$c = 'PRB'
          and tfacp200.t$amnt > 0) TITULO_CAP

        ON TITULO_CAP.t$ncia$c = znsls402.t$ncia$c 
       AND TITULO_CAP.t$uneg$c = znsls402.t$uneg$c
       AND TITULO_CAP.t$pecl$c = znsls402.t$pecl$c
       --AND TITULO_CAP.t$sequ$c = znsls402.t$sequ$c
       AND znsls400.t$sqpd$c = 1
          
 inner join (SELECT 
                tfacr200d.t$ttyp            DOCTO_TRANSACAO_DEV,
                tfacr200d.t$ninv            TITULO_DEV,
                tfacr200d.t$docn$l || 
                tfacr200d.t$seri$l          DOCTO_DEV,
                CISLI940_DEV.t$fire$l       REF_FISCAL_DEV,
                tfacr200d.t$amnt            VL_TITULO_DEV,
                CISLI941_DEV.T$REFR$L       REF_FISCAL_RELATIVA,
                CISLI940_FAT.T$ityp$l       TRANSACAO_FAT,
                CISLI940_FAT.T$idoc$l       DOCUMENTO_FAT,
                tfacr201.t$rpst$l           STATUS_DEV
            
            from BAANDB.ttfacr200301 tfacr200d
            
            LEFT JOIN BAANDB.TCISLI940301 CISLI940_DEV
                  on CISLI940_DEV.T$DOCN$L = tfacr200d.t$docn$l
                  AND CISLI940_DEV.T$SERI$L = tfacr200d.t$seri$l
            
            LEFT JOIN BAANDB.TCISLI941301 CISLI941_DEV
                   ON CISLI941_DEV.T$FIRE$L = CISLI940_DEV.T$FIRE$L
                   
            LEFT JOIN BAANDB.TCISLI940301 CISLI940_FAT
                  on CISLI940_FAT.T$FIRE$L = CISLI941_DEV.t$REFR$l
            
            left JOIN baandb.ttfacr201301 tfacr201
                   ON tfacr201.t$ttyp   = tfacr200d.t$ttyp 
                  AND tfacr201.t$ninv   = tfacr200d.t$ninv
                        
            where tfacr200d.t$ttyp = 'DEV') DEV
            
    ON DEV.TRANSACAO_FAT = tfacr200.t$ttyp
   AND DEV.DOCUMENTO_FAT = tfacr200.t$ninv

LEFT JOIN ( select distinct
                    iDOMAIN.t$cnst CODE_STATUS, 
                    iLABEL.t$desc  DESC_STATUS
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'acr.strp.l'
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
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) Status
        ON DEV.STATUS_DEV = Status.CODE_STATUS
        
LEFT JOIN ( select znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$sqpd$c,
                   znsls410int.t$entr$c,
                   max(znsls410int.t$dtoc$c) t$dtoc$c,
                   MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  znsls410int.T$SEQN$C)t$poco$c
              from baandb.tznsls410301 znsls410int
          group by znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$sqpd$c,
                   znsls410int.t$entr$c ) znsls410
          ON znsls410.t$ncia$c = znsls401.t$ncia$c
         AND znsls410.t$uneg$c = znsls401.t$uneg$c
         AND znsls410.t$pecl$c = znsls401.t$pecl$c
         AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
         AND znsls410.t$entr$c = znsls401.t$entr$c

LEFT JOIN baandb.tznmcs002301 znmcs002
       ON znmcs002.t$poco$c = znsls410.t$poco$c

-- Operacao Triangular

 LEFT JOIN ( select a.t$fire$l,
                    a.t$refr$l,
                    min(t$line$l)
             from   baandb.tcisli941301 a
             group by a.t$fire$l,
                      a.t$refr$l ) cisli941
        ON cisli941.t$fire$l = cisli940.t$fire$l
        
 LEFT JOIN baandb.tcisli940301 cisli940rem      --nota de remessa operação triangular
        ON cisli940rem.t$fire$l = cisli941.t$refr$l

 LEFT JOIN baandb.tznsls412301 znsls412rem
        ON znsls412rem.t$ttyp$c = cisli940rem.t$ityp$l 
       AND znsls412rem.t$ninv$c = cisli940rem.t$idoc$l 
     
 LEFT JOIN baandb.tznint002301 znint002rem
        ON znint002rem.t$uneg$c = znsls412rem.t$uneg$c

 LEFT JOIN baandb.tznsls400301 znsls400rem
        ON znsls400rem.t$ncia$c = znsls412rem.t$ncia$c
       AND znsls400rem.t$uneg$c = znsls412rem.t$uneg$c
       AND znsls400rem.t$pecl$c = znsls412rem.t$pecl$c 
       AND znsls400rem.t$sqpd$c = znsls412rem.t$sqpd$c 
     
 LEFT JOIN baandb.tznsls401301 znsls401rem
        ON znsls401rem.t$ncia$c = znsls412rem.t$ncia$c
       AND znsls401rem.t$uneg$c = znsls412rem.t$uneg$c
       AND znsls401rem.t$pecl$c = znsls412rem.t$pecl$c
       AND znsls401rem.t$sqpd$c = znsls412rem.t$sqpd$c
       AND znsls401rem.t$entr$c = znsls412rem.t$entr$c
       AND znsls401rem.t$sequ$c = znsls412rem.t$sequ$c
       
 left JOIN baandb.tznsls402301 znsls402rem
        ON znsls402rem.t$ncia$c = znsls401rem.t$ncia$c
       AND znsls402rem.t$uneg$c = znsls401rem.t$uneg$c
       AND znsls402rem.t$pecl$c = znsls401rem.t$pecl$c
       AND znsls402rem.t$sqpd$c = znsls401rem.t$sqpd$c
       and znsls402rem.t$sequ$c = znsls412rem.t$sequ$c

 LEFT JOIN baandb.tzncmg007301 zncmg007rem
         ON zncmg007rem.t$mpgt$c = znsls402rem.t$idmp$c  

LEFT JOIN (select distinct 
              znsls412.t$ncia$c,
              znsls412.t$uneg$c,
              znsls412.t$pecl$c, 
              znsls412.t$sqpd$c,
              znsls412.t$sequ$c,
              znsls412.t$ttyp$c, 
              znsls412.t$ninv$c,
              Concat(tfacp200.t$ttyp, tfacp200.t$ninv) TITULO,
              tfacp200.t$amnt,
              tfacp201.t$pyst$l
              
          from baandb.tznsls402301 znsls402
          inner join baandb.tzncmg007301 zncmg007
          on zncmg007.t$mpgt$c = znsls402.t$idmp$c
          and zncmg007.t$ctmp$c in (5,6)
          
          inner join baandb.tznsls412301 znsls412
          on znsls412.t$ncia$c = znsls402.t$ncia$c
          and znsls412.t$uneg$c = znsls402.t$uneg$c
          and znsls412.t$pecl$c = znsls402.t$pecl$c
          and znsls412.t$sqpd$c = znsls402.t$sqpd$c
          
          inner join baandb.ttfacp200301 tfacp200
          on tfacp200.t$ttyp = znsls412.t$ttyp$c
          and tfacp200.t$ninv = znsls412.t$ninv$c

          inner join baandb.ttfacp201301 tfacp201
          on tfacp201.t$ttyp = tfacp200.t$ttyp
          and tfacp201.t$ninv = tfacp200.t$ninv

          where znsls402.t$vlmr$c < 0 
          and znsls412.t$ttyp$c = 'PRB'
          and tfacp200.t$amnt > 0) TITULO_CAP_rem

        ON TITULO_CAP_rem.t$ncia$c = znsls402rem.t$ncia$c 
       AND TITULO_CAP_rem.t$uneg$c = znsls402rem.t$uneg$c
       AND TITULO_CAP_rem.t$pecl$c = znsls402rem.t$pecl$c
       AND znsls400rem.t$sqpd$c = 1

LEFT JOIN ( select znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$sqpd$c,
                   znsls410int.t$entr$c,
                   max(znsls410int.t$dtoc$c) t$dtoc$c,
                   MAX(znsls410int.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410int.T$DTOC$C,  znsls410int.T$SEQN$C)t$poco$c
              from baandb.tznsls410301 znsls410int
          group by znsls410int.t$ncia$c,      
                   znsls410int.t$uneg$c,
                   znsls410int.t$pecl$c,
                   znsls410int.t$sqpd$c,
                   znsls410int.t$entr$c ) znsls410rem
          ON znsls410rem.t$ncia$c = znsls401rem.t$ncia$c
         AND znsls410rem.t$uneg$c = znsls401rem.t$uneg$c
         AND znsls410rem.t$pecl$c = znsls401rem.t$pecl$c
         AND znsls410rem.t$sqpd$c = znsls401rem.t$sqpd$c
         AND znsls410rem.t$entr$c = znsls401rem.t$entr$c

LEFT JOIN baandb.tznmcs002301 znmcs002rem
       ON znmcs002rem.t$poco$c = znsls410rem.t$poco$c

WHERE tfacr200.t$docd Between :DataEmissaoDe AND :DataEmissaoAte
  AND tfacr201.t$recd Between :DataVenctoDe AND :DataVenctoAte
  AND NVL(znsls412.t$uneg$c, NVL(znsls412rem.t$uneg$c,0)) IN (:UniNegocio)
  AND ((:PN = '000') or (tfacr200.t$itbp = :PN))  
  AND tfacr201.t$rpst$l IN (:Situacao)
  AND NVL(znsls402.t$idmp$c, NVL(znsls402rem.t$idmp$c,0)) IN (:MeioPagto)
  AND NVL(znsls400.t$idca$c, NVL(znsls400rem.t$idca$c,'XXX')) IN (:CanalVendas)
  AND CASE WHEN NVL( ( select c.t$styp 
                         from baandb.tcisli205301 c
                        where c.t$styp = 'BL ATC'
                          AND c.t$ityp = tfacr200.t$ttyp
                          AND c.t$idoc = tfacr200.t$ninv
                          AND rownum = 1 ), '0' ) = '0' 
             THEN 2 
           ELSE   3 
       END IN (:Filial)
  AND ((:CNPJ is null) or (regexp_replace(tccom130.t$fovn$l, '[^0-9]', '') = :CNPJ))
