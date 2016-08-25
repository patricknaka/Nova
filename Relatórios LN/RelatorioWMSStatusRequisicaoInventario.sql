"select '"+ Parameters!Table.Label +"' COMPANIA,  "  &
"		gcd.requestnumber as NUM_REQUISICAO,  "  &
"       gcd.location AS LOCAL,    "  &
"       l.locbarcode AS  COD_OCULTO,  "  &
"       gcd.EDITWHO AS USER_ULTIMA_ATUL,  "  &
"       gcd.COUNTUSER AS USER_CONTAGEM,   "  &
"       gcd.NOOFCOUNTED AS QTD_CONT_EFETUADAS,    "  &
"       gcd.NOOFCOUNTS AS QTDE_CONTADA,   "  &
"       TO_DATE(gcd.USERCOUNTDATE) as DATA_CONTAGEM,  "  &
"       CASE to_char (GCD.STATUS)     "  &
"                WHEN '01' THEN 'NÃO CONTADO'     "  &
"                WHEN '02' THEN 'CONTADO'     "  &
"                WHEN '03' THEN 'EM CONTAGEM'     "  &
"                WHEN '04' THEN 'LOCAL VAZIO'     "  &
"                WHEN '05' THEN 'POSTADO'     "  &
"                WHEN '06' THEN 'CONTAGEM SUPERVISOR'     "  &
"                WHEN '07' THEN 'RECONTAR'    "  &
"                WHEN '08' THEN 'DESBLOQUEADO'    "  &
"                WHEN '09' THEN 'EM POSTAGEM'     "  &
"        END status  "  &
" from " + Parameters!Table.Value + ".GLOBALINVCOUNTDETAIL gcd, " + Parameters!Table.Value + ".loc l    "  &
"where ( (gcd.requestnumber IN  " &
"        ( " + IIF(Trim(Parameters!Requisicao.Value) = "", "''", "'" + Replace(Replace(Parameters!Requisicao.Value, " ", ""), ",", "','") + "'")  + " )  "&
"           AND (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 0))  " &
"            OR (" + IIF(Parameters!Requisicao.Value Is Nothing, "1", "0") + " = 1) )  " &
"  and l.loc = gcd.location   "  &
"    "  &
" order by gcd.status  "
