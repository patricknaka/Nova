SELECT      
  CAGE.CAGEID              GAIOLA, 
  F171.T$NENT$C            ID_CAMI,                      
  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  
                           PLACA_CAMI,                   
  CASE                                                   
   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               
   WHEN F170.T$CFIM$C IS NULL THEN NULL                  
   ELSE 'ABERTO'                                         
  END                      SIT_CAMI,                                           
  CGST.DESCRIPTION         GAIOLA_SIT,                   
  CAGE.WHSEID              ID_PLANTA,                    
  PLDS.UDF2                DESCR_PLANTA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_ABERTURA_GAIOLA,
        
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CAGE.CLOSEDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) DATA_FECHAMENTO_GAIOLA  
                                                         
FROM       WMWHSE5.CAGEID CAGE    
                                                         
INNER JOIN WMWHSE5.CODELKUP CGST   
        ON CGST.CODE = CAGE.STATUS                       
       AND CGST.LISTNAME = 'CAGESTATUS'                  
                                                         
INNER JOIN ENTERPRISE.CODELKUP PLDS                      
        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                
       AND PLDS.LISTNAME = 'SCHEMA'                      
                                                         
 LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                
        ON F171.T$NCAR$C = CAGE.CAGEID                   
                                                         
 LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                
        ON F170.T$FILI$C = F171.T$FILI$C                 
       AND F170.T$NENT$C = F171.T$NENT$C                 
       AND F170.T$CFRW$C = F171.T$CFRW$C                 
       AND F170.T$CFIM$C!= 1                             
                                                         
WHERE CAGE.STATUS != '7'                                 
                                                         
 ORDER BY DESCR_PLANTA, CAGE.CAGEID 


=IIF(Parameters!Table.Value <> "AAA",

"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       " + Parameters!Table.Value + ".CAGEID CAGE    " &
"                                                         " &
"INNER JOIN " + Parameters!Table.Value + ".CODELKUP CGST  " & 
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
" ORDER BY DESCR_PLANTA, ID_CAMI                          "
                                                          
,                                                         
                                                          
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE1.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE1.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE2.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE2.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE3.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE3.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE4.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE4.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE5.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE5.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE6.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE6.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"UNION                                                    " &
"                                                         " &
"SELECT                                                   " &
"  F171.T$NENT$C            ID_CAMI,                      " &
"  NVL(F170.T$VPLT$C, NVL(F170.T$VPLC$C, F170.T$VPLA$C))  " &
"                           PLACA_CAMI,                   " &
"  CASE                                                   " &
"   WHEN F170.T$CFIM$C = 1 THEN 'ENCERRADO'               " &
"   WHEN F170.T$CFIM$C IS NULL THEN NULL                  " &
"   ELSE 'ABERTO'                                         " &
"  END                      SIT_CAMI,                     " &
"  CAGE.CAGEID              GAIOLA,                       " &
"  CGST.DESCRIPTION         GAIOLA_SIT,                   " &
"  CAGE.WHSEID              ID_PLANTA,                    " &
"  PLDS.UDF2                DESCR_PLANTA                  " &
"                                                         " &
"FROM       WMWHSE7.CAGEID CAGE                           " &
"                                                         " &
"INNER JOIN WMWHSE7.CODELKUP CGST                         " &
"        ON CGST.CODE = CAGE.STATUS                       " &
"       AND CGST.LISTNAME = 'CAGESTATUS'                  " &
"                                                         " &
"INNER JOIN ENTERPRISE.CODELKUP PLDS                      " &
"        ON UPPER(PLDS.UDF1) = CAGE.WHSEID                " &
"       AND PLDS.LISTNAME = 'SCHEMA'                      " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD171301@pln01 F171                " &
"        ON F171.T$NCAR$C = CAGE.CAGEID                   " &
"                                                         " &
" LEFT JOIN BAANDB.TZNFMD170301@pln01 F170                " &
"        ON F170.T$FILI$C = F171.T$FILI$C                 " &
"       AND F170.T$NENT$C = F171.T$NENT$C                 " &
"       AND F170.T$CFRW$C = F171.T$CFRW$C                 " &
"       AND F170.T$CFIM$C!= 1                             " &
"                                                         " &
"WHERE CAGE.STATUS != '7'                                 " &
"                                                         " &
"ORDER BY DESCR_PLANTA, ID_CAMI                           " 
)