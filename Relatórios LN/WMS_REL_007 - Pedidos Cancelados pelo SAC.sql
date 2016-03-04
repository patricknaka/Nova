SELECT 
  DISTINCT
    ORDERS.WHSEID                               PLANTA,
    CODELKUP.UDF2                               DESC_PLANTA,
    ORDERS.REFERENCEDOCUMENT                    PED_TERC,
    ORDERS.ORDERKEY                             ID_PED,
    TASKDETAIL.ASSIGNMENTNUMBER                 PROG,
    WAVEDETAIL.WAVEKEY                          ONDA,
    CASE WHEN OSET1.DESCRIPTION IS NULL 
           THEN OSET2.DESCRIPTION
         ELSE OSET1.description 
    END                                         EVENTO,
    CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL 
           THEN ORDERS.EDITWHO
         ELSE ULTIMO_EVENTO.ADDWHO 
    END                                         USUARIO,
    CASE WHEN tu_1.usr_name IS NULL 
           THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )
         ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 ) 
    END                                         NOME,
    CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL 
           THEN ORDERS.EDITDATE
         ELSE ULTIMO_EVENTO.ADDDATE 
    END                                         DT_EVENTO,
    CASE WHEN STATUSCANCELADO.ADDDATE IS NULL 
           THEN ORDERS.EDITDATE
         ELSE STATUSCANCELADO.ADDDATE 
    END                                         DT_CANC

FROM      WMWHSE6.ORDERS

LEFT JOIN WMWHSE6.WAVEDETAIL
       ON WAVEDETAIL.ORDERKEY = ORDERS.ORDERKEY
       
LEFT JOIN WMWHSE6.TASKDETAIL
       ON TASKDETAIL.ORDERKEY = ORDERS.ORDERKEY
      AND TASKDETAIL.WAVEKEY = WAVEDETAIL.WAVEKEY
             
LEFT JOIN ( select a.ORDERKEY, 
                   a.ORDERLINENUMBER, 
                   max(a.STATUS)   STATUS, 
                   max(a.ADDDATE)  ADDDATE, 
                   max(a.ADDWHO)   ADDWHO 
              from WMWHSE6.ORDERSTATUSHISTORY a
             where a.ADDDATE = ( select max(b.adddate) 
                                   from WMWHSE6.ORDERSTATUSHISTORY b
                                  where b.ORDERKEY = a.ORDERKEY
                                    and b.ORDERLINENUMBER = a.ORDERLINENUMBER )
          group by a.ORDERKEY, 
                   a.ORDERLINENUMBER ) ULTIMO_EVENTO
       ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY 
     
LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY
              FROM WMWHSE6.ORDERSTATUSHISTORY C
             WHERE C.STATUS in (98, 99)    --Cancelado Externamente ou Cancelado Internamente
          GROUP BY C.ORDERKEY )  STATUSCANCELADO
       ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY
            
LEFT JOIN WMWHSE6.ORDERSTATUSSETUP OSET1 
       ON OSET1.CODE = ULTIMO_EVENTO.STATUS

LEFT JOIN WMWHSE6.ORDERSTATUSSETUP OSET2 
       ON OSET2.CODE = ORDERS.STATUS
       
LEFT JOIN ( select a.UDF1, 
                   a.UDF2
              from CODELKUP a
             where LISTNAME = 'SCHEMA' ) CODELKUP
       ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)

LEFT JOIN WMWHSE6.taskmanageruser tu_1 
       ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO

LEFT JOIN WMWHSE6.taskmanageruser tu_2
       ON tu_2.userkey = ORDERS.EDITWHO
       
    WHERE orders.status in (98, 99) --Cancelado Externamente ou Cancelado Internamente

 ORDER BY ORDERS.ORDERKEY

 
= IIF(Parameters!Table.Value <> "AAA",
 
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM " + Parameters!Table.Value + ".ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from " + Parameters!Table.Value + ".CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
" ORDER BY ORDERS.ORDERKEY  "

,

" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE1.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE1.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE1.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE1.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE1.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE1.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE1.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE2.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE2.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE2.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE2.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE2.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE2.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE2.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE3.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE3.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE3.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE3.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE3.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE3.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE3.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE4.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE4.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE4.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE4.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE4.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE4.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE4.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE5.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE5.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE5.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE5.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE5.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE5.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE5.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE6.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE6.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE6.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE6.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE6.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE6.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE6.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
"UNION  " &
" SELECT  " &
"   DISTINCT  " &
"     ORDERS.WHSEID                               PLANTA,  " &
"     CODELKUP.UDF2                               DESC_PLANTA,  " &
"     ORDERS.REFERENCEDOCUMENT                    PED_TERC,  " &
"     ORDERS.ORDERKEY                             ID_PED,  " &
"     TASKDETAIL.ASSIGNMENTNUMBER                 PROG,  " &
"     WAVEDETAIL.WAVEKEY                          ONDA,  " &
"     CASE WHEN OSET1.DESCRIPTION IS NULL  " &
"            THEN OSET2.DESCRIPTION  " &
"          ELSE OSET1.description  " &
"     END                                         EVENTO,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDWHO IS NULL  " &
"            THEN ORDERS.EDITWHO  " &
"          ELSE ULTIMO_EVENTO.ADDWHO  " &
"     END                                         USUARIO,  " &
"     CASE WHEN tu_1.usr_name IS NULL  " &
"            THEN subStr( tu_2.usr_name, 4, inStr(tu_2.usr_name, ',') -4 )  " &
"          ELSE   subStr( tu_1.usr_name, 4, inStr(tu_1.usr_name, ',') -4 )  " &
"     END                                         NOME,  " &
"     CASE WHEN ULTIMO_EVENTO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE ULTIMO_EVENTO.ADDDATE  " &
"     END                                         DT_EVENTO,  " &
"     CASE WHEN STATUSCANCELADO.ADDDATE IS NULL  " &
"            THEN ORDERS.EDITDATE  " &
"          ELSE STATUSCANCELADO.ADDDATE  " &
"     END                                         DT_CANC  " &
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
" LEFT JOIN ( select a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER,  " &
"                    max(a.STATUS)   STATUS,  " &
"                    max(a.ADDDATE)  ADDDATE,  " &
"                    max(a.ADDWHO)   ADDWHO  " &
"               from WMWHSE7.ORDERSTATUSHISTORY a  " &
"              where a.ADDDATE = ( select max(b.adddate)  " &
"                                    from WMWHSE7.ORDERSTATUSHISTORY b  " &
"                                   where b.ORDERKEY = a.ORDERKEY  " &
"                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"           group by a.ORDERKEY,  " &
"                    a.ORDERLINENUMBER ) ULTIMO_EVENTO  " &
"        ON ULTIMO_EVENTO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN ( SELECT MAX(C.ADDDATE)  ADDDATE, C.ORDERKEY  " &
"               FROM WMWHSE7.ORDERSTATUSHISTORY C  " &
"              WHERE C.STATUS in (98, 99)  " &
"           GROUP BY C.ORDERKEY )  STATUSCANCELADO  " &
"        ON STATUSCANCELADO.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP OSET1  " &
"        ON OSET1.CODE = ULTIMO_EVENTO.STATUS  " &
"  " &
" LEFT JOIN WMWHSE7.ORDERSTATUSSETUP OSET2  " &
"        ON OSET2.CODE = ORDERS.STATUS  " &
"  " &
" LEFT JOIN ( select a.UDF1,  " &
"                    a.UDF2  " &
"               from WMWHSE7.CODELKUP a  " &
"              where LISTNAME = 'SCHEMA' ) CODELKUP  " &
"        ON UPPER(CODELKUP.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
" LEFT JOIN WMWHSE7.taskmanageruser tu_1  " &
"        ON tu_1.userkey = ULTIMO_EVENTO.ADDWHO  " &
"  " &
" LEFT JOIN WMWHSE7.taskmanageruser tu_2  " &
"        ON tu_2.userkey = ORDERS.EDITWHO  " &
"  " &
"     WHERE orders.status in (98, 99)  " &
"  " &
" ORDER BY DESC_PLANTA, ID_PED  "

)