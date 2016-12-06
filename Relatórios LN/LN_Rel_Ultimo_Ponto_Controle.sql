SELECT DISTINCT
    znsls401.t$uneg$c                                     UNID_NEGOCIO,
    znsls401.t$pecl$c                                     PEDIDO,
    znsls401.t$sqpd$c                                     SEQ_PEDIDO,
    znsls401.t$entr$c                                     NO_ENTREGA,
    znsls401.t$orno$c                                    ORDEM_VENDA,
    znsls410.t$docn$C                                     NF,
    znsls410.t$seri$C                                     SERIE,
    znsls410.t$poco$C                                     CODIGO_OCORRENCIA,
        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.T$DTOC$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)        DATA_HORA,
                
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.T$DATE$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)        DATA_PROCESSAMENTO,
                                                                    
    CASE WHEN znsls410.T$DTEM$C  <= to_date('01-01-1980','DD-MM-YYYY') 
          THEN  NULL
    ELSE
          CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.T$DTEM$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE) END 
                                                          DATA_SAIDA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)        DATA_PROMETIDA,
        
    znfmd630.t$cfrw$c                                     COD_TRANSPORTADORA,
    
    tcmcs080.t$dsca                                       NOME_TRANSPORTADORA,
    
    znfmd630.t$cono$c                                     CONTRATO,
    
    znfmd060.t$cdes$c                                     DESC_CONTRATO,
    
    tdsls401.t$oamt                                       VALOR_ENTREGA,
    
    tcemm030.t$euca                                       FILIAL,
    tcemm030.t$dsca                                       NOME_FILIAL,
    
    znsls400.t$cepf$c                                     CEP,
    
    znsls400.t$cidf$c                                     CIDADE,
    
    znsls400.t$emaf$c                                     EMAIL_CLIENTE,
    
    znsls400.t$telf$c                                     TELEFONE_1,
    
    znsls400.t$te1f$c                                     TELEFONE_2,
    
    znfmd640.t$ulog$c                                     MATRICULA,
    
    ttaad200.t$name                                       NOME,
    
    znsls400.t$tped$c                                     TIPO_DE_VENDA,
    
    znsls002.t$dsca$c                                     TIPO_DE_DEVOLUCAO,
    
    znsls401.t$lmot$c                                     MOTIVO, 
    CASE WHEN znsls402.t$idmp$c IS NULL THEN
        'REENVIO'
    ELSE zncmg007.t$desc$c END                            FORMA_DE_RESTITUICAO,
    OVENDA.STATUS                                         SITUACAO,
    cisli940.t$amnt$l                                     VALOR_NOTA,
    
        CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                    THEN NULL
                  ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'),
                           'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
             END                DATA_PREVISTA,   -- Campo Novo
             
    
    CASE WHEN znfmd630.t$dtco$c > '01/01/1975' then
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),
                        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)    
    ELSE NULL
END                             DT_CORRIGIDA           --Campo Novo
    
FROM ( select a.t$ncia$c,
              a.t$uneg$c,
              a.t$pecl$c,
              a.t$sqpd$c,
              a.t$entr$c,
              a.t$lmot$c,
              a.t$orno$c,
              a.t$cwoc$c,
              a.t$itpe$c,
              a.t$dtep$c
        from baandb.tznsls401301 a
        group by  a.t$ncia$c,
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$lmot$c,
                  a.t$orno$c,
                  a.t$cwoc$c,
                  a.t$itpe$c,
                  a.t$dtep$c) znsls401

LEFT JOIN baandb.tznsls400301 znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c
 
 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$docn$c) t$docn$c,
                    max(a.t$seri$c) t$seri$c,
                    max(a.t$date$c) t$date$c,
                    max(a.t$dtem$c) t$dtem$c,
                    max(a.t$dtep$c) t$dtep$c,
                    max(a.t$dtoc$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C) t$dtoc$c,  --Data de ocorrência
                    max(a.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY a.T$DTOC$C) t$poco$c   --Data de ocorrência
               from baandb.tznsls410301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
 
 LEFT JOIN baandb.tznfmd630301 znfmd630
        ON to_char(znfmd630.t$pecl$c) = to_char(znsls401.t$entr$c)
        
 LEFT JOIN baandb.tznfmd640301 znfmd640
        ON  znfmd640.t$fili$c = znfmd630.t$fili$c
        AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
        AND znfmd640.t$coci$c = znsls410.t$poco$c
        
 LEFT JOIN baandb.tttaad200000 ttaad200
        ON  ttaad200.t$user = znfmd640.t$ulog$c
 
 LEFT JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c
 
 LEFT JOIN baandb.tznfmd060301 znfmd060
        ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd060.t$cono$c = znfmd630.t$cono$c
        
 LEFT JOIN (  select a.t$orno,
                    sum(a.t$oamt) t$oamt
              from baandb.ttdsls401301 a
              group by a.t$orno ) tdsls401
        ON tdsls401.t$orno = znsls401.t$orno$c

 LEFT JOIN baandb.ttdsls400301 tdsls400
        ON tdsls400.t$orno = tdsls401.t$orno
        
 LEFT JOIN baandb.ttcemm124301  tcemm124
        ON tcemm124.t$cwoc=znsls401.t$cwoc$c
 
 LEFT JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt=tcemm124.t$grid

 INNER JOIN baandb.tznsls002301 znsls002
        ON znsls002.t$tpen$c = znsls401.t$itpe$c
 
 LEFT JOIN baandb.tznsls402301 znsls402
        ON znsls402.t$ncia$c = znsls401.t$ncia$c
       AND znsls402.t$uneg$c = znsls401.t$uneg$c
       AND znsls402.t$pecl$c = znsls401.t$pecl$c
       AND znsls402.t$sqpd$c = znsls401.t$sqpd$c
       
 LEFT JOIN baandb.tzncmg007301 zncmg007
        ON zncmg007.t$mpgt$c = znsls402.t$idmp$c

 LEFT JOIN (select a.t$slso,
                   a.t$fire$l
            from  baandb.tcisli245301 a
            where a.t$ortp = 1
              and a.t$koor = 3 
            group by a.t$slso,
                     a.t$fire$l ) cisli245
        ON cisli245.t$slso = znsls401.t$orno$c
        
 LEFT JOIN ( select a.t$fire$l,
                    a.t$amnt$l
             from   baandb.tcisli940301 a) cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l
        
  LEFT JOIN ( select  l.t$desc STATUS,
                      d.t$cnst
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
                                            and l1.t$cpac = l.t$cpac ) ) OVENDA
        ON OVENDA.t$cnst = tdsls400.t$hdst
        
WHERE znsls410.t$poco$c IS NOT NULL

and ((znsls401.t$entr$c in (:NumEntrega) and :Todos = 1  ) OR :Todos = 0)
  and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.T$DTOC$C, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE))   
      between :DataOcorrenciaDe
          and :DataOcorrenciaAte
  AND znsls401.t$uneg$c IN (:UnidadeNegocio)
  AND tcemm030.t$euca IN (:Filial)
