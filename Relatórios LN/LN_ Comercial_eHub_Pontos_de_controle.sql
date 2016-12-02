select
        znsls400.t$pecl$c                     PEDIDO_CLIENTE,
        znsls410.t$entr$c                     ENTREGA,
        znsls002.t$dsca$c                     TIPO_ENTREGA,
        znsls400.t$nomf$c                     NOME_CLIENTE,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
                                              DATA_PLANEJADA_RECEB,
        TO_CHAR(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date), 'HH24:MI:SS')
                                              HORA_RECEB,
        znsls410.t$poco$c                     PONTO_CONTROLE,
        znmcs002.t$desc$c                     DESCRICAO,
        cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
                                              DATA_OCORRENCIA,
        TO_CHAR(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410.t$dtoc$c, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date), 'HH24:MI:SS')
                                              HORA_OCORRENCIA

from    baandb.tznsls400601 znsls400

inner join  ( select  a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$poco$c,
                      a.t$dtoc$c
              from    baandb.tznsls410601 a
              where   a.t$poco$c in ('CME', 'DDL',
                                     'ES1', 'EA2',
                                     'EA3', 'ENL',
                                     'IDE', 'TEN') ) znsls410
        on  znsls410.t$ncia$c = znsls400.t$ncia$c
       and  znsls410.t$uneg$c = znsls400.t$uneg$c
       and  znsls410.t$pecl$c = znsls400.t$pecl$c
       and  znsls410.t$sqpd$c = znsls400.t$sqpd$c

inner join  baandb.tznmcs002301 znmcs002    -- Tabela compartilhada na Cia 301
        on  znmcs002.t$poco$c = znsls410.t$poco$c

inner join  (select  a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$orno$c,
                     a.t$itpe$c
             from   baandb.tznsls401601 a
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$orno$c,
                      a.t$itpe$c) znsls401
        on  znsls401.t$ncia$c = znsls400.t$ncia$c
       and  znsls401.t$uneg$c = znsls400.t$uneg$c
       and  znsls401.t$pecl$c = znsls400.t$pecl$c
       and  znsls401.t$sqpd$c = znsls400.t$sqpd$c

inner join  baandb.tznsls002601 znsls002
        on  znsls002.t$tpen$c = znsls401.t$itpe$c

inner join  baandb.ttdsls400601 tdsls400
        on  tdsls400.t$orno = znsls401.t$orno$c

where   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date))
        between :DATA_PLANEJADA_RECEB_DE and :DATA_PLANEJADA_RECEB_ATE
