SELECT
  DISTINCT
    SHO.WHSEID             ID_PLANTA,
    CL.UDF2                NOME_PLANTA,
    ZNFMD630.T$FILI$C      ID_FILIAL,
    ZNFMD001.T$DSCA$C      DESCR_FILIAL,
    ZNSLS401.T$UNEG$C      ID_UNEG,
    ZNINT002.T$DESC$C      DESCR_UNEG,
    ZNSLS401.T$ENTR$C      ENTREGA,
    ZNSLS401.T$PECL$C      PEDIDO,
    SHO.INVOICENUMBER      NOTA,
    SHO.LANE               SERIE,
    ZNFMD630.T$ORNO$C      ORDEM_VENDA,
    OXV.NOTES1             ETIQUETA,
    ZNSLS401.T$NOME$C      CLIENTE,
    ZNSLS401.T$ICLE$C      CPF_CNPJ,
    ZNSLS401.T$LOGE$C      ENDERECO,
    ZNSLS401.T$NUME$C      NUMERO,
    ZNSLS401.T$BAIE$C      BAIRRO,
    ZNSLS401.T$REFE$C      REFERENCIA,
    ZNSLS401.T$EMAE$C      EMAIL,
    ZNSLS401.T$TELE$C      TELEFONE_1,
    ZNSLS401.T$TE1E$C      TELEFONE_2,
    ZNSLS401.T$TE2E$C      TELEFONE_3,
    SHD.ORIGINALQTY        QTD_VOL,
    SHD.PRODUCT_WEIGHT     PESO,
    SHD.PRODUCT_CUBE       VOLUME,
    ZNSLS401.T$VLUN$C *
    SHD.ORIGINALQTY        VL_SEM_FRETE,
    ZNFMD630.T$VLFC$C      FRETE,
    ZNSLS401.T$VLFR$C      FRETE_SITE,
    ( ZNSLS401.T$VLUN$C *
      SHD.ORIGINALQTY ) +
      ZNSLS401.T$VLFR$C +
      ZNSLS401.T$VLDE$C -
      ZNSLS401.T$VLDI$C    VL_TOTAL,
    TCMCS080.T$DSCA        TRANSPORTADORA,
    TCMCS080.T$SEAK        APELIDO,
    ZNSLS401.T$CEPE$C      CEP,
    ZNSLS401.T$CIDE$C      CIDADE,
    ZNSLS401.T$UFEN$C      UF,
    ZNSLS400.T$IDCA$C      CANAL,
    ZNFMD630.T$CFRW$C      ID_TRANSP,
    CASE WHEN Trunc(ZNSLS401.T$DTEP$C) = '01/01/1970'
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C - ZNSLS401.T$PZCD$C,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
    END                    DT_LIMITE,
    ZNSLS401.T$PZCD$C      PZ_CD,
    ZNSLS401.T$PZTR$C      PZ_TRANSIT,
    CASE WHEN Trunc(ZNSLS401.T$DTEP$C) = '01/01/1970'
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
    END                    DT_PROMET,

    CASE WHEN Trunc(ZNFMD630.T$DTCO$C) = '01/01/1970'
           THEN NULL
         ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNFMD630.T$DTCO$C,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
    END                    DT_CORRIGIDA,

    CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
           THEN NULL
         ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'),
                  'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
    END                    DT_PREVISTA,

    ZNFMD630.T$NCAR$C      CARGA,
    znfmd062.t$creg$c      CAPITAL_INTERIOR,
    znfmd061.t$dzon$c      REGIAO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DT_ETR,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                           DATA_COMPRA,

    CASE WHEN ZNSLS401.T$IDPA$C = '1'
           THEN 'Manhã'
         WHEN ZNSLS401.T$IDPA$C = '2'
           THEN 'Tarde'
         WHEN ZNSLS401.T$IDPA$C = '3'
           THEN 'Noite'
         ELSE Null
    END                    PERIODO

FROM       WMWHSE9.ORDERDETAIL SHD

INNER JOIN WMWHSE9.ORDERDETAILXVAS OXV
        ON OXV.ORDERKEY = SHD.ORDERKEY
       AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER

INNER JOIN WMWHSE9.ORDERS SHO
        ON SHO.ORDERKEY = SHD.ORDERKEY

 LEFT JOIN BAANDB.TWHINH431601@PLN01 WHINH431
        ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)
       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO*10)

 LEFT JOIN BAANDB.TZNSLS004601@PLN01 ZNSLS004
        ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN
       AND ZNSLS004.T$PONO$C = WHINH431.T$WPON

 LEFT JOIN BAANDB.TZNSLS401601@PLN01 ZNSLS401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C
       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C

 LEFT JOIN BAANDB.TZNSLS400601@PLN01 ZNSLS400
        ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C

 LEFT JOIN ( select A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    MIN(A.T$DTOC$C) T$DTOC$C,
                    MIN(A.T$CONO$C) T$CONO$C
               from BAANDB.TZNSLS410601@PLN01 A
              where A.T$POCO$C = 'ETR'
           group by A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C ) ZNSLS410
        ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C

 LEFT JOIN BAANDB.TZNFMD630601@PLN01 ZNFMD630
        ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN

 LEFT JOIN BAANDB.TZNFMD001601@PLN01 ZNFMD001
        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C

 LEFT JOIN BAANDB.TZNINT002601@PLN01 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C

 LEFT JOIN BAANDB.TTCMCS080601@PLN01 TCMCS080
        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C

INNER JOIN ENTERPRISE.CODELKUP CL
        ON UPPER(CL.UDF1) = SHO.WHSEID
       AND CL.LISTNAME = 'SCHEMA'

 LEFT JOIN ( select znfmd062.t$creg$c,
                    znfmd062.t$cfrw$c,
                    znfmd062.t$cono$c,
                    znfmd062.t$cepd$c,
                    znfmd062.t$cepa$c
               from baandb.tznfmd062601@PLN01 znfmd062 ) znfmd062
        ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd062.t$cono$c = znfmd630.t$cono$c
       AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c
       AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c

 LEFT JOIN baandb.tznfmd061601@PLN01 znfmd061
        ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c
       AND znfmd061.t$cono$c = znfmd630.t$cono$c
       AND znfmd061.t$creg$c = znfmd062.t$creg$c

WHERE ZNSLS410.T$DTOC$C IS NOT NULL
  AND OXV.NOTES1 IS NOT NULL
  AND OXV.UDF1 = 'SHIPPINGID'

  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      Between :DataETRDe
          AND :DataETRAte
  AND NVL(TCMCS080.t$cfrw, 'N/A') IN (:Transportadora)
  AND ZNSLS401.T$UNEG$C IN (:UnidNegocio)

ORDER BY DT_ETR



=

" SELECT  " &
"   DISTINCT  " &
"     SHO.WHSEID             ID_PLANTA,  " &
"     CL.UDF2                NOME_PLANTA,  " &
"     ZNFMD630.T$FILI$C      ID_FILIAL,  " &
"     ZNFMD001.T$DSCA$C      DESCR_FILIAL,  " &
"     ZNSLS401.T$UNEG$C      ID_UNEG,  " &
"     ZNINT002.T$DESC$C      DESCR_UNEG,  " &
"     ZNSLS401.T$ENTR$C      ENTREGA,  " &
"     ZNSLS401.T$PECL$C      PEDIDO,  " &
"     SHO.INVOICENUMBER      NOTA,  " &
"     SHO.LANE               SERIE,  " &
"     ZNFMD630.T$ORNO$C      ORDEM_VENDA,  " &
"     OXV.NOTES1             ETIQUETA,  " &
"     ZNSLS401.T$NOME$C      CLIENTE,  " &
"     ZNSLS401.T$ICLE$C      CPF_CNPJ,  " &
"     ZNSLS401.T$LOGE$C      ENDERECO,  " &
"     ZNSLS401.T$NUME$C      NUMERO,  " &
"     ZNSLS401.T$BAIE$C      BAIRRO,  " &
"     ZNSLS401.T$REFE$C      REFERENCIA,  " &
"     ZNSLS401.T$EMAE$C      EMAIL,  " &
"     ZNSLS401.T$TELE$C      TELEFONE_1,  " &
"     ZNSLS401.T$TE1E$C      TELEFONE_2,  " &
"     ZNSLS401.T$TE2E$C      TELEFONE_3,  " &
"     SHD.ORIGINALQTY        QTD_VOL,  " &
"     SHD.PRODUCT_WEIGHT     PESO,  " &
"     SHD.PRODUCT_CUBE       VOLUME,  " &
"     ZNSLS401.T$VLUN$C *  " &
"     SHD.ORIGINALQTY        VL_SEM_FRETE,  " &
"     ZNFMD630.T$VLFC$C      FRETE,  " &
"     ZNSLS401.T$VLFR$C      FRETE_SITE,  " &
"     ( ZNSLS401.T$VLUN$C *  " &
"       SHD.ORIGINALQTY ) +  " &
"       ZNSLS401.T$VLFR$C +  " &
"       ZNSLS401.T$VLDE$C -  " &
"       ZNSLS401.T$VLDI$C    VL_TOTAL,  " &
"     TCMCS080.T$DSCA        TRANSPORTADORA,  " &
"     TCMCS080.T$SEAK        APELIDO,  " &
"     ZNSLS401.T$CEPE$C      CEP,  " &
"     ZNSLS401.T$CIDE$C      CIDADE,  " &
"     ZNSLS401.T$UFEN$C      UF,  " &
"     ZNSLS400.T$IDCA$C      CANAL,  " &
"     ZNFMD630.T$CFRW$C      ID_TRANSP,  " &
"     CASE WHEN Trunc(ZNSLS401.T$DTEP$C) = '01/01/1970'  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C - ZNSLS401.T$PZCD$C,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                    DT_LIMITE,  " &
"     ZNSLS401.T$PZCD$C      PZ_CD,  " &
"     ZNSLS401.T$PZTR$C      PZ_TRANSIT,  " &
"     CASE WHEN Trunc(ZNSLS401.T$DTEP$C) = '01/01/1970'  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS401.T$DTEP$C,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                    DT_PROMET,  " &
"  " &
"     CASE WHEN Trunc(ZNFMD630.T$DTCO$C) = '01/01/1970'  " &
"            THEN NULL  " &
"          ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNFMD630.T$DTCO$C,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                    DT_CORRIGIDA,  " &
"  " &
"     CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')  " &
"            THEN NULL  " &
"          ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"                   'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"     END                    DT_PREVISTA,  " &
"  " &
"     ZNFMD630.T$NCAR$C      CARGA,  " &
"     znfmd062.t$creg$c      CAPITAL_INTERIOR,  " &
"     znfmd061.t$dzon$c      REGIAO,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                            DT_ETR,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                            DATA_COMPRA,  " &
"  " &
"     CASE WHEN ZNSLS401.T$IDPA$C = '1'  " &
"            THEN 'Manhã'  " &
"          WHEN ZNSLS401.T$IDPA$C = '2'  " &
"            THEN 'Tarde'  " &
"          WHEN ZNSLS401.T$IDPA$C = '3'  " &
"            THEN 'Noite'  " &
"          ELSE Null  " &
"     END                    PERIODO  " &
"  " &
" FROM       " + Parameters!Compania.Value + ".ORDERDETAIL SHD  " &
"  " &
" INNER JOIN " + Parameters!Compania.Value + ".ORDERDETAILXVAS OXV  " &
"         ON OXV.ORDERKEY = SHD.ORDERKEY  " &
"        AND OXV.ORDERLINENUMBER = SHD.ORDERLINENUMBER  " &
"  " &
" INNER JOIN " + Parameters!Compania.Value + ".ORDERS SHO  " &
"         ON SHO.ORDERKEY = SHD.ORDERKEY  " &
"  " &
"  LEFT JOIN BAANDB.TWHINH431" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 WHINH431  " &
"         ON WHINH431.T$SHPM = SUBSTR(SHD.EXTERNORDERKEY,5,9)  " &
"        AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(SHD.EXTERNLINENO*10)  " &
"  " &
"  LEFT JOIN BAANDB.TZNSLS004" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNSLS004  " &
"         ON ZNSLS004.T$ORNO$C = WHINH431.T$WORN  " &
"        AND ZNSLS004.T$PONO$C = WHINH431.T$WPON  " &
"  " &
"  LEFT JOIN BAANDB.TZNSLS401" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNSLS401  " &
"         ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"        AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"        AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"        AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"        AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"        AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C  " &
"  " &
"  LEFT JOIN BAANDB.TZNSLS400" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNSLS400  " &
"         ON ZNSLS400.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"        AND ZNSLS400.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"        AND ZNSLS400.T$PECL$C = ZNSLS004.T$PECL$C  " &
"        AND ZNSLS400.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"  " &
"  LEFT JOIN ( select A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     MIN(A.T$DTOC$C) T$DTOC$C,  " &
"                     MIN(A.T$CONO$C) T$CONO$C  " &
"                from BAANDB.TZNSLS410" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 A  " &
"               where A.T$POCO$C = 'ETR'  " &
"            group by A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C ) ZNSLS410  " &
"         ON ZNSLS410.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"        AND ZNSLS410.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"        AND ZNSLS410.T$PECL$C = ZNSLS004.T$PECL$C  " &
"        AND ZNSLS410.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"        AND ZNSLS410.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"  " &
"  LEFT JOIN BAANDB.TZNFMD630" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNFMD630  " &
"         ON ZNFMD630.T$ORNO$C = WHINH431.T$WORN  " &
"  " &
"  LEFT JOIN BAANDB.TZNFMD001" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNFMD001  " &
"         ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
"  " &
"  LEFT JOIN BAANDB.TZNINT002" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 ZNINT002  " &
"         ON ZNINT002.T$NCIA$C = ZNSLS401.T$NCIA$C  " &
"        AND ZNINT002.T$UNEG$C = ZNSLS401.T$UNEG$C  " &
"  " &
"  LEFT JOIN BAANDB.TTCMCS080" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 TCMCS080  " &
"         ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"  " &
" INNER JOIN ENTERPRISE.CODELKUP CL  " &
"         ON UPPER(CL.UDF1) = SHO.WHSEID  " &
"        AND CL.LISTNAME = 'SCHEMA'  " &
"  " &
"  LEFT JOIN ( select znfmd062.t$creg$c,  " &
"                     znfmd062.t$cfrw$c,  " &
"                     znfmd062.t$cono$c,  " &
"                     znfmd062.t$cepd$c,  " &
"                     znfmd062.t$cepa$c  " &
"                from baandb.tznfmd062" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 znfmd062 ) znfmd062  " &
"         ON znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"        AND znfmd062.t$cepd$c <= ZNSLS401.t$cepe$c  " &
"        AND znfmd062.t$cepa$c >= ZNSLS401.t$cepe$c  " &
"  " &
"  LEFT JOIN baandb.tznfmd061" + IIF(Parameters!Compania.Value = "WMWHSE9","601","602") + "@PLN01 znfmd061  " &
"         ON znfmd061.t$cfrw$c = znfmd630.t$cfrw$c  " &
"        AND znfmd061.t$cono$c = znfmd630.t$cono$c  " &
"        AND znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"  " &
" WHERE ZNSLS410.T$DTOC$C IS NOT NULL  " &
"   AND OXV.NOTES1 IS NOT NULL  " &
"   AND OXV.UDF1 = 'SHIPPINGID'  " &
"  " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ZNSLS410.T$DTOC$C,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       Between :DataETRDe  " &
"           AND :DataETRAte  " &
"   AND NVL(TCMCS080.t$cfrw, 'N/A') IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"   AND ZNSLS401.T$UNEG$C IN (" + JOIN(Parameters!UnidNegocio.Value, ", ") + ") " &
"  " &
" ORDER BY DT_ETR  "

