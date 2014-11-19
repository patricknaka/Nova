﻿SELECT 
    WMSADMIN.PL_DB.DB_ALIAS                PLANTA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE)
                                           DT_LIMITE,

    ORDERS.ORDERKEY                        PEDIDO, ORDERDETAIL.ORDERLINENUMBER ,
    ORDERS.SUSR4                           UNINEG,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
                                           DT_REGISTRO,

CASE WHEN (ORDERS.status='02' or ORDERS.status='09' or ORDERS.status='04' or ORDERS.status='00') and
          WAVEDETAIL.wavekey is null then
  'Recebimento_host'
WHEN (ORDERS.INVOICESTATUS='2' and ORDERS.status>='55') OR
	 (nvl(LNREF.t$poco$c,' ')='NFT' and ORDERS.status='95') OR
	 (nvl(LNREF.t$poco$c,' ')='CAN' and ORDERS.status='95') OR
   ORDERS.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%' THEN
  'Estorno' 
WHEN ORDERS.status='100' then
  'Perda_Logistica' 
WHEN (ORDERS.status>='95' or sq2.status=6) then
  'Expedicao_concluida'
WHEN (sq2.status=3 or sq2.status=4) and ORDERS.status>='55' then
  'Fechamento_Gaiola'
WHEN sq2.status=5 and ORDERS.status>='55' then
  'Entregue_Doca'
WHEN sq2.orderid IS NOT NULL and sq2.status=2 and ORDERS.status>='55' then
  'Inclusao_Carga'
WHEN ORDERS.INVOICESTATUS='1' and ORDERS.status>='55' then
  'DANFE_Solicitada'
WHEN ORDERS.INVOICESTATUS='3' and ORDERS.status>='55' then
  'DANFE_Aprovada'
WHEN ORDERS.INVOICESTATUS='4' and ORDERS.status>='55' then
  'Fim_Conferencia'
WHEN (ORDERS.status<='22') and
          WAVEDETAIL.wavekey is not null then
  'Incluido_Onda'
WHEN (ORDERS.status='29' and sq1.Released>0 and sq1.InPicking=0 and sq1.PartPicked=0) then
  'Picking_Liberado'
WHEN (ORDERS.status='52') then
  'Inicio_Picking'
WHEN (ORDERS.status='55') then
  'Picking_Completo'
ELSE
  'Outros'  
END EVENTO,


										   
    -- nvl(ORDERSTATUSSETUP2.DESCRIPTION,
        -- ORDERSTATUSSETUP.DESCRIPTION )     EVENTO,
 
    nvl(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE),
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE))        
                                           DT_ULT_EVENTO,

    nvl(ORDERSTATUSHISTORY.ADDWHO,
        ORDERS.EDITWHO)                    OPERADOR,
    ORDERDETAIL.SKU                        ITEM,
    SKU.ACTIVE                             ST_ITEM,
    SKU.DESCR                              NOME_ST_ITEM,
    DEPART.DEPART_NAME                     DEPARTAMENTO,
    DEPART.SECTOR_NAME                     SETOR,
 
    ORDERDETAIL.PRODUCT_CUBE *
    ORDERDETAIL.ORIGINALQTY                M3,
 
    TCCOM130.T$FOVN$L                      CNPJF,
    TCMCS060.T$DSCA                        FABRICANTE,
    LNREF.T$IDCA$C                        CANAL,
    ORDERS.C_VAT                           MEGA_ROTA,
    ORDERSTATUSSETUP.DESCRIPTION           SITUACAO,
    TASKDETAIL.TASKDETAILKEY               PROGRAMA,
    WAVEDETAIL.WAVEKEY                     ONDA,
    ORDERS.CARRIERCODE                     ID_TRANSPORTADORA,
    ORDERS.CARRIERNAME                     NOME_TRANSP,
    SLS002.T$TPEN$C                        TIPO_ENTREGA,
    ORDERS.SUSR1                           NOME_TP_ENT,
    ORDERS.INVOICENUMBER                   NOTA,
    ORDERS.LANE                            SERIE,
    CAGEIDDETAIL.CAGEID                    CARGA,
    CISLI940.T$CCFO$L                      CFOP,
    CISLI940.T$OPOR$L                      CFOP_SR,
  
    CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO' 
         ELSE 'LEVE' 
     END                                   TP_TRANSPORTE,
  
    ORDERS.C_ZIP                           CEP,
    LNREF.t$fovn$c                        CNPJ,       
    ORDERS.C_COMPANY                       NOME,
    ORDERDETAIL.ORIGINALQTY                QTDE_TOTAL,
    
    CASE WHEN nvl(cisli940.t$amnt$l,0) != 0 THEN cisli940.t$amnt$l
         WHEN NVL(TDSLS400.T$OAMT,0) != 0 THEN TDSLS400.T$OAMT
         WHEN nvl(LNREF.VALOR,0) !=0 THEN LNREF.VALOR
    ELSE
      0 END                                 VL,
    ORDERS.type                            COD_TIPO_PEDIDO,
    TIPO_PEDIDO.                           DSC_TIPO_PEDIDO

 
FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL 
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU
        
INNER JOIN (select 
            o1.orderkey,
            (select count(*) from WMWHSE5.orderdetail od1
             where od1.orderkey=o1.orderkey
             and od1.status='29') Released,
            (select count(*) from WMWHSE5.orderdetail od1
             where od1.orderkey=o1.orderkey
             and od1.status='51') InPicking,
            (select count(*) from WMWHSE5.orderdetail od1
             where od1.orderkey=o1.orderkey
             and od1.status='52') PartPicked,
            (select count(*) from WMWHSE5.orderdetail od1
             where od1.orderkey=o1.orderkey
             and od1.status='55') PickedComplete
            from WMWHSE5.orders o1) sq1 ON sq1.orderkey=orders.orderkey

 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2) 
        
 LEFT JOIN ENTERPRISE.CODELKUP cl  
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
      
 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  
        
 LEFT JOIN (select distinct a.CAGEID,
                            a.ORDERID
            from WMWHSE5.CAGEIDDETAIL a) CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY 
		
    LEFT JOIN  (select cd.orderid, max(cg.status) status
                from WMWHSE5.CAGEID cg, CAGEIDDETAIL cd
                where cd.CAGEID=cg.CAGEID
                group by cd.orderid) sq2
                                    ON sq2.orderid=ORDERS.orderkey
    LEFT JOIN WMWHSE5.WAVEDETAIL w ON w.ORDERKEY=ORDERS.ORDERKEY
	
        
-- LEFT JOIN WMWHSE5.CAGEID
--        ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID
        
INNER JOIN WMSADMIN.PL_DB
        ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID 
        
 LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002
        ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1)) 
        
        
 LEFT JOIN ( SELECT a.ORDERKEY, 
                    a.ORDERLINENUMBER , 
                    max(a.STATUS) STATUS, 
                    max(a.ADDDATE) ADDDATE, 
                    max(a.ADDWHO) ADDWHO 
               FROM WMWHSE5.ORDERSTATUSHISTORY a
              WHERE a.ADDDATE = ( select max(b.adddate) 
                                    from WMWHSE5.ORDERSTATUSHISTORY b
                                   where b.ORDERKEY = a.ORDERKEY
                                     and b.ORDERLINENUMBER = a.ORDERLINENUMBER )
           GROUP BY a.ORDERKEY, 
                    a.ORDERLINENUMBER ) ORDERSTATUSHISTORY
        ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER 
       
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP
        ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS
        
 LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2
        ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS
        
 LEFT JOIN ( select max(a.TASKDETAILKEY) keep (dense_rank last order by a.ENDTIME) TASKDETAILKEY,
                    a.ORDERKEY,
                    a.ORDERLINENUMBER,
                    max(a.LOT) LOT,
                    max(a.FROMLOC) FROMLOC
               from WMWHSE5.TASKDETAIL a
              where a.tasktype = 'PK'
           group by a.ORDERKEY, 
                    a.ORDERLINENUMBER ) TASKDETAIL
        ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY 
       AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  
               
 -- LEFT JOIN ( select q.T$IDCA$C, 
                    -- ZNSLS004.T$ORNO$C,
                    -- znsls401.t$item$c,
                    -- znsls401.t$tpes$c,
                    -- q.t$fovn$c,
                    -- sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) - 
                          -- znsls401.t$vldi$c +
                          -- znsls401.t$vlfr$c + 
                          -- znsls401.t$vlde$c ) VALOR
               -- from BAANDB.TZNSLS004301@pln01 ZNSLS004, 
                    -- BAANDB.TZNSLS400301@pln01 q,
                    -- BAANDB.TZNSLS401301@pln01 ZNSLS401
              -- where ZNSLS004.T$NCIA$C = q.T$NCIA$C
                -- and ZNSLS004.T$UNEG$C = q.T$UNEG$C
                -- and ZNSLS004.T$PECL$C = q.T$PECL$C
                -- and ZNSLS004.T$SQPD$C = q.T$SQPD$C
                -- and znsls401.T$NCIA$C = znsls004.T$NCIA$C
                -- and znsls401.T$UNEG$C = znsls004.T$UNEG$C
                -- and znsls401.T$PECL$C = znsls004.T$PECL$C
                -- and znsls401.T$SQPD$C = znsls004.T$SQPD$C
                -- and znsls401.t$entr$c = znsls004.t$entr$c
                -- and znsls401.t$sequ$c = znsls004.t$sequ$c
           -- group by q.T$IDCA$C, 
                    -- ZNSLS004.T$ORNO$C,
                    -- znsls401.t$item$c,
                    -- znsls401.t$tpes$c,
                    -- q.t$fovn$c ) SLS400
        -- ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT
       -- AND SLS400.t$item$c = ORDERDETAIL.SKU
	   
	   
	   
	LEFT JOIN  (select  r.t$orno$c,
						r.t$ncia$c,
						r.t$uneg$c,
						r.t$pecl$c,
						r.t$sqpd$c,
						r.t$entr$c,
						o.t$tpes$c,
						q.t$idca$c,
						q.t$fovn$c,
						t0.t$poco$c,
                    sum( (o.t$vlun$c * o.t$qtve$c) - 
                          o.t$vldi$c +
                          o.t$vlfr$c + 
                          o.t$vlde$c ) VALOR
				from 		BAANDB.TZNSLS004301@pln01 r
				left join	BAANDB.TZNSLS401301@pln01 o	on 	o.t$ncia$c = r.t$ncia$c
				                                        and o.t$uneg$c = r.t$uneg$c 
				                                        and o.t$pecl$c = r.t$pecl$c
				                                        and o.t$sqpd$c = r.t$sqpd$c 
				                                        and o.t$entr$c = r.t$entr$c
				left join 	BAANDB.TZNSLS400301@pln01 q on 	q.t$ncia$c = r.t$ncia$c
				                                        and q.t$uneg$c = r.t$uneg$c
				                                        and q.t$pecl$c = r.t$pecl$c
				                                        and q.t$sqpd$c = r.t$sqpd$c
				
				
				left join	(select t1.t$poco$c,
									t1.t$ncia$c,
                  t1.t$uneg$c, 
									t1.t$pecl$c,
				                    t1.t$sqpd$c,
				                    t1.t$entr$c
							 from	BAANDB.TZNSLS410301@pln01 t1
							 where	t1.t$poco$c in ('NFT', 'WMS', 'CAN')
							 and	t1.t$dtoc$c = (	select max(t2.t$dtoc$c)
													from BAANDB.TZNSLS410301@pln01 t2
													where t2.t$uneg$c = t1.t$uneg$c
													and   t2.t$pecl$c = t1.t$pecl$c
													and   t2.t$sqpd$c = t1.t$sqpd$c
													and   t2.t$entr$c = t1.t$entr$c
													and	  t2.t$poco$c in ('NFT', 'WMS', 'CAN'))) t0
														on 	t0.t$ncia$c = r.t$ncia$c
				                                        and t0.t$uneg$c = r.t$uneg$c
				                                        and t0.t$pecl$c = r.t$pecl$c
				                                        and t0.t$sqpd$c = r.t$sqpd$c
				                                        and t0.t$entr$c = r.t$entr$c														
				group by
							r.t$orno$c,
				            r.t$ncia$c,
				            r.t$uneg$c,
				            r.t$pecl$c,
				            r.t$sqpd$c,
				            r.t$entr$c,
				            o.t$tpes$c,
				            q.t$idca$c,
				            q.t$fovn$c,
				            t0.t$poco$c) LNREF ON LNREF.t$orno$c=ORDERS.REFERENCEDOCUMENT
	   

 LEFT JOIN BAANDB.TTDSLS400301@pln01 TDSLS400	ON	TDSLS400.T$ORNO = ORDERS.REFERENCEDOCUMENT
 
 LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940 
        ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER
       AND CISLI940.T$SERI$L = ORDERS.LANE
       AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY
       AND CISLI940.T$DOCN$L != 0
    
 LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001 
        ON TRIM(TCIBD001.T$ITEM) = SKU.SKU
  
 LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060 
        ON TCMCS060.T$CMNF = TCIBD001.T$CMNF
  
 LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100 
        ON TCCOM100.T$BPID = STORER.STORERKEY
  
 LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130 
        ON TCCOM130.t$CADR = TCCOM100.T$CADR

 LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO, 
                    trans.description DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
         inner join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
              where clkp.listname = 'ORDERTYPE'
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
                and Trim(clkp.code) is not null ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type  

WHERE cl.listname = 'SCHEMA'
  AND STORER.TYPE = 5


  AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE),
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone sessiontimezone) AS DATE))) 
      Between :DataUltimoEventoDe
          And :DataUltimoEventoAte
		  
= IIF(Parameters!Table.Value <> "AAA",

" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  "+ Parameters!Table.Value + ".ORDERS  " &
" INNER JOIN "+ Parameters!Table.Value + ".ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN "+ Parameters!Table.Value + ".SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM "+ Parameters!Table.Value + ".ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from "+ Parameters!Table.Value + ".ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN "+ Parameters!Table.Value + ".ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN "+ Parameters!Table.Value + ".ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN "+ Parameters!Table.Value + ".TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"ORDER BY PLANTA, PEDIDO, DT_REGISTRO "
  
,
  
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE1.ORDERS  " &
" INNER JOIN WMWHSE1.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE1.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE1.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE1.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE1.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE1.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE1.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE1.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE1.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE1.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE1.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE2.ORDERS  " &
" INNER JOIN WMWHSE2.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE2.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE2.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE2.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE2.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE2.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE2.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE2.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE2.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE2.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE2.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE3.ORDERS  " &
" INNER JOIN WMWHSE3.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE3.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE3.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE3.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE3.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE3.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE3.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE3.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE3.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE3.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE3.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE4.ORDERS  " &
" INNER JOIN WMWHSE4.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE4.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE4.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE4.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE4.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE4.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE4.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE4.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE4.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE4.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE4.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE5.ORDERS  " &
" INNER JOIN WMWHSE5.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE5.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE5.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE5.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE5.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE5.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE5.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE5.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE5.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE5.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE5.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE6.ORDERS  " &
" INNER JOIN WMWHSE6.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE6.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE6.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE6.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE6.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE6.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE6.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE6.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE6.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE6.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE6.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"Union " &
" SELECT   " &
"   WMSADMIN.PL_DB.DB_ALIAS  PLANTA,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_LIMITE,   " &
"   ORDERS.ORDERKEY   PEDIDO,   " &
"   ORDERS.SUSR4   UNINEG,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_REGISTRO,  " &
"   ORDERSTATUSSETUP2.DESCRIPTION  EVENTO,   " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"   AT time zone sessiontimezone) AS DATE)  " &
"   DT_ULT_EVENTO,   " &
"   ORDERSTATUSHISTORY.ADDWHO   OPERADOR,  " &
"   ORDERDETAIL.SKU   ITEM,   " &
"   SKU.ACTIVE   ST_ITEM,   " &
"   SKU.DESCR   NOME_ST_ITEM,   " &
"   DEPART.DEPART_NAME   DEPARTAMENTO,   " &
"   DEPART.SECTOR_NAME   SETOR,  " &
"   ORDERDETAIL.PRODUCT_CUBE *   " &
"   ORDERDETAIL.ORIGINALQTY  M3,  " &
"   TCCOM130.T$FOVN$L  CNPJF,  " &
"   TCMCS060.T$DSCA   FABRICANTE,   " &
"   SLS400.T$IDCA$C   CANAL,  " &
"   ORDERS.C_VAT   MEGA_ROTA,   " &
"   ORDERSTATUSSETUP.DESCRIPTION   SITUACAO,  " &
"   TASKDETAIL.TASKDETAILKEY   PROGRAMA,  " &
"   WAVEDETAIL.WAVEKEY   ONDA,   " &
"   ORDERS.CARRIERCODE   ID_TRANSPORTADORA,  " &
"   ORDERS.CARRIERNAME   NOME_TRANSP,  " &
"   SLS002.T$TPEN$C   TIPO_ENTREGA,   " &
"   ORDERS.SUSR1   NOME_TP_ENT,  " &
"   ORDERS.INVOICENUMBER  NOTA,   " &
"   ORDERS.LANE  SERIE,  " &
"   CAGEIDDETAIL.CAGEID   CARGA,  " &
"   CISLI940.T$CCFO$L  CFOP,   " &
"   CISLI940.T$OPOR$L  CFOP_SR,   " &
"   CASE WHEN SKU.SUSR2 = 2 THEN 'PESADO'   " &
"  ELSE 'LEVE'   " &
"   END   TP_TRANSPORTE,   " &
"   ORDERS.C_ZIP   CEP,   " &
"   SLS400.t$fovn$c   CNPJ,   " &
"   ORDERS.C_COMPANY  NOME,   " &
"   ORDERDETAIL.ORIGINALQTY  QTDE_TOTAL,   " &
"   sls400.VALOR   VL,   " &
"   ORDERS.type COD_TIPO_PEDIDO,   " &
"   TIPO_PEDIDO.DSC_TIPO_PEDIDO   " &
" FROM  WMWHSE7.ORDERS  " &
" INNER JOIN WMWHSE7.ORDERDETAIL   " &
"   ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
" INNER JOIN WMWHSE7.SKU  " &
"   ON SKU.SKU = ORDERDETAIL.SKU   " &
"  LEFT JOIN WMWHSE7.STORER  " &
"   ON STORER.STORERKEY = sku.SUSR5   " &
"   AND STORER.WHSEID = sku.WHSEID  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART   " &
"   ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)   " &
"   AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl   " &
"   ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)   " &
"  LEFT JOIN WMWHSE7.WAVEDETAIL   " &
"   ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE7.CAGEIDDETAIL  " &
"   ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY   " &
"  LEFT JOIN WMWHSE7.CAGEID  " &
"   ON CAGEID.CAGEID = CAGEIDDETAIL.CAGEID  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"   ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID   " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"   ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"   a.ORDERLINENUMBER ,   " &
"   max(a.STATUS) STATUS,   " &
"   max(a.ADDDATE) ADDDATE,  " &
"   max(a.ADDWHO) ADDWHO  " &
"  FROM WMWHSE7.ORDERSTATUSHISTORY a   " &
"   WHERE a.ADDDATE = ( select max(b.adddate)  " &
"  from WMWHSE7.ORDERSTATUSHISTORY b  " &
"   where b.ORDERKEY = a.ORDERKEY  " &
"   and b.ORDERLINENUMBER = a.ORDERLINENUMBER ) " &
"   GROUP BY a.ORDERKEY,   " &
"   a.ORDERLINENUMBER ) ORDERSTATUSHISTORY   " &
"   ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER " &
"  LEFT JOIN WMWHSE7.ORDERSTATUSSETUP   " &
"   ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
"  LEFT JOIN WMWHSE7.ORDERSTATUSSETUP ORDERSTATUSSETUP2   " &
"   ON ORDERSTATUSSETUP2.CODE = ORDERSTATUSHISTORY.STATUS   " &
"  LEFT JOIN WMWHSE7.TASKDETAIL   " &
"   ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY   " &
"   AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER   " &
"  LEFT JOIN ( select q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,   " &
"   znsls401.t$item$c,   " &
"   znsls401.t$tpes$c,   " &
"   q.t$fovn$c,   " &
"   sum( (znsls401.t$vlun$c * znsls401.t$qtve$c) -  " &
"   znsls401.t$vldi$c +   " &
"   znsls401.t$vlfr$c +   " &
"   znsls401.t$vlde$c ) VALOR   " &
"  from BAANDB.TZNSLS004301@pln01 ZNSLS004,   " &
"   BAANDB.TZNSLS400301@pln01 q,   " &
"   BAANDB.TZNSLS401301@pln01 ZNSLS401   " &
"   where ZNSLS004.T$NCIA$C = q.T$NCIA$C  " &
"   and ZNSLS004.T$UNEG$C = q.T$UNEG$C  " &
"   and ZNSLS004.T$PECL$C = q.T$PECL$C  " &
"   and ZNSLS004.T$SQPD$C = q.T$SQPD$C  " &
"   and znsls401.T$NCIA$C = znsls004.T$NCIA$C   " &
"   and znsls401.T$UNEG$C = znsls004.T$UNEG$C   " &
"   and znsls401.T$PECL$C = znsls004.T$PECL$C   " &
"   and znsls401.T$SQPD$C = znsls004.T$SQPD$C   " &
"   and znsls401.t$entr$c = znsls004.t$entr$c   " &
"   and znsls401.t$sequ$c = znsls004.t$sequ$c   " &
"   group by q.T$IDCA$C,   " &
"   ZNSLS004.T$ORNO$C,  " &
"   znsls401.t$item$c,  " &
"   znsls401.t$tpes$c,  " &
"   q.t$fovn$c ) SLS400   " &
"   ON SLS400.T$ORNO$C = ORDERS.REFERENCEDOCUMENT  " &
"   AND SLS400.t$item$c = ORDERDETAIL.SKU  " &
"  LEFT JOIN BAANDB.tcisli940301@pln01 CISLI940   " &
"   ON CISLI940.T$DOCN$L = ORDERS.INVOICENUMBER   " &
"   AND CISLI940.T$SERI$L = ORDERS.LANE   " &
"   AND CISLI940.T$BPID$L = ORDERS.CONSIGNEEKEY  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001   " &
"   ON TRIM(TCIBD001.T$ITEM) = SKU.SKU   " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060   " &
"   ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100   " &
"   ON TCCOM100.T$BPID = STORER.STORERKEY   " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130   " &
"   ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
" LEFT JOIN ( select clkp.code         COD_TIPO_PEDIDO,   " &
"                    trans.description DSC_TIPO_PEDIDO   " &
"               from WMWHSE5.codelkup clkp   " &
"         inner join WMWHSE5.translationlist trans   " &
"                 on trans.code = clkp.code   " &
"                and trans.joinkey1 = clkp.listname   " &
"              where clkp.listname = 'ORDERTYPE'   " &
"                and trans.locale = 'pt'   " &
"                and trans.tblname = 'CODELKUP'   " &
"                and Trim(clkp.code) is not null ) TIPO_PEDIDO   " &
"        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type   " &
" WHERE cl.listname = 'SCHEMA'   " &
"   AND STORER.TYPE = 5   " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE),   " &
"                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,   " &
"                  'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')   " &
"                    AT time zone sessiontimezone) AS DATE)))   " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'   " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'   " &
"ORDER BY PLANTA, PEDIDO, DT_REGISTRO "

)