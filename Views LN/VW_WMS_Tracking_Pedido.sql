﻿--	FAF.004 - 13-mai-2014, Fabio Ferreira, 	Correção timezone
--	FAF.000 - 18-jun-2014, Fabio Ferreira,	Inclusão de campos que estavam pedentes de definição								
--*******************************************************************************************************************************************
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE1.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE1.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE1.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE1.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE1.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE1.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE1.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE1.CAGEID cg, WMWHSE1.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE1.ORDERDETAIL OD,
      WMWHSE1.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE2.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE2.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE2.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE2.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE2.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE2.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE2.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE2.CAGEID cg, WMWHSE2.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE2.ORDERDETAIL OD,
      WMWHSE2.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE3.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE3.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE3.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE3.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE3.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE3.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE3.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE3.CAGEID cg, WMWHSE3.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE3.ORDERDETAIL OD,
      WMWHSE3.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE4.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE4.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE4.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE4.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE4.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE4.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE4.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE4.CAGEID cg, WMWHSE4.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE4.ORDERDETAIL OD,
      WMWHSE4.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE5.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE5.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE5.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE5.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE5.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE5.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE5.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE5.CAGEID cg, WMWHSE5.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE5.ORDERDETAIL OD,
      WMWHSE5.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE6.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE6.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE6.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE6.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE6.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE6.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE6.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE6.CAGEID cg, WMWHSE6.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE6.ORDERDETAIL OD,
      WMWHSE6.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE7.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE7.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE7.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE7.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE7.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE7.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE7.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE7.CAGEID cg, WMWHSE7.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE7.ORDERDETAIL OD,
      WMWHSE7.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE8.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE8.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE8.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE8.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE8.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE8.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE8.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE8.CAGEID cg, WMWHSE8.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and ROWNUM=1 and cg.cageid=cd.CAGEID) DT_FECHA_GAIOLA
FROM
      WMWHSE8.ORDERDETAIL OD,
      WMWHSE8.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE
UNION
SELECT
      OD.ORDERKEY NR_PEDIDO_WMS, 
      O.WHSEID CD_ARMAZEM,
      SUM(O.TOTALQTY) NR_VOLUME,
      (SELECT MIN(OSH.ADDDATE) FROM WMWHSE9.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED) NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY) NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE9.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE9.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMA_OCORRENCIA,
      (SELECT 
		CAST((FROM_TZ(CAST(TO_CHAR(MIN(OSH.ADDDATE), 'DD-MON-YYYY HH:MI:SS') AS TIMESTAMP), 'GMT')
		AT time zone 'America/Sao_Paulo') AS DATE)	  
		FROM WMWHSE9.ORDERSTATUSHISTORY OSH 
		WHERE OSH.ORDERKEY=OD.ORDERKEY) DT_ULT_ATUALIZACAO,
       O.EXTERNORDERKEY CD_EXTERNO_ORDER_KEY,
       O.CARRIERCODE CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY FROM WMWHSE9.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) FROM WMWHSE9.ORDERSTATUSHISTORY OSH2 
                                                       WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
       AND ROWNUM=1) CD_ULTIMO_TRACKING,
     (select cd.ADDDATE from WMWHSE9.CAGEIDDETAIL cd
      where cd.ORDERID=OD.ORDERKEY and ROWNUM=1) DT_INCLUSAO_VL_CARGA,
     O.ACTUALSHIPDATE DT_SAIDA_CAMINHAO, 
     (select cg.CLOSEDATE from WMWHSE9.CAGEID cg, WMWHSE9.CAGEIDDETAIL cd
     where cd.ORDERID=OD.ORDERKEY and cg.cageid=cd.CAGEID and ROWNUM=1) DT_FECHA_GAIOLA
FROM
      WMWHSE9.ORDERDETAIL OD,
      WMWHSE9.ORDERS O
WHERE O.ORDERKEY=OD.ORDERKEY
GROUP BY OD.ORDERKEY, O.EXTERNORDERKEY, O.CARRIERCODE, O.WHSEID, O.ACTUALSHIPDATE