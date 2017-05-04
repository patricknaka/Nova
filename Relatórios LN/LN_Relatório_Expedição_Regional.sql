   select distinct
          znfmd630.t$pecl$c           ENTREGA,
          cisli940.t$docn$l           NOTA,
          cisli940.t$seri$l           SERIE,
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
          --znfmd630.t$vlmr$c           VALOR_ITEM,
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
          znsls401.t$vlfr$c           VL_FRETE

  
     from baandb.tznfmd630301 znfmd630

left join baandb.tcisli940301 cisli940
       on cisli940.t$fire$l = znfmd630.t$fire$c

left join baandb.ttccom130301  tccom130_cli
       on tccom130_cli.t$cadr = cisli940.t$stoa$l

left join baandb.tcisli941301 cisli941
       on cisli941.t$fire$l = cisli940.t$fire$l

left join baandb.ttcibd001301 tcibd001
       on tcibd001.t$item = cisli941.t$item$l  

left join baandb.twhwmd400301 whwmd400 
       on whwmd400.t$item=tcibd001.t$item

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

left join baandb.tznsls401301 znsls401
       on znsls401.T$ORNO$C = znfmd630.T$ORNO$C
      and znsls401.t$item$c = trim(cisli941.t$item$l)
	   
left join baandb.tznsls400301 znsls400
       on znsls400.T$NCIA$C = znsls401.T$NCIA$C
      and znsls400.T$UNEG$C = znsls401.T$UNEG$C	   
      and znsls400.T$PECL$C = znsls401.T$PECL$C
      and znsls400.T$SQPD$C = znsls401.T$SQPD$C  	   
       
where	cisli940.t$stat$l = 6
and znfmd630.t$torg$c = 1
AND ((znfmd630.t$pecl$c IN (:Entrega))
	OR (:EntregaTodos = '0'))
AND cisli941.t$item$l != znsls000.t$itmf$c      --ITEM FRETE
AND cisli941.t$item$l != znsls000.t$itmd$c      --ITEM DESPESAS
AND cisli941.t$item$l != znsls000.t$itjl$c      --ITEM JUROS



=
"select distinct  " &
"          znfmd630.t$pecl$c           ENTREGA,  " &
"          cisli940.t$docn$l           NOTA,  " &
"          cisli940.t$seri$l           SERIE,  " &
"          znfmd630.t$ncar$c           CARGA,  " &
"          znfmd630.t$fili$c           FILIAL,  " &
"          (select CAST((from_tz(to_timestamp(to_char(znfmd640_ETR.t$date$c,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                 AT time zone 'America/Sao_Paulo') AS DATE)  " &
"            from BAANDB.tznfmd640" + Parameters!Compania.Value + " znfmd640_ETR  " &
"           where znfmd640_ETR.t$fili$c = znfmd630.t$fili$c  " &
"             and znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c  " &
"             and znfmd640_ETR.t$coct$c = 'ETR' )  " &
"                                      DATA_EXPEDICAO,  " &
"  " &
"          case when znfmd630.t$dtpe$c <= '01/01/70'  " &
"          then  " &
"             null  " &
"          else  " &
"          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c, 'dd-mon-yyyy hh24:mi:ss'),  " &
"                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)  " &
"          end                         DATA_PROMETIDA,  " &
"  " &
"          case when znfmd630.t$dtco$c <= '01/01/70'  " &
"          then  " &
"             null  " &
"          else  " &
"          cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c, 'dd-mon-yyyy hh24:mi:ss'),  " &
"                        'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)  " &
"          end                         DATA_AJUSTADA,  " &
"          tcmcs080.t$dsca             TRANSPORTADORA,  " &
"          tccom130.t$fovn$l           CNPJ,  " &
"          trim(cisli941.t$item$l)     ITEM,  " &
"          tcibd001.t$dsca             ITEM_DSCA,  " &
"          cisli941.t$dqua$l           QTDE_ITEM,  " &
"          cisli941.T$PRIC$L           VALOR_ITEM,  " &
"          cisli940.t$amnt$l           VALOR_NOTA,  " &
"          whwmd400.t$hght             ALTURA,  " &
"          whwmd400.t$wdth             LARGURA,  " &
"          whwmd400.t$dpth             COMPRIMENTO,  " &
"          tcibd001.t$wght             PESO,  " &
"          znfmd630.t$cnfe$c           CHAVE_DANFE,  " &
"          tccom139.t$dsca             MUNICIPIO,  " &
"          tccom130_cli.t$cste         UF,  " &
"          tccom130_cli.t$pstc         CEP,  " &
"          znsls400.t$logf$c           ENDERECO_CLIENTE,  " &
"          znsls400.t$numf$c           NR_ENDERECO_CLIENTE,  " &
"          znsls400.t$baif$c           BAIRRO_CLIENTE,  " &
"          znsls400.T$REFF$C           REFERENCIA_CLIENTE,  " &
"          znsls400.t$telf$c           TELEFONE1_CLIENTE,  " &
"          znsls400.t$te1f$c           TELEFONE2_CLIENTE,  " &
"          znsls400.T$NOMF$C           NOME_CLIENTE,  " &
"          znsls400.T$ICLC$C           CPF_CLIENTE,  " &
"          znsls400.t$emaf$c           EMAIL  " &
"  " &
"  " &
"     from baandb.tznfmd630" + Parameters!Compania.Value + "  znfmd630  " &
"  " &
"left join baandb.tcisli940" + Parameters!Compania.Value + "  cisli940  " &
"       on cisli940.t$fire$l = znfmd630.t$fire$c  " &
"  " &
"left join baandb.ttccom130" + Parameters!Compania.Value + "   tccom130_cli  " &
"       on tccom130_cli.t$cadr = cisli940.t$stoa$l  " &
"  " &
"left join baandb.tcisli941" + Parameters!Compania.Value + "  cisli941  " &
"       on cisli941.t$fire$l = cisli940.t$fire$l  " &
"  " &
"left join baandb.ttcibd001" + Parameters!Compania.Value + "  tcibd001  " &
"       on tcibd001.t$item = cisli941.t$item$l  " &
"  " &
"left join baandb.twhwmd400" + Parameters!Compania.Value + "  whwmd400  " &
"       on whwmd400.t$item=tcibd001.t$item  " &
"  " &
"left join baandb.ttcmcs080" + Parameters!Compania.Value + "  tcmcs080  " &
"       on tcmcs080.t$cfrw = znfmd630.t$cfrw$c  " &
"  " &
"left join baandb.ttccom130" + Parameters!Compania.Value + "   tccom130  " &
"       on tccom130.t$cadr = tcmcs080.t$cadr$l  " &
"  " &
"left join baandb.ttccom139301 tccom139  " &
"       on tccom139.t$ccty = tccom130_cli.t$ccty  " &
"      and tccom139.t$cste = tccom130_cli.t$cste  " &
"      and tccom139.t$city = tccom130_cli.t$ccit  " &
"  " &
"left join baandb.ttdrec955" + Parameters!Compania.Value + "  tdrec955	  " &
"       on tdrec955.t$fire$l = cisli941.t$fire$l  " &
"      and tdrec955.t$line$l = cisli941.t$line$l  " &
"  " &
"	  LEFT JOIN baandb.tznsls000601 znsls000  " &
"        ON znsls000.t$indt$c = TO_DATE('01-01-1970','DD-MM-YYYY')  " &
"  " &
"left join baandb.tznsls401" + Parameters!Compania.Value + "  znsls401  " &
"       on znsls401.T$ORNO$C = znfmd630.T$ORNO$C  " &
"  " &
"left join baandb.tznsls400" + Parameters!Compania.Value + "  znsls400  " &
"       on znsls400.T$NCIA$C = znsls401.T$NCIA$C  " &
"      and znsls400.T$UNEG$C = znsls401.T$UNEG$C	  " &
"      and znsls400.T$PECL$C = znsls401.T$PECL$C  " &
"      and znsls400.T$SQPD$C = znsls401.T$SQPD$C  	  " &
"  " &
"where	cisli940.t$stat$l = 6  " &
" AND ((znfmd630.t$pecl$c IN ( " + IIF(Trim(Parameters!Entrega.Value) = "", "''", "'" + Replace(Replace(Parameters!Entrega.Value, " ", ""), ",", "','") + "'")  + " )  " &
"       AND (" + IIF(Parameters!Entrega.Value Is Nothing, "1", "0") + " = 0))  " &
"        OR (" + IIF(Parameters!Entrega.Value Is Nothing, "1", "0") + " = 1) ) " &
"and znfmd630.t$torg$c = 1  " &
"AND cisli941.t$item$l != znsls000.t$itmf$c  " &
"AND cisli941.t$item$l != znsls000.t$itmd$c  " &
"AND cisli941.t$item$l != znsls000.t$itjl$c "
