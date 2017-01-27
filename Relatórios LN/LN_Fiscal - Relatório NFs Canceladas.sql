SELECT 
  CISLI940.T$SFCP$L        CIA,
  
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)
                           DATA_EMISSAO,
  CISLI940.T$FIRE$L        REF_FISCAL,
  CISLI940.T$DOCN$L        NF,
  CISLI940.T$SERI$L        SERIE,
  DESC_DOMAIN_STAT.DESCR   STATUS,
  DESC_NFE_STAT.DESCR      HISTORICO_TRANSMISSAO,
  CISLI940.T$CNFE$L        CHAVE
  ,znnfe011.t$logn$c || ' - ' || znnfe011.t$name      USUARIO  -- SDP.1283436.sn
  ,STATUS_FATURA.DESCR     STATUS_FATURA                       -- SDP.1283436.en
  
FROM       BAANDB.TCISLI940301 CISLI940 
   
LEFT JOIN ( SELECT d.t$cnst CODE,
                   l.t$desc DESCR
              FROM baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             WHERE d.t$cpac = 'ci'
               AND d.t$cdom = 'sli.stat'
               AND l.t$clan = 'p'
               AND l.t$cpac = 'ci'
               AND l.t$clab = d.t$za_clab
               AND rpad(d.t$vers,4) 
                || rpad(d.t$rele,2) 
                || rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele, 2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
               AND rpad(l.t$vers,4) 
                || rpad(l.t$rele,2) 
                || rpad(l.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                               || rpad(l1.t$rele,2) 
                                               || rpad(l1.t$cust,4)) 
                                         from baandb.tttadv140000 l1 
                                        where l1.t$clab = l.t$clab 
                                          AND l1.t$clan = l.t$clan 
                                          AND l1.t$cpac = l.t$cpac)) DESC_DOMAIN_STAT
       ON DESC_DOMAIN_STAT.CODE = cisli940.t$stat$l
  
LEFT JOIN ( select A.T$NCMP$L,
                   A.T$REFI$L,
                   A.T$STAT$L
              from BAANDB.TBRNFE020301 A
             where A.T$SRNB$L = ( SELECT MAX(B.T$SRNB$L)
                                    FROM BAANDB.TBRNFE020301 B
                                   WHERE B.T$NCMP$L=A.T$NCMP$L
                                     AND B.T$REFI$L=A.T$REFI$L)) BRNFE020
       ON BRNFE020.T$NCMP$L = CISLI940.T$SFCP$L
      AND BRNFE020.T$REFI$L = CISLI940.T$FIRE$L
           
 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'br'
                AND d.t$cdom = 'nfe.tsta.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'br'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) 
                 || rpad(d.t$rele,2) 
                 || rpad(d.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele, 2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           AND l1.t$cdom = d.t$cdom)
                AND rpad(l.t$vers,4) 
                 || rpad(l.t$rele,2) 
                 || rpad(l.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele,2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           AND l1.t$clan = l.t$clan 
                                           AND l1.t$cpac = l.t$cpac)) DESC_NFE_STAT
        ON DESC_NFE_STAT.CODE = BRNFE020.t$stat$l

left join ( select  a.t$logn$c,                                -- SDP.1283436.sn
                    a.t$fire$c,
                    a.t$oper$c,
                    a.t$nfes$c,
                    b.t$name
            from    baandb.tznnfe011301 a,
                    baandb.tttaad200000 b
            where   a.t$nfes$c = 3 -- Pedido cancelamento
              and   b.t$user   = a.t$logn$c
            group by a.t$logn$c,
                     a.t$fire$c,
                     a.t$oper$c,
                     a.t$nfes$c,
                     b.t$name ) znnfe011
       on znnfe011.t$oper$c = 1    -- Faturamento
      and znnfe011.t$fire$c = cisli940.t$fire$l                -- SDP.1283436.en

left join ( select d.t$cnst CODE,                              -- SDP.1283436.sn
                   l.t$desc DESCR
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.nfes.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) 
                 || rpad(d.t$rele,2) 
                 || rpad(d.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele, 2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom)
                and rpad(l.t$vers,4) 
                 || rpad(l.t$rele,2) 
                 || rpad(l.t$cust,4) = (select max(rpad(l1.t$vers,4) 
                                                || rpad(l1.t$rele,2) 
                                                || rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac)) STATUS_FATURA
       on STATUS_FATURA.CODE = znnfe011.t$nfes$c               -- SDP.1283436.en

WHERE   (CISLI940.T$STAT$L=2 
		 OR BRNFE020.T$STAT$L IN (4,3,8,5))


  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
                AT time zone 'America/Sao_Paulo') AS DATE) )
Between :DataEmissaoDe And :DataEmissaoAte
