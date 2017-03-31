SELECT
    301                                               CIA,
    ZNFMD001_ORG.T$FILI$C                             FILIAL_VENDA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDSLS400.T$ODAT, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)    DT_ORDEM,
    
    TDSLS400.T$ORNO                                   ORDEM_DEVOLUCAO,
    TDSLS400.T$SOTP                                   TIPO_ORDEM,
    TDSLS094.T$DSCA                                   DESCR_ORDEM,
    D_HDST.DSC                                        STATUS_ORDEM,
    znsls400.t$sige$c SIG,
    znmcs095.t$docn$c SIGE,
    CISLI940_ORG.T$DOCN$L LN,
    CASE WHEN znsls400.t$sige$c = 1 and znmcs095.t$docn$c is not null
      THEN
            znmcs095.t$docn$c
      WHEN znsls400.t$sige$c = 1 AND znmcs095.t$docn$c is null 
      then  CISLI940_ORG.T$DOCN$L  
      ELSE CISLI940_ORG.T$DOCN$L 
      END                                               NF_VENDA,
    CASE WHEN znsls400.t$sige$c = 1 and znmcs095.t$seri$c is not null 
      THEN
           znmcs095.t$seri$c
      WHEN
           znsls400.t$sige$c = 1 AND znmcs095.t$seri$c is null 
      THEN
           CISLI940_ORG.T$SERI$L
         ELSE CISLI940_ORG.T$SERI$L
    END                                               SERIE_VENDA,
    
znmcs095.t$trdt$C,
CISLI940_ORG.T$DATE$L,
      CASE WHEN znsls400.t$sige$c = 1 AND znmcs095.t$docn$c is not null 
      then  znmcs095.t$trdt$C  
      WHEN znsls400.t$sige$c = 1 AND znmcs095.t$trdt$C is not null  
      then
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940_ORG.T$DATE$L, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                    AT time zone 'America/Sao_Paulo') AS DATE)
         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940_ORG.T$DATE$L, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                    AT time zone 'America/Sao_Paulo') AS DATE)    
    END                                               DT_EMISS_VENDA,
    TCCOM130C.T$FOVN$L                                CPF_CNPJ,
    TCCOM130C.T$NAMA                                  NOME_PARCEIRO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
        AT time zone 'America/Sao_Paulo') AS DATE)    DT_EMISSAO_DEV,

    ZNFMD001.T$FILI$C                                 FILIAL_DEVOLUCAO,
    CASE WHEN cisli940.t$docn$l IS NULL 
           THEN tdrec940_rec.t$docn$l
         ELSE   CISLI940.T$DOCN$L 
    END                                               NFD,
    CASE WHEN cisli940.t$seri$l IS NULL 
           THEN tdrec940_rec.t$seri$l
         ELSE   CISLI940.T$SERI$L                                                                
    END                                               SERIE_ND,
      D_STAT.DSC                                      STATUS_NFD,
    CASE WHEN tdrec940.t$fire$l IS NULL 
           THEN tdrec940_rec.t$fire$l
         ELSE TDREC940.T$FIRE$L    
    END                                               REF_FISCAL_REC,
    nvl(CISLI941_REL.T$FIRE$L,CISLI245.t$fire$l)      REF_FISCAL_DEV,
    CASE WHEN tdrec940.t$date$l IS NULL 
           THEN CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940_rec.t$date$l, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                    AT time zone 'America/Sao_Paulo') AS DATE)
         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.t$DATE$L, 
                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                    AT time zone 'America/Sao_Paulo') AS DATE)
    END                                               DT_REC_FISCAL,
    CASE WHEN D_RSTA.DSC IS NULL 
           THEN D_RSTA_REC.DSC
         ELSE   D_RSTA.DSC 
    END                                               STATUS_REC,
    tdsls400.t$corn                            NR_PEDIDO
    
FROM       BAANDB.TTDSLS400301 TDSLS400

INNER JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c
               from baandb.tznsls004301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c ) znsls004
        ON znsls004.t$orno$c = tdsls400.t$orno
          
INNER JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls004.t$ncia$c
       AND znsls400.t$uneg$c = znsls004.t$uneg$c
       AND znsls400.t$pecl$c = znsls004.t$pecl$c
       AND znsls400.t$sqpd$c = znsls004.t$sqpd$c
       
 LEFT JOIN baandb.tznmcs095301 znmcs095
        ON znmcs095.t$orno$c = tdsls400.t$orno
            
INNER JOIN BAANDB.TTCMCS065301 TCMCS065 
        ON TCMCS065.T$CWOC  = TDSLS400.T$COFC

INNER JOIN BAANDB.TTCCOM130301 TCCOM130F
        ON TCCOM130F.T$CADR = TCMCS065.T$CADR

INNER JOIN BAANDB.TZNFMD001301 ZNFMD001 
        ON ZNFMD001.T$FOVN$C = TCCOM130F.T$FOVN$L
        
INNER JOIN BAANDB.TTDSLS094301 TDSLS094
        ON TDSLS094.T$SOTP = TDSLS400.T$SOTP

INNER JOIN BAANDB.TTCCOM130301 TCCOM130C
        ON TCCOM130C.T$CADR = TDSLS400.T$OFAD
        
INNER JOIN (SELECT DISTINCT
                   A.T$ORNO,
                   A.T$FIRE$L
              FROM BAANDB.TTDSLS401301 A ) TDSLS401
        ON TDSLS401.T$ORNO = TDSLS400.T$ORNO
        
 LEFT JOIN BAANDB.TCISLI940301 CISLI940_ORG
        ON CISLI940_ORG.T$FIRE$L = TDSLS401.T$FIRE$L

 LEFT JOIN BAANDB.TTCMCS065301 TCMCS065_ORG 
        ON TCMCS065_ORG.T$CWOC = CISLI940_ORG.T$COFC$L

 LEFT JOIN BAANDB.TTCCOM130301 TCCOM130_ORG
        ON TCCOM130_ORG.T$CADR = TCMCS065_ORG.T$CADR

 LEFT JOIN BAANDB.TZNFMD001301 ZNFMD001_ORG 
        ON ZNFMD001_ORG.T$FOVN$C = TCCOM130_ORG.T$FOVN$L
        
 LEFT JOIN ( select distinct
                    A.T$SLSO,
                    A.T$FIRE$L
               from BAANDB.TCISLI245301 A
              where A.T$SLCP = 301
                and A.T$ORTP = 1
                and A.T$KOOR = 3 ) CISLI245
        ON CISLI245.T$SLSO = TDSLS400.T$ORNO

 LEFT JOIN BAANDB.TCISLI940301 CISLI940
        ON CISLI940.T$FIRE$L = CISLI245.T$FIRE$L
        
 LEFT JOIN ( select distinct
                    A.T$DVRF$C,
                    A.T$FIRE$L
               from BAANDB.TTDREC941301 A ) TDREC941
        ON TDREC941.T$DVRF$C = CISLI940_ORG.T$FIRE$L
        
 LEFT JOIN (select a.T$FIRE$L, 
                   a.T$REFR$L,
                   min(a.t$line$l) t$line$l
              from BAANDB.TCISLI941301 a
          group by a.T$FIRE$L, 
                   a.T$REFR$L) CISLI941_REL
        ON CISLI941_REL.T$REFR$L = TDREC941.T$DVRF$C

 LEFT JOIN BAANDB.TTDREC940301 TDREC940
        ON TDREC940.T$FIRE$L = TDREC941.T$FIRE$L

 LEFT JOIN ( select a.t$ncmp$l,
                    a.t$oorg$l,
                    a.t$orno$l,
                    a.t$fire$l,
                    min(a.t$pono$l) t$pono$l,
                    min(a.t$seqn$l) t$seqn$l
               from baandb.ttdrec947301 a
           group by a.t$ncmp$l,
                    a.t$oorg$l,
                    a.t$orno$l,
                    a.t$fire$l ) tdrec947
        ON tdrec947.t$ncmp$l = 301
       AND tdrec947.t$oorg$l = 1   --Venda
       AND tdrec947.t$orno$l = tdsls400.t$orno
       
LEFT JOIN ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$poco$c
            from    baandb.tznsls410301 a
            where   a.t$poco$c = 'INS' ) znsls410     --Quando há insucesso na entrega, o Ln grava o mesmo sequencial
      ON  znsls410.t$ncia$c = znsls004.t$ncia$c       --do pedido na entrega de devolucao na znsls004. 
     AND  znsls410.t$uneg$c = znsls004.t$uneg$c       --Desta forma, nao e possivel encontrar a entrega de devolucao.
     AND  znsls410.t$pecl$c = znsls004.t$pecl$c       
     AND  znsls410.t$sqpd$c = znsls004.t$sqpd$c       --Vide pedido 1/5/99970207
     AND  znsls410.t$entr$c = znsls004.t$entr$c       
       
 LEFT JOIN baandb.ttdrec940301 tdrec940_rec
        ON tdrec940_rec.t$fire$l = tdrec947.t$fire$l

 LEFT JOIN ( select l.t$desc DSC,
                    d.t$cnst COD
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'sls.hdst'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) D_HDST
        ON D_HDST.COD = TDSLS400.T$HDST                              

 LEFT JOIN ( select l.t$desc DSC,
                    d.t$cnst COD
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.stat'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
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
                                            and l1.t$cpac = l.t$cpac ) ) D_STAT
        ON D_STAT.COD = CISLI940.T$STAT$L        
        
 LEFT JOIN ( select l.t$desc DSC,
                    d.t$cnst COD
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) D_RSTA
        ON D_RSTA.COD = TDREC940.T$STAT$L            

 LEFT JOIN ( select l.t$desc DSC,
                    d.t$cnst COD
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'td'
                and d.t$cdom = 'rec.stat.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
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
                                            and l1.t$cpac = l.t$cpac ) ) D_RSTA_REC
        ON D_RSTA_REC.COD = tdrec940_rec.T$STAT$L                    
        
WHERE TDSLS094.T$RETO != 2
--and tdsls400.t$orno = '120113264'
    AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDSLS400.T$ODAT, 'DD-MON-YYYY HH24:MI:SS'), 
              'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)) 
      BETWEEN :DataCriacaoOrdemDe 
          AND :DataCriacaoOrdemAte
    AND ((:NFVendaTodos = 0) OR (TRIM(CISLI940_ORG.T$DOCN$L) IN (:NFVenda) AND (:NFVendaTodos = 1)))
    AND ((:TipoOrdemTodos = 0) OR (TRIM(TDSLS400.T$SOTP) IN (:TipoOrdem) AND (:TipoOrdemTodos = 1)))
    AND ((:FilialTodos = 0) OR (TRIM(ZNFMD001.T$FILI$C) IN (:Filial) AND (:FilialTodos = 1)))
