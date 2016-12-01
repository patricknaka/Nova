SELECT
  DISTINCT
    znsls004.t$ncia$c            CIA,
    znsls004.t$uneg$c            UNID_NEGOCIO,
    znsls004.t$pecl$c            PEDIDO,
    znsls004.t$sqpd$c            SEQ_PEDIDO,
    znsls004.t$entr$c            ENTREGA,
    cisli245.t$slso              ORDEM,
    znsls004.t$orig$c            ORIGEM,
    ORIGEM.                      DESCR_ORIGEM,
    cisli940.t$amnt$l            VALOR_TOT_NF,
    cisli940.t$stat$l            ID_STATUS_NF,
    SITUACAO_NF.DESCR_NF         DESCR_STATUS_NF,
    cisli940.t$ityp$l            TIPO_DE_TRANSACAO,
    cisli940.t$idoc$l            DOC_LIGADO_TRANSACAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                 DATA_EMISSAO_NF,

    cisli940.t$fire$l            REF_FISCAL_NF,
    DOC_FISCAL.DESCR_DOC_FISCAL  TIPO_NF,
   
    (select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') THEN NULL
                 ELSE t.t$dcdt END AS t$dcdt
       from baandb.ttfgld018301 t
      where t.t$ttyp = cisli940.t$ityp$l
        and t.t$docn = cisli940.t$idoc$l
        and t.t$docn!= 0)
                                 DATA_DOC_LIGADO_TRANSACAO
 
FROM      baandb.tcisli940301 cisli940

LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$fire$l = cisli940.t$fire$l
 
LEFT JOIN (select r.t$ncia$c, 
                  r.t$uneg$c,
                  r.t$pecl$c,
                  r.t$sqpd$c,
                  r.t$entr$c,
                  r.t$sequ$c,
                  r.t$orno$c,
                  r.t$pono$c,
                  r.t$orig$c
             from baandb.tznsls004301 r
            where r.t$entr$c = (SELECT r0.t$entr$c 
                                  FROM baandb.tznsls004301 r0
                                 WHERE r0.t$orno$c = r.t$orno$c
                                   AND ROWNUM = 1
                                   AND r0.t$date$c = (select max(r1.t$date$c)
                                                        from baandb.tznsls004301 r1
                                                       where r1.t$orno$c = r0.t$orno$c))) znsls004
       ON znsls004.t$orno$c = cisli245.t$slso
   
LEFT JOIN (select l.t$desc DESCR_ORIGEM,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'zn'
              and d.t$cdom = 'sls.orig.c'
              and l.t$clan = 'p'
              and l.t$cpac = 'zn'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) ORIGEM
       ON ORIGEM.t$cnst = znsls004.t$orig$c
  
LEFT JOIN (select l.t$desc DESCR_NF,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.stat'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) SITUACAO_NF
       ON SITUACAO_NF.t$cnst = cisli940.t$stat$l
  
LEFT JOIN (select l.t$desc DESCR_DOC_FISCAL,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.tdff.l'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) DOC_FISCAL
       ON DOC_FISCAL.t$cnst = cisli940.t$fdty$l
    
WHERE cisli940.t$stat$l = 6  --Lancado
  AND TRUNC((select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') 
                           THEN NULL
                         ELSE   t.t$dcdt 
                    END AS t$dcdt
               from baandb.ttfgld018301 t
              where t.t$ttyp = cisli940.t$ityp$l
                and t.t$docn = cisli940.t$idoc$l
                and t.t$docn!= 0)) 
      BETWEEN :DataDocLigadoTransacaoDe 
          AND :DataDocLigadoTransacaoAte
--  AND cisli940.t$ityp$l IN ('DEV', 'FAT', 'RB3', 'RBN', 'RPV', 'RWC', 'NCV', 'RWA')
  AND cisli940.t$ityp$l in (:TipoTransacao)
  AND cisli940.t$styp$l in (:TipoVenda)

--**************************************************************

UNION

SELECT
  DISTINCT
    znsls004.t$ncia$c            CIA,
    znsls004.t$uneg$c            UNID_NEGOCIO,
    znsls004.t$pecl$c            PEDIDO,
    znsls004.t$sqpd$c            SEQ_PEDIDO,
    znsls004.t$entr$c            ENTREGA,
    cisli245.t$slso              ORDEM,
    znsls004.t$orig$c            ORIGEM,
    ORIGEM.                      DESCR_ORIGEM,
    cisli940.t$amnt$l            VALOR_TOT_NF,
    cisli940.t$stat$l            ID_STATUS_NF,
    SITUACAO_NF.DESCR_NF         DESCR_STATUS_NF, 
    cisli940.t$ityp$l            TIPO_DE_TRANSACAO,
    cisli940.t$idoc$l            DOC_LIGADO_TRANSACAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 'DD-MON-YYYY HH24:MI:SS'), 
     'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                 DATA_EMISSAO_NF,
                                 
    cisli940.t$fire$l            REF_FISCAL_NF,
    DOC_FISCAL.DESCR_DOC_FISCAL  TIPO_NF,
   
    (select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') THEN NULL
                 ELSE t.t$dcdt END AS t$dcdt
       from baandb.ttfgld018301 t
      where t.t$ttyp = cisli940.t$ityp$l
        and t.t$docn = cisli940.t$idoc$l
        and t.t$docn!= 0)
                                 DATA_DOC_LIGADO_TRANSACAO
 
FROM      baandb.tcisli940301 cisli940

LEFT JOIN baandb.tcisli245301 cisli245
       ON cisli245.t$slcp = cisli940.t$sfcp$l
      AND cisli245.t$ityp = cisli940.t$ityp$l
      AND cisli245.t$idoc = cisli940.t$idoc$l

LEFT JOIN (select r.t$ncia$c,
                  r.t$uneg$c,
                  r.t$pecl$c,
                  r.t$sqpd$c,
                  r.t$entr$c,
                  r.t$sequ$c,
                  r.t$orno$c,
                  r.t$pono$c,
                  r.t$orig$c
             from baandb.tznsls004301 r
            where r.t$entr$c = (SELECT r0.t$entr$c
                                  FROM baandb.tznsls004301 r0
                                 WHERE r0.t$orno$c = r.t$orno$c
                                   AND ROWNUM = 1
                                   AND r0.t$date$c = (select max(r1.t$date$c)
                                                        from baandb.tznsls004301 r1
                                                       where r1.t$orno$c = r0.t$orno$c))) znsls004
       ON znsls004.t$orno$c = cisli245.t$slso
   
LEFT JOIN (select l.t$desc DESCR_ORIGEM,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'zn'
              and d.t$cdom = 'sls.orig.c'
              and l.t$clan = 'p'
              and l.t$cpac = 'zn'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan 
                                          AND l1.t$cpac = l.t$cpac)) ORIGEM
       ON ORIGEM.t$cnst = znsls004.t$orig$c
  
LEFT JOIN (select l.t$desc DESCR_NF,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.stat'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) SITUACAO_NF
       ON SITUACAO_NF.t$cnst = cisli940.t$stat$l
  
LEFT JOIN (select l.t$desc DESCR_DOC_FISCAL,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'ci'
              and d.t$cdom = 'sli.tdff.l'
              and l.t$clan = 'p'
              and l.t$cpac = 'ci'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) || 
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) DOC_FISCAL
       ON DOC_FISCAL.t$cnst = cisli940.t$fdty$l
    
WHERE cisli940.t$stat$l = 101  --Estornado
  AND TRUNC((select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') 
                           THEN NULL
                         ELSE   t.t$dcdt 
                    END AS t$dcdt
               from baandb.ttfgld018301 t
              where t.t$ttyp = cisli940.t$ityp$l
                and t.t$docn = cisli940.t$idoc$l
                and t.t$docn!= 0)) 
      BETWEEN :DataDocLigadoTransacaoDe 
          AND :DataDocLigadoTransacaoAte
--AND cisli940.t$ityp$l IN ('DEV', 'FAT', 'RB3', 'RBN', 'RPV', 'RWC', 'NCV', 'RWA')
AND cisli940.t$ityp$l in (:TipoTransacao)
AND cisli940.t$styp$l in (:TipoVenda)
--*************************************************************
-- tdrec940
--**************************************************************
UNION

SELECT 
  DISTINCT
   znsls004.t$ncia$c            CIA,
   znsls004.t$uneg$c            UNID_NEGOCIO,
   znsls004.t$pecl$c            PEDIDO,
   znsls004.t$sqpd$c            SEQ_PEDIDO,
   znsls004.t$entr$c            ENTREGA,
   tdrec947.t$orno$l            ORDEM,
   znsls004.t$orig$c            ORIGEM,
   ORIGEM.                      DESCR_ORIGEM,
   tdrec940.t$tfda$l            VALOR_TOT_NF,
   tdrec940.t$stat$l            ID_STATUS_NF,
   SITUACAO_NF.DESCR_NF         DESCR_STATUS_NF,
   tdrec940.t$ttyp$l            TIPO_DE_TRANSACAO,
   tdrec940.t$invn$l            DOC_LIGADO_TRANSACAO,
   
   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 'DD-MON-YYYY HH24:MI:SS'), 
    'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                                DATA_EMISSAO_NF,
                                
   tdrec940.t$fire$l            REF_FISCAL_NF,
   DOC_FISCAL.DESCR_DOC_FISCAL  TIPO_NF,
  
   (select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') THEN NULL
                ELSE t.t$dcdt END AS t$dcdt 
      from baandb.ttfgld018301 t
     where t.t$ttyp = tdrec940.t$ttyp$l
       and t.t$docn = tdrec940.t$invn$l
       and t.t$docn!= 0)
                                DATA_DOC_LIGADO_TRANSACAO

FROM  baandb.ttdrec940301 tdrec940
 
LEFT JOIN baandb.ttdrec947301 tdrec947
       ON tdrec947.t$fire$l = tdrec940.t$fire$l

LEFT JOIN ( select r.t$ncia$c, 
                   r.t$uneg$c,
                   r.t$pecl$c,
                   r.t$sqpd$c,
                   r.t$entr$c,
                   r.t$sequ$c,
                   r.t$orno$c,
                   r.t$pono$c,
                   r.t$orig$c
              from baandb.tznsls004301 r
             where r.t$entr$c = ( SELECT r0.t$entr$c 
                                    FROM baandb.tznsls004301 r0
                                   WHERE r0.t$orno$c = r.t$orno$c
                                     AND ROWNUM = 1
                                     AND r0.t$date$c = ( select max(r1.t$date$c)
                                                           from baandb.tznsls004301 r1
                                                          where r1.t$orno$c = r0.t$orno$c ) )) znsls004
       ON znsls004.t$orno$c = tdrec947.t$orno$l
    
LEFT JOIN (select l.t$desc DESCR_ORIGEM,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'zn'
              and d.t$cdom = 'sls.orig.c'
              and l.t$clan = 'p'
              and l.t$cpac = 'zn'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) ORIGEM
       ON ORIGEM.t$cnst = znsls004.t$orig$c

LEFT JOIN (select l.t$desc DESCR_NF,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'td'
              and d.t$cdom = 'rec.stat.l'
              and l.t$clan = 'p'
              and l.t$cpac = 'td'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv140000 l1
                                        WHERE l1.t$clab = l.t$clab
                                          AND l1.t$clan = l.t$clan
                                          AND l1.t$cpac = l.t$cpac)) SITUACAO_NF
       ON SITUACAO_NF.t$cnst = tdrec940.t$stat$l
    
LEFT JOIN (select l.t$desc DESCR_DOC_FISCAL,
                  d.t$cnst
             from baandb.tttadv401000 d,
                  baandb.tttadv140000 l
            where d.t$cpac = 'td'
              and d.t$cdom = 'rec.trfd.l'
              and l.t$clan = 'p'
              and l.t$cpac = 'td'
              and l.t$clab = d.t$za_clab
              and rpad(d.t$vers,4) ||
                  rpad(d.t$rele,2) ||
                  rpad(d.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) ||
                                                  rpad(l1.t$cust,4) )
                                         FROM baandb.tttadv401000 l1
                                        WHERE l1.t$cpac = d.t$cpac
                                          AND l1.t$cdom = d.t$cdom )
              and rpad(l.t$vers,4) ||
                  rpad(l.t$rele,2) ||
                  rpad(l.t$cust,4) = ( SELECT MAX(rpad(l1.t$vers,4) ||
                                                  rpad(l1.t$rele,2) || 
                                                  rpad(l1.t$cust,4) ) 
                                         FROM baandb.tttadv140000 l1 
                                        WHERE l1.t$clab = l.t$clab 
                                          AND l1.t$clan = l.t$clan 
                                          AND l1.t$cpac = l.t$cpac)) DOC_FISCAL
       ON DOC_FISCAL.t$cnst = tdrec940.t$rfdt$l 
 
WHERE tdrec940.t$rfdt$l = 10      --retorno de mercadoria
  AND tdrec940.t$stat$l IN (4,5)  --aprovado, aprovado com problemas
  AND TRUNC((select CASE WHEN t.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') 
                           THEN NULL
                         ELSE   t.t$dcdt 
                    END AS t$dcdt
               from baandb.ttfgld018301 t
              where t.t$ttyp = tdrec940.t$ttyp$l
                and t.t$docn = tdrec940.t$invn$l
                and t.t$docn!= 0)) 
      BETWEEN :DataDocLigadoTransacaoDe 
          AND :DataDocLigadoTransacaoAte
--AND tdrec940.t$ttyp$l IN ('DEV', 'FAT', 'RB3', 'RBN', 'RPV', 'RWC', 'NCV', 'RWA')
AND tdrec940.t$ttyp$l in (:TipoTransacao)
AND tdrec940.t$styp$l in (:TipoVenda)
