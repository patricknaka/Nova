select
          znsls400.t$pecl$c                      NUMERO_PEDIDO,
          znsls400.t$sqpd$c                      SEQ_PEDIDO,
          znsls002.t$dsca$c                      TIPO_ENTREGA,
          case when znsls430.COID is not null then
               'SIM'
          else
               'NAO'
          end                                    CUSTOMIZACAO,
          MEIO_PAGTO.t$desc$c                    MEIO_PAGAMENTO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_EMISSAO_PEDIDO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_APROVACAO_PAGTO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_PAP.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_PAP,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_AES.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_AES,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_TNA.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DATA_TNA,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_WMS.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)
                                                 DT_LIBERACAO_WMS,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_NFS.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                     
                                                 DT_FATURAMENTO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_ETR.DTOC,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                                    
                                                 DT_EXPEDICAO,
          cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_ENT.DTOC,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date)                                 
                                                 DT_ENTREGA_CLIENTE,
          case  when  znsls410_CTR_PAP.DTOC is not null then
                case when znsls002.t$tpen$c = 10 then -- Urgente
                     case when cast((znsls410_CTR_PAP.DTOC - znsls400.t$dtem$c) * 
                                   ((86400 / 60)/60) as int) > 12 then
                          'ATRASO'  -- Se aprovação ocorrer após 12 horas
                     else
                          'NO PRAZO'
                     end
                else
                     case when znsls002.t$tpen$c = 2 then -- Expressa
                          case when cast((znsls410_CTR_PAP.DTOC - znsls400.t$dtem$c) * 
                                        ((86400 / 60)/60) as int) > 15 then
                               'ATRASO'  -- Se aprovação ocorrer após 15 horas
                          else
                               'NO PRAZO'
                          end
                     else
                          case when MEIO_PAG.BOLETO is not null then -- Pagto via boleto
                               case when cast((znsls410_CTR_PAP.DTOC - znsls400.t$dtem$c) * 
                                             ((86400 / 60)/60) as int) > 96 then
                                    'ATRASO'  -- Se aprovação ocorrer após 96 horas
                               else
                                    'NO PRAZO'
                               end
                          else
                               case when cast((znsls410_CTR_PAP.DTOC - znsls400.t$dtem$c) * 
                                             ((86400 / 60)/60) as int) > 48 then
                                    'ATRASO'  -- Se aprovação ocorrer após 48 horas
                               else
                                    'NO PRAZO'
                               end
                          end
                     end
                end
          else
                case when znsls002.t$tpen$c = 10 then -- Urgente
                     case when cast((znsls400.t$dtin$c - znsls400.t$dtem$c) * 
                                   ((86400 / 60)/60) as int) > 12 then
                          'ATRASO'  -- Se aprovação ocorrer após 12 horas
                     else
                          'NO PRAZO'
                     end
                else
                     case when znsls002.t$tpen$c = 2 then -- Expressa
                          case when cast((znsls400.t$dtin$c - znsls400.t$dtem$c) * 
                                        ((86400 / 60)/60) as int) > 15 then
                               'ATRASO'  -- Se aprovação ocorrer após 15 horas
                          else
                               'NO PRAZO'
                          end
                     else
                          case when MEIO_PAG.BOLETO is not null then -- Pagto via boleto
                               case when cast((znsls400.t$dtin$c - znsls400.t$dtem$c) * 
                                             ((86400 / 60)/60) as int) > 96 then
                                    'ATRASO'  -- Se aprovação ocorrer após 96 horas
                               else
                                    'NO PRAZO'
                               end
                          else
                               case when cast((znsls400.t$dtin$c - znsls400.t$dtem$c) * 
                                             ((86400 / 60)/60) as int) > 48 then
                                    'ATRASO'  -- Se aprovação ocorrer após 48 horas
                               else
                                    'NO PRAZO'
                               end
                          end
                     end
                end
          end                                    ATRASO_APROVACAO,
          case when znsls410_CTR_AES.DTOC is not null then
               'ATRASO'
          else
               'NO PRAZO'
          end                                    ATRASO_FORNECEDOR,
          case when znsls410_CTR_TNA.DTOC is not null then
               'ATRASO'
          else
               'NO PRAZO'
          end                                    ATRASO_LIBERACAO_WMS_TNA,
          case when znsls430.COID is not null then
               case when cast((znsls410_CTR_ICA.DTOC - znsls410_CTR_PAP.DTOC) * 
                             ((86400 / 60)/60) as int) > 1 then
                    'ATRASO'  -- Se ficou em PAP por mais de 1 hora
               else
                    'NO PRAZO'
               end
          else
               case when znsls410_CTR_AES.DTOC is not null then
                    case when cast((znsls410_CTR_AES.DTOC - znsls410_CTR_PAP.DTOC) * 
                                  ((86400 / 60)/60) as int) > 1 then
                         'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                    else
                         'NO PRAZO'
                    end
               else
                    case when znsls410_CTR_TNA.DTOC is not null then
                         case when cast((znsls410_CTR_TNA.DTOC - znsls410_CTR_PAP.DTOC) * 
                                       ((86400 / 60)/60) as int) > 1 then
                              'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                         else
                              'NO PRAZO'
                         end
                    else
                         case when znsls410_CTR_WMS.DTOC is not null then
                              case when cast((znsls410_CTR_WMS.DTOC - znsls410_CTR_PAP.DTOC) * 
                                            ((86400 / 60)/60) as int) > 1 then
                                   'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                              else
                                   'NO PRAZO'
                              end
                         else
                               case when cast((sysdate - znsls410_CTR_PAP.DTOC) * 
                                             ((86400 / 60)/60) as int) > 1 then
                                    'ATRASO'  -- Se ficou em PAP por mais de 1 hora
                               else
                                    'NO PRAZO'
                               end
                         end
                    end
               end
          end                                    ATRASO_LIBERACAO_WMS_PAP,
          case when znsls410_CTR_PRD.DTOC is not null then
                'SIM'
          else
                'NAO'
          end                                    PERDA_LOGISTICA,
          case when znsls410_CTR_ETR.DTOC is not null then
               case when  znsls410_CTR_ETR.DTOC > tdsls400.t$ddat then
                    'ATRASO'
               else
                    'NO PRAZO'
               end
          end                                    ATRASO_OPERACAO,
          case when znsls410_CTR_ENT.DTOC is not null then
               case when znsls410_CTR_ENT.DTOC > tdsls400.t$prdt then
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

inner join  ( select a.t$slcp,
                     a.t$ortp,
                     a.t$koor,
                     a.t$slso,
                     a.t$fire$l
              from   baandb.tcisli245601 a
              group by a.t$slcp,
                       a.t$ortp,
                       a.t$koor,
                       a.t$slso,
                       a.t$fire$l ) cisli245
        on  cisli245.t$slcp = 601 -- Cia 601
       and  cisli245.t$ortp = 1   -- Ordem/programação de venda
       and  cisli245.t$koor = 3   -- Ordem de venda
       and  cisli245.t$slso = tdsls400.t$orno

inner join baandb.tcisli940601 cisli940
        on cisli940.t$fire$l = cisli245.t$fire$l
       and cisli940.t$fdty$l != 14  -- Retorno mercadoria de cliente

left  join  baandb.tznsls002601 znsls002
        on  znsls002.t$tpen$c = znsls401.t$itpe$c

-- Data do ponto de controle PAP
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'PAP'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_PAP
        on  znsls410_CTR_PAP.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_PAP.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_PAP.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_PAP.t$sqpd$c = znsls400.t$sqpd$c

-- Data do ponto de controle AES
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'AES'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c) znsls410_CTR_AES
        on  znsls410_CTR_AES.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_AES.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_AES.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_AES.t$sqpd$c = znsls400.t$sqpd$c

-- Data do ponto de controle TNA
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'TNA'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_TNA
        on  znsls410_CTR_TNA.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_TNA.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_TNA.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_TNA.t$sqpd$c = znsls400.t$sqpd$c

-- Data da liberaçao do pedido para o ICA
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'ICA'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_ICA
        on  znsls410_CTR_ICA.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_ICA.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_ICA.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_ICA.t$sqpd$c = znsls400.t$sqpd$c

-- Data da liberaçao do pedido para o WMS
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'WMS'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_WMS
        on  znsls410_CTR_WMS.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_WMS.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_WMS.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_WMS.t$sqpd$c = znsls400.t$sqpd$c

-- Data da expedição ponto ETR
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'ETR'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_ETR
        on  znsls410_CTR_ETR.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_ETR.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_ETR.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_ETR.t$sqpd$c = znsls400.t$sqpd$c

-- Data do faturamento (nota fiscal emitida) ponto NFS
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'NFS'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_NFS
        on  znsls410_CTR_NFS.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_NFS.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_NFS.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_NFS.t$sqpd$c = znsls400.t$sqpd$c

-- Data da entrega ao cliente ponto ENT
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c)  DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'ENT'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_ENT
        on  znsls410_CTR_ENT.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_ENT.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_ENT.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_ENT.t$sqpd$c = znsls400.t$sqpd$c

-- Verifica ponto controle PRD
left  join  ( select    a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c,
                        max(a.t$dtoc$c)
                        keep (dense_rank last order by a.t$dtoc$c) DTOC
              from    baandb.tznsls410601 a
              where   a.t$poco$c = 'PRD'
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$poco$c ) znsls410_CTR_PRD
        on  znsls410_CTR_PRD.t$ncia$c = znsls400.t$ncia$c
       and  znsls410_CTR_PRD.t$uneg$c = znsls400.t$uneg$c
       and  znsls410_CTR_PRD.t$pecl$c = znsls400.t$pecl$c
       and  znsls410_CTR_PRD.t$sqpd$c = znsls400.t$sqpd$c

left  join ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    min(a.t$coid$c)  COID
             from baandb.tznsls430601 a 
             group by a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c ) znsls430
        on  znsls430.t$ncia$c = znsls400.t$ncia$c
       and  znsls430.t$uneg$c = znsls400.t$uneg$c
       and  znsls430.t$pecl$c = znsls400.t$pecl$c
       and  znsls430.t$sqpd$c = znsls400.t$sqpd$c

left  join  ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     b.t$ctmp$c  BOLETO
              from baandb.tznsls402601 a,
                   baandb.tzncmg007601 b
              where  b.t$mpgt$c = a.t$idmp$c
                and  b.t$ctmp$c in (5,6) ) MEIO_PAG
        on  MEIO_PAG.t$ncia$c = znsls400.t$ncia$c
       and  MEIO_PAG.t$uneg$c = znsls400.t$uneg$c
       and  MEIO_PAG.t$pecl$c = znsls400.t$pecl$c
       and  MEIO_PAG.t$sqpd$c = znsls400.t$sqpd$c

left  join  ( select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     b.t$desc$c
              from baandb.tznsls402601 a,
                   baandb.tzncmg007601 b
              where  b.t$mpgt$c = a.t$idmp$c ) MEIO_PAGTO
        on  MEIO_PAGTO.t$ncia$c = znsls400.t$ncia$c
       and  MEIO_PAGTO.t$uneg$c = znsls400.t$uneg$c
       and  MEIO_PAGTO.t$pecl$c = znsls400.t$pecl$c
       and  MEIO_PAGTO.t$sqpd$c = znsls400.t$sqpd$c

where   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_EMISSAO_PEDIDO_DE and :DT_EMISSAO_PEDIDO_ATE
  and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_APROVACAO_PAGTO_DE and :DT_APROVACAO_PAGTO_ATE
  and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_WMS.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_LIBERACAO_WMS_DE and :DT_LIBERACAO_WMS_ATE
  and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_NFS.DTOC, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_FATURAMENTO_DE and :DT_FATURAMENTO_ATE
  and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_ETR.DTOC,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_EXPEDICAO_DE and :DT_EXPEDICAO_ATE
  and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls410_CTR_ENT.DTOC,
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') as date))
        between :DT_ENTREGA_CLIENTE_DE and :DT_ENTREGA_CLIENTE_ATE
