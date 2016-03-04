SELECT
  DISTINCT
    WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,
    LOC.PUTAWAYZONE                                    CLASSSE,
    PUTAWAYZONE.DESCR                                  NOME,
    count(distinct LOC.LOC)                            NUM_LOCAIS,
    NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,
    count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,
    ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /
             count(distinct LOC.LOC) ), 4 )            PERC_OCUP

FROM       WMWHSE5.LOC

INNER JOIN WMWHSE5.PUTAWAYZONE  PUTAWAYZONE
        ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE
       AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)

INNER JOIN WMSADMIN.PL_DB  PL_DB
        ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)

 LEFT JOIN ( SELECT B.PUTAWAYZONE,
                    UPPER(B.WHSEID) WHSEID,
                    COUNT(distinct A.LOC) QTDE_LOC
               FROM WMWHSE5.SKUXLOC A
         INNER JOIN WMWHSE5.LOC B
                 ON UPPER(B.LOC) = UPPER(A.LOC)
                AND UPPER(A.WHSEID) = UPPER(B.WHSEID)
             HAVING SUM(A.QTY) != 0
           GROUP BY B.PUTAWAYZONE,
                    UPPER(B.WHSEID) ) SKUXLOC
        ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE
       AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)

  GROUP BY WMSADMIN.PL_DB.DB_ALIAS,
           LOC.PUTAWAYZONE,
           PUTAWAYZONE.DESCR,
           PUTAWAYZONE.WHSEID,
           SKUXLOC.QTDE_LOC
		   

=IIF(Parameters!Table.Value <> "AAA", 

" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       " + Parameters!Table.Value + ".LOC  " &
"  " &
" INNER JOIN " + Parameters!Table.Value + ".PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM " + Parameters!Table.Value + ".SKUXLOC A  " &
"          INNER JOIN " + Parameters!Table.Value + ".LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
" ORDER BY PLANTA, CLASSSE  "
		   
,

" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE1.LOC  " &
"  " &
" INNER JOIN WMWHSE1.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE1.SKUXLOC A  " &
"          INNER JOIN WMWHSE1.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE2.LOC  " &
"  " &
" INNER JOIN WMWHSE2.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE2.SKUXLOC A  " &
"          INNER JOIN WMWHSE2.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE3.LOC  " &
"  " &
" INNER JOIN WMWHSE3.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE3.SKUXLOC A  " &
"          INNER JOIN WMWHSE3.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE4.LOC  " &
"  " &
" INNER JOIN WMWHSE4.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE4.SKUXLOC A  " &
"          INNER JOIN WMWHSE4.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE5.LOC  " &
"  " &
" INNER JOIN WMWHSE5.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE5.SKUXLOC A  " &
"          INNER JOIN WMWHSE5.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE6.LOC  " &
"  " &
" INNER JOIN WMWHSE6.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE6.SKUXLOC A  " &
"          INNER JOIN WMWHSE6.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                            PLANTA,  " &
"     LOC.PUTAWAYZONE                                    CLASSSE,  " &
"     PUTAWAYZONE.DESCR                                  NOME,  " &
"     count(distinct LOC.LOC)                            NUM_LOCAIS,  " &
"     NVL(SKUXLOC.QTDE_LOC,0)                            NUM_OCUP,  " &
"     count(distinct LOC.LOC) - NVL(SKUXLOC.QTDE_LOC, 0) NUM_LIVRES,  " &
"     ROUND( ( NVL(SKUXLOC.QTDE_LOC, 0) /  " &
"              count(distinct LOC.LOC) ), 4 )            PERC_OCUP  " &
"  " &
" FROM       WMWHSE7.LOC  " &
"  " &
" INNER JOIN WMWHSE7.PUTAWAYZONE  PUTAWAYZONE  " &
"         ON LOC.PUTAWAYZONE = PUTAWAYZONE.PUTAWAYZONE  " &
"        AND UPPER(LOC.WHSEID) = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  PL_DB  " &
"         ON UPPER(PL_DB.DB_LOGID) = UPPER(LOC.WHSEID)  " &
"  " &
"  LEFT JOIN ( SELECT B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) WHSEID,  " &
"                     COUNT(distinct A.LOC) QTDE_LOC  " &
"                FROM WMWHSE7.SKUXLOC A  " &
"          INNER JOIN WMWHSE7.LOC B  " &
"                  ON UPPER(B.LOC) = UPPER(A.LOC)  " &
"                 AND UPPER(A.WHSEID) = UPPER(B.WHSEID)  " &
"              HAVING SUM(A.QTY) != 0  " &
"            GROUP BY B.PUTAWAYZONE,  " &
"                     UPPER(B.WHSEID) ) SKUXLOC  " &
"         ON SKUXLOC.PUTAWAYZONE = LOC.PUTAWAYZONE  " &
"        AND SKUXLOC.WHSEID = UPPER(PUTAWAYZONE.WHSEID)  " &
"  " &
"   GROUP BY WMSADMIN.PL_DB.DB_ALIAS,  " &
"            LOC.PUTAWAYZONE,  " &
"            PUTAWAYZONE.DESCR,  " &
"            PUTAWAYZONE.WHSEID,  " &
"            SKUXLOC.QTDE_LOC  " &
"  " &
"ORDER BY PLANTA, CLASSSE  "

)
