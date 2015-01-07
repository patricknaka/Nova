SELECT CG.WHSEID            ID_FILIAL,
       CL.UDF2              DESCR_FILIAL,
       PZ.PUTAWAYZONE       ZONA,
       SUBSTR(CG.LOC,1,5)   RUA,
       SUM(CASE WHEN CG.STATUS != 0 
                  THEN 1 
                ELSE 0 
            END)            QT_INVENTARIO,
       COUNT(CG.LOC)        QT_HABILITADO
FROM ( select IV.WHSEID,
              IV.LOC,
              MAX(IV.STATUS) STATUS
         from ( SELECT CD.WHSEID,
                       CD.LOC,
                       CD.STATUS
                  FROM WMWHSE5.CC CC
            INNER JOIN WMWHSE5.CCDETAIL CD 
                    ON CD.CCKEY = CC.CCKEY
                 WHERE CC.STATUS != 9
                 UNION 
                SELECT PH.WHSEID,
                       PH.LOC,
                       PH.STATUS
                  FROM WMWHSE5.PHYSICAL PH ) IV
     group by IV.WHSEID, IV.LOC ) CG
INNER JOIN WMWHSE5.LOC LC 
        ON LC.LOC = CG.LOC
INNER JOIN WMWHSE5.PUTAWAYZONE PZ 
        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE
INNER JOIN ENTERPRISE.CODELKUP CL 
        ON UPPER(CL.UDF1) = CG.WHSEID
       AND CL.LISTNAME = 'SCHEMA'
  GROUP BY PZ.PUTAWAYZONE,
           SUBSTR(CG.LOC,1,5),
           CG.WHSEID,
           CL.UDF2
		   
		   
=IIF(Parameters!Table.Value <> "AAA",

"SELECT CG.WHSEID            ID_FILIAL,                                  " &
"       CL.UDF2              DESCR_FILIAL,                               " &
"       PZ.PUTAWAYZONE       ZONA,                                       " &
"       SUBSTR(CG.LOC,1,5)   RUA,                                        " &
"       SUM(CASE WHEN CG.STATUS != 0                                     " &
"                  THEN 1                                                " &
"                ELSE 0                                                  " &
"            END)            QT_INVENTARIO,                              " &
"       COUNT(CG.LOC)        QT_HABILITADO                               " &
"FROM ( select IV.WHSEID,                                                " &
"              IV.LOC,                                                   " &
"              MAX(IV.STATUS) STATUS                                     " &
"         from ( SELECT CD.WHSEID,                                       " &
"                       CD.LOC,                                          " &
"                       CD.STATUS                                        " &
"                  FROM " + Parameters!Table.Value + ".CC CC             " &
"            INNER JOIN " + Parameters!Table.Value + ".CCDETAIL CD       " &
"                    ON CD.CCKEY = CC.CCKEY                              " &
"                 WHERE CC.STATUS != 9                                   " &
"                 UNION                                                  " &
"                SELECT PH.WHSEID,                                       " &
"                       PH.LOC,                                          " &
"                       PH.STATUS                                        " &
"                  FROM " + Parameters!Table.Value + ".PHYSICAL PH ) IV  " &
"     group by IV.WHSEID, IV.LOC ) CG                                    " &
"INNER JOIN " + Parameters!Table.Value + ".LOC LC                        " &
"        ON LC.LOC = CG.LOC                                              " &
"INNER JOIN " + Parameters!Table.Value + ".PUTAWAYZONE PZ                " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE                              " &
"INNER JOIN ENTERPRISE.CODELKUP CL                                       " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                                   " &
"       AND CL.LISTNAME = 'SCHEMA'                                       " &
"  GROUP BY PZ.PUTAWAYZONE,                                              " &
"           SUBSTR(CG.LOC,1,5),                                          " &
"           CG.WHSEID,                                                   " &
"           CL.UDF2                                                      " &
"                                                                        " &
"ORDER BY PZ.PUTAWAYZONE, SUBSTR(CG.LOC,1,5)                             "

,

"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE1.CC CC                 " &
"            INNER JOIN WMWHSE1.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE1.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE1.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE1.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE2.CC CC                 " &
"            INNER JOIN WMWHSE2.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE2.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE2.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE2.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE3.CC CC                 " &
"            INNER JOIN WMWHSE3.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE3.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE3.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE3.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE4.CC CC                 " &
"            INNER JOIN WMWHSE4.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE4.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE4.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE4.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE5.CC CC                 " &
"            INNER JOIN WMWHSE5.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE5.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE5.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE5.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE6.CC CC                 " &
"            INNER JOIN WMWHSE6.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE6.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE6.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE6.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"Union                                                " &
"                                                     " &
"SELECT CG.WHSEID            ID_FILIAL,               " &
"       CL.UDF2              DESCR_FILIAL,            " &
"       PZ.PUTAWAYZONE       ZONA,                    " &
"       SUBSTR(CG.LOC,1,5)   RUA,                     " &
"       SUM(CASE WHEN CG.STATUS != 0                  " &
"                  THEN 1                             " &
"                ELSE 0                               " &
"            END)            QT_INVENTARIO,           " &
"       COUNT(CG.LOC)        QT_HABILITADO            " &
"FROM ( select IV.WHSEID,                             " &
"              IV.LOC,                                " &
"              MAX(IV.STATUS) STATUS                  " &
"         from ( SELECT CD.WHSEID,                    " &
"                       CD.LOC,                       " &
"                       CD.STATUS                     " &
"                  FROM WMWHSE7.CC CC                 " &
"            INNER JOIN WMWHSE7.CCDETAIL CD           " &
"                    ON CD.CCKEY = CC.CCKEY           " &
"                 WHERE CC.STATUS != 9                " &
"                 UNION                               " &
"                SELECT PH.WHSEID,                    " &
"                       PH.LOC,                       " &
"                       PH.STATUS                     " &
"                  FROM WMWHSE7.PHYSICAL PH ) IV      " &
"     group by IV.WHSEID, IV.LOC ) CG                 " &
"INNER JOIN WMWHSE7.LOC LC                            " &
"        ON LC.LOC = CG.LOC                           " &
"INNER JOIN WMWHSE7.PUTAWAYZONE PZ                    " &
"        ON PZ.PUTAWAYZONE = LC.PUTAWAYZONE           " &
"INNER JOIN ENTERPRISE.CODELKUP CL                    " &
"        ON UPPER(CL.UDF1) = CG.WHSEID                " &
"       AND CL.LISTNAME = 'SCHEMA'                    " &
"  GROUP BY PZ.PUTAWAYZONE,                           " &
"           SUBSTR(CG.LOC,1,5),                       " &
"           CG.WHSEID,                                " &
"           CL.UDF2                                   " &
"                                                     " &
"ORDER BY DESCR_FILIAL, ZONA, RUA                     "

)