select  
        znsls401.t$pecl$c                        NRO_PEDIDO,
        cast((from_tz(to_timestamp(to_char(znsls400.t$dtem$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_PEDIDO,
        cast((from_tz(to_timestamp(to_char(znsls410_PAP.DATA_APROV,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_APROV_PEDIDO,
        znsls401.t$entr$c                        NRO_ENTREGA,
        znint002.t$desc$c                        BANDEIRA,
        znfmd630.t$orno$c                        ORDEM_DEVOLUCAO,
        cast((from_tz(to_timestamp(to_char(znsls410_POS.DT_EMISSAO,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_EMISSAO_POS,
        znfmd630.t$etiq$c                        CODIGO_POS,
        cast((from_tz(to_timestamp(to_char(( znsls410_POS.DT_EMISSAO  + 10),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_VENCIMENTO,
        znsls400.t$nomf$c                        NOME_CLIENTE,
        znsls400.t$fovn$c                        CPF,
        znsls400.t$uffa$c                        UF,
        tcibd001.t$dsca                          DESCRICAO_ITEM,
        case when znfmd640.STATUS = 'COP' then 'Produto Postado'
             when znfmd640.STATUS = 'DME' then 'Recebimento de Devolucao'
        else
             znmcs002.t$desc$c
        end                                      STATUS_POS,
        znfmd630.t$etiq$c                        RASTREAMENTO

from    baandb.tznfmd630301 znfmd630

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$itml$c
             from baandb.tznsls401301 a 
             where a.t$idor$c = 'TD'    -- Troca/Devolução
               and a.t$qtve$c < 0       -- Devolução
             group by a.t$ncia$c,
                      a.t$uneg$c,
	                    a.t$pecl$c,
	                    a.t$sqpd$c,
	                    a.t$entr$c,
                      a.t$itml$c) znsls401
        on to_char(znsls401.t$entr$c) = znfmd630.t$pecl$c

inner join baandb.tznsls400301 znsls400
        on znsls400.t$ncia$c = znsls401.t$ncia$c
       and znsls400.t$uneg$c = znsls401.t$uneg$c
       and znsls400.t$pecl$c = znsls401.t$pecl$c
       and znsls400.t$sqpd$c = znsls401.t$sqpd$c

inner join baandb.ttcibd001301 tcibd001
        on tcibd001.t$item = znsls401.t$itml$c

inner join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    max(a.t$dtoc$c)  DT_EMISSAO,
                    max(a.t$poco$c) keep (dense_rank last order by a.t$dtoc$c, a.t$seqn$c)
             from baandb.tznsls410301 a
             where a.t$poco$c = 'POS' -- Postagem
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c ) znsls410_POS
        on znsls410_POS.t$ncia$c = znsls401.t$ncia$c
       and znsls410_POS.t$uneg$c = znsls401.t$uneg$c
       and znsls410_POS.t$pecl$c = znsls401.t$pecl$c
       and znsls410_POS.t$sqpd$c = znsls401.t$sqpd$c
       and znsls410_POS.t$entr$c = znsls401.t$entr$c

left join baandb.tznint002301 znint002
       on znint002.t$uneg$c = znsls400.t$uneg$c

left join ( select a.t$ncia$c,
                   a.t$uneg$c,
                   a.t$pecl$c,
                   a.t$sqpd$c,
                   a.t$entr$c,
                   min(a.t$dtoc$c) DATA_APROV
            from baandb.tznsls410301 a
            where a.t$poco$c = 'PAP'      -- Aprovação pagto devolução
            group by a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c ) znsls410_PAP
        on znsls410_PAP.t$ncia$c = znsls401.t$ncia$c
       and znsls410_PAP.t$uneg$c = znsls401.t$uneg$c
       and znsls410_PAP.t$pecl$c = znsls401.t$pecl$c
       and znsls410_PAP.t$sqpd$c = znsls401.t$sqpd$c
       and znsls410_PAP.t$entr$c = znsls401.t$entr$c

left join ( select a.t$fili$c,
                   a.t$etiq$c,
                   a.t$torg$c,
                   a.t$sqrt$c,
                   max(a.t$date$c),
                   max(a.t$coci$c) keep (dense_rank last order by a.t$date$c, a.t$coci$c) STATUS
            from baandb.tznfmd640301 a 
            group by a.t$fili$c,
                     a.t$etiq$c,
                     a.t$torg$c,
                     a.t$sqrt$c ) znfmd640
       on znfmd640.t$fili$c = znfmd630.t$fili$c
      and znfmd640.t$etiq$c = znfmd630.t$etiq$c
      and znfmd640.t$torg$c = znfmd630.t$torg$c
      and znfmd640.t$sqrt$c = znfmd630.t$sqrt$c

left join baandb.tznmcs002301 znmcs002
       on znmcs002.t$poco$c = znfmd640.STATUS

where cast((from_tz(to_timestamp(to_char(( znsls410_POS.DT_EMISSAO  + 10),
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
              AT time zone 'America/Sao_Paulo') as date)
      between :DATA_VENCIMENTO_DE
          and :DATA_VENCIMENTO_ATE
