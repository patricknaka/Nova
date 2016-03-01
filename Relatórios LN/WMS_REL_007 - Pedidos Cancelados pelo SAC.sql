Select Distinct

ORDERS.REFERENCEDOCUMENT                    PED_TERC,
ORDERS.ORDERKEY                             ID_PED,
TASKDETAIL.ASSIGNMENTNUMBER                 PROG,
WAVEDETAIL.WAVEKEY                          ONDA,
--CASE WHEN OSET1.CODE IS NULL THEN
--    OSET2.CODE
--ELSE OSET1.CODE END                         COD_EVENTO,
CASE WHEN OSET1.DESCRIPTION IS NULL THEN
  OSET2.DESCRIPTION
ELSE OSET1.description END                  EVENTO,
CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL THEN
    ORDERS.EDITWHO
ELSE ULTIMO_EVENTO.ADDWHO END               USUARIO,
CASE WHEN tu_1.usr_name IS NULL THEN
     subStr( tu_2.usr_name,4,
     inStr(tu_2.usr_name, ',')-4 )
ELSE subStr( tu_1.usr_name,4,
     inStr(tu_1.usr_name, ',')-4 ) END       NOME,
CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL THEN
    ORDERS.EDITDATE
ELSE ULTIMO_EVENTO.ADDDATE END              DT_EVENTO,
CASE WHEN STATUSCANCELADO.ADDDATE IS NULL THEN
     ORDERS.EDITDATE
ELSE STATUSCANCELADO.ADDDATE END            DT_CANC,
ORDERS.WHSEID                               PLANTA,
CODELKUP.UDF2                               DESC_PLANTA

FROM      WMWHSE6.ORDERS

LEFT JOIN WMWHSE6.WAVEDETAIL
       ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
       
LEFT JOIN WMWHSE6.TASKDETAIL
       ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY
      AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY
             
 LEFT JOIN ( SELECT a.ORDERKEY, 
                    a.ORDERLINENUMBER , 
                    max(a.STATUS)   STATUS, 
                    max(a.ADDDATE)  ADDDATE, 
                    max(a.ADDWHO)   ADDWHO 
              FROM WMWHSE6.ORDERSTATUSHISTORY a
              WHERE a.ADDDATE = ( select  max(b.adddate) 
                                  from    WMWHSE6.ORDERSTATUSHISTORY b
                                  where   b.ORDERKEY = a.ORDERKEY
                                  and     b.ORDERLINENUMBER = a.ORDERLINENUMBER )
              GROUP BY a.ORDERKEY, 
                       a.ORDERLINENUMBER ) ULTIMO_EVENTO
              ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY 
     
LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY
            FROM WMWHSE6.ORDERSTATUSHISTORY C
            WHERE C.STATUS = 98 or c.status = 99    --Cancelado Externamente ou Cancelado Internamente

            GROUP BY C.ORDERKEY)  STATUSCANCELADO
       ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY
            
LEFT JOIN ORDERSTATUSSETUP OSET1 
       ON OSET1.CODE = ULTIMO_EVENTO.STATUS

LEFT JOIN ORDERSTATUSSETUP OSET2 
       ON OSET2.CODE = ORDERS.STATUS
       
LEFT JOIN ( SELECT a.UDF1, a.UDF2
            FROM  CODELKUP a
            WHERE LISTNAME = 'SCHEMA')  CODELKUP
       ON   UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)

LEFT JOIN WMWHSE6.taskmanageruser tu_1 
       ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO

LEFT JOIN WMWHSE6.taskmanageruser tu_2
       ON tu_2.userkey = ORDERS.EDITWHO
       
where (orders.status = 98 or orders.status = 99) --Cancelado Externamente ou Cancelado Internamente

order by ORDERS.ORDERKEY
