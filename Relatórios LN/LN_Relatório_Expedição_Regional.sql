select	distinct
	znfmd630.t$pecl$c		ENTREGA,
	cisli940.t$docn$l			NOTA,
	cisli940.t$seri$l			SERIE,
	znfmd630.t$ncar$c		CARGA,
	znfmd630.t$fili$c			FILIAL,
	(select 	CAST((from_tz(to_timestamp(to_char(znfmd640_ETR.t$date$c,
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			AT time zone 'America/Sao_Paulo') AS DATE)
	from		BAANDB.tznfmd640301 	znfmd640_ETR
	where	znfmd640_ETR.t$fili$c = znfmd630.t$fili$c
        and		znfmd640_ETR.t$etiq$c = znfmd630.t$etiq$c
        and		znfmd640_ETR.t$coct$c = 'ETR' )
						DATA_EXPEDICAO,

	case when znfmd630.t$dtpe$c <= '01/01/70'
	then 	
		null	
	else   	
		cast((from_tz(to_timestamp(to_char(znfmd630.t$dtpe$c, 'dd-mon-yyyy hh24:mi:ss'),
			'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date) 
	end			DATA_PROMETIDA,

	case when znfmd630.t$dtco$c <= '01/01/70'
	then 
		null
         else 
		cast((from_tz(to_timestamp(to_char(znfmd630.t$dtco$c, 'dd-mon-yyyy hh24:mi:ss'),
                'dd-mon-yyyy hh24:mi:ss'), 'gmt') at time zone 'america/sao_paulo') as date)
	end                  	DATA_AJUSTADA,
	tcmcs080.t$dsca			TRANSPORTADORA,
	tccom130.t$fovn$l  		CNPJ,
	trim(cisli941.t$item$l)		ITEM,
	tcibd001.t$dsca			ITEM_DSCA,
	cisli941.T$PRIC$L VALOR_ITEM,
	--znfmd630.t$vlmr$c    		VALOR_ITEM,
	cisli941.t$dqua$l			QTDE_ITEM,
	whwmd400.t$hght 		ALTURA,
	whwmd400.t$wdth 		LARGURA,
	whwmd400.t$dpth 		COMPRIMENTO,
	tcibd001.t$wght			PESO,
	znfmd630.t$cnfe$c		CHAVE_DANFE,
	tccom139.t$dsca			MUNICIPIO,
	tccom130_cli.t$cste		UF,
	tccom130_cli.t$pstc		CEP
	
from	baandb.tznfmd630301 znfmd630

left join	baandb.tcisli940301 cisli940
on		cisli940.t$fire$l = znfmd630.t$fire$c

left join 	baandb.ttccom130301  tccom130_cli
on		tccom130_cli.t$cadr = cisli940.t$stoa$l

left join	baandb.tcisli941301 cisli941
on		cisli941.t$fire$l = cisli940.t$fire$l

left join 	baandb.ttcibd001301 tcibd001
on		tcibd001.t$item = cisli941.t$item$l  

left join 	baandb.twhwmd400301 whwmd400 
on		whwmd400.t$item=tcibd001.t$item

left join 	baandb.ttcmcs080301 tcmcs080
on		tcmcs080.t$cfrw = znfmd630.t$cfrw$c

left join 	baandb.ttccom130301  tccom130
on		tccom130.t$cadr = tcmcs080.t$cadr$l 

left join 	baandb.ttccom139301 tccom139
on		tccom139.t$ccty = tccom130_cli.t$ccty
and		tccom139.t$cste = tccom130_cli.t$cste
and		tccom139.t$city = tccom130_cli.t$ccit

left join 	baandb.ttdrec955301 tdrec955			
on 		tdrec955.t$fire$l = cisli941.t$fire$l
and 		tdrec955.t$line$l = cisli941.t$line$l

where	cisli940.t$stat$l = 6
and	cisli940.t$fdty$l = 17			-- remessa para terceiros
and trim(tdrec955.t$lfir$l) is null		-- recebimento pendente
AND ( :Entrega IS NULL
      OR znfmd630.t$pecl$c IN (:Entrega))
