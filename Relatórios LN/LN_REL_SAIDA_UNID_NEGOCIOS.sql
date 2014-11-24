SELECT DISTINCT

wmsCODE.FILIAL                 FILIAL,
wmsCODE.ID_FILIAL              NOME_FILIAL,
TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
                  'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                    AT time zone sessiontimezone) AS DATE),'HH24'), 'DD-MON-YYYY')    DT_EMISSAO,
                    
       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 

                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')

                         AT time zone sessiontimezone) AS DATE),'HH24'), 'HH24:MI')

       || ' ~ ' 

       || TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 

                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')

                         AT time zone sessiontimezone) AS DATE)+1/24,'HH24'), 'HH24:MI') PERIODO,
                                --PEDIDOS,
tdsls400.t$cbrn                   ID_UNINEG,        --Ramo de Atividade (tdsls400)
tcmcs031.t$dsca                   NOME_UNINEG,
COUNT(tdsls400.t$orno)            NO_PEDIDOS

FROM  baandb.ttdsls400301   tdsls400

LEFT JOIN baandb.ttcmcs031301   tcmcs031 
       ON tcmcs031.t$cbrn=tdsls400.t$cbrn
       
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$loco=301
      AND tcemm124.t$dtyp=1
      AND tcemm124.t$cwoc=tdsls400.t$cofc
       
LEFT JOIN ( select upper(wmsCODE.UDF1)  FILIAL,
                    wmsCODE.UDF2        ID_FILIAL,
                    b.t$grid
            from baandb.ttcemm300301 a
                  inner join baandb.ttcemm112301 b 
                          on b.t$waid = a.t$code

                  left join ENTERPRISE.CODELKUP@DL_LN_WMS wmsCode
                         on upper(trim(wmsCode.DESCRIPTION)) = a.t$lctn
                        and wmsCode.LISTNAME = 'SCHEMA'
            where a.t$type = 20

            group by  upper(wmsCODE.UDF1),
                      wmsCODE.UDF2,
                      b.t$grid )  wmsCODE
        ON wmsCODE.t$grid = tcemm124.t$grid
        
GROUP BY  --FILIAL,
          --NOME_FILIAL
          --DT_EMISSAO
          --PERIODO
          --ID_UNINEG
          --NOME_UNINEG
          wmsCODE.FILIAL,
          wmsCODE.ID_FILIAL,
          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
                  'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                    AT time zone sessiontimezone) AS DATE),'HH24'), 'DD-MON-YYYY'),
          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE),'HH24'), 'HH24:MI')
          || ' ~ ' 

          || TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat,
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE)+1/24,'HH24'), 'HH24:MI'),
          tdsls400.t$cbrn,
          tcmcs031.t$dsca

ORDER BY DT_EMISSAO, PERIODO
