SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,
    LOC.PUTAWAYZONE                                  CLASSSE,
    PUTAWAYZONE.DESCR                                NOME,
    count(distinct LOC.LOC)                          NUM_LOCAIS,
  
    count(distinct LOC.LOC) - 
	( SELECT count(distinct A.LOC)  
        FROM WMWHSE4.SKUXLOC A, 
             WMWHSE4.LOC B 
       WHERE B.LOC = A.LOC 
         AND UPPER(A.WHSEID) = UPPER(B.WHSEID) 
         AND A.LOC =  ( select A1.LOC 
                          from WMWHSE4.SKUXLOC A1 
                         where A1.LOC = A.LOC 
                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID) 
                      group by A1.LOC HAVING SUM(A1.QTY)! = 0) 
         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE 
         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )
                                                     NUM_LIVRES,
                            
    ( SELECT count(distinct A.LOC)  
        FROM WMWHSE4.SKUXLOC A, 
             WMWHSE4.LOC B 
       WHERE UPPER(B.LOC) = UPPER(A.LOC) 
         AND UPPER(A.WHSEID) = UPPER(B.WHSEID) 
         AND A.LOC = ( select A1.LOC 
                         from WMWHSE4.SKUXLOC A1 
                        where A1.LOC = A.LOC 
                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID) 
                     group by A1.LOC 
                       having SUM(A1.QTY)! = 0 ) 
         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE 
         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )
                                                     NUM_OCUP,
                           
    ROUND( (( SELECT count(distinct A.LOC)  
                FROM WMWHSE4.SKUXLOC A, 
                     WMWHSE4.LOC B 
               WHERE UPPER(B.LOC) = UPPER(A.LOC) 
                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID) 
                 AND A.LOC = ( select A1.LOC 
                                 from WMWHSE4.SKUXLOC A1 
                                where A1.LOC = A.LOC 
                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID) 
                             group by A1.LOC 
                               having SUM(A1.QTY)! = 0 ) 
                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE 
                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) / 
            count(distinct LOC.LOC)), 4 )            PERC_OCUP 
  
FROM WMWHSE4.PUTAWAYZONE,
     WMSADMIN.PL_DB,
     WMWHSE4.LOC
    
LEFT JOIN WMWHSE4.SKUXLOC 
       ON SKUXLOC.LOC = LOC.LOC
     
LEFT JOIN WMWHSE4.SKU
       ON SKU.SKU = SKUXLOC.SKU

WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE 
  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) 
  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)
  
GROUP BY WMSADMIN.PL_DB.DB_ALIAS, 
         LOC.PUTAWAYZONE, 
         PUTAWAYZONE.DESCR, 
         PUTAWAYZONE.WHSEID
     
ORDER BY LOC.PUTAWAYZONE


"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM " + Parameters!Table.Value + ".SKUXLOC A,                          " &
"             " + Parameters!Table.Value + ".LOC B                               " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from " + Parameters!Table.Value + ".SKUXLOC A1        " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM " + Parameters!Table.Value + ".SKUXLOC A,                          " &
"             " + Parameters!Table.Value + ".LOC B                               " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from " + Parameters!Table.Value + ".SKUXLOC A1         " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM " + Parameters!Table.Value + ".SKUXLOC A,                  " &
"                     " + Parameters!Table.Value + ".LOC B                       " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from " + Parameters!Table.Value + ".SKUXLOC A1 " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM " + Parameters!Table.Value + ".PUTAWAYZONE,                                " &
"     WMSADMIN.PL_DB,                                                            " &
"     " + Parameters!Table.Value + ".LOC                                         " &
"                                                                                " &
"LEFT JOIN " + Parameters!Table.Value + ".SKUXLOC                                " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN " + Parameters!Table.Value + ".SKU                                    " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"ORDER BY LOC.PUTAWAYZONE                                                        "

-- QUERY COM UNION *****************************************************************

"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE1.SKUXLOC A,                                                 " &
"             WMWHSE1.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE1.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE1.SKUXLOC A,                                                 " &
"             WMWHSE1.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE1.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE1.SKUXLOC A,                                         " &
"                     WMWHSE1.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE1.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE1.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE1.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE1.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE1.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE2.SKUXLOC A,                                                 " &
"             WMWHSE2.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE2.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE2.SKUXLOC A,                                                 " &
"             WMWHSE2.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE2.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE2.SKUXLOC A,                                         " &
"                     WMWHSE2.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE2.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE2.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE2.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE2.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE2.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE3.SKUXLOC A,                                                 " &
"             WMWHSE3.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE3.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE3.SKUXLOC A,                                                 " &
"             WMWHSE3.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE3.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE3.SKUXLOC A,                                         " &
"                     WMWHSE3.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE3.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE3.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE3.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE3.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE3.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE4.SKUXLOC A,                                                 " &
"             WMWHSE4.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE4.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE4.SKUXLOC A,                                                 " &
"             WMWHSE4.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE4.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE4.SKUXLOC A,                                         " &
"                     WMWHSE4.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE4.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE4.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE4.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE4.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE4.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE5.SKUXLOC A,                                                 " &
"             WMWHSE5.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE5.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE5.SKUXLOC A,                                                 " &
"             WMWHSE5.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE5.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE5.SKUXLOC A,                                         " &
"                     WMWHSE5.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE5.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE5.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE5.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE5.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE5.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE6.SKUXLOC A,                                                 " &
"             WMWHSE6.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE6.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE6.SKUXLOC A,                                                 " &
"             WMWHSE6.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE6.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE6.SKUXLOC A,                                         " &
"                     WMWHSE6.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE6.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE6.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE6.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE6.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE6.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"Union                                                                           " &
"                                                                                " &
"SELECT                                                                          " &
"  DISTINCT                                                                      " &
"    WMSADMIN.PL_DB.DB_ALIAS                          PLANTA,                    " &
"    LOC.PUTAWAYZONE                                  CLASSSE,                   " &
"    PUTAWAYZONE.DESCR                                NOME,                      " &
"    count(distinct LOC.LOC)                          NUM_LOCAIS,                " &
"                                                                                " &
"    count(distinct LOC.LOC) -                                                   " &
"	( SELECT count(distinct A.LOC)                                               " &
"        FROM WMWHSE7.SKUXLOC A,                                                 " &
"             WMWHSE7.LOC B                                                      " &
"       WHERE B.LOC = A.LOC                                                      " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC =  ( select A1.LOC                                           " &
"                          from WMWHSE7.SKUXLOC A1                               " &
"                         where A1.LOC = A.LOC                                   " &
"                           and UPPER(A1.WHSEID) = UPPER(A.WHSEID)               " &
"                      group by A1.LOC HAVING SUM(A1.QTY)! = 0)                  " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_LIVRES,                " &
"                                                                                " &
"    ( SELECT count(distinct A.LOC)                                              " &
"        FROM WMWHSE7.SKUXLOC A,                                                 " &
"             WMWHSE7.LOC B                                                      " &
"       WHERE UPPER(B.LOC) = UPPER(A.LOC)                                        " &
"         AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                                  " &
"         AND A.LOC = ( select A1.LOC                                            " &
"                         from WMWHSE7.SKUXLOC A1                                " &
"                        where A1.LOC = A.LOC                                    " &
"                          and UPPER(A1.WHSEID) = UPPER(A.WHSEID)                " &
"                     group by A1.LOC                                            " &
"                       having SUM(A1.QTY)! = 0 )                                " &
"         AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                                    " &
"         AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) )                      " &
"                                                     NUM_OCUP,                  " &
"                                                                                " &
"    ROUND( (( SELECT count(distinct A.LOC)                                      " &
"                FROM WMWHSE7.SKUXLOC A,                                         " &
"                     WMWHSE7.LOC B                                              " &
"               WHERE UPPER(B.LOC) = UPPER(A.LOC)                                " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)                          " &
"                 AND A.LOC = ( select A1.LOC                                    " &
"                                 from WMWHSE7.SKUXLOC A1                        " &
"                                where A1.LOC = A.LOC                            " &
"                                  and UPPER(A1.WHSEID) = UPPER(A.WHSEID)        " &
"                             group by A1.LOC                                    " &
"                               having SUM(A1.QTY)! = 0 )                        " &
"                 AND B.PUTAWAYZONE = LOC.PUTAWAYZONE                            " &
"                 AND UPPER(B.WHSEID) = UPPER(PUTAWAYZONE.WHSEID) ) /            " &
"            count(distinct LOC.LOC)), 4 )            PERC_OCUP                  " &
"                                                                                " &
"FROM WMWHSE7.PUTAWAYZONE,                                                       " &
"     WMSADMIN.PL_DB,                                                            " &
"     WMWHSE7.LOC                                                                " &
"                                                                                " &
"LEFT JOIN WMWHSE7.SKUXLOC                                                       " &
"       ON SKUXLOC.LOC = LOC.LOC                                                 " &
"                                                                                " &
"LEFT JOIN WMWHSE7.SKU                                                           " &
"       ON SKU.SKU = SKUXLOC.SKU                                                 " &
"                                                                                " &
"WHERE LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE                                 " &
"  AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)                             " &
"  AND UPPER(LOC.WHSEID) = UPPER(WMSADMIN.PL_DB.DB_LOGID)                        " &
"                                                                                " &
"GROUP BY WMSADMIN.PL_DB.DB_ALIAS,                                               " &
"         LOC.PUTAWAYZONE,                                                       " &
"         PUTAWAYZONE.DESCR,                                                     " &
"         PUTAWAYZONE.WHSEID                                                     " &
"                                                                                " &
"order by PLANTA, CLASSSE                                                        "