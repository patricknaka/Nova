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

             znsls410.CODE_OCORRENCIA    OCORRENCIA,
             znsls410.DESC_OCORRENCIA    DESCRICAO,
             CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR( znsls410.DATA_OCORRENCIA,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE)
                                DATA_OCORRENCIA,


             CASE WHEN znfmd030.t$finz$c = 1
                    THEN 'F'
                  ELSE   'P'
             END                SITUACAO,
             znsls401.t$cide$c  CIDADE,
             znsls401.t$cepe$c  CEP,
             znsls401.t$ufen$c  UF,
             znsls401.t$nome$c  DESTINATARIO,

             CASE WHEN Trunc(tdsls401.t$prdt) = '01/01/1970'
                    THEN NULL
                  ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'),
                         'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
             END                DATA_PROMETIDA,

             ( SELECT MAX(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(A.t$date$c,
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone 'America/Sao_Paulo') AS DATE))
                 FROM BAANDB.tznfmd640301 A
                WHERE A.T$FILI$C = ZNFMD630.T$FILI$C
                  AND A.T$ETIQ$C = ZNFMD630.T$ETIQ$C
                  AND A.T$COCI$C = 'ETR' )
                                 DATA_EXPEDICAO,

             CASE WHEN TRUNC(znfmd630.t$dtpe$c) <= TO_DATE('01/01/1970','DD/MM/YYYY')
                    THEN NULL
                  ELSE   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtpe$c, 'DD-MON-YYYY HH24:MI:SS'),
                           'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
             END                DATA_PREVISTA,

             cisli940.t$amnt$l  VALOR,

             ( select znfmd061.t$dzon$c
                 from baandb.tznfmd062301 znfmd062,
                      baandb.tznfmd061301 znfmd061
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

             CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l,
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE) 
                                DT_EMISSAO,
             ZNSLS401.T$PZTR$C  TRANSIT_TIME,
             ZNSLS401.T$PZCD$C  PRAZO_CD,
             CASE WHEN ZNSLS400.T$SIGE$C = 1
                    THEN 'Sim'
                  ELSE   'Não'
              END               PEDIDO_SIGE,

             ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$udat$c, 'DD-MON-YYYY HH24:MI:SS'),
                        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)
                 FROM BAANDB.tznfmd640301 znfmd640
                WHERE znfmd640.t$date$c = ( select max(znfmd640.t$date$c)
                                              from BAANDB.tznfmd640301 znfmd640
                                             where znfmd640.t$fili$c = znfmd630.t$fili$c
                                               and znfmd640.t$etiq$c = znfmd630.t$etiq$c )
                  AND znfmd640.t$fili$c = znfmd630.t$fili$c
                  AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
                  AND RowNum = 1 )
                                DT_INSERCAO,

CASE WHEN znfmd630.t$dtco$c > '01/01/1975' then
CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630.t$dtco$c, 'DD-MON-YYYY HH24:MI:SS'),
                        'DD-MON-YYYY HH24:MI:SS'), 'GMT') AT time zone 'America/Sao_Paulo') AS DATE)    
    ELSE NULL
END                             DT_CORRIGIDA             

  FROM       baandb.tcisli940301 cisli940  
  
  INNER JOIN BAANDB.tznfmd630301 znfmd630
          ON cisli940.t$fire$l = znfmd630.t$fire$c
         AND cisli940.t$docn$l = znfmd630.t$docn$c
         AND cisli940.t$seri$l = znfmd630.t$seri$c

inner join  baandb.tznfmd640301 znfmd640
on  znfmd640.t$fili$c = znfmd630.t$fili$c 
AND znfmd640.t$etiq$c = znfmd630.t$etiq$c
and znfmd630.t$torg$c = znfmd640.t$torg$c

  
  INNER JOIN BAANDB.tznsls004301 znsls004
          ON znsls004.t$orno$c = znfmd630.t$orno$c

  INNER JOIN BAANDB.tznsls401301 znsls401
          ON znsls401.t$ncia$c = znsls004.t$ncia$c
         AND znsls401.t$uneg$c = znsls004.t$uneg$c
         AND znsls401.t$pecl$c = znsls004.t$pecl$c
         AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
         AND znsls401.t$entr$c = znsls004.t$entr$c
         AND znsls401.t$sequ$c = znsls004.t$sequ$c

   LEFT JOIN baandb.ttdsls400301 tdsls400
          ON tdsls400.t$orno = znsls401.t$orno$c

   LEFT JOIN baandb.ttdsls401301 tdsls401
          ON tdsls401.t$orno = tdsls400.t$orno

  INNER JOIN BAANDB.tznsls400301 znsls400
          ON znsls400.t$ncia$c = znsls004.t$ncia$c
         AND znsls400.t$uneg$c = znsls004.t$uneg$c
         AND znsls400.t$pecl$c = znsls004.t$pecl$c
         AND znsls400.t$sqpd$c = znsls004.t$sqpd$c

  INNER JOIN BAANDB.tznint002301 znint002
          ON znint002.t$ncia$c = znsls401.t$ncia$c
         AND znint002.t$uneg$c = znsls401.t$uneg$c

  INNER JOIN BAANDB.tznsls002301 znsls002
          ON znsls002.t$tpen$c = znsls401.t$itpe$c

   LEFT JOIN BAANDB.tznfmd060301 znfmd060
          ON znfmd060.t$cfrw$c = znfmd630.t$cfrw$c
         AND znfmd060.t$cono$c = znfmd630.t$cono$c

   LEFT JOIN BAANDB.ttcmcs080301 tcmcs080
          ON tcmcs080.t$cfrw = znfmd630.t$cfrw$c

   LEFT JOIN baandb.ttccom130301 tccom130
          ON tccom130.t$cadr = cisli940.t$stoa$l

   LEFT JOIN ( SELECT d.t$cnst CNST,
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

  INNER JOIN ( select znsls410.t$poco$c CODE_OCORRENCIA
                    , znmcs002.t$desc$c DESC_OCORRENCIA
                    , znsls410.t$dtoc$c DATA_OCORRENCIA
                    , znsls410.t$ncia$c
                    , znsls410.t$uneg$c
                    , znsls410.t$pecl$c
                    , znsls410.t$sqpd$c
                    , znsls410.t$entr$c
                 from baandb.tznsls410301 znsls410
           inner join baandb.tznmcs002301 znmcs002
                   on znmcs002.t$poco$c = znsls410.t$poco$c
                where znsls410.t$seqn$c = ( select max(a.t$seqn$c)  
                                             from baandb.tznsls410301 a  
                                            where znsls410.t$entr$c = a.t$entr$c ) ) znsls410
          ON znsls410.t$ncia$c = znsls004.t$ncia$c
         AND znsls410.t$uneg$c = znsls004.t$uneg$c
         AND znsls410.t$pecl$c = znsls004.t$pecl$c
         AND znsls410.t$sqpd$c = znsls004.t$sqpd$c
         AND znsls410.t$entr$c = znsls004.t$entr$c
  
  LEFT JOIN BAANDB.tznfmd030601 znfmd030
         ON znfmd030.t$ocin$c = znsls410.CODE_OCORRENCIA
  
  
WHERE 
     znfmd640.t$torg$c != 7
and  znsls410.CODE_OCORRENCIA IN ('PIC','PZC','DNF','GAL','LFE','ARE','ARO','FIS','ROT','DDL','CME','ENL','ETR','POT','DIE','PNR','PRT','TRN','REE','SEF','EA1','EA2','EA3','CXP','AGE','NAP','RET','PRE','DRE','TRD','FER','CHU','MPD')
        ) Q1
where Trunc(Q1.DATA_EXPEDICAO)
      Between :DataExpedicaoDe
          And :DataExpedicaoAte
 and Q1.CODI_TRANSP IN (:Transportadora)
  and NVL(TRIM(Q1.SITUACAO), 'P') IN (:Situacao)
  and Q1.ID_TIPO_ENTREGA IN (:TipoEntrega)
 
ORDER BY Q1.DATA_EXPEDICAO, Q1.NUME_ENTREGA
