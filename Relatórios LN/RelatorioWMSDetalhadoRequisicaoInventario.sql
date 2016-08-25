
"SELECT DISTINCT '"+ Parameters!Table.Label +"' ARMAZEM,  "  &
"                GRD.SERIALKEY, "  &
"				 GRD.REQUESTNUMBER, "  &
"				 GRD.LOCATION AS LOCAL,   "  &
"				 PTY.PUTAWAYZONE AS ZONA, "  &
"				 TO_CHAR(GRD.SKU) AS ITEM, "  &
"				 TO_CHAR(SKU.DESCR) AS DESCRICAO, "  &
"				 TO_NUMBER(GRD.COUNTQTY) AS QTY_CONTADA, "  &
"				 TO_NUMBER(GRD.SYSTEMQTY) AS QTY_SISTEMA, "  &
"				 TO_NUMBER(GRD.COUNTQTY-GRD.SYSTEMQTY) AS DIFERENCA, "  &
"				 CASE TO_CHAR (GRD.STATUS) "  &
"					  WHEN '01' THEN 'NAO_CONTADO'   "  &
"					  WHEN '02' THEN 'CONTADO'  "  &
"					  WHEN '03' THEN 'LOCAL_VAZIO'   "  &
"					  WHEN '04' THEN 'POSTADO'  "  &
"					  WHEN '05' THEN 'CONTAGEM_SUPERVISOR'  "  &
"					  WHEN '06' THEN 'RECONTAGEM' "  &
"					  WHEN '07' THEN 'EM CONTAGEM'   "  &
"					  WHEN '08' THEN 'ITEM ENCONTRADO'  "  &
"			     END AS STATUS_CONTAGEM,  "  &
"				 GRD.EDITWHO AS USUARIO_CONTAGEM, "  &
"				 TO_CHAR(GRD.EDITDATE ,'DD/MM/YYYY') AS DATAFECHALOCAL, "  &
"				 TO_CHAR(GRD.EDITDATE ,'HH24:MM:SS') AS HORAFECHAMENTOLOCAL, "  &
"				 TO_CHAR(BOM.SKU) AS SKU_TIK,  "  &
"				 CASE to_char(BOM.primarycomponent)   "  &
"					  WHEN '0' THEN 'N'  "  &
"					  WHEN '1' THEN 'S'  "  &
"                END AS PRIMARIO   "  &
"  FROM " + Parameters!Table.Value + ".GLOBALINVREQUESTDETAIL GRD, " + Parameters!Table.Value + ".SKU SKU,"  & 
"		" + Parameters!Table.Value + ".PUTAWAYZONE PTY, " + Parameters!Table.Value + ".LOC LOC, "  &
"		" + Parameters!Table.Value + ".BILLOFMATERIAL BOM "  &
" "  &
" WHERE GRD.SYSTEMQTY >=0   "  &
"   AND GRD.SKU = SKU.SKU   "  &
"   AND GRD.LOCATION = LOC.LOC "  &
"   AND LOC.PUTAWAYZONE = PTY.PUTAWAYZONE "  &
"   AND BOM.COMPONENTSKU(+) = GRD.SKU "  &
"   and ( (GRD.REQUESTNUMBER IN  " &
"         ( " + IIF(Trim(Parameters!Requisicao.Value) = "", "''", "'" + Replace(Replace(Parameters!Requisicao.Value, " ", ""), ",", "','") + "'")  + " )  "&
"               AND (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 0))  " &
"                OR (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 1) )  " &
" "  &
"UNION ALL "  &
" "  &
"SELECT DISTINCT '"+ Parameters!Table.Label +"' COMPANIA,  "  &
"                GCD.SERIALKEY, "  &
"				 GCD.REQUESTNUMBER, "  &
"				 GCD.LOCATION AS LOCAL,   "  &
"				 PTY.PUTAWAYZONE AS ZONA, "  &
"				 TO_CHAR('') AS SKU,  "  &
"				 '' AS DESCRICAO, TO_NUMBER('0') AS QTY_CONTADA, "  &
"				 TO_NUMBER('0') AS QTY_SISTEMA,  "  &
"				 TO_NUMBER('0') AS DIFERENCA, "  &
"				 CASE TO_CHAR (GCD.STATUS) "  &
"				      WHEN '04' THEN 'LOCAL VAZIO'   "  &
"					  WHEN '06' THEN 'CONTAGEM SUPERVISOR'  "  &
"				 END AS STATUS_CONTAGEM,  "  &
"				 GCD.EDITWHO AS USUARIO_CONTAGEM, "  &
"				 TO_CHAR(GCD.EDITDATE ,'DD/MM/YYYY') AS DATAFECHALOCAL, "  &
"				 TO_CHAR(GCD.EDITDATE ,'HH24:MM:SS') AS HORAFECHAMENTOLOCAL, "  &
"				 TO_CHAR('') AS  SKU_TIK,  "  &
"				 TO_CHAR('') AS PRIMARIO  "  &
"  FROM " + Parameters!Table.Value + ".GLOBALINVCOUNTDETAIL GCD, " + Parameters!Table.Value + ".PUTAWAYZONE PTY, "  &
"		" + Parameters!Table.Value + ".LOC LOC  "  &
" "  &
" WHERE GCD.STATUS IN ('04','06')  "  &
"   AND GCD.LOCATION = LOC.LOC "  &
"   AND LOC.PUTAWAYZONE = PTY.PUTAWAYZONE "  &
"   AND GCD.LOCATION NOT IN (SELECT LOCATION FROM " + Parameters!Table.Value + ".GLOBALINVREQUESTDETAIL GRD)  "  &
"   and ( (GCD.REQUESTNUMBER IN  " &
"         ( " + IIF(Trim(Parameters!Requisicao.Value) = "", "''", "'" + Replace(Replace(Parameters!Requisicao.Value, " ", ""), ",", "','") + "'")  + " )  "&
"               AND (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 0))  " &
"                OR (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 1) )  " &
" "  &
"ORDER BY 2, 3 "
