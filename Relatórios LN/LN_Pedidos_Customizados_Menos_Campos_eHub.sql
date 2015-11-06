=

SELECT

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_EMISSAO,
  znsls401.t$pecl$c       PEDIDO,
  znsls410.STATUS         STATUS_PED,
  znsls410.t$dtoc$c       DATA_ULTIMO_PONTO,

  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_FATURAMENTO,

  znsls401.t$item$c       ITEM,
  tcibd001.t$dscb$c       ITEM_NOME,
  tcibd001.t$mdfb$c       CODIGO_FORNECEDOR,
  tcmcs023.t$dsca         DEPARTAMENTO,

  znsls430.t$coit$c       CODE_ITEM_CUSTOMIZADO,
  znsls430.t$codc$c       DESC_ITEM_CUSTOMIZADO,
  znsls430.t$coqt$c       QTDE_CUSTOMIZADO

FROM  baandb.tznsls401601 znsls401

INNER JOIN baandb.tznsls400601  znsls400
        ON znsls400.t$ncia$c = znsls401.t$ncia$c
       AND znsls400.t$uneg$c = znsls401.t$uneg$c
       AND znsls400.t$pecl$c = znsls401.t$pecl$c
       AND znsls400.t$sqpd$c = znsls401.t$sqpd$c

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c,
                    Max(znsls410.t$dtoc$c) t$dtoc$c,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) STATUS
               from baandb.tznsls410601 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$entr$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls401.t$ncia$c
       AND znsls410.t$uneg$c = znsls401.t$uneg$c
       AND znsls410.t$pecl$c = znsls401.t$pecl$c
       AND znsls410.t$entr$c = znsls401.t$entr$c
       AND znsls410.t$sqpd$c = znsls401.t$sqpd$c

INNER JOIN ( select a.t$slso,
                    a.t$fire$l
               from baandb.tcisli245601 a
           group by a.t$slso,
                    a.t$fire$l ) cisli245
        ON trim(TO_CHAR(cisli245.t$slso)) = trim(TO_CHAR(znsls401.t$orno$c))

INNER JOIN baandb.tcisli940601 cisli940
        ON cisli940.t$fire$l = cisli245.t$fire$l
       AND cisli940.t$stat$l in (5, 6)

 LEFT JOIN baandb.ttcibd001601  tcibd001
        ON TRIM(TO_CHAR(tcibd001.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))

 LEFT JOIN baandb.ttcmcs023601  tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg

 LEFT JOIN baandb.tznsls430601 znsls430
        ON znsls430.t$ncia$c = znsls401.t$ncia$c
       AND znsls430.t$uneg$c = znsls401.t$uneg$c
       AND znsls430.t$pecl$c = znsls401.t$pecl$c
       AND znsls430.t$sqpd$c = znsls401.t$sqpd$c
       AND znsls430.t$entr$c = znsls401.t$entr$c
       AND znsls430.t$sequ$c = znsls401.t$sequ$c

WHERE znsls430.t$cosq$c IS NOT NULL
  AND znsls401.t$IDOR$c = 'LJ'  --Vendas
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataEmissaoDe
          And :DataEmissaoAte

ORDER BY PEDIDO



" SELECT  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_EMISSAO,  " &
"   znsls401.t$pecl$c       PEDIDO,  " &
"   znsls410.STATUS         STATUS_PED,  " &
"   znsls410.t$dtoc$c       DATA_ULTIMO_PONTO,  " &
"  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_FATURAMENTO,  " &
"  " &
"   znsls401.t$item$c       ITEM,  " &
"   tcibd001.t$dscb$c       ITEM_NOME,  " &
"   tcibd001.t$mdfb$c       CODIGO_FORNECEDOR,  " &
"   tcmcs023.t$dsca         DEPARTAMENTO,  " &
"  " &
"   znsls430.t$coit$c       CODE_ITEM_CUSTOMIZADO,  " &
"   znsls430.t$codc$c       DESC_ITEM_CUSTOMIZADO,  " &
"   znsls430.t$coqt$c       QTDE_CUSTOMIZADO  " &
"  " &
"  " &
" FROM  baandb.tznsls401" + Parameters!Compania.Value + " znsls401  " &
"  " &
" INNER JOIN baandb.tznsls400" + Parameters!Compania.Value + "  znsls400  " &
"         ON znsls400.t$ncia$c = znsls401.t$ncia$c  " &
"        AND znsls400.t$uneg$c = znsls401.t$uneg$c  " &
"        AND znsls400.t$pecl$c = znsls401.t$pecl$c  " &
"        AND znsls400.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
"  LEFT JOIN ( select znsls410.t$ncia$c,  " &
"                     znsls410.t$uneg$c,  " &
"                     znsls410.t$pecl$c,  " &
"                     znsls410.t$entr$c,  " &
"                     znsls410.t$sqpd$c,  " &
"                     Max(znsls410.t$dtoc$c) t$dtoc$c,  " &
"                     MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) STATUS  " &
"                from baandb.tznsls410" + Parameters!Compania.Value + " znsls410  " &
"            group by znsls410.t$ncia$c,  " &
"                     znsls410.t$uneg$c,  " &
"                     znsls410.t$pecl$c,  " &
"                     znsls410.t$entr$c,  " &
"                     znsls410.t$sqpd$c ) znsls410  " &
"         ON znsls410.t$ncia$c = znsls401.t$ncia$c  " &
"        AND znsls410.t$uneg$c = znsls401.t$uneg$c  " &
"        AND znsls410.t$pecl$c = znsls401.t$pecl$c  " &
"        AND znsls410.t$entr$c = znsls401.t$entr$c  " &
"        AND znsls410.t$sqpd$c = znsls401.t$sqpd$c  " &
"  " &
" INNER JOIN ( select a.t$slso,  " &
"                     a.t$fire$l  " &
"                from baandb.tcisli245" + Parameters!Compania.Value + " a  " &
"            group by a.t$slso,  " &
"                     a.t$fire$l ) cisli245  " &
"         ON trim(TO_CHAR(cisli245.t$slso)) = trim(TO_CHAR(znsls401.t$orno$c))  " &
"  " &
" INNER JOIN baandb.tcisli940" + Parameters!Compania.Value + " cisli940  " &
"         ON cisli940.t$fire$l = cisli245.t$fire$l  " &
"        AND cisli940.t$stat$l in (5, 6)  " &
"  " &
"  LEFT JOIN baandb.ttcibd001" + Parameters!Compania.Value + "  tcibd001  " &
"         ON TRIM(TO_CHAR(tcibd001.t$item)) = TRIM(TO_CHAR(znsls401.t$item$c))  " &
"  " &
"  LEFT JOIN baandb.ttcmcs023" + Parameters!Compania.Value + "  tcmcs023  " &
"         ON tcmcs023.t$citg = tcibd001.t$citg  " &
"  " &
"  LEFT JOIN baandb.tznsls430" + Parameters!Compania.Value + " znsls430  " &
"         ON znsls430.t$ncia$c = znsls401.t$ncia$c  " &
"        AND znsls430.t$uneg$c = znsls401.t$uneg$c  " &
"        AND znsls430.t$pecl$c = znsls401.t$pecl$c  " &
"        AND znsls430.t$sqpd$c = znsls401.t$sqpd$c  " &
"        AND znsls430.t$entr$c = znsls401.t$entr$c  " &
"        AND znsls430.t$sequ$c = znsls401.t$sequ$c  " &
"  " &
" WHERE znsls430.t$cosq$c IS NOT NULL  " &
"   AND znsls401.t$IDOR$c = 'LJ'  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataEmissaoDe  " &
"           And :DataEmissaoAte  " &
"  " &
" ORDER BY PEDIDO  "