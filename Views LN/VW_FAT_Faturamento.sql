-- 05-mai-2014, Fabio Ferreira, Retirados os campos COD_PAIS_FATURA, COD_ESTADO_FATURA, COD_CEP_FATURA, COD_PAIS_ENTREGA, COD_ESTADO_ENTREGA, COD_CEP_ENTREGA,
--								Inclusão dos campos VALOR_TOTAL_MERCADOR, CPF/CNPJ CLIENTE FATURA, TIPO CLENTE
-- 06-mai-2014, Fabio Ferreira, Correcção timezone ULTIMA_ATUALIZACAO, DATA_FATURA, DT_ENTREGA
--								Correção formatação campo PEDIDO_ENTREGA;
--								Correção informação da quantidade de volumes
-- 07-mai-2014, Fabio Ferreira, Incluído campo COD_CIDADE_ENTREGA (Excluido indevidamente)
--								Corrigido campo VALOR_CMV
-- #FAF.007 - 17-mai-2014, Fabio Ferreira, 	Retirado campo PEDIDO_ENTREGA;
-- #FAF.008 - 17-mai-2014, Fabio Ferreira, 	Incluida condição para evitar divisão por zero
-- #FAF.063 - 22-mai-2014, Fabio Ferreira, 	Alterado o código da transportadora para o código do parceiro
-- #FAF.083 - 26-mai-2014, Fabio Ferreira, 	Campo NUM_ENTREGA convertido para string
-- #FAF.087 - 29-mai-2014, Fabio Ferreira, 	Correções de informações que estavam pendente do financeiro
-- #FAF.125 - 10-jun-2014, Fabio Ferreira, 	Correções impostos frete
-- #FAF.138 - 13-jun-2014, Fabio Ferreira, 	Correção campo CD_VENDEDOR
--	#FAF.151 - 20-jun-2014,	Fabio Ferreira,	Tratamento para o CNPJ
--	#FAF.169 - 24-jun-2014,	Fabio Ferreira,	Mostrar linha da NF de remessa e fatura
--	#FAF.172 - 24-jun-2014,	Fabio Ferreira,	Inclusão do campo referencia fiscal
--	#FAF.173 - 25-jun-2014,	Fabio Ferreira,	Correção duplicidade
--	#FAF.176 - 25-jun-2014,	Fabio Ferreira,	Inclusão do campo CD_STATUS_SEFAZ, filtro status e sefaz
--****************************************************************************************************************************************************************
SELECT 
      CAST((FROM_TZ(CAST(TO_CHAR(Greatest(cisli940.t$datg$l, cisli940.t$date$l, cisli940.t$dats$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
        cisli940.t$sfcp$l CD_CIA,
    (SELECT tcemm030.t$euca FROM ttcemm124201 tcemm124, ttcemm030201 tcemm030
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm030.t$eunt=tcemm124.t$grid
    AND tcemm124.t$loco=201
    AND rownum=1) CD_FILIAL,
        cisli940.t$docn$l NR_NF,
        cisli940.t$seri$l NR_SERIE_NF,
        cisli940.t$ccfo$l CD_NATUREZA_OPERACAO,
        cisli940.t$opor$l SQ_NATUREZA_OPERACAO,
    CAST((FROM_TZ(CAST(TO_CHAR(cisli940.t$datg$l, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DT_FATURA,
        cisli940.t$itbp$l CD_CLIENTE_FATURA,
        cisli940.t$stbp$l CD_CLIENTE_ENTREGA,
        znsls401.t$sequ$c NR_SEQ_ENTREGA,
        znsls401.t$pecl$c NR_PEDIDO,
        TO_CHAR(znsls401.t$entr$c) NR_ENTREGA,                                  --#FAF.083.n
    znsls401.t$orno$c NR_ORDEM,
        CASE WHEN cisli940.t$fdty$l=15 then
          (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l and rownum=1)
          else 0
          end  NR_NF_FATURA,
       CASE WHEN cisli940.t$fdty$l=15 then
          (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l and rownum=1)
          else ' '
          end  NR_SERIE_NF_FATURA,        
        CASE WHEN cisli940.t$fdty$l=16 then
          (select distinct a.t$docn$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l and rownum=1)
          else 0
          end NR_NF_REMESSA,
        CASE WHEN cisli940.t$fdty$l=16 then
          (select distinct a.t$seri$l from tcisli940201 a, tcisli941201 b
          where b.t$fire$l=cisli940.t$fire$l
          and a.t$fire$l=b.t$refr$l and rownum=1)
          else ' '
          end NR_SERIE_NF_REMESSA,

    CASE WHEN tdsls094.t$bill$c!=3 THEN consold.NOTA ELSE 0 END NR_NF_CONSOLIDADA,              --#FAF.087.n
    CASE WHEN tdsls094.t$bill$c!=3 THEN consold.SERIE ELSE ' ' END NR_SERIE_NF_CONSOLIDADA,       --#FAF.087.n


        cisli940.t$stat$l CD_SITUACAO_NF,
        (Select 
     CAST((FROM_TZ(CAST(TO_CHAR(max(brnfe020.t$date$l), 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE)
     FROM tbrnfe020201 brnfe020
    Where brnfe020.t$refi$l=cisli940.t$fire$l AND brnfe020.t$ncmp$l=201) DT_STATUS,
        cisli940.t$fdty$l CD_TIPO_NF,
        ltrim(rtrim(cisli941f.t$item$l)) CD_ITEM,
        cisli941f.t$dqua$l QT_FATURADA,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=1),0) VL_ICMS,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=2),0) VL_ICMS_ST,
        cisli941f.t$gamt$l VL_PRODUTO,
        znsls401.t$vlfr$c VL_FRETE,
        nvl((select sum(f.t$vlfc$c) from tznfmd630201 f
       where f.t$fire$c=cisli940.t$fire$l),0) * (cisli941f.t$gamt$l/nvl((select sum(cisli941b.t$gamt$l) 
                             from tcisli941201 cisli941b, ttcibd001201 tcibd001b
                             where cisli941b.t$fire$l=cisli941f.t$fire$l
                             and   cisli941b.t$line$l=cisli941f.t$line$l
                             and   tcibd001b.T$ITEM=cisli941b.t$item$l
                             and   cisli941b.t$gamt$l!=0                                                --#FAF.008.n                              
                             and   tcibd001b.t$kitm<3),1)) VL_FRETE_CIA,            
        cisli941f.t$gexp$l VL_DESPESA,
        cisli941f.t$ldam$l VL_DESCONTO,
        cisli941f.t$iprt$l VL_TOTAL_ITEM,
        cisli941f.t$AMFI$l VL_DESPESA_FINANCEIRA,
        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=5),0) VL_PIS,
    
        Nvl((SELECT cisli943.t$amni$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=1),0) VL_ICMS_PRODUTO,

       
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND     cisli943.T$LINE$L=cisli941b.T$LINE$L
    AND    tcibd001b.t$ctyp$l=2
    AND   cisli943.t$brty$l=1),0) VL_ICMS_FRETE,

    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND    tcibd001b.t$kitm>3
    AND    tcibd001b.t$ctyp$l!=2
    AND   cisli943.t$brty$l=1),0) VL_ICMS_OUTROS,
    

        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=6),0) VL_COFINS,
       
        Nvl((SELECT cisli943.t$amni$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=6),0) VL_COFINS_PRODUTO,       
      
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND     cisli943.T$LINE$L=cisli941b.T$LINE$L
    AND    tcibd001b.t$ctyp$l=2
    AND   cisli943.t$brty$l=6),0) VL_COFINS_FRETE,      

    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND    tcibd001b.t$kitm>3
    AND    tcibd001b.t$ctyp$l!=2
    AND   cisli943.t$brty$l=6),0) VL_COFINS_OUTROS,

        Nvl((SELECT cisli943.t$amni$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=5),0) VL_PIS_PRODUTO,
       
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND     cisli943.T$LINE$L=cisli941b.T$LINE$L
    AND    tcibd001b.t$ctyp$l=2
    AND   cisli943.t$brty$l=5),0) VL_PIS_FRETE,
    
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND    tcibd001b.t$kitm>3
    AND    tcibd001b.t$ctyp$l!=2
    AND   cisli943.t$brty$l=5),0) VL_PIS_OUTROS,  

        Nvl((SELECT cisli943.t$amnt$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=13),0) VL_CSLL,
      
        Nvl((SELECT cisli943.t$amni$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=13),0) VL_CSLL_PRODUTO,
       
    
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND     cisli943.T$LINE$L=cisli941b.T$LINE$L
    AND    tcibd001b.t$ctyp$l=2
    AND   cisli943.t$brty$l=13),0) VL_CSLL_FRETE,
    
    nvl((SELECT sum(cisli943.t$amnt$l) FROM tcisli943201 cisli943, 
                        tcisli941201 cisli941b,
                        ttcibd001201 tcibd001b
    WHERE   cisli943.t$fire$l=cisli941f.t$fire$l
    AND   cisli941b.t$fire$l=cisli941f.t$fire$l
    AND    tcibd001b.t$item=cisli941b.t$item$l
    AND    tcibd001b.t$kitm>3
    AND    tcibd001b.t$ctyp$l!=2
    AND   cisli943.t$brty$l=13),0) VL_CSLL_OUTROS,  
    
        cisli941f.t$tldm$l VL_DESCONTO_INCONDICIONAL,
    CAST((FROM_TZ(CAST(TO_CHAR(znsls400.t$dtem$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DT_PEDIDO,
        znsls400.t$idca$c CD_CANAL,
        endfat.t$ccit CD_CIDADE_FATURA,
        endent.t$ccit CD_CIDADE_ENTREGA,
        nvl((select sum(b.t$mauc$1) from twhina114201 a, twhina113201 b 
      where b.t$item=A.T$ITEM
      and   b.T$CWAR=a.t$cwar
      and   b.T$TRDT=A.T$TRDT
      and   b.t$seqn=A.T$SEQN
      and   b.T$INWP=A.T$INWP
      and   a.t$orno=tdsls401.t$orno
      and    a.t$pono=tdsls401.t$pono),0) VL_CMV,
        znsls401.t$uneg$c CD_UNIDADE_NEGOCIO,
        ' ' CD_MODULO_GERENCIAL,        -- *** AGUARDANDO DUVIDAS
        cisli941f.t$ccfo$l CD_NATUREZA_OPERACAO_ITEM,
        cisli941f.t$opor$l SQ_NATUREZA_OPERACAO_ITEM,
        CASE WHEN znsls400.t$cven$c=100 THEN NULL ELSE znsls400.t$cven$c END CD_VENDEDOR,
        Nvl((SELECT cisli943.t$base$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=1),0) VL_BASE_ICMS,
        Nvl((SELECT cisli943.t$base$l from tcisli943201 cisli943
             WHERE  cisli943.t$fire$l=cisli941f.t$fire$l
             AND    cisli943.t$line$l=cisli941f.t$line$l
             AND    cisli943.t$brty$l=3),0) VL_BASE_IPI,
    nvl((select t.t$suno from ttcmcs080201 t where t.t$cfrw=cisli940.t$cfrw$l and rownum=1),' ') CD_TRANSPORTADORA,      --#FAF.063.n
    CAST((FROM_TZ(CAST(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
      AT time zone sessiontimezone) AS DATE) DT_ENTREGA,
        (Select sum(znfmd630.t$qvol$c) From tznfmd630201 znfmd630 WHERE znfmd630.t$fire$c=cisli941f.t$fire$l and rownum=1) QT_VOLUME,
        cisli940.t$gwgt$l VL_PESO_BRUTO,
        cisli940.t$nwgt$l VL_PESO_LIQUIDO,
        znsls401.t$itpe$c CD_TIPO_ENTREGA,
        tcibd001.t$tptr$c CD_TIPO_TRANSPORTE,
        znsls400.t$idli$c NR_LISTA_CASAMENTO,
    (SELECT tcemm124.t$grid FROM ttcemm124201 tcemm124
    WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
    AND tcemm124.t$loco=201
    AND rownum=1) CD_UNIDADE_EMPRESARIAL,  
    (select 
        CASE WHEN regexp_replace(e.t$fovn$l, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
    WHEN LENGTH(regexp_replace(e.t$fovn$l, '[^0-9]', ''))<11
    THEN '00000000000000'
    ELSE regexp_replace(e.t$fovn$l, '[^0-9]', '') END                                --#FAF.151.n  
--    e.t$fovn$l                                                     --#FAF.151.o
    from ttccom130201 e where e.t$cadr=cisli940.t$stoa$l and rownum=1) NR_CNPJ_CPF_ENTREGA,
    (select e.t$ftyp$l from ttccom130201 e where e.t$cadr=cisli940.t$stoa$l and rownum=1) CD_TIPO_CLIENTE_ENTREGA,
    (select 
        CASE WHEN regexp_replace(e.t$fovn$l, '[^0-9]', '') IS NULL
    THEN '00000000000000' 
    WHEN LENGTH(regexp_replace(e.t$fovn$l, '[^0-9]', ''))<11
    THEN '00000000000000'
    ELSE regexp_replace(e.t$fovn$l, '[^0-9]', '') END                                --#FAF.151.n  
--    e.t$fovn$l                                                     --#FAF.151.o
    from ttccom130201 e where e.t$cadr=cisli940.t$itoa$l and rownum=1) NR_CNPJ_CPF_FATURA,
    (select e.t$ftyp$l from ttccom130201 e where e.t$cadr=cisli940.t$itoa$l and rownum=1) CD_TIPO_CLIENTE_FATURA,
    cisli941f.t$fire$l NR_REFERENCIA_FISCAL,  															--#FAF.172.n
	cisli940.t$nfes$l CD_STATUS_SEFAZ																	--#FAF.176.n
FROM    tcisli940201 cisli940,
        tcisli941201 cisli941,
    tcisli941201 cisli941f,                                          --#FAF.169.n
        tcisli245201 cisli245,
        ttdsls401201 tdsls401,
        tznsls401201 znsls401,
        tznsls400201 znsls400,
    
    ttdsls400201 tdsls400                                          --#FAF.087.sn
    LEFT JOIN (  select DISTINCT c245.T$SLSO, c940.T$DOCN$L NOTA, c940.t$seri$l SERIE             
          from tcisli245201 c245, tcisli941201 c941, tcisli940201 c940
          where c941.t$fire$l=c245.T$FIRE$L
          and c940.t$fire$l=c941.T$REFR$L) consold ON consold.T$SLSO=tdsls400.t$orno,          --#FAF.087.en    
    
        ttccom130201 endfat,
        ttccom130201 endent,
        ttcibd001201 tcibd001,
    ttdsls094201 tdsls094                                          --#FAF.087.n
WHERE   cisli941f.t$fire$l=cisli940.t$fire$l
AND     cisli245.t$fire$l=cisli941.t$fire$l
AND     cisli245.t$line$l=cisli941.t$line$l
AND     tdsls401.t$orno = cisli245.t$slso
AND     tdsls401.t$pono = cisli245.t$pono
AND     znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
AND     endfat.t$cadr=cisli940.t$itoa$l
AND     endent.t$cadr=cisli940.t$stoa$l
AND     tcibd001.t$item=cisli941.t$item$l
AND    tdsls400.t$orno=tdsls401.t$orno                                      --#FAF.087.n
AND    tdsls094.t$sotp=tdsls400.t$sotp                                      --#FAF.087.n
--and (cisli941.T$fire$L= cisli941f.T$REFR$L or cisli941.T$fire$L= cisli941f.T$fire$L)              --#FAF.169.n
--and (cisli941.T$line$L= cisli941f.T$rfdl$L or cisli941.T$line$L= cisli941f.T$line$l)              --#FAF.169.n
and ((cisli941.T$fire$L= cisli941f.T$REFR$L and (cisli940.t$fdty$l=15 or cisli940.t$fdty$l=16))  
      or cisli941.T$fire$L= cisli941f.T$fire$L)              										--#FAF.173.n
and ((cisli941.T$line$L= cisli941f.T$rfdl$L and (cisli940.t$fdty$l=15 or cisli940.t$fdty$l=16))  
      or cisli941.T$line$L= cisli941f.T$line$l)              										--#FAF.173.n
and cisli940.t$stat$l IN (5,6) and cisli940.t$nfes$l IN (2,5)										--#FAF.176.n		
