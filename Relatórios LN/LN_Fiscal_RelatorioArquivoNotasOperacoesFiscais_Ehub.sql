
	SELECT 
	  DISTINCT 
		601                CODE_CIA, 
		tcemm122.T$grid    UNID_EMPRESARIAL, 
		tccom130.t$fovn$L  NUME_FILIAL,
						   
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,  
		  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
			AT time zone 'America/Sao_Paulo') AS DATE)  
						   DATA_APROV, 
						   
		tdrec940.t$fire$l  REFE_FISCAL,                  
		tdrec940.t$stat$l  STAT_REFFISC,   
		DESC_DOMAIN_STAT.  DESC_STAT, 
		tdrec940.t$fovn$l  CNPJ_FORN, 
		tdrec940.t$fids$l  NOME_PARCE, 
		tdrec940.t$opfc$l  NUME_CFOP, 
		tdrec940.t$docn$l  NUME_NF, 
		tdrec940.t$seri$l  SERI_NF, 
		tdrec940.t$tfda$l  VALO_TOTAL, 
		whinh300.t$recd$c  RECDOC_WMS, 
		tdrec940.t$lipl$l  PLAC_VEIC, 
		tdrec940.t$logn$l  CODE_USUA, 
		tdrec940.t$cnfe$l  CHAV_ACESS, 
		tdrec940.t$fdtc$l  COD_TIPO_DOCFIS, 
		tcmcs966.t$dsca$l  DESC_TIPO_DOCFIS 
		   
	FROM       baandb.ttdrec940601  tdrec940   
	 
	INNER JOIN baandb.ttdrec941601 tdrec941
			ON tdrec941.T$FIRE$L = tdrec940.T$FIRE$L

	 LEFT JOIN baandb.twhinh300601 whinh300 
			ON whinh300.t$fire$c = tdrec940.t$fire$l
			
	INNER JOIN baandb.ttccom130601 tccom130
			ON tccom130.t$cadr = tdrec940.t$sfra$l

	INNER JOIN baandb.ttcemm122601 tcemm122
			ON tcemm122.t$bupa = tdrec940.t$sfra$l
				
	 LEFT JOIN ( SELECT d.t$cnst DESC_DOMAIN_STAT,  
						l.t$desc DESC_STAT  
				   FROM baandb.tttadv401000 d,  
						baandb.tttadv140000 l  
				  WHERE d.t$cpac = 'td'  
					AND d.t$cdom = 'rec.stat.l' 
					AND l.t$clan = 'p' 
					AND l.t$cpac = 'td' 
					AND l.t$clab = d.t$za_clab 
					AND rpad(d.t$vers,4) || 
						rpad(d.t$rele,2) || 
						rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
														rpad(l1.t$rele,2) || 
														rpad(l1.t$cust,4))  
											   from baandb.tttadv401000 l1  
											  where l1.t$cpac = d.t$cpac  
												and l1.t$cdom = d.t$cdom ) 
					AND rpad(l.t$vers,4) || 
						rpad(l.t$rele,2) || 
						rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
														rpad(l1.t$rele,2) ||  
														rpad(l1.t$cust,4))  
											   from baandb.tttadv140000 l1  
											  where l1.t$clab = l.t$clab  
												and l1.t$clan = l.t$clan  
												and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_STAT
			ON tdrec940.t$stat$l = DESC_DOMAIN_STAT.DESC_DOMAIN_STAT
		   
	 LEFT JOIN baandb.ttcmcs966601 tcmcs966
			ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l
			
 WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,    
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   
           AT time zone 'America/Sao_Paulo') AS DATE))   
       between :DtAprovacaoDe   
           and :DtAprovacaoAte   
   AND tdrec940.t$stat$l IN (:StatusRefFiscal)   
   AND tdrec940.t$opfc$l IN (:COD_CFOP)   
   AND NVL(Trim(tdrec940.t$fdtc$l), '000') IN (:TipoDocFiscal)   
	ORDER BY Trunc(DATA_APROV), 
			 REFE_FISCAL

--view com parâmetros
=
"	SELECT "&
"	  DISTINCT "&
"		" + Parameters!Compania.Value + "  CODE_CIA, "&
"		tcemm122.T$grid    UNID_EMPRESARIAL, "&
"		tccom130.t$fovn$L  NUME_FILIAL,"&
"						   "&
"		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,  "&
"		  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') "&
"			AT time zone 'America/Sao_Paulo') AS DATE)  "&
"						   DATA_APROV, "&
"						   "&
"		tdrec940.t$fire$l  REFE_FISCAL,                  "&
"		tdrec940.t$stat$l  STAT_REFFISC,   "&
"		DESC_DOMAIN_STAT.  DESC_STAT, "&
"		tdrec940.t$fovn$l  CNPJ_FORN, "&
"		tdrec940.t$fids$l  NOME_PARCE, "&
"		tdrec940.t$opfc$l  NUME_CFOP, "&
"		tdrec940.t$docn$l  NUME_NF, "&
"		tdrec940.t$seri$l  SERI_NF, "&
"		tdrec940.t$tfda$l  VALO_TOTAL, "&
"		whinh300.t$recd$c  RECDOC_WMS, "&
"		tdrec940.t$lipl$l  PLAC_VEIC, "&
"		tdrec940.t$logn$l  CODE_USUA, "&
"		tdrec940.t$cnfe$l  CHAV_ACESS, "&
"		tdrec940.t$fdtc$l  COD_TIPO_DOCFIS, "&
"		tcmcs966.t$dsca$l  DESC_TIPO_DOCFIS "&
"		   "&
"	FROM       baandb.ttdrec940" + Parameters!Compania.Value + "   tdrec940   "&
"	 "&
"	INNER JOIN baandb.ttdrec941" + Parameters!Compania.Value + "  tdrec941"&
"			ON tdrec941.T$FIRE$L = tdrec940.T$FIRE$L"&
""&
"	 LEFT JOIN baandb.twhinh300" + Parameters!Compania.Value + "  whinh300 "&
"			ON whinh300.t$fire$c = tdrec940.t$fire$l"&
"			"&
"	INNER JOIN baandb.ttccom130" + Parameters!Compania.Value + " tccom130"&
"			ON tccom130.t$cadr = tdrec940.t$sfra$l"&
""&
"	INNER JOIN baandb.ttcemm122" + Parameters!Compania.Value + "  tcemm122"&
"			ON tcemm122.t$bupa = tdrec940.t$sfra$l"&
"				"&
"	 LEFT JOIN ( SELECT d.t$cnst DESC_DOMAIN_STAT,  "&
"						l.t$desc DESC_STAT  "&
"				   FROM baandb.tttadv401000 d,  "&
"						baandb.tttadv140000 l  "&
"				  WHERE d.t$cpac = 'td'  "&
"					AND d.t$cdom = 'rec.stat.l' "&
"					AND l.t$clan = 'p' "&
"					AND l.t$cpac = 'td' "&
"					AND l.t$clab = d.t$za_clab "&
"					AND rpad(d.t$vers,4) || "&
"						rpad(d.t$rele,2) || "&
"						rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || "&
"														rpad(l1.t$rele,2) || "&
"														rpad(l1.t$cust,4))  "&
"											   from baandb.tttadv401000 l1  "&
"											  where l1.t$cpac = d.t$cpac  "&
"												and l1.t$cdom = d.t$cdom ) "&
"					AND rpad(l.t$vers,4) || "&
"						rpad(l.t$rele,2) || "&
"						rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || "&
"														rpad(l1.t$rele,2) ||  "&
"														rpad(l1.t$cust,4))  "&
"											   from baandb.tttadv140000 l1  "&
"											  where l1.t$clab = l.t$clab  "&
"												and l1.t$clan = l.t$clan  "&
"												and l1.t$cpac = l.t$cpac ) ) DESC_DOMAIN_STAT"&
"			ON tdrec940.t$stat$l = DESC_DOMAIN_STAT.DESC_DOMAIN_STAT"&
"		   "&
"	 LEFT JOIN baandb.ttcmcs966" + Parameters!Compania.Value + " tcmcs966"&
"			ON tcmcs966.t$fdtc$l = tdrec940.t$fdtc$l"&
"			"&
" WHERE Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l,   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE))  " &
"       between :DtAprovacaoDe  " &
"           and :DtAprovacaoAte  " &
"   AND tdrec940.t$stat$l IN (" + Replace(("'" + JOIN(Parameters!StatusRefFiscal.Value, "',") + "'"),",",",'") + ")  " &
"   AND tdrec940.t$opfc$l IN (" + Replace(("'" + JOIN(Parameters!COD_CFOP.Value, "',") + "'"),",",",'") + ")  " &
"   AND NVL(Trim(tdrec940.t$fdtc$l), '000') IN (" + Replace(("'" + JOIN(Parameters!TipoDocFiscal.Value, "',") + "'"),",",",'") + ")  " &
"	ORDER BY Trunc(DATA_APROV), "&
"			 REFE_FISCAL"