SELECT  
    taskdetail.whseid                        						PLANTA,
    PL_DB.DB_ALIAS                           						DSC_PLANTA,
    TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE), 'DD')         
																	DATA_COL,   
	OS.SCHEDULEDSHIPDATE											DATA_LIM,
    (select	a.t$entr$c ENTREGA
	 from	baandb.tznsls004301@pln01 a
	 where a.t$orno$c=os.referencedocument
     and rownum=1) 													ENTREGA,
	OS.REFERENCEDOCUMENT 											ORDEM_LN,
	OS.ORDERKEY														ORDEM_WMS,
	WD.WAVEKEY														ONDA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 						HR_INICIO,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)   					HR_FIM,
    taskdetail.addwho                        						OPERADOR,
    subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )      						NOME_OP,
    taskdetail.sku                    								ITEM,
    sk.descr														DESCR_ITEM,
    sum(taskdetail.qty)                      						QUANT
    
FROM      	WMWHSE5.taskdetail
INNER JOIN	WMWHSE5.ORDERS	OS		ON	OS.ORDERKEY		=	taskdetail.ORDERKEY
INNER JOIN	WMWHSE5.SKU		SK		ON	SK.SKU			=	taskdetail.SKU

INNER JOIN (select 	max(b.WAVEKEY) WAVEKEY,
					b.ORDERKEY
			from	WMWHSE5.WAVEDETAIL b
			group by b.ORDERKEY) WD ON WD.ORDERKEY 		= 	OS.ORDERKEY
LEFT JOIN WMWHSE5.taskmanageruser tu 
       ON tu.userkey = TASKDETAIL.EDITWHO,
          WMSADMIN.PL_DB 
    
WHERE taskdetail.status = 9 
  and taskdetail.tasktype = 'PK' 
 and UPPER(PL_DB.db_logid) = UPPER(taskdetail.whseid)
 and PL_DB.ISACTIVE = 1
 and PL_DB.DB_ENTERPRISE = 0

  -- and trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
      -- 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        -- AT time zone sessiontimezone) AS DATE)) between :DataDe and :DataAte
    
GROUP BY 	
			taskdetail.whseid,                        						
            PL_DB.DB_ALIAS,                           						      	
            OS.SCHEDULEDSHIPDATE,																									
            OS.REFERENCEDOCUMENT, 											
            OS.ORDERKEY,														
            WD.WAVEKEY,														
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.STARTTIME, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE), 						
            CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(taskdetail.endtime, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone sessiontimezone) AS DATE),   					
            taskdetail.addwho,                        						
            subStr( tu.usr_name,4,
                    inStr(tu.usr_name, ',')-4 ),      						
            taskdetail.sku,                    								
            sk.descr														