--LN_Planejamento Logistico - Entregas_eHub.sql

SELECT
  DISTINCT
    znfmd630.t$pecl$c            ENTREGA,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                 DATA_COMPRA,

    ( SELECT znfmd640.t$coci$c
        FROM BAANDB.tznfmd640601 znfmd640
       WHERE znfmd640.t$date$c = ( select max(znfmd640X.t$date$c)
                                     from BAANDB.tznfmd640601 znfmd640X
                                    where znfmd640X.t$fili$c = znfmd640.t$fili$c
                                      and znfmd640X.t$etiq$c = znfmd640.t$etiq$c)
         AND znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
         AND ROWNUM = 1 )        ULT_PONTO,

    ( SELECT znfmd030d.t$dsci$c
        FROM BAANDB.tznfmd640601 znfmd640d,
             BAANDB.tznfmd030601 znfmd030d
       WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c)
                                      from BAANDB.tznfmd640601 znfmd640x
                                     where znfmd640x.t$fili$c = znfmd640d.t$fili$c                                   
                                       and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c)
         AND znfmd640d.t$fili$c = znfmd630.t$fili$c
         AND znfmd640d.t$etiq$c = znfmd630.t$etiq$c
         AND znfmd030d.t$ocin$c = znfmd640d.t$coci$c
         AND ROWNUM = 1 )        DESCRICAO,

    ZNFMD630.T$CFRW$C            ID_TRANSPORTADORA,
    TCMCS080.T$DSCA              DESCR_TRANSPORTADORA,
    ZNFMD630.T$CONO$C            ID_CONTRATO,
    ZNFMD060.T$CDES$C            DESCR_CONTRATO,
    ZNFMD630.T$FILI$C            ID_FILIAL,
    ZNFMD001.T$DSCA$C            DESCR_FILIAL,
    ZNFMD630.T$DOCN$C            NF,
    ZNFMD630.T$SERI$C            SERIE,
    TDSLS400.T$SOTP              ID_TIPO_ORDEM,
    TDSLS094.T$DSCA              DESCR_TIPO_ORDEM,
    ZNSLS400.T$UNEG$C            ID_UNEG,
    ZNINT002.T$DESC$C            DESCR_UNEG,

    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c),
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
        from BAANDB.tznfmd640601 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                                 DATA_OCORRENCIA,

    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$udat$c),
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
        from BAANDB.tznfmd640601 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                                 DATA_PROCESSAMENTO,
								
    CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'
           THEN 'FINALIZADO'
         ELSE   'PENDENTE'
    END                          SITUACAO,

    ZNSLS401.T$CIDE$C            CIDADE,
    ZNSLS401.T$CEPE$C            CEP,
    ZNSLS401.T$UFEN$C            UF,
    ZNSLS401.T$NOME$C            DESTINATARIO,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                 DATA_PROMETIDA,

    CASE WHEN ZNSLS401.T$IDPA$C = '1'
           THEN 'Manhã'
         WHEN ZNSLS401.T$IDPA$C = '2'
           THEN 'Tarde'
         WHEN ZNSLS401.T$IDPA$C = '3'
           THEN 'Noite'
         ELSE ''
    END                          PERIODO,
    ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c),
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE)
        from BAANDB.tznfmd640601 znfmd640
       where znfmd640.t$fili$c = znfmd630.t$fili$c
         and znfmd640.t$etiq$c = znfmd630.t$etiq$c
         and znfmd640.t$coct$c = 'ETR')
                                 DATA_EXPED,
								
    CISLI940.T$AMNT$L            VALOR,
    ZNSLS401.T$ITPE$C            ID_TIPO_ENTREGA,
    ZNSLS002.T$DSCA$C            DESCR_TIPO_ENTREGA,

    ( select znfmd061.t$dzon$c
        from baandb.tznfmd062601 znfmd062,
             baandb.tznfmd061601 znfmd061
       where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c
         and znfmd062.t$cono$c = znfmd630.t$cono$c
         and znfmd062.t$cepd$c <= tccom130.t$pstc
         and znfmd062.t$cepa$c >= tccom130.t$pstc
         and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c
         and znfmd061.t$cono$c = znfmd062.t$cono$c
         and znfmd061.t$creg$c = znfmd062.t$creg$c
         and rownum = 1 )        REGIAO,
		
    TDSLS400.T$ORNO              ORDEM_VENDA,
    ZNFMD630.T$NCAR$C            NR_CARGA

FROM       BAANDB.tznfmd630601 znfmd630

INNER JOIN BAANDB.TTCMCS080601 TCMCS080
        ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C

INNER JOIN BAANDB.TZNFMD060601 ZNFMD060
        ON ZNFMD060.T$CFRW$C = ZNFMD630.T$CFRW$C
       AND ZNFMD060.T$CONO$C = ZNFMD630.T$CONO$C

INNER JOIN BAANDB.TZNFMD001601 ZNFMD001
        ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C

INNER JOIN BAANDB.TTDSLS400601 TDSLS400
        ON TDSLS400.T$ORNO  = ZNFMD630.T$ORNO$C

INNER JOIN BAANDB.TCISLI940601 CISLI940
        ON CISLI940.T$FIRE$L = ZNFMD630.T$FIRE$C

 LEFT JOIN BAANDB.TTCCOM130601 TCCOM130
        ON TCCOM130.T$CADR   =  CISLI940.T$STOA$L

INNER JOIN BAANDB.TTDSLS094601 TDSLS094
        ON TDSLS094.T$SOTP  = TDSLS400.T$SOTP

INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C
               FROM BAANDB.TZNSLS004601 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$ORNO$C ) ZNSLS004
        ON ZNSLS004.T$ORNO$C = ZNFMD630.T$ORNO$C

INNER JOIN ( SELECT A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C
               FROM BAANDB.tznsls401601 A
           GROUP BY A.T$NCIA$C,
                    A.T$UNEG$C,
                    A.T$PECL$C,
                    A.T$SQPD$C,
                    A.T$ENTR$C,
                    A.T$CIDE$C,
                    A.T$CEPE$C,
                    A.T$UFEN$C,
                    A.T$NOME$C,
                    A.T$DTEP$C,
                    A.T$IDPA$C,
                    A.T$ITPE$C ) znsls401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C

INNER JOIN BAANDB.TZNSLS002601 ZNSLS002
        ON ZNSLS002.T$TPEN$C  = ZNSLS401.T$ITPE$C

INNER JOIN BAANDB.tznsls400601 znsls400
        ON znsls401.t$ncia$c = znsls400.t$ncia$c
       AND znsls401.t$uneg$c = znsls400.t$uneg$c
       AND znsls401.t$pecl$c = znsls400.t$pecl$c
       AND znsls401.t$sqpd$c = znsls400.t$sqpd$c

INNER JOIN BAANDB.TZNINT002601 ZNINT002
        ON ZNINT002.T$NCIA$C = ZNSLS400.T$NCIA$C
       AND ZNINT002.T$UNEG$C = ZNSLS400.T$UNEG$C

WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataCompra_De
          AND :DataCompra_Ate
  AND CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'
             THEN 'F'
           ELSE   'P'
      END IN (:Status)
  AND ZNSLS401.T$ITPE$C IN (:TipoEntrega)
  
  
=

" SELECT  " &
"   DISTINCT  " &
"     znfmd630.t$pecl$c            ENTREGA,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                  DATA_COMPRA,  " &
"  " &
"     ( SELECT znfmd640.t$coci$c  " &
"         FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"        WHERE znfmd640.t$date$c = ( select max(znfmd640X.t$date$c)  " &
"                                      from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640X  " &
"                                     where znfmd640X.t$fili$c = znfmd640.t$fili$c  " &
"                                       and znfmd640X.t$etiq$c = znfmd640.t$etiq$c)  " &
"          AND znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"          AND znfmd640.t$etiq$c = znfmd630.t$etiq$c  " &
"          AND ROWNUM = 1 )        ULT_PONTO,  " &
"  " &
"     ( SELECT znfmd030d.t$dsci$c  " &
"         FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640d,  " &
"              BAANDB.tznfmd030" + Parameters!Compania.Value + " znfmd030d  " &
"        WHERE znfmd640d.t$date$c = ( select max(znfmd640x.t$date$c)  " &
"                                       from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640x  " &
"                                      where znfmd640x.t$fili$c = znfmd640d.t$fili$c  " &                                   
"                                        and znfmd640x.t$etiq$c = znfmd640d.t$etiq$c)  " &
"          AND znfmd640d.t$fili$c = znfmd630.t$fili$c  " &
"          AND znfmd640d.t$etiq$c = znfmd630.t$etiq$c  " &
"          AND znfmd030d.t$ocin$c = znfmd640d.t$coci$c  " &
"          AND ROWNUM = 1 )        DESCRICAO,  " &
"  " &
"     ZNFMD630.T$CFRW$C            ID_TRANSPORTADORA,  " &
"     TCMCS080.T$DSCA              DESCR_TRANSPORTADORA,  " &
"     ZNFMD630.T$CONO$C            ID_CONTRATO,  " &
"     ZNFMD060.T$CDES$C            DESCR_CONTRATO,  " &
"     ZNFMD630.T$FILI$C            ID_FILIAL,  " &
"     ZNFMD001.T$DSCA$C            DESCR_FILIAL,  " &
"     ZNFMD630.T$DOCN$C            NF,  " &
"     ZNFMD630.T$SERI$C            SERIE,  " &
"     TDSLS400.T$SOTP              ID_TIPO_ORDEM,  " &
"     TDSLS094.T$DSCA              DESCR_TIPO_ORDEM,  " &
"     ZNSLS400.T$UNEG$C            ID_UNEG,  " &
"     ZNINT002.T$DESC$C            DESCR_UNEG,  " &
"  " &
"     ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c),  " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"        where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"          and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                  DATA_OCORRENCIA,  " &
"  " &
"     ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$udat$c),  " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"        where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"          and znfmd640.t$etiq$c = znfmd630.t$etiq$c )  " &
"                                  DATA_PROCESSAMENTO,  " &
" 								  " &
"     CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'  " &
"            THEN 'FINALIZADO'  " &
"          ELSE   'PENDENTE'  " &
"     END                          SITUACAO,  " &
"  " &
"     ZNSLS401.T$CIDE$C            CIDADE,  " &
"     ZNSLS401.T$CEPE$C            CEP,  " &
"     ZNSLS401.T$UFEN$C            UF,  " &
"     ZNSLS401.T$NOME$C            DESTINATARIO,  " &
"  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                  DATA_PROMETIDA,  " &
"  " &
"     CASE WHEN ZNSLS401.T$IDPA$C = '1'  " &
"            THEN 'Manhã'  " &
"          WHEN ZNSLS401.T$IDPA$C = '2'  " &
"            THEN 'Tarde'  " &
"          WHEN ZNSLS401.T$IDPA$C = '3'  " &
"            THEN 'Noite'  " &
"          ELSE ''  " &
"     END                          PERIODO,  " &
"     ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(znfmd640.t$date$c),  " &
"                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)  " &
"         from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"        where znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"          and znfmd640.t$etiq$c = znfmd630.t$etiq$c  " &
"          and znfmd640.t$coct$c = 'ETR')  " &
"                                  DATA_EXPED,  " &
" 								  " &
"     CISLI940.T$AMNT$L            VALOR,  " &
"     ZNSLS401.T$ITPE$C            ID_TIPO_ENTREGA,  " &
"     ZNSLS002.T$DSCA$C            DESCR_TIPO_ENTREGA,  " &
"  " &
"     ( select znfmd061.t$dzon$c  " &
"         from baandb.tznfmd062" + Parameters!Compania.Value + " znfmd062,  " &
"              baandb.tznfmd061" + Parameters!Compania.Value + " znfmd061  " &
"        where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"          and znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"          and znfmd062.t$cepd$c <= tccom130.t$pstc  " &
"          and znfmd062.t$cepa$c >= tccom130.t$pstc  " &
"          and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c  " &
"          and znfmd061.t$cono$c = znfmd062.t$cono$c  " &
"          and znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"          and rownum = 1 )        REGIAO,  " &
" 		  " &
"     TDSLS400.T$ORNO              ORDEM_VENDA,  " &
"     ZNFMD630.T$NCAR$C            NR_CARGA  " &
"  " &
" FROM       BAANDB.tznfmd630" + Parameters!Compania.Value + " znfmd630  " &
"  " &
" INNER JOIN BAANDB.TTCMCS080" + Parameters!Compania.Value + " TCMCS080  " &
"         ON TCMCS080.T$CFRW = ZNFMD630.T$CFRW$C  " &
"  " &
" INNER JOIN BAANDB.TZNFMD060" + Parameters!Compania.Value + " ZNFMD060  " &
"         ON ZNFMD060.T$CFRW$C = ZNFMD630.T$CFRW$C  " &
"        AND ZNFMD060.T$CONO$C = ZNFMD630.T$CONO$C  " &
"  " &
" INNER JOIN BAANDB.TZNFMD001" + Parameters!Compania.Value + " ZNFMD001  " &
"         ON ZNFMD001.T$FILI$C = ZNFMD630.T$FILI$C  " &
"  " &
" INNER JOIN BAANDB.TTDSLS400" + Parameters!Compania.Value + " TDSLS400  " &
"         ON TDSLS400.T$ORNO  = ZNFMD630.T$ORNO$C  " &
"  " &
" INNER JOIN BAANDB.TCISLI940" + Parameters!Compania.Value + " CISLI940  " &
"         ON CISLI940.T$FIRE$L = ZNFMD630.T$FIRE$C  " &
"  " &
"  LEFT JOIN BAANDB.TTCCOM130" + Parameters!Compania.Value + " TCCOM130  " &
"         ON TCCOM130.T$CADR   =  CISLI940.T$STOA$L  " &
"  " &
" INNER JOIN BAANDB.TTDSLS094" + Parameters!Compania.Value + " TDSLS094  " &
"         ON TDSLS094.T$SOTP  = TDSLS400.T$SOTP  " &
"  " &
" INNER JOIN ( SELECT A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$ORNO$C  " &
"                FROM BAANDB.TZNSLS004" + Parameters!Compania.Value + " A  " &
"            GROUP BY A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$ORNO$C ) ZNSLS004  " &
"         ON ZNSLS004.T$ORNO$C = ZNFMD630.T$ORNO$C  " &
"  " &
" INNER JOIN ( SELECT A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$CIDE$C,  " &
"                     A.T$CEPE$C,  " &
"                     A.T$UFEN$C,  " &
"                     A.T$NOME$C,  " &
"                     A.T$DTEP$C,  " &
"                     A.T$IDPA$C,  " &
"                     A.T$ITPE$C  " &
"                FROM BAANDB.tznsls401" + Parameters!Compania.Value + " A  " &
"            GROUP BY A.T$NCIA$C,  " &
"                     A.T$UNEG$C,  " &
"                     A.T$PECL$C,  " &
"                     A.T$SQPD$C,  " &
"                     A.T$ENTR$C,  " &
"                     A.T$CIDE$C,  " &
"                     A.T$CEPE$C,  " &
"                     A.T$UFEN$C,  " &
"                     A.T$NOME$C,  " &
"                     A.T$DTEP$C,  " &
"                     A.T$IDPA$C,  " &
"                     A.T$ITPE$C ) znsls401  " &
"         ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C  " &
"        AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C  " &
"        AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C  " &
"        AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C  " &
"        AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C  " &
"  " &
" INNER JOIN BAANDB.TZNSLS002" + Parameters!Compania.Value + " ZNSLS002  " &
"         ON ZNSLS002.T$TPEN$C  = ZNSLS401.T$ITPE$C  " &
"  " &
" INNER JOIN BAANDB.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"         ON znsls401.t$ncia$c = znsls400.t$ncia$c  " &
"        AND znsls401.t$uneg$c = znsls400.t$uneg$c  " &
"        AND znsls401.t$pecl$c = znsls400.t$pecl$c  " &
"        AND znsls401.t$sqpd$c = znsls400.t$sqpd$c  " &
"  " &
" INNER JOIN BAANDB.TZNINT002" + Parameters!Compania.Value + " ZNINT002  " &
"         ON ZNINT002.T$NCIA$C = ZNSLS400.T$NCIA$C  " &
"        AND ZNINT002.T$UNEG$C = ZNSLS400.T$UNEG$C  " &
"  " &
" WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,  " &
"               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       BETWEEN :DataCompra_De  " &
"           AND :DataCompra_Ate  " &
"   AND CASE WHEN TO_CHAR(ZNFMD630.T$STAT$C) = 'F'  " &
"              THEN 'F'  " &
"            ELSE   'P'  " &
"       END IN (" + Replace(("'" + JOIN(Parameters!Status.Value, "',") + "'"),",",",'") + ") " &
"   AND ZNSLS401.T$ITPE$C IN (" + JOIN(Parameters!TipoEntrega.Value, ", ") + ") "