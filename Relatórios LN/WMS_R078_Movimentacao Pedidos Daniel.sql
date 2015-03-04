SELECT
		TD.WHSEID							ID_PLANTA,
		CL.UDF2								DESCR_PLANTA,
		TD.ORDERKEY							ORDEM_MOV,
		TD.WAVEKEY							ONDA,
		OC.REFERENCEDOCUMENT				ORDEM_LN,
		(select a.t$pecl$c
		 from baandb.tznsls004301@pln01 a
		 where a.t$orno$c = OC.REFERENCEDOCUMENT
		 and rownum=1)						PEDIDO_SITE,
		TD.STARTTIME						INICIO_MOV,
		TD.SKU								ID_ITEM,
		SK.DESCR							DESCR_ITEM,
		TD.QTY								QUANTID,
		TD.FROMLOC							LOC_ORG,
		PO.DESCR							LOCAL_ORIG,
		LO.PUTAWAYZONE						ZONA_ORIG,
		TD.TOLOC							LOC_DEST,
		PD.DESCR							LOCAL_DEST,
		LD.PUTAWAYZONE						ZONA_DEST,
		OC.STATUS							ID_SITUACAO,
		SS.DESCRIPTION						DESCR_SITUACAO,
		CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
											DT_HR,
		IT.EDITWHO							ID_OPERADOR,
		subStr( tu.usr_name,4,
            inStr(tu.usr_name, ',')-4 )   	NOME_OP		
FROM
		WMWHSE5.TASKDETAIL						TD
		INNER JOIN	WMWHSE5.ITRN				IT	ON	IT.SOURCEKEY	=	TD.SOURCEKEY
													AND	IT.FROMLOC		=	TD.FROMLOC
													AND	IT.TOLOC		=	TD.TOLOC
													AND	IT.SKU			=	TD.SKU
													AND	IT.LOT			=	TD.LOT
													AND IT.SOURCETYPE	=	'PICKING'
		INNER JOIN 	ENTERPRISE.CODELKUP			CL	ON	UPPER(CL.UDF1)	=	TD.WHSEID
													AND	CL.LISTNAME 	=	'SCHEMA'
		INNER JOIN	WMWHSE5.ORDERS				OC	ON	OC.ORDERKEY		=	TD.ORDERKEY
		INNER JOIN	WMWHSE5.SKU					SK	ON	SK.SKU			=	TD.SKU
		INNER JOIN	WMWHSE5.LOC					LO	ON	LO.LOC			=	TD.FROMLOC
		INNER JOIN	WMWHSE5.PUTAWAYZONE 		PO	ON	PO.PUTAWAYZONE	=	LO.PUTAWAYZONE
		INNER JOIN	WMWHSE5.LOC					LD	ON	LD.LOC			=	TD.TOLOC
		INNER JOIN	WMWHSE5.PUTAWAYZONE 		PD	ON	PD.PUTAWAYZONE	=	LD.PUTAWAYZONE
		INNER JOIN	WMWHSE5.ORDERSTATUSSETUP	SS	ON	SS.CODE			=	OC.STATUS
		LEFT JOIN 	WMWHSE5.taskmanageruser 	tu 	ON 	tu.userkey 		= 	IT.EDITWHO
WHERE
				TD.TASKTYPE = 'PK'
		AND		TD.STATUS = 9
		AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE)
      BETWEEN :DataMovtoDe
          AND :DataMovtoAte


=IIF(Parameters!Table.Value <> "AAA",

"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       " + Parameters!Table.Value + ".TASKDETAIL  TD                 " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERS  OC                     " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN " + Parameters!Table.Value + ".SKU  SK                        " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN " + Parameters!Table.Value + ".LOC  LO                        " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN " + Parameters!Table.Value + ".PUTAWAYZONE  PO                " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN " + Parameters!Table.Value + ".LOC  LD                        " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN " + Parameters!Table.Value + ".PUTAWAYZONE  PD                " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP  SS           " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN " + Parameters!Table.Value + ".taskmanageruser  tu            " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"ORDER BY INICIO_MOV, ORDEM_MOV                                           "

,

"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE1.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE1.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE1.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE1.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE1.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE1.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE1.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE1.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE1.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE2.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE2.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE2.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE2.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE2.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE2.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE2.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE2.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE2.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE3.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE3.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE3.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE3.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE3.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE3.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE3.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE3.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE3.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE4.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE4.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE4.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE4.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE4.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE4.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE4.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE4.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE4.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE5.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE5.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE5.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE5.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE5.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE5.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE5.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE5.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE5.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE6.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE6.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE6.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE6.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE6.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE6.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE6.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE6.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE6.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"Union                                                                    " &
"SELECT TD.WHSEID               ID_PLANTA,                                " &
"       CL.UDF2                 DESCR_PLANTA,                             " &
"       TD.ORDERKEY             ORDEM_MOV,                                " &
"       TD.WAVEKEY              ONDA,                                     " &
"       OC.REFERENCEDOCUMENT    ORDEM_LN,                                 " &
"       ( select a.t$pecl$c                                               " &
"           from baandb.tznsls004301@pln01 a                              " &
"          where a.t$orno$c = OC.REFERENCEDOCUMENT                        " &
"            and rownum = 1 )   PEDIDO_SITE,                              " &
"       TD.STARTTIME            INICIO_MOV_1,                             " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               INICIO_MOV,                               " &
"       TD.SKU                  ID_ITEM,                                  " &
"       SK.DESCR                DESCR_ITEM,                               " &
"       TD.QTY                  QUANTID,                                  " &
"       TD.FROMLOC              LOC_ORG,                                  " &
"       PO.DESCR                LOCAL_ORIG,                               " &
"       LO.PUTAWAYZONE          ZONA_ORIG,                                " &
"       TD.TOLOC                LOC_DEST,                                 " &
"       PD.DESCR                LOCAL_DEST,                               " &
"       LD.PUTAWAYZONE          ZONA_DEST,                                " &
"       OC.STATUS               ID_SITUACAO,                              " &
"       SS.DESCRIPTION          DESCR_SITUACAO,                           " &
"       OC.EDITDATE             DT_HR_1,                                  " &
"       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(OC.EDITDATE,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"                               DT_HR,                                    " &
"       TD.EDITWHO              ID_OPERADOR,                              " &
"       subStr( tu.usr_name, 4, inStr(tu.usr_name, ',') -4 )              " &
"                               NOME_OP                                   " &
"FROM       WMWHSE7.TASKDETAIL  TD                                        " &
"INNER JOIN ENTERPRISE.CODELKUP  CL                                       " &
"        ON UPPER(CL.UDF1) = TD.WHSEID                                    " &
"       AND CL.LISTNAME = 'SCHEMA'                                        " &
"INNER JOIN WMWHSE7.ORDERS  OC                                            " &
"        ON OC.ORDERKEY = TD.ORDERKEY                                     " &
"INNER JOIN WMWHSE7.SKU  SK                                               " &
"        ON SK.SKU = TD.SKU                                               " &
"INNER JOIN WMWHSE7.LOC  LO                                               " &
"        ON LO.LOC = TD.FROMLOC                                           " &
"INNER JOIN WMWHSE7.PUTAWAYZONE  PO                                       " &
"        ON PO.PUTAWAYZONE = LO.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE7.LOC  LD                                               " &
"        ON LD.LOC = TD.TOLOC                                             " &
"INNER JOIN WMWHSE7.PUTAWAYZONE  PD                                       " &
"        ON PD.PUTAWAYZONE = LD.PUTAWAYZONE                               " &
"INNER JOIN WMWHSE7.ORDERSTATUSSETUP  SS                                  " &
"        ON SS.CODE = OC.STATUS                                           " &
" LEFT JOIN WMWHSE7.taskmanageruser  tu                                   " &
"        ON tu.userkey = TD.EDITWHO                                       " &
"WHERE TD.TASKTYPE = 'PK'                                                 " &
"  AND TD.STATUS = 9                                                      " &
"  AND CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TD.STARTTIME,                   " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    " &
"           AT time zone 'America/Sao_Paulo') AS DATE)                        " &
"      BETWEEN '"+ Parameters!DataMovtoDe.Value + "'                      " &
"          AND '"+ Parameters!DataMovtoAte.Value + "'                     " &
"                                                                         " &
"ORDER BY DESCR_PLANTA, INICIO_MOV, ORDEM_MOV                             "

)

