SELECT 
  DISTINCT
    wmsCODE.FILIAL               FILIAL,
    wmsCODE.ID_FILIAL            NOME_FILIAL,

    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
      'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
        AT time zone sessiontimezone) AS DATE),'HH24')  
                                 DT_EMISSAO,
                    
    TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
      'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
        AT time zone sessiontimezone) AS DATE),'HH24'), 'HH24:MI')
    || ' ~ ' 
    || TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
         'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
           AT time zone sessiontimezone) AS DATE)+1/24,'HH24'), 'HH24:MI') 
                                 PERIODO,

tdsls400.t$cbrn                  ID_UNINEG,        --Ramo de Atividade (tdsls400)
NVL(tcmcs031.t$dsca, 'REVERSA')  NOME_UNINEG,
COUNT(tdsls400.t$orno)           NO_PEDIDOS

FROM      baandb.ttdsls400301 tdsls400

LEFT JOIN baandb.ttcmcs031301 tcmcs031 
       ON tcmcs031.t$cbrn = tdsls400.t$cbrn
       
LEFT JOIN baandb.ttcemm124301 tcemm124
       ON tcemm124.t$loco = 301
      AND tcemm124.t$dtyp = 1
      AND tcemm124.t$cwoc = tdsls400.t$cofc
       
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

          group by upper(wmsCODE.UDF1),
                   wmsCODE.UDF2,
                   b.t$grid )  wmsCODE
       ON wmsCODE.t$grid = tcemm124.t$grid

WHERE TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
          AT time zone sessiontimezone) AS DATE),'HH24')
      BETWEEN :EmissaoDe
          AND :EmissaoAte
			
      AND ( (:Filial = 'AAA') OR (UPPER(wmsCODE.FILIAL) = :Filial) )
        
GROUP BY  wmsCODE.FILIAL,
          wmsCODE.ID_FILIAL,
          
          TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$odat, 
           'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
             AT time zone sessiontimezone) AS DATE),'HH24'),
          
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