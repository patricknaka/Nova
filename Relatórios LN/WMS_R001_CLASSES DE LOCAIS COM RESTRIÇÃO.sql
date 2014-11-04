SELECT CL.UDF2                PLANTA,
       LOC.PUTAWAYZONE        ID_ZONA,
       Trim(PZ.DESCR)         DESCR_ZONA,
       LOC.LOC                ID_LOCAL,
       LOC.LOGICALLOCATION    LOC_DESCR,
       SKU.DESCR              DESCR_ITEM,
       sum(LLID.QTY)          ESTO_QTY,
       LLID.EDITWHO           ID_OPERADOR,
       LLID.EDITDATE          DT_MOV,
       CASE WHEN IH.STATUS IS NULL   
              THEN 'OK'   
            ELSE TO_CHAR(IH.STATUS) 
        END                   ID_RESTR

FROM       WMWHSE5.LOTXLOCXID LLID
  
INNER JOIN WMWHSE5.SKU SKU
        ON SKU.SKU = LLID.SKU
  
INNER JOIN WMWHSE5.LOC LOC
        ON LOC.LOC = LLID.LOC

 LEFT JOIN ( select LOC, 
                    STATUS 
               from WMWHSE5.INVENTORYHOLD 
              where hold = 1 
                and loc <> ' ') IH
        ON IH.LOC=LLID.LOC
		
 LEFT JOIN WMWHSE5.PUTAWAYZONE PZ
        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE

 LEFT JOIN ENTERPRISE.CODELKUP CL
        ON UPPER(CL.UDF1) = LLID.WHSEID 
		
WHERE LLID.QTY > 0
  AND CASE WHEN IH.STATUS IS NULL   
             THEN 'OK'   
           ELSE TO_CHAR(IH.STATUS) 
       END IN (:Restricao)
  AND LOC.PUTAWAYZONE IN (:Zona)

GROUP BY LOC.PUTAWAYZONE,    
         PZ.DESCR, 
         LOC.LOC,
         LOC.LOGICALLOCATION,   
         SKU.DESCR,         
         LLID.EDITWHO,    
         LLID.EDITDATE,     
         CASE WHEN IH.STATUS IS NULL 
                THEN 'OK'   
              ELSE TO_CHAR(IH.STATUS) 
          END,  
         CL.UDF2
		 

=IIF(Parameters!Table.Value <> "AAA",
		 
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       "+ Parameters!Table.Value + ".LOTXLOCXID LLID                                           " &
"                                                                                                   " &
"INNER JOIN "+ Parameters!Table.Value + ".SKU SKU                                                   " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN "+ Parameters!Table.Value + ".LOC LOC                                                   " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from "+ Parameters!Table.Value + ".INVENTORYHOLD                                    " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN "+ Parameters!Table.Value + ".PUTAWAYZONE PZ                                            " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"ORDER BY PLANTA, ID_ZONA                                                                           "

,		 
		 
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE1.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE1.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE1.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE1.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE1.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE2.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE2.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE2.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE2.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE2.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE3.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE3.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE3.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE3.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE3.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE4.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE4.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE4.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE4.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE4.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE5.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE5.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE5.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE5.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE5.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE6.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE6.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE6.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE6.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE6.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"Union                                                                                              " &
"		                                                                                            " &
"SELECT CL.UDF2                PLANTA,                                                              " &
"       LOC.PUTAWAYZONE        ID_ZONA,                                                             " &
"       Trim(PZ.DESCR)         DESCR_ZONA,                                                          " &
"       LOC.LOC                ID_LOCAL,                                                            " &
"       LOC.LOGICALLOCATION    LOC_DESCR,                                                           " &
"       SKU.DESCR              DESCR_ITEM,                                                          " &
"       sum(LLID.QTY)          ESTO_QTY,                                                            " &
"       LLID.EDITWHO           ID_OPERADOR,                                                         " &
"       LLID.EDITDATE          DT_MOV,                                                              " &
"       CASE WHEN IH.STATUS IS NULL                                                                 " &
"              THEN 'OK'                                                                            " &
"            ELSE TO_CHAR(IH.STATUS)                                                                " &
"        END                   ID_RESTR                                                             " &
"                                                                                                   " &
"FROM       WMWHSE7.LOTXLOCXID LLID                                                                 " &
"                                                                                                   " &
"INNER JOIN WMWHSE7.SKU SKU                                                                         " &
"        ON SKU.SKU = LLID.SKU                                                                      " &
"                                                                                                   " &
"INNER JOIN WMWHSE7.LOC LOC                                                                         " &
"        ON LOC.LOC = LLID.LOC                                                                      " &
"                                                                                                   " &
" LEFT JOIN ( select LOC,                                                                           " &
"                    STATUS                                                                         " &
"               from WMWHSE7.INVENTORYHOLD                                                          " &
"              where hold = 1                                                                       " &
"                and loc <> ' ') IH                                                                 " &
"        ON IH.LOC=LLID.LOC                                                                         " &
"		                                                                                            " &
" LEFT JOIN WMWHSE7.PUTAWAYZONE PZ                                                                  " &
"        ON PZ.PUTAWAYZONE = LOC.PUTAWAYZONE                                                        " &
"                                                                                                   " &
" LEFT JOIN ENTERPRISE.CODELKUP CL                                                                  " &
"        ON UPPER(CL.UDF1) = LLID.WHSEID                                                            " &
"		                                                                                            " &
"WHERE LLID.QTY > 0                                                                                 " &
"  AND CASE WHEN IH.STATUS IS NULL                                                                  " &
"             THEN 'OK'                                                                             " &
"           ELSE TO_CHAR(IH.STATUS)                                                                 " &
"       END IN ("+ Replace(("'"+ JOIN(Parameters!Restricao.Value, "',") + "'"),",",",'") + ")       " &
"  AND LOC.PUTAWAYZONE IN ("+ Replace(("'"+ JOIN(Parameters!Zona.Value, "',") + "'"),",",",'") + ") " &
"                                                                                                   " &
"GROUP BY LOC.PUTAWAYZONE,                                                                          " &
"         PZ.DESCR,                                                                                 " &
"         LOC.LOC,                                                                                  " &
"         LOC.LOGICALLOCATION,                                                                      " &
"         SKU.DESCR,                                                                                " &
"         LLID.EDITWHO,                                                                             " &
"         LLID.EDITDATE,                                                                            " &
"         CASE WHEN IH.STATUS IS NULL                                                               " &
"                THEN 'OK'                                                                          " &
"              ELSE TO_CHAR(IH.STATUS)                                                              " &
"          END,                                                                                     " &
"         CL.UDF2                                                                                   " &
"		                                                                                            " &
"ORDER BY PLANTA, ID_ZONA                                                                           "

)