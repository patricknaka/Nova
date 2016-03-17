SELECT 
    znsls401.t$uneg$c ||
    ' - '             ||
    znint002.t$desc$c     BANDEIRA,
    znsls401.t$entr$c     ENTREGA,
    znsls400.t$pecl$c     NUM_PEDIDO,
    znsls401.t$item$c     ITEM,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,   
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
        AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_EMISSAO,
    
    znsls410.DATA_HORA    DATA_CONTROLE,                      
    znsls401.t$itpe$c ||
    ' - '             ||
    znsls002.t$dsca$c     TIPO_ENTREGA,
    znsls401.t$idlo$c     COD_LOGISTA
    
FROM  baandb.tznsls400301 znsls400

INNER JOIN baandb.tznsls401301 znsls401
        on znsls401.t$pecl$c = znsls400.t$pecl$c
       and znsls401.t$sqpd$c = znsls400.t$sqpd$c

--identifica marketplace
INNER JOIN baandb.ttcibd001301 tcibd001
               on tcibd001.t$item = znsls401.t$item$c

INNER JOIN baandb.tznisa002301 znisa002
               on znisa002.t$npcl$c = tcibd001.t$npcl$c
               
INNER JOIN baandb.tznisa001301 znisa001
               on znisa001.t$nptp$c = znisa002.t$nptp$c
              and znisa001.t$emnf$c = 2  --não emite nf
              and znisa001.t$bpti$c = 5  --tabela muro
              and znisa001.t$siit$c = 1  --Envia na interface de item (sim)
              and znisa001.t$nfed$c = 2  --não Gera nota fiscal de entrada de devolução
  
INNER JOIN baandb.tznsls002301 znsls002
               on znsls002.t$tpen$c = znsls401.t$itpe$c
               
INNER JOIN baandb.tznint002301 znint002
               on znint002.t$uneg$c = znsls401.t$uneg$c

--busca somente pedidos que possuem somente o status PAP
INNER JOIN ((select Q1.* 
                from (SELECT 
                       znsls410.t$pecl$c    PEDIDO,
                       znsls410.t$entr$c    ENTREGA,
                       MAX(znsls410.T$POCO$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, znsls410.t$entr$c) CODIGO_OCORRENCIA,
                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znsls410.T$DTOC$C) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C, znsls410.T$SEQN$C),
                         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                           AT time zone 'America/Sao_Paulo') AS DATE) DATA_HORA
                       FROM baandb.tznsls410301 znsls410
                       GROUP BY znsls410.t$pecl$c, znsls410.t$entr$c 
                       ORDER BY DATA_HORA, PEDIDO ) Q1
             WHERE CODIGO_OCORRENCIA = 'PAP')) znsls410
       on znsls410.ENTREGA = znsls401.t$entr$c
        
  WHERE trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
         AT time zone 'America/Sao_Paulo') AS DATE))
               between :DataEmissaoDe
                   and :DataEmissaoAte

GROUP BY
    znint002.t$desc$c,
    znsls401.t$uneg$c,
    znsls400.t$pecl$c,
    znsls400.t$dtem$c,
    znsls401.t$entr$c,
    znsls401.t$itpe$c,
    znsls401.t$idlo$c,
    znsls401.t$item$c,
    znsls002.t$dsca$c,
    znsls410.DATA_HORA
    
order by ENTREGA