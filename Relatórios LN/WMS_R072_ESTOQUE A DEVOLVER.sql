SELECT WMSADMIN.DB_ALIAS               PLANTA,
       LLID.LOC                        ID_LOCAL,
       PTWZ.DESCR                      DESCR_LOCAL,   
       SUM(LLID.QTY)                   ESTO_QT,  
       LOCA.STATUS                     ESTO_SIT,
       LLID.SKU                        ID_ITEM,
       SKUT.DESCR                      DESCR_ITEM,
       STOR.COMPANY                    FORNECEDOR,
       TSKD.ASSIGNMENTNUMBER           PROGRAMA,
       TSKD.WAVEKEY                    ONDA,
       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,
       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA
  
FROM      WMWHSE5.LOTXLOCXID LLID

LEFT JOIN ( select a.LOT, 
                   a.SKU,    
                   a.TOLOC, 
                   a.TOID, 
                   a.SOURCEKEY
              from WMWHSE5.ITRN a
             where a.TRANTYPE = 'MV' 
               and a.SOURCETYPE  = 'PICKING'
               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)
                                     FROM WMWHSE5.ITRN b
                                    WHERE b.LOT  = a.LOT  
                                      AND b.SKU        = a.SKU       
                                      AND b.TOLOC      = a.TOLOC     
                                      AND b.TOID       = a.TOID      
                                      AND b.TRANTYPE   = a.TRANTYPE  
                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN
       ON ITRN.LOT = LLID.LOT
      AND ITRN.SKU = LLID.SKU
      AND ITRN.TOLOC = LLID.LOC
      AND ITRN.TOID =  LLID.ID

LEFT JOIN WMWHSE5.TASKDETAIL TSKD 
       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY
      AND TSKD.SOURCETYPE = 'PICKDETAIL'
      AND TSKD.STATUS = '9'
      AND TSKD.TASKTYPE = 'PK'
      AND TSKD.TOLOC = ITRN.TOLOC
	  
LEFT JOIN WMSADMIN.PL_DB WMSADMIN
       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID
    
LEFT JOIN WMWHSE5.LOC   LOCA 
       ON LOCA.LOC = LLID.LOC
	   
LEFT JOIN WMWHSE5.SKU   SKUT 
       ON SKUT.SKU = LLID.SKU
	   
LEFT JOIN WMWHSE5.ORDERDETAIL ORDT 
       ON ORDT.ORDERKEY = TSKD.ORDERKEY
      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER
	  
LEFT JOIN WMWHSE5.PUTAWAYZONE PTWZ 
       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE
	   
LEFT JOIN WMWHSE5.STORER  STOR 
       ON STOR.STORERKEY = SKUT.SUSR5
      AND STOR.WHSEID = SKUT.WHSEID
      AND STOR.TYPE =  5
          
WHERE LLID.QTY > 0
  AND LLID.QTYPICKED < LLID.QTY
  AND LLID.LOC = 'PICKTO'
  
GROUP BY WMSADMIN.DB_ALIAS,
         LLID.LOC,      
         PTWZ.DESCR,          
         LOCA.STATUS,    
         LLID.SKU,      
         STOR.COMPANY,                  
         SKUT.DESCR,      
         TSKD.ASSIGNMENTNUMBER,   
         TSKD.WAVEKEY 
		 
order by 1, 6





=IIF(Parameters!Table.Value <> "AAA",

"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      "+ Parameters!Table.Value + ".LOTXLOCXID LLID                            " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from "+ Parameters!Table.Value + ".ITRN a                            " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM "+ Parameters!Table.Value + ".ITRN b     " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN "+ Parameters!Table.Value + ".TASKDETAIL TSKD                            " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN "+ Parameters!Table.Value + ".LOC   LOCA                                 " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN "+ Parameters!Table.Value + ".SKU   SKUT                                 " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN "+ Parameters!Table.Value + ".ORDERDETAIL ORDT                           " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN "+ Parameters!Table.Value + ".PUTAWAYZONE PTWZ                           " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN "+ Parameters!Table.Value + ".STORER  STOR                               " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"order by 1, 6                                                                      "

,

"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE1.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE1.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE1.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE1.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE1.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE1.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE1.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE1.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE1.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE2.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE2.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE2.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE2.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE2.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE2.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE2.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE2.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE3.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE3.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE3.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE3.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE3.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE3.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE3.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE3.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE4.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE4.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE4.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE4.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE4.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE4.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE4.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE4.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE5.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE5.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE5.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE5.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE5.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE5.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE5.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE5.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE6.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE6.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE6.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE6.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE6.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE6.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE6.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE6.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"Union                                                                              " &
"		                                                                            " &
"SELECT WMSADMIN.DB_ALIAS               PLANTA,                                     " &
"       LLID.LOC                        ID_LOCAL,                                   " &
"       PTWZ.DESCR                      DESCR_LOCAL,                                " &
"       SUM(LLID.QTY)                   ESTO_QT,                                    " &
"       LOCA.STATUS                     ESTO_SIT,                                   " &
"       LLID.SKU                        ID_ITEM,                                    " &
"       SKUT.DESCR                      DESCR_ITEM,                                 " &
"       STOR.COMPANY                    FORNECEDOR,                                 " &
"       TSKD.ASSIGNMENTNUMBER           PROGRAMA,                                   " &
"       TSKD.WAVEKEY                    ONDA,                                       " &
"       SUM(ORDT.ORIGINALQTY)           QTY_ROMANEADA,                              " &
"       SUM(LLID.QTY - LLID.QTYPICKED)  QTY_CANCELA                                 " &
"                                                                                   " &
"FROM      WMWHSE7.LOTXLOCXID LLID                                                  " &
"                                                                                   " &
"LEFT JOIN ( select a.LOT,                                                          " &
"                   a.SKU,                                                          " &
"                   a.TOLOC,                                                        " &
"                   a.TOID,                                                         " &
"                   a.SOURCEKEY                                                     " &
"              from WMWHSE7.ITRN a                                                  " &
"             where a.TRANTYPE = 'MV'                                               " &
"               and a.SOURCETYPE  = 'PICKING'                                       " &
"               and a.SERIALKEY = ( SELECT max(b.SERIALKEY)                         " &
"                                     FROM WMWHSE7.ITRN b                           " &
"                                    WHERE b.LOT  = a.LOT                           " &
"                                      AND b.SKU        = a.SKU                     " &
"                                      AND b.TOLOC      = a.TOLOC                   " &
"                                      AND b.TOID       = a.TOID                    " &
"                                      AND b.TRANTYPE   = a.TRANTYPE                " &
"                                      AND b.SOURCETYPE = a.SOURCETYPE ) ) ITRN     " &
"       ON ITRN.LOT = LLID.LOT                                                      " &
"      AND ITRN.SKU = LLID.SKU                                                      " &
"      AND ITRN.TOLOC = LLID.LOC                                                    " &
"      AND ITRN.TOID =  LLID.ID                                                     " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.TASKDETAIL TSKD                                                  " &
"       ON TSKD.SOURCEKEY = ITRN.SOURCEKEY                                          " &
"      AND TSKD.SOURCETYPE = 'PICKDETAIL'                                           " &
"      AND TSKD.STATUS = '9'                                                        " &
"      AND TSKD.TASKTYPE = 'PK'                                                     " &
"      AND TSKD.TOLOC = ITRN.TOLOC                                                  " &
"	                                                                                " &
"LEFT JOIN WMSADMIN.PL_DB WMSADMIN                                                  " &
"       ON UPPER(WMSADMIN.DB_LOGID) = TSKD.WHSEID                                   " &
"                                                                                   " &
"LEFT JOIN WMWHSE7.LOC   LOCA                                                       " &
"       ON LOCA.LOC = LLID.LOC                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE7.SKU   SKUT                                                       " &
"       ON SKUT.SKU = LLID.SKU                                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE7.ORDERDETAIL ORDT                                                 " &
"       ON ORDT.ORDERKEY = TSKD.ORDERKEY                                            " &
"      AND ORDT.ORDERLINENUMBER = TSKD.ORDERLINENUMBER                              " &
"	                                                                                " &
"LEFT JOIN WMWHSE7.PUTAWAYZONE PTWZ                                                 " &
"       ON PTWZ.PUTAWAYZONE = LOCA.PUTAWAYZONE                                      " &
"	                                                                                " &
"LEFT JOIN WMWHSE7.STORER  STOR                                                     " &
"       ON STOR.STORERKEY = SKUT.SUSR5                                              " &
"      AND STOR.WHSEID = SKUT.WHSEID                                                " &
"      AND STOR.TYPE =  5                                                           " &
"                                                                                   " &
"WHERE LLID.QTY > 0                                                                 " &
"  AND LLID.QTYPICKED < LLID.QTY                                                    " &
"  AND LLID.LOC = 'PICKTO'                                                          " &
"                                                                                   " &
"GROUP BY WMSADMIN.DB_ALIAS,                                                        " &
"         LLID.LOC,                                                                 " &
"         PTWZ.DESCR,                                                               " &
"         LOCA.STATUS,                                                              " &
"         LLID.SKU,                                                                 " &
"         STOR.COMPANY,                                                             " &
"         SKUT.DESCR,                                                               " &
"         TSKD.ASSIGNMENTNUMBER,                                                    " &
"         TSKD.WAVEKEY                                                              " &
"		                                                                            " &
"order by 1, 6                                                                      " 

)