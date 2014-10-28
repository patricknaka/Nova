SELECT CL.UDF2                         FILIAL,

       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
         'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
           AT time zone sessiontimezone) AS DATE) 
                                       DTHR,
       
       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')
       || ' ~ ' 
       || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
                                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                                         AT time zone sessiontimezone) AS DATE),'HH24')) + 1))
       || ':00'                        DH_FORMAT,
       
       COUNT(DISTINCT TD.ORDERKEY)     QT_PED,
       COUNT(DISTINCT TD.ORDERKEY 
       || TD.ORDERLINENUMBER)          QT_ITEM,
       SUM(TD.QTY)                     QT_PECAS
    
FROM       WMWHSE5.TASKDETAIL TD

INNER JOIN WMWHSE5.CODELKUP CL 
        ON UPPER(CL.UDF1) = TD.WHSEID

WHERE TD.TASKTYPE = 'PK'
  AND TD.STATUS = '9'
  AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
              'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                AT time zone sessiontimezone) AS DATE))
      Between :DataDe
          And :DataAte

GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
           'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
             AT time zone sessiontimezone) AS DATE),
         TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME, 
                         'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')
                           AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')
         || ' ~ ' 
         || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))
         || ':00',
         CL.UDF2
        
		
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       " + Parameters!Table.Value + ".TASKDETAIL TD                                          " &
"                                                                                                  " &
" INNER JOIN " + Parameters!Table.Value + ".CODELKUP CL                                            " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  "
		
-- Query com UNION ***********************************************************************************
		
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE1.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE1.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE2.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE2.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE3.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE3.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE4.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE4.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE5.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE5.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE6.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE6.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"Union                                                                                             " &
"                                                                                                  " &
" SELECT CL.UDF2                         FILIAL,                                                   " &
"                                                                                                  " &
"        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                            " &
"          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                        " &
"            AT time zone sessiontimezone) AS DATE)                                                " &
"                                        DTHR,                                                     " &
"                                                                                                  " &
"       TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                               " &
"                       'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                           " &
"                         AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI')    " &
"        || ' ~ '                                                                                  " &
"        || TO_CHAR(TO_NUMBER((TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,              " &
"                                        'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')          " &
"                                          AT time zone sessiontimezone) AS DATE),'HH24')) + 1))   " &
"        || ':00'                        DH_FORMAT,                                                " &
"                                                                                                  " &
"        COUNT(DISTINCT TD.ORDERKEY)     QT_PED,                                                   " &
"        COUNT(DISTINCT TD.ORDERKEY                                                                " &
"        || TD.ORDERLINENUMBER)          QT_ITEM,                                                  " &
"        SUM(TD.QTY)                     QT_PECAS                                                  " &
"                                                                                                  " &
" FROM       WMWHSE7.TASKDETAIL TD                                                                 " &
"                                                                                                  " &
" INNER JOIN WMWHSE7.CODELKUP CL                                                                   " &
"         ON UPPER(CL.UDF1) = TD.WHSEID                                                            " &
"                                                                                                  " &
" WHERE TD.TASKTYPE = 'PK'                                                                         " &
"   AND TD.STATUS = '9'                                                                            " &
"   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                       " &
"               'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                   " &
"                 AT time zone sessiontimezone) AS DATE))                                          " &
"       Between '"+ Parameters!DataDe.Value + "'                                                   " &
"           And '"+ Parameters!DataAte.Value + "'                                                  " &
"                                                                                                  " &
" GROUP BY CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                                          " &
"            'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                                      " &
"              AT time zone sessiontimezone) AS DATE),                                             " &
"          TO_CHAR(TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.ENDTIME,                            " &
"                          'DD-MON-YYYY HH24'), 'DD-MON-YYYY HH24'), 'GMT')                        " &
"                            AT time zone sessiontimezone) AS DATE),'HH24'), 'DD/MM/YYYY HH24:MI') " &
"          || ' ~ '                                                                                " &
"          || TO_CHAR(TO_NUMBER((TO_CHAR(TD.ENDTIME,'HH24'))+1))                                   " &
"          ||                              ':00',                                                  " &
"                                                                                                  " &
"          CL.UDF2                                                                                 " &
"                                                                                                  " &
"ORDER BY FILIAL                                                                                   "