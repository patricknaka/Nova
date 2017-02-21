  select 
        tdsls400.t$rcd_utc                                      DT_ULT_ATUALIZACAO,
        znsls400.t$ncia$c                                       CD_CIA,
        tdsls400.t$orno                                         NR_ORDEM,
        tdsls400.t$ofbp                                         CD_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)          DT_COMPRA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)          HR_COMPRA,
        znsls400.t$uneg$c                                       CD_UNIDADE_NEGOCIO,
        znsls400.t$pecl$c                                       NR_PEDIDO_LOJA,
        TO_CHAR(znsls401.t$entr$c)                              NR_ENTREGA, 
        znsls400.t$cven$c                                       CD_VENDEDOR,
        case when tcemm030.t$euca   =  ' ' 
               then substr(tcemm124.t$grid,-2,2) 
             else tcemm030.t$euca 
        end                                                     CD_FILIAL,
        brmcs941.t$opfc$l                                       CD_NATUREZA_OPERACAO,		
        ' '                                                     SQ_NATUREZA_OPERACAO,       -- *** NAO EXISTE NA PREVISAO DE IMPOSTOS
        tdsls400.t$ccur                                         CD_MOEDA,
        tdsls400.t$hdst                                         CD_SITUACAO_PEDIDO,
        
        ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(a.t$trdt), 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
            from baandb.ttdsls450301 a
           where a.t$orno = tdsls400.t$orno )                   DT_SITUACAO_PEDIDO,
        
        znsls400.t$vlfr$c                                       VL_FRETE_CLIENTE,
        nvl(znfmd630.vlft,0)                                    VL_FRETE_CIA,
        case when znfmd630.vlft = 0 then 
        znsls400.t$vlfo$c else znfmd630.vlft end 
                                                                VL_FRETE_CIA,
        znsls400.t$vlfo$c                                       VL_FRETE_CIA,
        znsls400.t$idca$c                                       CD_CANAL_VENDA,
        znsls004.t$orig$c                                       CD_ORIGEM_PEDIDO,
        znsls400.t$ipor$c                                       NR_IP_CLIENTE,
        case when tdsls400.t$oamt = 0 
                 then znsls400.t$vlme$c
             else   tdsls400.t$oamt 
        end                                                     VL_PEDIDO,
        nvl(znfmd630.vlfc,0)                                    VL_FRETE_TABELA,
        endfat.t$ccit                                           CD_CIDADE_FATURA,
        endfat.t$ccty                                           CD_PAIS_FATURA,
        endfat.t$cste                                           CD_ESTADO_FATURA,
        endfat.t$pstc                                           CD_CEP_FATURA,
        tdsls400.t$stbp                                         CD_CLIENTE_ENTREGA,
        endent.t$ccit                                           CD_CIDADE_ENTREGA,
        endent.t$ccty                                           CD_PAIS_ENTREGA,
        endent.t$cste                                           CD_ESTADO_ENTREGA,
        endent.t$pstc                                           CD_CEP_ENTREGA,
        znsls400.t$idli$c                                       NR_LISTA_CASAMENTO,
        znsls400.t$idco$c                                       NR_CONTRATO_B2B,
        znsls400.t$idcp$c                                       NR_CAMPANHA_B2B,
        znsls401.t$pztr$c                                       QT_PRAZO_TRANSIT_TIME,
        znsls401.t$pzcd$c                                       QT_PRAZO_CD,
        CASE WHEN tdsls094.t$bill$c !=  3 
               THEN to_char(consold.NOTA) 
             ELSE   '0' 
        END                                                     NR_NF_CONSOLIDADA,      
        CASE WHEN tdsls094.t$bill$c !=  3 
               THEN consold.SERIE 
             ELSE   ' ' 
        END                                                     NR_SERIE_NF_CONSOLIDADA,  
        znsls401.t$pcga$c                                       NR_PEDIDO_GARANTIA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)          DT_LIMITE_EXPED, 
        znsls400.t$tped$c                                       CD_TIPO_PEDIDO,
        TO_CHAR(znsls402.t$idmp$c)                              CD_MEIO_PAGAMENTO_PRINCIPAL,
        znsls400.t$peex$c                                       NR_PEDIDO_EXTERNO,
        znsls401.t$itpe$c                                       CD_TIPO_ENTREGA,
        tcibd001.t$tptr$c                                       CD_TIPO_TRANSPORTE,
        tcmcs080.t$suno                                         CD_TRANSPORTADORA,
        znsls401.t$mgrt$c                                       CD_MEGA_ROTA,
        null                                                    CD_STATUS,
        cast(null as date)                                      DT_STATUS_PEDIDO,
        tcemm124.t$grid                                         CD_UNIDADE_EMPRESARIAL,
        znsls401.t$idor$c                                       CD_TIPO_SITE,
        tdsls400.t$sotp                                         CD_TIPO_ORDEM_VENDA,
        1                                                       IN_CANCELADO,
        znsls401.t$sedt$c                                       SQ_PEDIDO_CANCELADO,
        TO_CHAR(znsls401.t$endt$c)                              NR_ENTREGA_CANCELADO,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)          DT_PROMETIDA_ENTREGA 

FROM  baandb.ttdsls400301 tdsls400

INNER JOIN (  select a.t$ncia$c,
                     a.t$uneg$c,
                     a.t$pecl$c,
                     a.t$sqpd$c,
                     a.t$entr$c,
                     min(a.t$sequ$c) t$sequ$c,
                     a.t$orno$c,
                     min(a.t$pono$c) t$pono$c,
                     min(a.t$orig$c) t$orig$c
              from baandb.tznsls004301 a
              group by  a.t$ncia$c,
                        a.t$uneg$c,
                        a.t$pecl$c,
                        a.t$sqpd$c,
                        a.t$entr$c,
                        a.t$orno$c ) znsls004
        ON znsls004.t$orno$c = tdsls400.t$orno
 
 INNER JOIN baandb.tznsls401301 znsls401
         ON znsls401.t$ncia$c = znsls004.t$ncia$c
        AND znsls401.t$uneg$c = znsls004.t$uneg$c
        AND znsls401.t$pecl$c = znsls004.t$pecl$c
        AND znsls401.t$sqpd$c = znsls004.t$sqpd$c
        AND znsls401.t$entr$c = znsls004.t$entr$c
        AND znsls401.t$sequ$c = znsls004.t$sequ$c

INNER JOIN baandb.ttcibd001301  tcibd001
        ON tcibd001.t$item = znsls401.t$itml$c

INNER JOIN baandb.ttdsls401301 tdsls401
        ON tdsls401.t$orno = znsls004.t$orno$c
       AND tdsls401.t$pono = znsls004.t$pono$c
       AND tdsls401.t$oltp = 2
       
LEFT JOIN baandb.tbrmcs941301 brmcs941
       ON brmcs941.t$txre$l = tdsls401.t$txre$l
      AND brmcs941.t$line$l = tdsls401.t$txli$l
                         
INNER JOIN baandb.tznsls400301 znsls400          
        ON znsls400.t$ncia$c = znsls004.t$ncia$c
       AND znsls400.t$uneg$c = znsls004.t$uneg$c
       AND znsls400.t$pecl$c = znsls004.t$pecl$c
       AND znsls400.t$sqpd$c = znsls004.t$sqpd$c
       
 LEFT JOIN ( select c245.T$SLSO, 
                    c940.T$DOCN$L NOTA, 
                    c940.t$seri$l SERIE
               from baandb.tcisli245301 c245
                inner join baandb.tcisli941301 c941
                        on c941.t$fire$l = c245.T$FIRE$L
                inner join baandb.tcisli940301 c940
                        on c940.t$fire$l = c941.T$REFR$L
                group by  c245.T$SLSO, 
                          c940.T$DOCN$L, 
                          c940.t$seri$l ) consold 
        ON consold.T$SLSO = tdsls400.t$orno

INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdsls400.t$cofc
       AND tcemm124.t$dtyp = 1
       
INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.ttccom130301 endfat
        ON endfat.t$cadr = tdsls400.t$itad

INNER JOIN baandb.ttccom130301 endent
        ON endent.t$cadr = tdsls400.t$stad
       
INNER JOIN baandb.ttdsls094301 tdsls094
        ON tdsls094.t$sotp = tdsls400.t$sotp
        
LEFT JOIN (select a.t$orno$c,
                   sum(a.t$vlft$c) vlft,   --VL_FRETE_CIA
                   sum(a.t$vlfc$c) vlfc    --VL_FRETE_TABELA
           from baandb.tznfmd630301 a 
            group by a.t$orno$c ) znfmd630
       ON  znfmd630.t$orno$c = tdsls400.t$orno  

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    max(a.t$idmp$c) keep (dense_rank last order by a.t$vlmr$c) t$idmp$c
               from baandb.tznsls402301 a
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c ) znsls402                  --CD_MEIO_PAGAMENTO_PRINCIPAL
        ON znsls402.t$ncia$c = znsls400.t$ncia$c
       AND znsls402.t$uneg$c = znsls400.t$uneg$c
       AND znsls402.t$pecl$c = znsls400.t$pecl$c
       AND znsls402.t$sqpd$c = znsls400.t$sqpd$c                                        

 LEFT JOIN baandb.ttcmcs080301 tcmcs080
        ON tcmcs080.t$cfrw = tdsls400.t$cfrw               --CD_TRANSPORTADORA,

where tdsls400.t$fdty$l != 14 
  and znsls401.t$qtve$c > 0  
;
