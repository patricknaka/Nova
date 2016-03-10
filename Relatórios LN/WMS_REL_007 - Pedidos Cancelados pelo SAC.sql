SELECT
  DISTINCT
    ORDERS.REFERENCEDOCUMENT              PED_TERC,
    ORDERS.ORDERKEY                       ID_PED,
    TASKDETAIL.ASSIGNMENTNUMBER           PROG,
    WAVEDETAIL.WAVEKEY                    ONDA,
    OSET.DESCRIPTION                      EVENTO,
    ORDERS.EDITWHO                        USUARIO,
    tu.usr_fname || ' ' || tu.usr_lname   NOME,  
    ORDERS.EDITDATE                       DT_EVENTO,
    ORDERS.EDITDATE                       DT_CANC,
    ORDERS.WHSEID                         PLANTA,
    CODELKUP.UDF2                         DESC_PLANTA

FROM      WMWHSE4.ORDERS

LEFT JOIN WMWHSE4.WAVEDETAIL
       ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
       
LEFT JOIN WMWHSE4.TASKDETAIL
       ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY
      AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY
             
LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE, 
                   C.ORDERKEY
              from WMWHSE4.ORDERSTATUSHISTORY C
             where C.STATUS IN (98, 99)    --Cancelado Externamente ou Cancelado Internamente
          group by C.ORDERKEY)  STATUSCANCELADO
       ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY

LEFT JOIN WMWHSE4.ORDERSTATUSSETUP OSET 
       ON OSET.CODE = ORDERS.STATUS
       
LEFT JOIN ( select a.UDF1, 
                   a.UDF2
              from WMWHSE4.CODELKUP a
             where LISTNAME = 'SCHEMA' )  CODELKUP
       ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)

LEFT JOIN WMWHSE4.taskmanageruser tu
       ON tu.userkey = ORDERS.EDITWHO
       
    WHERE orders.status IN (98, 99) --Cancelado Externamente ou Cancelado Internamente

 ORDER BY ORDERS.ORDERKEY

 
= IIF(Parameters!Table.Value <> "AAA",
 
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      " + Parameters!Table.Value + ".ORDERS  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from " + Parameters!Table.Value + ".CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" ORDER BY ORDERS.ORDERKEY  "
,
 
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE1.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE1.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE1.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE1.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE1.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE2.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE2.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE2.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE2.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE2.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE3.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE3.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE3.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE3.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE3.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE4.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE4.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE4.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE4.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE4.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE5.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE5.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE5.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE5.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE5.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE6.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE6.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE6.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE6.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE6.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" UNION  " &
"  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.REFERENCEDOCUMENT              PED_TERC,  " &
"     ORDERS.ORDERKEY                       ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER           PROG,  " &
"     WAVEDETAIL.WAVEKEY                    ONDA,  " &
"     OSET.DESCRIPTION                      EVENTO,  " &
"     ORDERS.EDITWHO                        USUARIO,  " &
"     tu.usr_fname || ' ' || tu.usr_lname   NOME,  " &
"     ORDERS.EDITDATE                       DT_EVENTO,  " &
"     ORDERS.EDITDATE                       DT_CANC,  " &
"     ORDERS.WHSEID                         PLANTA,  " &
"     CODELKUP.UDF2                         DESC_PLANTA  " &
"  " &
" FROM      WMWHSE7.ORDERS  " &
"  " &
" LEFT JOIN WMWHSE7.WAVEDETAIL  " &
"        ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.TASKDETAIL  " &
"        ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"       AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY  " &
"  " &
" LEFT JOIN ( select MAX(C.ADDDATE)  ADDDATE,  " &
"                    C.ORDERKEY  " &
"               from WMWHSE7.ORDERSTATUSHISTORY C  " &
"              where C.STATUS IN (98, 99)  " &
"           group by C.ORDERKEY)  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP OSET  " &
"        ON OSET.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE7.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' )  CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE7.taskmanageruser tu  " &
"        ON tu.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status IN (98, 99)  " &
"  " &
" ORDER BY DESC_PLANTA, ID_PED  "

)