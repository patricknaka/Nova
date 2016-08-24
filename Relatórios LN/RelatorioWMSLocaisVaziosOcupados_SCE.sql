
"SELECT '"+ Parameters!Table.Label + "' ARMAZEM, "&
"       L.LOC,  "& 
"       L.PUTAWAYZONE,  "&
"       CASE  "&
"            WHEN sum(SL.QTY) > 0 THEN 'OCUPADO'  "&
"            ELSE 'VAZIO'  "&
"      END AS STATUS  "&
"  "&     
"FROM " + Parameters!Table.Value + ".LOC L  "&
"  "&
"LEFT JOIN " + Parameters!Table.Value + ".SKUXLOC SL  "&
"     ON SL.LOC = L.LOC  "&
"  "&   
"GROUP BY L.LOC, L.PUTAWAYZONE  "&
"ORDER BY L.LOC "
