select  
--cabecalho alterada Rosana
        --tdsls400.t$rcd_utc                              DT_ULT_ATUALIZACAO,         --Capa Ordem de Venda LN - Data [Ult. Atualizacao
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(greatest(tdsls400.t$rcd_utc, znsls401.rcd_utc), 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  DT_ULT_ATUALIZACAO,
        znsls400.t$ncia$c                               CD_CIA,
        tdsls400.t$orno                                 NR_ORDEM,
        --znsls401.pono,
        tdsls400.t$ofbp                                 CD_CLIENTE,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  DT_COMPRA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  HR_COMPRA,
        znsls400.t$uneg$c                               CD_UNIDADE_NEGOCIO,
        znsls401.pecl                                   NR_PEDIDO_LOJA,
        TO_CHAR(znsls401.entr)                          NR_ENTREGA, 
        znsls400.t$cven$c                               CD_VENDEDOR,
        case when tcemm030.t$euca   =  ' ' 
               then substr(tcemm124.t$grid,-2,2) 
             else tcemm030.t$euca 
        end                                             CD_FILIAL,

        ( select max(n.t$opfc$l) t$opfc$l  
            from baandb.tbrmcs941201 n, 
                 baandb.ttdsls401201 o
           where n.T$LINE$L=( select min(n1.t$line$l)   
                                from baandb.tbrmcs941201 n1
                               where n1.T$GAMT$L=(select max(n2.T$GAMT$L) 
                                                    from baandb.tbrmcs941201 n2
                                                   where n2.T$TXRE$L=n1.T$TXRE$L)
                                 and n1.T$TXRE$L=n.T$TXRE$L)                   
             and o.T$TXRE$L=n.T$TXRE$L
             and o.t$orno=tdsls401.t$orno
        group by o.t$orno )                             CD_NATUREZA_OPERACAO,
		
        ' '                                             SQ_NATUREZA_OPERACAO,       -- *** NAO EXISTE NA PREVISAO DE IMPOSTOS
        tdsls400.t$ccur                                 CD_MOEDA,
        tdsls400.t$hdst                                 CD_SITUACAO_PEDIDO,
        
        ( select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(a.t$trdt), 
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE)
            from baandb.ttdsls450201 a
           where a.t$orno = tdsls400.t$orno )           DT_SITUACAO_PEDIDO,
        
        znsls400.t$vlfr$c                               VL_FRETE_CLIENTE,
        nvl(znfmd630.vlft,0)                            VL_FRETE_CIA,
        znsls400.t$idca$c                               CD_CANAL_VENDA,
        znsls004.t$orig$c                               CD_ORIGEM_PEDIDO,
        znsls400.t$ipor$c                               NR_IP_CLIENTE,
        case when tdsls400.t$oamt = 0 
               then tdsls401.VL_TOT
             else   tdsls400.t$oamt 
        end                                             VL_PEDIDO,
        nvl(znfmd630.vlfc,0)                            VL_FRETE_TABELA,
        endfat.t$ccit                                   CD_CIDADE_FATURA,
        endfat.t$ccty                                   CD_PAIS_FATURA,
        endfat.t$cste                                   CD_ESTADO_FATURA,
        endfat.t$pstc                                   CD_CEP_FATURA,
        tdsls400.t$stbp                                 CD_CLIENTE_ENTREGA,
        endent.t$ccit                                   CD_CIDADE_ENTREGA,
        endent.t$ccty                                   CD_PAIS_ENTREGA,
        endent.t$cste                                   CD_ESTADO_ENTREGA,
        endent.t$pstc                                   CD_CEP_ENTREGA,
        znsls400.t$idli$c                               NR_LISTA_CASAMENTO,
        znsls400.t$idco$c                               NR_CONTRATO_B2B,
        znsls400.t$idcp$c                               NR_CAMPANHA_B2B,
        znsls401.pztr                                   QT_PRAZO_TRANSIT_TIME,
        znsls401.pzcd                                   QT_PRAZO_CD,
        CASE WHEN tdsls094.t$bill$c !=  3 
               THEN to_char(consold.NOTA) 
             ELSE   '0' 
        END                                             NR_NF_CONSOLIDADA,      
        CASE WHEN tdsls094.t$bill$c !=  3 
               THEN consold.SERIE 
             ELSE   ' ' 
        END                                             NR_SERIE_NF_CONSOLIDADA,  
        znsls401.pcga                                   NR_PEDIDO_GARANTIA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE)  DT_LIMITE_EXPED, 
        znsls400.t$tped$c                               CD_TIPO_PEDIDO,
        znsls402.idmp                                   CD_MEIO_PAGAMENTO_PRINCIPAL,
        znsls400.t$peex$c                               NR_PEDIDO_EXTERNO,
        znsls401.itpe                                   CD_TIPO_ENTREGA,
        znsls401.tptr                                   CD_TIPO_TRANSPORTE,
        tcmcs080.t$suno                                 CD_TRANSPORTADORA,
        znsls401.mgrt                                   CD_MEGA_ROTA,
        '     '                                         CD_STATUS,
        cast(null as date)                              DT_STATUS_PEDIDO,
        tcemm124.t$grid                                 CD_UNIDADE_EMPRESARIAL,
        znsls401.idor                                   CD_TIPO_SITE,
        tdsls400.t$sotp                                 CD_TIPO_ORDEM_VENDA,
        znsls401.cancela                                IN_CANCELADO,
        znsls401.seq_pedido_cancel                      SQ_PEDIDO_CANCELADO,
        TO_CHAR(znsls401.entrega_cancel)                NR_ENTREGA_CANCELADO

FROM       baandb.ttdsls400201 tdsls400

 LEFT JOIN ( select c245.T$SLSO, 
                    c940.T$DOCN$L NOTA, 
                    c940.t$seri$l SERIE
               from baandb.tcisli245201 c245
         inner join baandb.tcisli941201 c941
                 on c941.t$fire$l = c245.T$FIRE$L
         inner join baandb.tcisli940201 c940
                 on c940.t$fire$l = c941.T$REFR$L
           group by c245.T$SLSO, 
                    c940.T$DOCN$L, 
                    c940.t$seri$l ) consold 
        ON consold.T$SLSO = tdsls400.t$orno
          
INNER JOIN ( select a.t$orno$c       orno,
                    min(a.t$pono$c)  pono,
                    a.t$ncia$c       ncia,
                    a.t$uneg$c       uneg,
                    a.t$pecl$c       pecl,
                    a.t$sqpd$c       sqpd,
                    a.t$entr$c       entr,
                    case when a.t$qtve$c < 0 
                           then 2 
                         else   1 
                    end              cancela,
                    a.t$sedt$c       seq_pedido_cancel,
                    a.t$endt$c       entrega_cancel,
                    max(a.t$pztr$c)  pztr,
                    max(a.t$pzcd$c)  pzcd,
                    max(a.t$pcga$c)  pcga,
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(a.t$dtep$c), 
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE) dtep,
                    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(tdsls401.t$rcd_utc), 
                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone 'America/Sao_Paulo') AS DATE) rcd_utc,
                     max(a.t$itpe$c)  itpe,
                    max(a.t$mgrt$c)  mgrt,
                    max(tcibd001.t$tptr$c)  tptr,
                    --brmcs941.t$opfc$l       opfc,
                    a.t$idor$c       idor  
               from baandb.tznsls401201 a
                  
         inner join baandb.ttdsls401201 tdsls401
                 on a.t$orno$c = tdsls401.t$orno
                and a.t$pono$c = tdsls401.t$pono
                          
         inner join baandb.ttcibd001201 tcibd001
                 on tcibd001.t$item = tdsls401.t$item
				 
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$orno$c,
                    case when a.t$qtve$c < 0 
                           then 2 
                         else   1 
                    end,
                    a.t$sedt$c,
                    a.t$endt$c,
                    --brmcs941.t$opfc$l,
                    a.t$idor$c --, tdsls401.t$rcd_utc
                   ) znsls401
        ON znsls401.orno = tdsls400.t$orno
             
 LEFT JOIN baandb.tznsls400201 znsls400          
        ON znsls400.t$ncia$c = znsls401.ncia
       AND znsls400.t$uneg$c = znsls401.uneg
       AND znsls400.t$pecl$c = znsls401.pecl
       AND znsls400.t$sqpd$c = znsls401.sqpd
       
left JOIN  baandb.tznsls004201 znsls004 
        ON znsls004.t$orno$c = znsls401.orno 
       AND znsls004.t$entr$c = znsls401.entr   
       AND znsls004.t$sequ$c = znsls401.sqpd
       AND znsls004.t$pono$c = znsls401.pono

INNER JOIN baandb.ttcemm124201 tcemm124
        ON tcemm124.t$cwoc = tdsls400.t$cofc
       AND tcemm124.t$dtyp = 1
       
INNER JOIN baandb.ttcemm030201 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid

INNER JOIN baandb.ttccom130201 endfat
        ON endfat.t$cadr = tdsls400.t$itad

INNER JOIN baandb.ttccom130201 endent
        ON endent.t$cadr = tdsls400.t$stad
       
INNER JOIN baandb.ttdsls094201 tdsls094
        ON tdsls094.t$sotp = tdsls400.t$sotp
        
 LEFT JOIN (select a.t$orno$c,
                   sum(a.t$vlft$c) vlft,   --VL_FRETE_CIA
                   sum(a.t$vlfc$c) vlfc    --VL_FRETE_TABELA
              from baandb.tznfmd630201 a 
          group by a.t$orno$c ) znfmd630
        ON  znfmd630.t$orno$c = tdsls400.t$orno  

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    to_char(a.t$idmp$c) idmp
               from baandb.tznsls402201 a
              where a.t$vlmr$c = ( SELECT Max(b.t$vlmr$c)
                                     FROM baandb.tznsls402201 b
                                    WHERE b.t$ncia$c = a.t$ncia$c
                                      AND b.t$uneg$c = a.t$uneg$c
                                      AND b.t$pecl$c = a.t$pecl$c
                                      AND b.t$sqpd$c = a.t$sqpd$c )
           group by a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$idmp$c ) znsls402                  --CD_MEIO_PAGAMENTO_PRINCIPAL
        ON znsls402.t$ncia$c = znsls400.t$ncia$c
       AND znsls402.t$uneg$c = znsls400.t$uneg$c
       AND znsls402.t$pecl$c = znsls400.t$pecl$c
       AND znsls402.t$sqpd$c = znsls400.t$sqpd$c                                        

 LEFT JOIN baandb.ttcmcs080201 tcmcs080
        ON tcmcs080.t$cfrw = tdsls400.t$cfrw               --CD_TRANSPORTADORA,

 LEFT JOIN ( select a.t$orno,
                    sum(a.t$qoor)             QTDE_TOT,
                    sum(a.t$pric * a.t$qoor)  VL_TOT
              from baandb.ttdsls401201 a
             where a.t$oltp = 2                           --linha da ordem/entrega
          group by a.t$orno ) tdsls401
        ON  tdsls401.t$orno = tdsls400.t$orno
                 
where tdsls400.t$fdty$l != 14
and znsls401.cancela = 1
