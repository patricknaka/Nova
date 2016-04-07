SELECT 
  DISTINCT
	tcemm030.t$euca                                 	FILIAL,
    
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
	'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
	AT time zone 'America/Sao_Paulo') AS DATE) 
								DT_NR,
             
	tdrec940.t$fire$l                               	NR,
	tccom130.t$ftyp$l || ' ' || tccom130.t$fovn$l 		CNPJ_FORN,
	tccom100.t$nama                                 	NOME_FORN,
	tdrec940.t$docn$l                               	NOTA_FISCAL,
    
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE) 
								DATA_EMISSAO,
              
    tdrec940.t$opfc$l                               		CFOP,
    
    tccom139.t$dsca						MUNICIPIO,
    tccom139.t$cste						ESTADO,
    
    nvl(( SELECT tdrec949.t$base$l
        FROM baandb.ttdrec949301 tdrec949
       WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
         AND tdrec949.t$brty$l = 5 ),0)                		VALOR_PIS,
     
    nvl(( SELECT tdrec949.t$base$l 
        FROM baandb.ttdrec949301 tdrec949
       WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
         AND tdrec949.t$brty$l = 6 ),0)                		VALOR_COFINS,
     
    nvl((SELECT tdrec949.t$base$l 
       FROM baandb.ttdrec949301 tdrec949
      WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
        AND tdrec949.t$brty$l = 13 ),0)                		VALOR_CSLL,
     
    nvl(( SELECT tdrec949.t$base$l 
        FROM baandb.ttdrec949301 tdrec949
       WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
         AND tdrec949.t$brty$l = 7 ),0)                		VALOR_ISS,
	 
   nvl(SUM( ( SELECT SUM(tdrec942.t$amnt$l) 
           FROM baandb.ttdrec942301 tdrec942
          WHERE tdrec942.t$fire$l = tdrec941.t$fire$l
            AND tdrec942.t$line$l = tdrec941.t$line$l
            AND tdrec942.t$brty$l = 14 ) ), 0)       		VALOR_ISS_RETIDO,
      
    nvl(( SELECT tdrec949.t$base$l 
        FROM baandb.ttdrec949301 tdrec949
       WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
         AND tdrec949.t$brty$l = 8 ),0)                		VALOR_INSS,
     
    nvl(( SELECT tdrec949.t$base$l 
        FROM baandb.ttdrec949301 tdrec949
       WHERE tdrec949.t$fire$l = tdrec940.t$fire$l
         AND tdrec949.t$brty$l IN (9,10) ),0)          		VALOR_IRRF,
     
     tdrec940.t$tfda$l                              			VALOR_TOTAL_NF,
     
     nvl(( SELECT SUBSTR( TRIM(t.t$text),1,15)
              FROM baandb.ttttxt010301 t 
             WHERE t$clan = 'p' 
               AND t.t$ctxt = tdrec940.t$obse$l
               AND rownum = 1 ) , ' ')    				OBSERVACAO,
     nvl(tdrec940.t$logn$l, ' ')                             		USUSARIO,
     nvl(nvl(tfacp201.payd, tfacp200.t$docd), tdrec940.t$date$l) DT_VENC,
     
     CASE WHEN tfacp200.t$balc = 0 THEN 'LIQUIDADO' 
          ELSE 'ABERTO' 
      END                                           				SIT_TITULO,
      tdrec941_serv.t$wrkc$l						CENTRO_DE_CUSTO,
      tdrec941_serv.DESC_CENTRO_CUSTO			DESCR_CENTRO_DE_CUSTO,
      tdrec941_serv.COD_SERVICO					COD_SERVICO,
      tdrec941_serv.DSCA_COD_SERVICO				DESCR_COD_SERVICO

FROM       baandb.ttccom100301 tccom100

LEFT JOIN baandb.ttccom130301 tccom130
	  ON	tccom130.t$cadr = tccom100.t$cadr
	  
LEFT JOIN baandb.ttccom139301 tccom139
	  ON	tccom139.t$ccty = tccom130.t$ccty
	 AND	tccom139.t$cste = tccom130.t$cste
	 AND	tccom139.t$city = tccom130.t$ccit
          
INNER JOIN baandb.ttdrec940301 tdrec940
        ON tccom100.t$bpid = tdrec940.t$bpid$l

LEFT JOIN (	select 	tdrec941.t$fire$l, 
					tdrec941.t$wrkc$l, 
					nvl(tcmcs065.t$dsca, ' ')	DESC_CENTRO_CUSTO,
					tdrec941.t$item$l,
					substr(tcibd001.t$dsca, 1, instr(tcibd001.t$dsca, ' ')-1) COD_SERVICO_ITEM,
					nvl(brmcs958.t$scod$l, ' ') 	COD_SERVICO,
					nvl(tcmcs981.t$dsca$l, ' ')	DSCA_COD_SERVICO
			from 	baandb.ttdrec941301 tdrec941
			inner join  baandb.ttcibd001301 tcibd001
				on     tcibd001.t$item = tdrec941.t$item$l
			left join 	baandb.tbrmcs958301	brmcs958
				on 	brmcs958.t$item$l = tdrec941.t$item$l
				and	brmcs958.t$tror$l = 1
			left join	baandb.ttcmcs981301	tcmcs981
				on	tcmcs981.t$scod$l = brmcs958.t$scod$l
			left join	baandb.ttcmcs065301	tcmcs065
				on	tcmcs065.t$cwoc = tdrec941.t$wrkc$l
			where 	tcibd001.t$kitm = 5 ) tdrec941_serv
       ON tdrec941_serv.t$fire$l = tdrec940.t$fire$l
      
 LEFT JOIN baandb.ttfacp200301 tfacp200
        ON tfacp200.t$ttyp = tdrec940.t$ttyp$l
       AND tfacp200.t$ninv = tdrec940.t$invn$l
       AND tfacp200.t$lino = 0
 	  
 LEFT JOIN ( select a.t$ttyp, 
                    a.t$ninv,
                    min(a.t$payd) payd
               from baandb.ttfacp201301 a
           group by a.t$ttyp, a.t$ninv ) tfacp201
       ON tfacp201.t$ttyp=tdrec940.t$ttyp$l
      AND tfacp201.t$ninv=tdrec940.t$invn$l
	   
INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdrec940.t$cofc$l
		
 LEFT JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
  
WHERE TRIM(tdrec940.t$opfc$l) IN ('1933', '2933', '1300')
  
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)) Between :DataEmissaoDe AND :DataEmissaoAte
