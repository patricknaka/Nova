select Q1.*
  from ( SELECT
           DISTINCT
             tcmcs080.t$cfrw    CODI_TRANSP,
             tcmcs080.t$dsca    DESC_TRANSP,
             znfmd060.t$cdes$c  DESC_CONTRATO,
             znsls401.t$entr$c  NUME_ENTREGA,
             znfmd630.t$etiq$c  NUME_ETIQUETA,
             znfmd630.t$fili$c  NUME_FILIAL,
             cisli940.t$docn$l  NUME_NOTA,
             cisli940.t$seri$l  NUME_SERIE,
             cisli940.t$fdty$l  TIPO_ORDEM,
             FGET.              DESC_TIPO_ORDEM,
             cisli940.t$gamt$l  VL_MERCADORIA,
             znsls401.t$uneg$c  UNINEG,

            znfmd640.t$coci$c   OCORRENCIA,
            znfmd640.t$dotr$c   DESCRICAO,
            znfmd640.t$date$c   DATA_OCORRENCIA,

             CASE WHEN znfmd630.t$stat$c = 2
                    THEN 'F'
                  ELSE   'P'
             END                SITUACAO,
             znsls401.t$cide$c  CIDADE,
             znsls401.t$cepe$c  CEP,
             znsls401.t$ufen$c  UF,
             znsls401.t$nome$c  DESTINATARIO,

             ( SELECT MAX(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.t$date$c,
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone 'America/Sao_Paulo') AS DATE))
                 FROM BAANDB.tznfmd640601 A
                WHERE A.T$FILI$C = ZNFMD630.T$FILI$C
                  AND A.T$ETIQ$C = ZNFMD630.T$ETIQ$C
                  AND A.T$COCI$C = 'ETR' )
                                 DATA_EXPEDICAO,

             CASE WHEN Trunc(znsls401.t$dtep$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                    THEN NULL	 
                  ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'),			 
                         'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  			 
             END                  DATA_PROMETIDA,

             CASE WHEN TRUNC(znfmd630.t$dtco$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                    Then null
                  Else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'), 
                         'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
             END                  DATA_CORRIGIDA,

             CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                    THEN NULL
                  ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'), 
                           'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
             END                  DATA_PREVISTA,

             cisli940.t$amnt$l  VALOR,

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
                  and rownum = 1 )
                                REGIAO,

             znsls401.t$itpe$c  ID_TIPO_ENTREGA,
             znsls002.t$dsca$c  DESCR_TIPO_ENTREGA,
             znfmd630.t$orno$c  ORDEM_VENDA,
             znint002.t$uneg$c  UNIDADE_NEG,
             znint002.t$desc$c  DESCR_UNIDADE_NEG,
             znsls004.t$sqpd$c  SEQ_PEDIDO,

             ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(A.T$DTOC$C),
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone 'America/Sao_Paulo') AS DATE)
                 FROM BAANDB.TZNSLS410601 A
                WHERE A.t$ncia$c = ZNSLS004.t$ncia$c
                  AND A.t$uneg$c = ZNSLS004.t$uneg$c
                  AND A.t$pecl$c = ZNSLS004.t$pecl$c
                  AND A.t$sqpd$c = ZNSLS004.t$sqpd$c
                  AND A.t$entr$c = ZNSLS004.t$entr$c )
                                DT_EMISSAO,

             ZNSLS401.T$PZTR$C  TRANSIT_TIME,
             ZNSLS401.T$PZCD$C  PRAZO_CD,
             CASE WHEN ZNSLS400.T$SIGE$C = 1
                    THEN 'Sim'
                  ELSE   'Não'
              END               PEDIDO_SIGE,

             znfmd640.t$udat$c  DT_INSERCAO

  FROM       BAANDB.tznfmd630601 znfmd630

  INNER JOIN BAANDB.tznsls004601 znsls004
          ON znsls004.t$orno$c = znfmd630.t$orno$c

  INNER JOIN BAANDB.tznsls401601 znsls401
          ON znsls401.t$ncia$c = znsls004.t$ncia$c
         AND znsls401.t$uneg$c = znsls004.t$uneg$c
         AND znsls401.t$pecl$c = znsls004.t$pecl$c
         AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
         AND znsls401.t$entr$c = znsls004.t$entr$c
         AND znsls401.t$sequ$c = znsls004.t$sequ$c

   LEFT JOIN baandb.ttdsls400601 tdsls400
          ON tdsls400.t$orno = znsls401.t$orno$c

  INNER JOIN BAANDB.tznsls400601 znsls400
          ON znsls400.t$ncia$c = znsls004.t$ncia$c
         AND znsls400.t$uneg$c = znsls004.t$uneg$c
         AND znsls400.t$pecl$c = znsls004.t$pecl$c
         AND znsls400.t$sqpd$c = znsls004.t$sqpd$c

  INNER JOIN BAANDB.tznint002601 znint002
          ON znint002.t$ncia$c = znsls401.t$ncia$c
         AND znint002.t$uneg$c = znsls401.t$uneg$c

  INNER JOIN BAANDB.tznsls002601 znsls002
          ON znsls002.t$tpen$c = znsls401.t$itpe$c

   LEFT JOIN BAANDB.tznfmd060601 znfmd060
          ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
         AND znfmd060.t$cono$c = znfmd630.t$cono$c

   LEFT JOIN BAANDB.ttcmcs080601 tcmcs080
          ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

  INNER JOIN baandb.tcisli940601 cisli940
          ON cisli940.t$fire$l = znfmd630.t$fire$c
         AND cisli940.t$docn$l = znfmd630.t$docn$c
         AND cisli940.t$seri$l = znfmd630.t$seri$c

   LEFT JOIN baandb.ttccom130601 tccom130
          ON tccom130.t$cadr = cisli940.t$stoa$l

  INNER JOIN ( SELECT d.t$cnst CNST,
                      l.t$desc DESC_TIPO_ORDEM
                 FROM baandb.tttadv401000 d, baandb.tttadv140000 l
                WHERE d.t$cpac = 'ci'
                  AND d.t$cdom = 'sli.tdff.l'
                  AND l.t$clan = 'p'
                  AND l.t$cpac = 'ci'
                  AND l.t$clab = d.t$za_clab
                  AND rpad(d.t$vers,4) ||
                      rpad(d.t$rele,2) ||
                      rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                      rpad(l1.t$rele,2) ||
                                                      rpad(l1.t$cust,4))
                                             from baandb.tttadv401000 l1
                                            where l1.t$cpac = d.t$cpac
                                              and l1.t$cdom = d.t$cdom )
                  AND rpad(l.t$vers,4) ||
                      rpad(l.t$rele,2) ||
                      rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                      rpad(l1.t$rele,2) ||
                                                      rpad(l1.t$cust,4))
                                             from baandb.tttadv140000 l1
                                            where l1.t$clab = l.t$clab
                                              and l1.t$clan = l.t$clan
                                              and l1.t$cpac = l.t$cpac ) ) FGET
    ON FGET.CNST = cisli940.t$fdty$l

  INNER JOIN ( SELECT znfmd640.t$coci$c,
                      znfmd640.t$fili$c,
                      znfmd640.t$etiq$c
                 FROM BAANDB.tznfmd640601 znfmd640
                WHERE znfmd640.t$coci$c = 'ETR' ) fmd640
          ON fmd640.t$fili$c = znfmd630.t$fili$c
         AND fmd640.t$etiq$c = znfmd630.t$etiq$c


  INNER JOIN ( select znfmd640.t$fili$c,
                      znfmd640.t$etiq$c,
                      znfmd640.t$coci$c,
                      znfmd040.t$cfrw$c,
                      znfmd040.t$dotr$c,
                      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),			
                        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	 t$udat$c,
                      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'),			
                        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	 t$date$c		
                  from BAANDB.tznfmd640601 znfmd640
             left join BAANDB.tznfmd040601 znfmd040
                    on znfmd040.t$ocin$c = znfmd640.t$coci$c
                 where znfmd640.t$coci$c = ( select max(fmd640.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY fmd640.t$date$C, fmd640.t$udat$C)
                                               from BAANDB.tznfmd640601 fmd640
                                              where znfmd640.t$fili$c = fmd640.t$fili$c
                                                and znfmd640.t$etiq$c = fmd640.t$etiq$c )
                   and znfmd640.t$coci$c IN ('ARE','ARO','FIS','ROT','DDL','CME','ENL','ETR','POT','DIE','PNR','PRT','TRN','REE','SEF','EA1','EA2','EA3','CXP','AGE','NAP','RET','PRE','DRE','TRD','FER','CHU','MPD' ) ) znfmd640
          ON znfmd640.t$fili$c = znfmd630.t$fili$c
         AND znfmd640.t$etiq$c = znfmd630.t$etiq$c ) Q1

where Trunc(Q1.DT_EMISSAO)
      Between :DataEmissaoDe
          And :DataEmissaoAte
  and Q1.CODI_TRANSP IN (:Transportadora)
  and NVL(TRIM(Q1.SITUACAO), 'P') IN (:Situacao.Value)
  and Q1.ID_TIPO_ENTREGA IN (:TipoEntrega.Value)
  
  
  
=

" select Q1.*  " &
"   from ( SELECT  " &
"            DISTINCT  " &
"              tcmcs080.t$cfrw    CODI_TRANSP,  " &
"              tcmcs080.t$dsca    DESC_TRANSP,  " &
"              znfmd060.t$cdes$c  DESC_CONTRATO,  " &
"              znsls401.t$entr$c  NUME_ENTREGA,  " &
"              znfmd630.t$etiq$c  NUME_ETIQUETA,  " &
"              znfmd630.t$fili$c  NUME_FILIAL,  " &
"              cisli940.t$docn$l  NUME_NOTA,  " &
"              cisli940.t$seri$l  NUME_SERIE,  " &
"              cisli940.t$fdty$l  TIPO_ORDEM,  " &
"              FGET.              DESC_TIPO_ORDEM,  " &
"              cisli940.t$gamt$l  VL_MERCADORIA,  " &
"              znsls401.t$uneg$c  UNINEG,  " &
"  " &
"             znfmd640.t$coci$c   OCORRENCIA,  " &
"             znfmd640.t$dotr$c   DESCRICAO,  " &
"             znfmd640.t$date$c   DATA_OCORRENCIA,  " &
"  " &
"              CASE WHEN znfmd630.t$stat$c = 2  " &
"                     THEN 'F'  " &
"                   ELSE   'P'  " &
"              END                SITUACAO,  " &
"              znsls401.t$cide$c  CIDADE,  " &
"              znsls401.t$cepe$c  CEP,  " &
"              znsls401.t$ufen$c  UF,  " &
"              znsls401.t$nome$c  DESTINATARIO,  " &
"  " &
"              CASE WHEN Trunc(znsls401.t$dtep$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')  " &
"                     THEN NULL  " &
"                   ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"                          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"              END                  DATA_PROMETIDA,  " &
"  " &
"              CASE WHEN TRUNC(znfmd630.t$dtco$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')  " &
"                     Then null  " &
"                   Else CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"                          'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"              END                  DATA_CORRIGIDA,  " &
"  " &
"              CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')  " &
"                     THEN NULL  " &
"                   ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'),  " &
"                            'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)  " &
"              END                  DATA_PREVISTA,  " &
"  " &
"              ( SELECT MAX(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.t$date$c,  " &
"                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                          AT time zone 'America/Sao_Paulo') AS DATE))  " &
"                  FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " A  " &
"                 WHERE A.T$FILI$C = ZNFMD630.T$FILI$C  " &
"                   AND A.T$ETIQ$C = ZNFMD630.T$ETIQ$C  " &
"                   AND A.T$COCI$C = 'ETR' )  " &
"                                  DATA_EXPEDICAO,  " &
"  " &
"              cisli940.t$amnt$l  VALOR,  " &
"  " &
"              ( select znfmd061.t$dzon$c  " &
"                  from baandb.tznfmd062" + Parameters!Compania.Value + " znfmd062,  " &
"                       baandb.tznfmd061" + Parameters!Compania.Value + " znfmd061  " &
"                 where znfmd062.t$cfrw$c = znfmd630.t$cfrw$c  " &
"                   and znfmd062.t$cono$c = znfmd630.t$cono$c  " &
"                   and znfmd062.t$cepd$c <= tccom130.t$pstc  " &
"                   and znfmd062.t$cepa$c >= tccom130.t$pstc  " &
"                   and znfmd061.t$cfrw$c = znfmd062.t$cfrw$c  " &
"                   and znfmd061.t$cono$c = znfmd062.t$cono$c  " &
"                   and znfmd061.t$creg$c = znfmd062.t$creg$c  " &
"                   and rownum = 1 )  " &
"                                 REGIAO,  " &
"  " &
"              znsls401.t$itpe$c  ID_TIPO_ENTREGA,  " &
"              znsls002.t$dsca$c  DESCR_TIPO_ENTREGA,  " &
"              znfmd630.t$orno$c  ORDEM_VENDA,  " &
"              znint002.t$uneg$c  UNIDADE_NEG,  " &
"              znint002.t$desc$c  DESCR_UNIDADE_NEG,  " &
"              znsls004.t$sqpd$c  SEQ_PEDIDO,  " &
"  " &
"              ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(A.T$DTOC$C),  " &
"                        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                          AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                  FROM BAANDB.TZNSLS410" + Parameters!Compania.Value + " A  " &
"                 WHERE A.t$ncia$c = ZNSLS004.t$ncia$c  " &
"                   AND A.t$uneg$c = ZNSLS004.t$uneg$c  " &
"                   AND A.t$pecl$c = ZNSLS004.t$pecl$c  " &
"                   AND A.t$sqpd$c = ZNSLS004.t$sqpd$c  " &
"                   AND A.t$entr$c = ZNSLS004.t$entr$c )  " &
"                                 DT_EMISSAO,  " &
"  " &
"              ZNSLS401.T$PZTR$C  TRANSIT_TIME,  " &
"              ZNSLS401.T$PZCD$C  PRAZO_CD,  " &
"              CASE WHEN ZNSLS400.T$SIGE$C = 1  " &
"                     THEN 'Sim'  " &
"                   ELSE   'Não'  " &
"               END               PEDIDO_SIGE,  " &
"  " &
"              znfmd640.t$udat$c  DT_INSERCAO  " &
"  " &
"   FROM       BAANDB.tznfmd630" + Parameters!Compania.Value + " znfmd630  " &
"  " &
"   INNER JOIN BAANDB.tznsls004" + Parameters!Compania.Value + " znsls004  " &
"           ON znsls004.t$orno$c = znfmd630.t$orno$c  " &
"  " &
"   INNER JOIN BAANDB.tznsls401" + Parameters!Compania.Value + " znsls401  " &
"           ON znsls401.t$ncia$c = znsls004.t$ncia$c  " &
"          AND znsls401.t$uneg$c = znsls004.t$uneg$c  " &
"          AND znsls401.t$pecl$c = znsls004.t$pecl$c  " &
"          AND znsls401.t$sqpd$c = znsls004.t$sqpd$c  " &
"          AND znsls401.t$entr$c = znsls004.t$entr$c  " &
"          AND znsls401.t$sequ$c = znsls004.t$sequ$c  " &
"  " &
"    LEFT JOIN baandb.ttdsls400" + Parameters!Compania.Value + " tdsls400  " &
"           ON tdsls400.t$orno = znsls401.t$orno$c  " &
"  " &
"   INNER JOIN BAANDB.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"           ON znsls400.t$ncia$c = znsls004.t$ncia$c  " &
"          AND znsls400.t$uneg$c = znsls004.t$uneg$c  " &
"          AND znsls400.t$pecl$c = znsls004.t$pecl$c  " &
"          AND znsls400.t$sqpd$c = znsls004.t$sqpd$c  " &
"  " &
"   INNER JOIN BAANDB.tznint002" + Parameters!Compania.Value + " znint002  " &
"           ON znint002.t$ncia$c = znsls401.t$ncia$c  " &
"          AND znint002.t$uneg$c = znsls401.t$uneg$c  " &
"  " &
"   INNER JOIN BAANDB.tznsls002" + Parameters!Compania.Value + " znsls002  " &
"           ON znsls002.t$tpen$c = znsls401.t$itpe$c  " &
"  " &
"    LEFT JOIN BAANDB.tznfmd060" + Parameters!Compania.Value + " znfmd060  " &
"           ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c  " &
"          AND znfmd060.t$cono$c = znfmd630.t$cono$c  " &
"  " &
"    LEFT JOIN BAANDB.ttcmcs080" + Parameters!Compania.Value + " tcmcs080  " &
"           ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
"   INNER JOIN baandb.tcisli940" + Parameters!Compania.Value + " cisli940  " &
"           ON cisli940.t$fire$l = znfmd630.t$fire$c  " &
"          AND cisli940.t$docn$l = znfmd630.t$docn$c  " &
"          AND cisli940.t$seri$l = znfmd630.t$seri$c  " &
"  " &
"    LEFT JOIN baandb.ttccom130" + Parameters!Compania.Value + " tccom130  " &
"           ON tccom130.t$cadr = cisli940.t$stoa$l  " &
"  " &
"   INNER JOIN ( SELECT d.t$cnst CNST,  " &
"                       l.t$desc DESC_TIPO_ORDEM  " &
"                  FROM baandb.tttadv401000 d, baandb.tttadv140000 l  " &
"                 WHERE d.t$cpac = 'ci'  " &
"                   AND d.t$cdom = 'sli.tdff.l'  " &
"                   AND l.t$clan = 'p'  " &
"                   AND l.t$cpac = 'ci'  " &
"                   AND l.t$clab = d.t$za_clab  " &
"                   AND rpad(d.t$vers,4) ||  " &
"                       rpad(d.t$rele,2) ||  " &
"                       rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                       rpad(l1.t$rele,2) ||  " &
"                                                       rpad(l1.t$cust,4))  " &
"                                              from baandb.tttadv401000 l1  " &
"                                             where l1.t$cpac = d.t$cpac  " &
"                                               and l1.t$cdom = d.t$cdom )  " &
"                   AND rpad(l.t$vers,4) ||  " &
"                       rpad(l.t$rele,2) ||  " &
"                       rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                       rpad(l1.t$rele,2) ||  " &
"                                                       rpad(l1.t$cust,4))  " &
"                                              from baandb.tttadv140000 l1  " &
"                                             where l1.t$clab = l.t$clab  " &
"                                               and l1.t$clan = l.t$clan  " &
"                                               and l1.t$cpac = l.t$cpac ) ) FGET  " &
"     ON FGET.CNST = cisli940.t$fdty$l  " &
"  " &
"   INNER JOIN ( SELECT znfmd640.t$coci$c,  " &
"                       znfmd640.t$fili$c,  " &
"                       znfmd640.t$etiq$c  " &
"                  FROM BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"                 WHERE znfmd640.t$coci$c = 'ETR' ) fmd640  " &
"           ON fmd640.t$fili$c = znfmd630.t$fili$c  " &
"          AND fmd640.t$etiq$c = znfmd630.t$etiq$c  " &
"  " &
"  " &
"   INNER JOIN ( select znfmd640.t$fili$c,  " &
"                       znfmd640.t$etiq$c,  " &
"                       znfmd640.t$coci$c,  " &
"                       znfmd040.t$cfrw$c,  " &
"                       znfmd040.t$dotr$c,  " &
"                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),			  " &
"                         'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	 t$udat$c,  " &
"                       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 'DD-MON-YYYY HH24:MI:SS'),			  " &
"                         'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)	 t$date$c		  " &
"                   from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640  " &
"              left join BAANDB.tznfmd040" + Parameters!Compania.Value + " znfmd040  " &
"                     on znfmd040.t$ocin$c = znfmd640.t$coci$c  " &
"                  where znfmd640.t$coci$c = ( select max(fmd640.t$coci$c) KEEP (DENSE_RANK LAST ORDER BY fmd640.t$date$C, fmd640.t$udat$C)  " &
"                                                from BAANDB.tznfmd640" + Parameters!Compania.Value + " fmd640  " &
"                                               where znfmd640.t$fili$c = fmd640.t$fili$c  " &
"                                                 and znfmd640.t$etiq$c = fmd640.t$etiq$c )  " &
"                    and znfmd640.t$coci$c IN ('ARE','ARO','FIS','ROT','DDL','CME','ENL','ETR','POT','DIE','PNR','PRT','TRN','REE','SEF','EA1','EA2','EA3','CXP','AGE','NAP','RET','PRE','DRE','TRD','FER','CHU','MPD' ) ) znfmd640  " &
"           ON znfmd640.t$fili$c = znfmd630.t$fili$c  " &
"          AND znfmd640.t$etiq$c = znfmd630.t$etiq$c ) Q1  " &
"  " &
" where Trunc(Q1.DT_EMISSAO)  " &
"       Between :DataEmissaoDe  " &
"           And :DataEmissaoAte  " &
"   and Q1.CODI_TRANSP IN (" + Replace(("'" + JOIN(Parameters!Transportadora.Value, "',") + "'"),",",",'") + ")  " &
"   and NVL(TRIM(Q1.SITUACAO), 'P') IN (" + Replace(("'" + JOIN(Parameters!Situacao.Value, "',") + "'"),",",",'") + ")  " &
"   and Q1.ID_TIPO_ENTREGA IN (" + Replace(("'" + JOIN(Parameters!TipoEntrega.Value, "',") + "'"),",",",'") + ") "