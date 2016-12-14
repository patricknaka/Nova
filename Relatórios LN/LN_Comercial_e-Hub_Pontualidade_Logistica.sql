select
          znsls400.t$pecl$c                      NUMERO_PEDIDO,
          znsls400.t$sqpd$c                      SEQ_PEDIDO,
          znsls401.t$itpe$c || ' - ' || znsls002.t$dsca$c
                                                 TIPO_ENTREGA,
          case 
                when znsls430.t$coid$c is null then 'Não' else 'Sim'
          end                                    CUSTOMIZACAO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_EMISSAO_PEDIDO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_APROVACAO_PAGTO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR.DT_PAP, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_PAP,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR.DT_AES, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_AES,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR.DT_TNA, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_TNA,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_WMS.dtoc, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_LIBERACAO_WMS,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_NFS.dtoc, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                     
                                                 DT_FATURAMENTO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_ETR.dtoc,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                                    
                                                 DT_EXPEDICAO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_ENT.dtoc,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                                 
                                                 DT_ENTREGA_CLIENTE,
          case  when  znsls410_CTR.DT_PAP is not null then
                case  when  cast((znsls410_CTR.DT_PAP - znsls400.t$dtem$c) * 
                               ((86400 / 60)/60) as int) > 48 then
                    'ATRASO'  -- Se aprovação ocorrer após 48 horas
                else
                    'NO PRAZO'
                end
          else
                case  when  cast((znsls401.t$dtap$c - znsls400.t$dtem$c) * 
                               ((86400 / 60)/60) as int) > 48 then
                    'ATRASO'  -- Se aprovação ocorrer após 48 horas
                else
                    'NO PRAZO'
                end
          end                                    ATRASO_APROVACAO,
          case  when  znsls410_CTR.DT_AES is not null then
                'ATRASO'
          else
                'NO PRAZO'
          end                                    ATRASO_FORNECEDOR,
          case  when  znsls410_CTR.DT_TNA is not null then
                'ATRASO'
          else
                'NO PRAZO'
          end                                    ATRASO_LIBERACAO_WMS_TNA,
          case  when  znsls410_WMS.dtoc is not null then
                case  when  cast((znsls410_WMS.dtoc - znsls410_CTR.DT_PAP) * 
                                ((86400 / 60)/60) as int) > 1 then
                      'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                else
                      'NO PRAZO'
                end
          else
                case  when  cast((sysdate - znsls410_CTR.DT_PAP) * 
                                ((86400 / 60)/60) as int) > 1 then
                      'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                else
                      'NO PRAZO'
                end
          end                                    ATRASO_LIBERACAO_WMS_PAP,
          case  when  znsls410_ETR.dtoc is not null then
                case  when  znsls410_ETR.dtoc > tdsls400.t$ddat then
                      'ATRASO'
                else
                      'NO PRAZO'
                end
          end                                    ATRASO_OPERACAO,
          case  when  znsls410_ENT.dtoc is not null then
                case  when  znsls410_ENT.dtoc > tdsls400.t$prdt then
                      'ATRASO'
                else
                      'NO PRAZO'
                end
          end                                    ATRASO_TRANSPORTE

from      baandb.tznsls400601 znsls400

inner join  ( select  a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$orno$c,
                      a.t$itpe$c,
                      a.t$dtap$c
              from    baandb.tznsls401601 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$orno$c,
                        a.t$itpe$c,
                        a.t$dtap$c ) znsls401
        on  znsls401.t$ncia$c = znsls400.t$ncia$c
       and  znsls401.t$uneg$c = znsls400.t$uneg$c
       and  znsls401.t$pecl$c = znsls400.t$pecl$c
       and  znsls401.t$sqpd$c = znsls400.t$sqpd$c

inner join  baandb.ttdsls400601 tdsls400
        on  tdsls400.t$orno = znsls401.t$orno$c

left  join  baandb.tznsls002601 znsls002
        on  znsls002.t$tpen$c = znsls401.t$itpe$c

-- Data do ponto de controle PAP
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DT_PAP
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'PAP'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR
        on  znsls410_CTR.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR.t$sqpd$c = znsls400.t$sqpd$c

-- Data do ponto de controle AES
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DT_AES 
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'AES'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c) znsls410_CTR
        on  znsls410_CTR.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR.t$sqpd$c = znsls400.t$sqpd$c

-- Data do ponto de controle TNA
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DT_TNA
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'TNA'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR
        on  znsls410_CTR.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR.t$sqpd$c = znsls400.t$sqpd$c

-- Data da liberaçao do pedido para o WMS
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  dtoc
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'WMS'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_WMS
        on  znsls410_WMS.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_WMS.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_WMS.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_WMS.t$sqpd$c = znsls400.t$sqpd$c

-- Data da expedição
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  dtoc
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'ETR'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_ETR
        on  znsls410_ETR.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_ETR.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_ETR.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_ETR.t$sqpd$c = znsls400.t$sqpd$c

-- Data do faturamento (nota fiscal emitida)
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  dtoc
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'NFS'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_NFS
        on  znsls410_NFS.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_NFS.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_NFS.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_NFS.t$sqpd$c = znsls400.t$sqpd$c

-- Data da entrega ao cliente
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  dtoc
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'ENT'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_ENT
        on  znsls410_ENT.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_ENT.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_ENT.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_ENT.t$sqpd$c = znsls400.t$sqpd$c

left  join  baandb.tznsls430601 znsls430
        on  znsls430.t$ncia$c = znsls400.t$ncia$c
       and  znsls430.t$uneg$c = znsls400.t$uneg$c
       and  znsls430.t$pecl$c = znsls400.t$pecl$c
       and  znsls430.t$sqpd$c = znsls400.t$sqpd$c

where   znsls400.t$pecl$c between :NUMERO_PEDIDO_DE and :NUMERO_PEDIDO_ATE
and     trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_EMISSAO_PEDIDO_DE and :DT_EMISSAO_PEDIDO_ATE
