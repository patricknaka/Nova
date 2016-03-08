Select Distinct

ORDERS.REFERENCEDOCUMENT                    PED_TERC,
ORDERS.ORDERKEY                             ID_PED,
TASKDETAIL.ASSIGNMENTNUMBER                 PROG,
WAVEDETAIL.WAVEKEY                          ONDA,
OSET.DESCRIPTION                            EVENTO,
ORDERS.EDITWHO                              USUARIO,
tu.usr_fname || ' ' || tu.usr_lname         NOME,  
ORDERS.EDITDATE                             DT_EVENTO,
ORDERS.EDITDATE                             DT_CANC,
ORDERS.WHSEID                               PLANTA,
CODELKUP.UDF2                               DESC_PLANTA

FROM      WMWHSE4.ORDERS

LEFT JOIN WMWHSE4.WAVEDETAIL
       ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
       
LEFT JOIN WMWHSE4.TASKDETAIL
       ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY
      AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY
             
LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY
            FROM WMWHSE4.ORDERSTATUSHISTORY C
            WHERE C.STATUS = 98 or c.status = 99    --Cancelado Externamente ou Cancelado Internamente

            GROUP BY C.ORDERKEY)  STATUSCANCELADO
       ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY

LEFT JOIN ORDERSTATUSSETUP OSET 
       ON OSET.CODE = ORDERS.STATUS
       
LEFT JOIN ( SELECT a.UDF1, a.UDF2
            FROM  CODELKUP a
            WHERE LISTNAME = 'SCHEMA')  CODELKUP
       ON   UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)

LEFT JOIN WMWHSE4.taskmanageruser tu
       ON tu.userkey = ORDERS.EDITWHO
       
where (orders.status = 98 or orders.status = 99) --Cancelado Externamente ou Cancelado Internamente

order by ORDERS.ORDERKEY
