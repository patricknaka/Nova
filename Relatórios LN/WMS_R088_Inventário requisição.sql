SELECT Q1.            ID_PLANTA,
       CL.UDF2        DESCR_PLANTA,
       ' '            SIMULACAO,
       Q1.LOCAIS      TOT_LOC,
       Q1.CONFERIDOS  CNF_LOC,
       Q1.RESOLVIDOS  RES_LOC,
       Q1.            ID_SITUACAO,
       CS.DESCRIPTION DESCR_SITUACAO,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Q1.DT_SITUACAO,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)
                      DT_SITUACAO,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(Q1.DT_INICIO,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE)
                      DT_INICIO,
        Q1.DT_SITUACAO - Q1.DT_INICIO DURACAO
                      
FROM ( select IV.WHSEID               ID_PLANTA,
              IV.CCKEY                INVENTARIO,
              count(distinct IV.LOC)  LOCAIS,
              sum(case when IV.STATUS != 0 
                         then 1 
                       else   0 
                   end)               CONFERIDOS,
              sum(case when IV.STATUS = 9 
                         then 1
                       else   0 
                   end)               RESOLVIDOS,
              min(IV.STATUS)          ID_SITUACAO,
              max(IV.EDITDATE)        DT_SITUACAO,
              min(IV.DT_INICIO)       DT_INICIO
         from ( SELECT CD.WHSEID,
                       TO_CHAR(CD.CCKEY) CCKEY,
                       CD.LOC,
                       max(CD.STATUS)    STATUS,
                       max(CD.EDITDATE)  EDITDATE,
                       min(CD.EDITDATE)        DT_INICIO
                  FROM WMWHSE5.CC CC
            INNER JOIN WMWHSE5.CCDETAIL CD
                    ON CD.CCKEY = CC.CCKEY
                 WHERE CC.STATUS != 9
              GROUP BY CD.WHSEID,
                       TO_CHAR(CD.CCKEY),
                       CD.LOC
                 UNION
                SELECT PH.WHSEID,
                       ' ' CCKEY,
                       PH.LOC,
                       max(PH.STATUS) STATUS,
                       max(PH.EDITDATE) EDITDATE,
                       min(PH.EDITDATE)        DT_INICIO
                  FROM WMWHSE5.PHYSICAL PH
              GROUP BY PH.WHSEID,
                       PH.LOC ) IV 

     group by IV.WHSEID, IV.CCKEY ) Q1

INNER JOIN ENTERPRISE.CODELKUP CL
        ON UPPER(CL.UDF1) = Q1.ID_PLANTA
       AND CL.LISTNAME = 'SCHEMA'
INNER JOIN WMWHSE5.CODELKUP CS
        ON CS.CODE = Q1.ID_SITUACAO
       AND CS.LISTNAME = 'CCSTATUS'
--WHERE Q1.ID_SITUACAO IN (" + JOIN(Parameters!Situacao.Value, ", ") + ")       
  ORDER BY ID_PLANTA, 
           DT_SITUACAO