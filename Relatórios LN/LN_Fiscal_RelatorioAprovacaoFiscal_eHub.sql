	SELECT TDREC940.T$FIRE$L,
	  ZNFMD001.T$FILI$C                                  ID_FILIAL,
	  ZNFMD001.T$DSCA$C                                  DESCR_FILIAL,
	  TDPUR400.T$ORNO                                    ORDEM_COMPRA,
	  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDPUR400.T$ODAT, 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		  AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)     DATA_ORDEM,  
	  TDPUR400.T$COTP                                    TIPO_OC,
	  TDPUR094.T$DSCA                                    DESC_TIPO_OC,
	  TDREC940.T$DOCN$L                                  NOTA,
	  TDREC940.T$SERI$L                                  SERIE,
	  TCCOM100.T$NAMA                                    FORNECEDOR,
	  TDREC940.T$FOVN$L                                  CNPJ,
	  
	  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC943.T$ICAD$L, 
		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
		 AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)      DATA_VENCTO,
	  NVL(TRIM(APROVACAO_FIS.STATUS_APROVACAO_FIS), 
		  'Não definido')                                SITUACAO_NF,
	  TDREC940.T$TFDA$L                                  VL_TOTAL,
	  USER_NAME.T$NAME                                   SOLICITANTE

	FROM       BAANDB.TTDPUR400601    TDPUR400
	 
	INNER JOIN BAANDB.TTCMCS065601    TCMCS065
			ON TCMCS065.T$CWOC  = TDPUR400.T$COFC
			
	INNER JOIN BAANDB.TTCCOM130601    TCCOM130
			ON TCCOM130.T$CADR  = TCMCS065.T$CADR

	INNER JOIN BAANDB.TZNFMD001601    ZNFMD001
			ON ZNFMD001.T$FOVN$C = TCCOM130.T$FOVN$L
			
	INNER JOIN  BAANDB.TTDPUR094601    TDPUR094
			ON TDPUR094.T$POTP = TDPUR400.T$COTP
	  
	INNER JOIN ( SELECT  A.T$NCMP$L, 
						 A.T$OORG$L, 
						 A.T$ORNO$L, 
						 A.T$FIRE$L
					FROM BAANDB.TTDREC947601    A
				GROUP BY A.T$NCMP$L, 
						 A.T$OORG$L, 
						 A.T$ORNO$L,
						 A.T$FIRE$L ) TDREC947
			ON TDREC947.T$NCMP$L = 601  
		   AND TDREC947.T$OORG$L = 80
		   AND TDREC947.T$ORNO$L = TDPUR400.T$ORNO

	 LEFT JOIN BAANDB.TTDREC940601    TDREC940
			ON TDREC940.T$FIRE$L = TDREC947.T$FIRE$L

	 LEFT JOIN BAANDB.TTCCOM100601    TCCOM100
			ON TCCOM100.T$BPID = TDPUR400.T$OTBP

	 LEFT JOIN BAANDB.TTDREC943601    TDREC943
			ON TDREC943.T$FIRE$L = TDREC940.T$FIRE$L

	 LEFT JOIN ( select l.t$desc STATUS_APROVACAO_FIS,
						d.t$cnst Code
				   from baandb.tttadv401000 d,
						baandb.tttadv140000 l
				  where d.t$cpac = 'td'
					and d.t$cdom = 'rec.stat.l'
					and l.t$clan = 'p'
					and l.t$cpac = 'td'
					and l.t$clab = d.t$za_clab
					and rpad(d.t$vers,4) ||
						rpad(d.t$rele,2) ||
						rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
														rpad(l1.t$rele,2) ||
														rpad(l1.t$cust,4)) 
											   from baandb.tttadv401000 l1 
											  where l1.t$cpac = d.t$cpac 
												and l1.t$cdom = d.t$cdom )
					and rpad(l.t$vers,4) ||
						rpad(l.t$rele,2) ||
						rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
														rpad(l1.t$rele,2) ||
														rpad(l1.t$cust,4)) 
											   from baandb.tttadv140000 l1 
											  where l1.t$clab = l.t$clab 
												and l1.t$clan = l.t$clan 
												and l1.t$cpac = l.t$cpac ) ) APROVACAO_FIS
			ON APROVACAO_FIS.Code = tdrec940.t$stat$l

	 LEFT JOIN ( SELECT A.T$ORNO, A.T$LOGN
				   FROM BAANDB.TTDPUR450601    A
				  WHERE A.T$TRDT = ( SELECT MIN(B.T$TRDT)
									   FROM BAANDB.TTDPUR450601    B
									  WHERE B.T$ORNO = A.T$ORNO ) ) TDPUR450
			ON TDPUR450.T$ORNO  = TDPUR400.T$ORNO
	 
	 LEFT JOIN ( SELECT TTAAD200.T$USER, 
						TTAAD200.T$NAME
				   FROM BAANDB.TTTAAD200000 TTAAD200 ) USER_NAME
			ON USER_NAME.T$USER  =  TDPUR450.T$LOGN
	   
	WHERE (   TDPUR400.T$COTP IN ('A01', 'A02', 'A03', 'A04', 'A05', 'A06') 
		   OR TDREC940.T$OPFC$L IN ('1102', '1300', '1303', '1253','1551', '1556', '1403', '1406', '1407', '1922', '1933', '2102', '2253', '2303', '2551', '2556', '2407', '2406', '2922'))

	  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDPUR400.T$ODAT, 
			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
			  AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE) )
		  BETWEEN :DataOrdemDe AND :DataOrdemAte
	  AND TRIM(ZNFMD001.T$FILI$C) IN (:Filial) 
	  AND NVL(APROVACAO_FIS.Code, 0) IN (:SituacaoNF) 


--view com parâmetros    
=
"	SELECT TDREC940.T$FIRE$L,"&
"	  ZNFMD001.T$FILI$C                                  ID_FILIAL,"&
"	  ZNFMD001.T$DSCA$C                                  DESCR_FILIAL,"&
"	  TDPUR400.T$ORNO                                    ORDEM_COMPRA,"&
"	  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDPUR400.T$ODAT, "&
"		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')"&
"		  AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)     DATA_ORDEM,  "&
"	  TDPUR400.T$COTP                                    TIPO_OC,"&
"	  TDPUR094.T$DSCA                                    DESC_TIPO_OC,"&
"	  TDREC940.T$DOCN$L                                  NOTA,"&
"	  TDREC940.T$SERI$L                                  SERIE,"&
"	  TCCOM100.T$NAMA                                    FORNECEDOR,"&
"	  TDREC940.T$FOVN$L                                  CNPJ,"&
"	  "&
"	  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC943.T$ICAD$L, "&
"		'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')"&
"		 AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE)      DATA_VENCTO,"&
"	  NVL(TRIM(APROVACAO_FIS.STATUS_APROVACAO_FIS), "&
"		  'Não definido')                                SITUACAO_NF,"&
"	  TDREC940.T$TFDA$L                                  VL_TOTAL,"&
"	  USER_NAME.T$NAME                                   SOLICITANTE"&
""&
"	FROM       BAANDB.TTDPUR400" + Parameters!Compania.Value +  "   TDPUR400"&
"	 "&
"	INNER JOIN BAANDB.TTCMCS065" + Parameters!Compania.Value +  "   TCMCS065"&
"			ON TCMCS065.T$CWOC  = TDPUR400.T$COFC"&
"			"&
"	INNER JOIN BAANDB.TTCCOM130" + Parameters!Compania.Value +  "   TCCOM130"&
"			ON TCCOM130.T$CADR  = TCMCS065.T$CADR"&
""&
"	INNER JOIN BAANDB.TZNFMD001" + Parameters!Compania.Value +  "   ZNFMD001"&
"			ON ZNFMD001.T$FOVN$C = TCCOM130.T$FOVN$L"&
"			"&
"	INNER JOIN  BAANDB.TTDPUR094" + Parameters!Compania.Value +  "   TDPUR094"&
"			ON TDPUR094.T$POTP = TDPUR400.T$COTP"&
"	  "&
"	INNER JOIN ( SELECT  A.T$NCMP$L, "&
"						 A.T$OORG$L, "&
"						 A.T$ORNO$L, "&
"						 A.T$FIRE$L"&
"					FROM BAANDB.TTDREC947" + Parameters!Compania.Value +  "   A"&
"				GROUP BY A.T$NCMP$L, "&
"						 A.T$OORG$L, "&
"						 A.T$ORNO$L,"&
"						 A.T$FIRE$L ) TDREC947"&
"			ON TDREC947.T$NCMP$L = " + Parameters!Compania.Value +  " "&
"		   AND TDREC947.T$OORG$L = 80"&
"		   AND TDREC947.T$ORNO$L = TDPUR400.T$ORNO"&
""&
"	 LEFT JOIN BAANDB.TTDREC940" + Parameters!Compania.Value +  "   TDREC940"&
"			ON TDREC940.T$FIRE$L = TDREC947.T$FIRE$L"&
""&
"	 LEFT JOIN BAANDB.TTCCOM100" + Parameters!Compania.Value +  "   TCCOM100"&
"			ON TCCOM100.T$BPID = TDPUR400.T$OTBP"&
""&
"	 LEFT JOIN BAANDB.TTDREC943" + Parameters!Compania.Value +  "   TDREC943"&
"			ON TDREC943.T$FIRE$L = TDREC940.T$FIRE$L"&
""&
"	 LEFT JOIN ( select l.t$desc STATUS_APROVACAO_FIS,"&
"						d.t$cnst Code"&
"				   from baandb.tttadv401000 d,"&
"						baandb.tttadv140000 l"&
"				  where d.t$cpac = 'td'"&
"					and d.t$cdom = 'rec.stat.l'"&
"					and l.t$clan = 'p'"&
"					and l.t$cpac = 'td'"&
"					and l.t$clab = d.t$za_clab"&
"					and rpad(d.t$vers,4) ||"&
"						rpad(d.t$rele,2) ||"&
"						rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||"&
"														rpad(l1.t$rele,2) ||"&
"														rpad(l1.t$cust,4)) "&
"											   from baandb.tttadv401000 l1 "&
"											  where l1.t$cpac = d.t$cpac "&
"												and l1.t$cdom = d.t$cdom )"&
"					and rpad(l.t$vers,4) ||"&
"						rpad(l.t$rele,2) ||"&
"						rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||"&
"														rpad(l1.t$rele,2) ||"&
"														rpad(l1.t$cust,4)) "&
"											   from baandb.tttadv140000 l1 "&
"											  where l1.t$clab = l.t$clab "&
"												and l1.t$clan = l.t$clan "&
"												and l1.t$cpac = l.t$cpac ) ) APROVACAO_FIS"&
"			ON APROVACAO_FIS.Code = tdrec940.t$stat$l"&
""&
"	 LEFT JOIN ( SELECT A.T$ORNO, A.T$LOGN"&
"				   FROM BAANDB.TTDPUR450" + Parameters!Compania.Value +  "   A"&
"				  WHERE A.T$TRDT = ( SELECT MIN(B.T$TRDT)"&
"									   FROM BAANDB.TTDPUR450" + Parameters!Compania.Value +  "   B"&
"									  WHERE B.T$ORNO = A.T$ORNO ) ) TDPUR450"&
"			ON TDPUR450.T$ORNO  = TDPUR400.T$ORNO"&
"	 "&
"	 LEFT JOIN ( SELECT TTAAD200.T$USER, "&
"						TTAAD200.T$NAME"&
"				   FROM BAANDB.TTTAAD200000 TTAAD200 ) USER_NAME"&
"			ON USER_NAME.T$USER  =  TDPUR450.T$LOGN"&
"	   "&
"	WHERE (   TDPUR400.T$COTP IN ('A01', 'A02', 'A03', 'A04', 'A05', 'A06') "&
"		   OR TDREC940.T$OPFC$L IN ('1102', '1300', '1303', '1253','1551', '1556', '1403', '1406', '1407', '1922', '1933', '2102', '2253', '2303', '2551', '2556', '2407', '2406', '2922'))"&
""&
"	  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDPUR400.T$ODAT, "&
"			'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')"&
"			  AT TIME ZONE 'AMERICA/SAO_PAULO') AS DATE) )"&
"		  BETWEEN :DataOrdemDe AND :DataOrdemAte"&
"	  AND TRIM(ZNFMD001.T$FILI$C) IN (" + Replace(("'" + JOIN(Parameters!Filial.Value, "',") + "'"),",",",'") + ") "&
"	  AND NVL(APROVACAO_FIS.Code, 0) IN (" + Replace(("'" + JOIN(Parameters!SituacaoNF.Value, "',") + "'"),",",",'") + ") "