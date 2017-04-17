select 
          znfmd630.t$pecl$c           ENTREGA,
          cisli940.t$docn$l           NOTA,
          cisli940.t$seri$l           SERIE,
          cisli940.T$FIDS$L           NOME_CLIENTE,
          znfmd630.t$ncar$c           CARGA,
          znfmd630.t$fili$c           FILIAL,
          (select CAST((from_tz(to_timestamp(to_char(znfmd640_ETR.t$date$c,
                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                 AT time zone 'America/Sao_Paulo') AS DATE)
            from BAANDB.tznfmd640301 znfmd640_ETR
           where znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
             and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c
             and znfmd640_ETR.t$coct$c = 'ETR' )
                                      DATA_EXPEDICAO,
                                
          case when znfmd630.t$dtpe$c <= '01/01/70'
          then 
             null
          else   
          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) 
          end                         DATA_PROMETIDA,
            
          case when znfmd630.t$dtco$c <= '01/01/70'
          then 
             null
          else 
          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c, 'dd-mon-yyyy hh24:mi:ss'),
                        'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)
          end                         DATA_AJUSTADA,
          tcmcs080.t$dsca             TRANSPORTADORA,
          tccom130.t$fovn$l           CNPJ,
          trim(cisli941.t$item$l)     ITEM,
          tcibd001.t$dsca             ITEM_DSCA,
          cisli941.t$dqua$l           QTDE_ITEM,  
          cisli941.T$PRIC$L           VALOR_ITEM,
          cisli940.t$amnt$l           VALOR_NOTA,
          whwmd400.t$hght             ALTURA,
          whwmd400.t$wdth             LARGURA,
          whwmd400.t$dpth             COMPRIMENTO,
          tcibd001.t$wght             PESO,
          znfmd630.t$cnfe$c           CHAVE_DANFE,
          tccom139.t$dsca             MUNICIPIO,
          tccom130_cli.t$cste         UF,
          tccom130_cli.t$pstc         CEP,
          znsls400.t$logf$c           ENDERECO_CLIENTE,
          znsls400.t$numf$c           NR_ENDERECO_CLIENTE,
          znsls400.t$baif$c           BAIRRO_CLIENTE,
          znsls400.t$telf$c           TELEFONE1_CLIENTE,
          znsls400.t$te1f$c           TELEFONE2_CLIENTE,
          znsls401.t$vldi$c           VL_DESCONTO,
          znsls401.t$vlfr$c           VL_FRETE,
          
          case when znfmd630.t$torg$c in (1,7) then
              znfmd630.t$docn$c
          when znfmd630.t$torg$c = 2 then
              NVL(cisli940_venda.t$docn$l, znmcs096.t$docn$c)
          else
              znfmd630.t$docn$c
          end                         NF_SAIDA,
          
          case when znfmd630.t$torg$c in (1,7) then
              znfmd630.t$seri$c
          when znfmd630.t$torg$c = 2 then
              NVL(cisli940_venda.t$seri$l, znmcs096.t$seri$c)
          else 
              znfmd630.t$seri$c
          end                         SERIE_SAIDA
          
from ( select a.t$fili$c,
              a.t$pecl$c,
              a.t$ncar$c,
              a.t$fire$c,
              a.t$docn$c,
              a.t$seri$c,
              a.t$cnfe$c,
              max(a.t$dtpe$c) t$dtpe$c,
              max(a.t$dtco$c) t$dtco$c,
              a.t$cfrw$c,
              a.t$orno$c,
              a.t$torg$c,
              min(a.t$etiq$c) t$etiq$c
       from baandb.tznfmd630301 a
       where (a.t$torg$c IN (1,2) and not exists( select b.t$pecl$c
                                            from baandb.tznfmd630301 b
                                            where b.t$pecl$c = a.t$pecl$c
                                              and b.t$torg$c = 7)) or a.t$torg$c not in (1,2)
       group by a.t$fili$c,
                a.t$pecl$c,
                a.t$ncar$c,
                a.t$fire$c,
                a.t$docn$c,
                a.t$seri$c,
                a.t$cnfe$c,
                a.t$cfrw$c,
                a.t$torg$c,
                a.t$orno$c ) znfmd630

left join baandb.tcisli245301 cisli245 
       on cisli245.t$slcp = 301
      and cisli245.t$ortp = 1
      and cisli245.t$koor = 3
      and cisli245.t$slso = znfmd630.t$orno$c
      and cisli245.t$oset = 0
      and cisli245.t$sqnb = 0
      
--left join baandb.tcisli940301 cisli940        --nos casos de insucesso, a 630 grava a referencia de venda 
-- on cisli940.t$fire$l = znfmd630.t$fire$c     --para o registro de venda e para o de insucesso
                                                --no registro de insucesso deveria gravar a referencia de devolucao
     
left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = cisli245.t$fire$l
       
left join baandb.ttccom130301  tccom130_cli
       on tccom130_cli.t$cadr = cisli940.t$stoa$l

left join baandb.tcisli941301 cisli941
       on cisli941.t$fire$l = cisli245.t$fire$l
      and cisli941.t$line$l = cisli245.t$line$l

left join baandb.ttcibd001301 tcibd001
       on tcibd001.t$item = cisli941.t$item$l  

left join baandb.twhwmd400301 whwmd400 
       on whwmd400.t$item = tcibd001.t$item

left join baandb.ttcmcs080301 tcmcs080
       on tcmcs080.t$cfrw = znfmd630.t$cfrw$c

left join baandb.ttccom130301  tccom130
       on tccom130.t$cadr = tcmcs080.t$cadr$l 

left join baandb.ttccom139301 tccom139
       on tccom139.t$ccty = tccom130_cli.t$ccty
      and tccom139.t$cste = tccom130_cli.t$cste
      and tccom139.t$city = tccom130_cli.t$ccit

left join baandb.ttdrec955301 tdrec955	
       on tdrec955.t$fire$l = cisli941.t$fire$l
      and tdrec955.t$line$l = cisli941.t$line$l

	  LEFT JOIN baandb.tznsls000601 znsls000
        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')

left join baandb.tznsls004301 znsls004
       on znsls004.t$orno$c = cisli245.t$slso
      and znsls004.t$pono$c = cisli245.t$pono

left join baandb.tznsls401301 znsls401
       on znsls401.t$ncia$c = znsls004.t$ncia$c
      and znsls401.t$uneg$c = znsls004.t$uneg$c
      and znsls401.t$pecl$c = znsls004.t$pecl$c
      and znsls401.t$sqpd$c = znsls004.t$sqpd$c
      and znsls401.t$entr$c = znsls004.t$entr$c
      and znsls401.t$sequ$c = znsls004.t$sequ$c
      
left join baandb.tznsls400301 znsls400
       on znsls400.T$NCIA$C = znsls401.T$NCIA$C
      and znsls400.T$UNEG$C = znsls401.T$UNEG$C	   
      and znsls400.T$PECL$C = znsls401.T$PECL$C
      and znsls400.T$SQPD$C = znsls401.T$SQPD$C  	   

left join ( select  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$sequ$c,
                    max(a.t$orno$c) t$orno$c,
                    min(a.t$pono$c) t$pono$c
            from baandb.tznsls004301 a
            group by  a.t$ncia$c,
                      a.t$uneg$c,
                      a.t$pecl$c,
                      a.t$sqpd$c,
                      a.t$entr$c,
                      a.t$sequ$c ) znsls004_venda
      on znsls004_venda.t$ncia$c = znsls401.t$ncia$c
     and znsls004_venda.t$uneg$c = znsls401.t$uneg$c
     and znsls004_venda.t$pecl$c = znsls401.t$pvdt$c
     and znsls004_venda.t$sqpd$c = znsls401.t$sedt$c
     and znsls004_venda.t$entr$c = znsls401.t$endt$c
     and znsls004_venda.t$sequ$c = znsls401.t$sidt$c
            
left join baandb.tcisli245301 cisli245_venda
       on cisli245_venda.t$slcp = 301
      and cisli245_venda.t$ortp = 1
      and cisli245_venda.t$koor = 3
      and cisli245_venda.t$slso = znsls004_venda.t$orno$c
      and cisli245_venda.t$pono = znsls004_venda.t$pono$c
      and cisli245_venda.t$sqnb = 0
      
left join baandb.tcisli940301 cisli940_venda
       on cisli940_venda.t$fire$l = cisli245_venda.t$fire$l

left join ( select  a.t$docn$c,
                    a.t$seri$c,
                    a.t$trdt$c,
                    a.t$orno$c,
                    a.t$pono$c
             from baandb.tznmcs096301 a
             group by a.t$docn$c,
                    a.t$seri$c,
                    a.t$trdt$c,
                    a.t$orno$c,
                    a.t$pono$c ) znmcs096
        on znmcs096.t$orno$c = cisli245.t$slso
       and znmcs096.t$pono$c = cisli245.t$pono
       
where	cisli940.t$stat$l = 6
AND ((:EntregaTodos = 1  and znfmd630.t$pecl$c IN (:Entrega))
	OR (:EntregaTodos = 0))
AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS


=
"select  " &
"          znfmd630.t$pecl$c           ENTREGA,  " &
"          cisli940.t$docn$l           NOTA,  " &
"          cisli940.t$seri$l           SERIE,   " &
"          cisli940.T$FIDS$L           NOME_CLIENTE,  " &
"          znfmd630.t$ncar$c           CARGA,   " &
"          znfmd630.t$fili$c           FILIAL,  " &
"          (select CAST((from_tz(to_timestamp(to_char(znfmd640_ETR.t$date$c,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                 AT time zone 'America/Sao_Paulo') AS DATE)   " &
"            from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640_ETR  " &
"           where znfmd640_ETR.t$fili$c = znfmd630.t$fili$c  " &
"             and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c  " &
"             and znfmd640_ETR.t$coct$c = 'ETR' )  " &
"                                      DATA_EXPEDICAO,   " &
"  " &
"          case when znfmd630.t$dtpe$c <= '01/01/70'  " &
"          then   " &
"             null   " &
"          else   " &
"          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c, 'dd-mon-yyyy hh24:mi:ss'),  " &
"                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)   " &
"          end                         DATA_PROMETIDA,   " &
"  " &
"          case when znfmd630.t$dtco$c <= '01/01/70'  " &
"          then   " &
"             null   " &
"          else   " &
"          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c, 'dd-mon-yyyy hh24:mi:ss'),  " &
"                        'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)  " &
"          end                         DATA_AJUSTADA,  " &
"          tcmcs080.t$dsca             TRANSPORTADORA,   " &
"          tccom130.t$fovn$l           CNPJ,  " &
"          trim(cisli941.t$item$l)     ITEM,  " &
"          tcibd001.t$dsca             ITEM_DSCA,  " &
"          cisli941.t$dqua$l           QTDE_ITEM,  " &
"          cisli941.T$PRIC$L           VALOR_ITEM,  " &
"          cisli940.t$amnt$l           VALOR_NOTA,  " &
"          whwmd400.t$hght             ALTURA,  " &
"          whwmd400.t$wdth             LARGURA,  " &
"          whwmd400.t$dpth             COMPRIMENTO,   " &
"          tcibd001.t$wght             PESO,  " &
"          znfmd630.t$cnfe$c           CHAVE_DANFE,   " &
"          tccom139.t$dsca             MUNICIPIO,  " &
"          tccom130_cli.t$cste         UF,   " &
"          tccom130_cli.t$pstc         CEP,  " &
"          znsls400.t$logf$c           ENDERECO_CLIENTE,  " &
"          znsls400.t$numf$c           NR_ENDERECO_CLIENTE,  " &
"          znsls400.t$baif$c           BAIRRO_CLIENTE,   " &
"          znsls400.t$telf$c           TELEFONE1_CLIENTE,   " &
"          znsls400.t$te1f$c           TELEFONE2_CLIENTE,   " &
"          znsls401.t$vldi$c           VL_DESCONTO,   " &
"          znsls401.t$vlfr$c           VL_FRETE,   " &
"  " &
"          case when znfmd630.t$torg$c in (1,7) then  " &
"              znfmd630.t$docn$c  " &
"          when znfmd630.t$torg$c = 2 then   " &
"              NVL(cisli940_venda.t$docn$l, znmcs096.t$docn$c)  " &
"          else   " &
"              znfmd630.t$docn$c  " &
"          end                         NF_SAIDA,   " &
"  " &
"          case when znfmd630.t$torg$c in (1,7) then  " &
"              znfmd630.t$seri$c  " &
"          when znfmd630.t$torg$c = 2 then   " &
"              NVL(cisli940_venda.t$seri$l, znmcs096.t$seri$c)  " &
"          else   " &
"              znfmd630.t$seri$c  " &
"          end                         SERIE_SAIDA  " &
"  " &
"from ( select a.t$fili$c,  " &
"              a.t$pecl$c,  " &
"              a.t$ncar$c,  " &
"              a.t$fire$c,  " &
"              a.t$docn$c,  " &
"              a.t$seri$c,  " &
"              a.t$cnfe$c,  " &
"              max(a.t$dtpe$c) t$dtpe$c,  " &
"              max(a.t$dtco$c) t$dtco$c,  " &
"              a.t$cfrw$c,  " &
"              a.t$orno$c,  " &
"              a.t$torg$c,  " &
"              min(a.t$etiq$c) t$etiq$c   " &
"       from baandb.tznfmd630" + Parameters!Compania.Value + " a  " &
"       where (a.t$torg$c IN (1,2) and not exists( select b.t$pecl$c  " &
"                                            from baandb.tznfmd630" + Parameters!Compania.Value + " b  " &
"                                            where b.t$pecl$c = a.t$pecl$c  " &
"                                              and b.t$torg$c = 7)) or a.t$torg$c not in (1,2)  " &
"       group by a.t$fili$c,  " &
"                a.t$pecl$c,  " &
"                a.t$ncar$c,  " &
"                a.t$fire$c,  " &
"                a.t$docn$c,  " &
"                a.t$seri$c,  " &
"                a.t$cnfe$c,  " &
"                a.t$cfrw$c,  " &
"                a.t$torg$c,  " &
"                a.t$orno$c ) znfmd630  " &
"  " &
"left join baandb.tcisli245" + Parameters!Compania.Value + " cisli245   " &
"       on cisli245.t$slcp = " + Parameters!Compania.Value + " " &
"      and cisli245.t$ortp = 1   " &
"      and cisli245.t$koor = 3   " &
"      and cisli245.t$slso = znfmd630.t$orno$c  " &
"      and cisli245.t$oset = 0   " &
"      and cisli245.t$sqnb = 0   " &
"  " &
"left join baandb.tcisli940" + Parameters!Compania.Value + " cisli940   " &
"       on cisli940.t$fire$l = cisli245.t$fire$l   " &
"  " &
"left join baandb.ttccom130" + Parameters!Compania.Value + " tccom130_cli  " &
"       on tccom130_cli.t$cadr = cisli940.t$stoa$l  " &
"  " &
"left join baandb.tcisli941" + Parameters!Compania.Value + " cisli941   " &
"       on cisli941.t$fire$l = cisli245.t$fire$l   " &
"      and cisli941.t$line$l = cisli245.t$line$l   " &
"  " &
"left join baandb.ttcibd001" + Parameters!Compania.Value + " tcibd001   " &
"       on tcibd001.t$item = cisli941.t$item$l  " &
"  " &
"left join baandb.twhwmd400" + Parameters!Compania.Value + " whwmd400   " &
"       on whwmd400.t$item = tcibd001.t$item  " &
"  " &
"left join baandb.ttcmcs080" + Parameters!Compania.Value + " tcmcs080   " &
"       on tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
"left join baandb.ttccom130" + Parameters!Compania.Value + " tccom130  " &
"       on tccom130.t$cadr = tcmcs080.t$cadr$l  " &
"  " &
"left join baandb.ttccom139301 tccom139   " &
"       on tccom139.t$ccty = tccom130_cli.t$ccty   " &
"      and tccom139.t$cste = tccom130_cli.t$cste   " &
"      and tccom139.t$city = tccom130_cli.t$ccit   " &
"  " &
"left join baandb.ttdrec955" + Parameters!Compania.Value + " tdrec955	  " &
"       on tdrec955.t$fire$l = cisli941.t$fire$l   " &
"      and tdrec955.t$line$l = cisli941.t$line$l   " &
"  " &
"	  LEFT JOIN baandb.tznsls000601 znsls000  " &
"        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')   " &
"  " &
"left join baandb.tznsls004" + Parameters!Compania.Value + " znsls004   " &
"       on znsls004.t$orno$c = cisli245.t$slso  " &
"      and znsls004.t$pono$c = cisli245.t$pono  " &
"  " &
"left join baandb.tznsls401" + Parameters!Compania.Value + " znsls401   " &
"       on znsls401.t$ncia$c = znsls004.t$ncia$c   " &
"      and znsls401.t$uneg$c = znsls004.t$uneg$c   " &
"      and znsls401.t$pecl$c = znsls004.t$pecl$c   " &
"      and znsls401.t$sqpd$c = znsls004.t$sqpd$c   " &
"      and znsls401.t$entr$c = znsls004.t$entr$c   " &
"      and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"  " &
"left join baandb.tznsls400" + Parameters!Compania.Value + " znsls400   " &
"       on znsls400.T$NCIA$C = znsls401.T$NCIA$C   " &
"      and znsls400.T$UNEG$C = znsls401.T$UNEG$C	  " &
"      and znsls400.T$PECL$C = znsls401.T$PECL$C   " &
"      and znsls400.T$SQPD$C = znsls401.T$SQPD$C  	  " &
"  " &
"left join ( select  a.t$ncia$c,  " &
"                    a.t$uneg$c,  " &
"                    a.t$pecl$c,  " &
"                    a.t$sqpd$c,  " &
"                    a.t$entr$c,  " &
"                    a.t$sequ$c,  " &
"                    max(a.t$orno$c) t$orno$c,  " &
"                    min(a.t$pono$c) t$pono$c   " &
"            from baandb.tznsls004" + Parameters!Compania.Value + " a   " &
"            group by  a.t$ncia$c,  " &
"                      a.t$uneg$c,  " &
"                      a.t$pecl$c,  " &
"                      a.t$sqpd$c,  " &
"                      a.t$entr$c,  " &
"                      a.t$sequ$c ) znsls004_venda  " &
"      on znsls004_venda.t$ncia$c = znsls401.t$ncia$c  " &
"     and znsls004_venda.t$uneg$c = znsls401.t$uneg$c  " &
"     and znsls004_venda.t$pecl$c = znsls401.t$pvdt$c  " &
"     and znsls004_venda.t$sqpd$c = znsls401.t$sedt$c  " &
"     and znsls004_venda.t$entr$c = znsls401.t$endt$c  " &
"     and znsls004_venda.t$sequ$c = znsls401.t$sidt$c  " &
"  " &
"left join baandb.tcisli245" + Parameters!Compania.Value + " cisli245_venda   " &
"       on cisli245_venda.t$slcp = " + Parameters!Compania.Value + " " &
"      and cisli245_venda.t$ortp = 1   " &
"      and cisli245_venda.t$koor = 3   " &
"      and cisli245_venda.t$slso = znsls004_venda.t$orno$c  " &
"      and cisli245_venda.t$pono = znsls004_venda.t$pono$c  " &
"      and cisli245_venda.t$sqnb = 0   " &
"  " &
"left join baandb.tcisli940" + Parameters!Compania.Value + " cisli940_venda   " &
"       on cisli940_venda.t$fire$l = cisli245_venda.t$fire$l   " &
"  " &
"left join ( select  a.t$docn$c,  " &
"                    a.t$seri$c,  " &
"                    a.t$trdt$c,  " &
"                    a.t$orno$c,  " &
"                    a.t$pono$c  " &
"             from baandb.tznmcs096" + Parameters!Compania.Value + " a  " &
"             group by a.t$docn$c,  " &
"                    a.t$seri$c,  " &
"                    a.t$trdt$c,  " &
"                    a.t$orno$c,  " &
"                    a.t$pono$c ) znmcs096   " &
"        on znmcs096.t$orno$c = cisli245.t$slso  " &
"       and znmcs096.t$pono$c = cisli245.t$pono  " &
"  " &
" where	cisli940.t$stat$l = 6  " &
" AND ((znfmd630.t$pecl$c IN ( " + IIF(Trim(Parameters!Entrega.Value) = "", "''", "'" + Replace(Replace(Parameters!Entrega.Value, " ", ""), ";", "','") + "'")  + " )  " &
"       AND (" + IIF(Parameters!Entrega.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Entrega.Value Is Nothing, "1", "0") + " = 1) ) " &
" AND cisli941.t$item$l != znsls000.t$itmf$c " &
" AND cisli941.t$item$l != znsls000.t$itmd$c " &
" AND cisli941.t$item$l != znsls000.t$itjl$c "
