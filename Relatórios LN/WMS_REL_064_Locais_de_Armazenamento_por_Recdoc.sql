SELECT
  DISTINCT
    WMSADMIN.DB_ALIAS                     PLANTA,
    SUBSTR(TASKDETAIL.SOURCEKEY,0,11)     RECDOC,
    TASKDETAIL.SKU                        ID_ITEM,
    SKU.DESCR                             ITEM_NOME,
    TASKDETAIL.UOMQTY                     QTDE,
    TASKDETAIL.TASKDETAILKEY              ID_ROM,
    TASKDETAIL.STATUS                     SIT_ROM,
 
    ( select a.description                 
        from WMWHSE4.codelkup a                       
       where a.code = TASKDETAIL.STATUS       
         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,
   
    TASKDETAIL.EDITDATE                   DT_SIT_ROM,
    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,
    LOC.LOGICALLOCATION                   ENDERECO
  
FROM WMWHSE4.LOC,
     WMWHSE4.SKU,
     WMWHSE4.TASKDETAIL,  
     WMSADMIN.PL_DB WMSADMIN
  
WHERE SKU.SKU = TASKDETAIL.SKU
  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID
  AND LOC.LOC = TASKDETAIL.TOLOC
  AND TASKDETAIL.TASKTYPE = 'PA'
  AND TASKDETAIL.STATUS = '9'
  
  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) = :RecDoc
  
  
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from " + Parameters!Table.Value + ".codelkup a     " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM " + Parameters!Table.Value + ".LOC,                   " &
"     " + Parameters!Table.Value + ".SKU,                   " &
"     " + Parameters!Table.Value + ".TASKDETAIL,            " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        "

-- Query com UNION ********************************************

"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE1.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE1.LOC,                                          " &
"     WMWHSE1.SKU,                                          " &
"     WMWHSE1.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE2.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE2.LOC,                                          " &
"     WMWHSE2.SKU,                                          " &
"     WMWHSE2.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE3.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE3.LOC,                                          " &
"     WMWHSE3.SKU,                                          " &
"     WMWHSE3.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE4.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE4.LOC,                                          " &
"     WMWHSE4.SKU,                                          " &
"     WMWHSE4.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE5.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE5.LOC,                                          " &
"     WMWHSE5.SKU,                                          " &
"     WMWHSE5.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE6.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE6.LOC,                                          " &
"     WMWHSE6.SKU,                                          " &
"     WMWHSE6.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"Union                                                      " &
"                                                           " &
"SELECT                                                     " &
"  DISTINCT                                                 " &
"    WMSADMIN.DB_ALIAS                     PLANTA,          " &
"    SUBSTR(TASKDETAIL.SOURCEKEY,0,10)     RECDOC,          " &
"    TASKDETAIL.SKU                        ID_ITEM,         " &
"    SKU.DESCR                             ITEM_NOME,       " &
"    TASKDETAIL.UOMQTY                     QTDE,            " &
"    TASKDETAIL.TASKDETAILKEY              ID_ROM,          " &
"    TASKDETAIL.STATUS                     SIT_ROM,         " &
"                                                           " &
"    ( select a.description                                 " &
"        from WMWHSE7.codelkup a                            " &
"       where a.code = TASKDETAIL.STATUS                    " &
"         and a.listname = 'TMSTATUS' )    DESC_STI_ROM,    " &
"                                                           " &
"    TASKDETAIL.EDITDATE                   DT_SIT_ROM,      " &
"    TASKDETAIL.TOLOC                      ID_LOCAL_DEST,   " &
"    LOC.LOGICALLOCATION                   ENDERECO         " &
"                                                           " &
"FROM WMWHSE7.LOC,                                          " &
"     WMWHSE7.SKU,                                          " &
"     WMWHSE7.TASKDETAIL,                                   " &
"     WMSADMIN.PL_DB WMSADMIN                               " &
"                                                           " &
"WHERE SKU.SKU = TASKDETAIL.SKU                             " &
"  AND UPPER(WMSADMIN.DB_LOGID) = TASKDETAIL.WHSEID         " &
"  AND LOC.LOC = TASKDETAIL.TOLOC                           " &
"  AND TASKDETAIL.TASKTYPE = 'PA'                           " &
"  AND TASKDETAIL.STATUS = '9'                              " &
"                                                           " &
"  AND SUBSTR(TASKDETAIL.SOURCEKEY,0,10) =                  " &
"  '" + Parameters!RecDoc.Value + "'                        " &
"                                                           " &
"ORDER BY PLANTA                                            "