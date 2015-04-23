SELECT 
  DISTINCT 
    WMSADMIN.PL_DB.DB_ALIAS                PLANTA,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                                           DT_LIMITE,

    ORDERS.ORDERKEY                        PEDIDO, 
    ORDERDETAIL.ORDERLINENUMBER            ORDERLINENUMBER,
    ORDERS.SUSR4                           UNINEG,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
                                           DT_REGISTRO,

    CASE WHEN ( ORDERS.status = '02' or 
                ORDERS.status = '09' or 
                ORDERS.status = '04' or 
                ORDERS.status = '00' ) and WAVEDETAIL.wavekey is null 
           THEN 'Recebimento_host'
         WHEN ( ORDERS.INVOICESTATUS = '2' and ORDERS.status> = '55')      OR
              ( nvl(LNREF.t$poco$c, ' ') = 'NFT' and ORDERS.status = '95') OR
              ( nvl(LNREF.t$poco$c, ' ') = 'CAN' and ORDERS.status = '95') OR
              ORDERS.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%' 
           THEN 'Estorno' 
         WHEN ORDERS.status = '100' 
           THEN 'Perda_Logistica' 
         WHEN ( ORDERS.status> = '95' or sq2.status = 6 ) 
           THEN 'Expedicao_concluida'
         WHEN ( sq2.status = 3 or sq2.status = 4 ) and ORDERS.status> = '55' 
           THEN 'Fechamento_Gaiola'
         WHEN sq2.status = 5 and ORDERS.status> = '55' 
           THEN 'Entregue_Doca'
         WHEN sq2.orderid IS NULL and sq2.status = 2 and ORDERS.status> = '55' 
           THEN 'Inclusao_Carga'
         WHEN ORDERS.INVOICESTATUS = '1' and ORDERS.status> = '55' 
           THEN 'DANFE_Solicitada'
         WHEN ORDERS.INVOICESTATUS = '3' and ORDERS.status> = '55' 
           THEN 'DANFE_Aprovada'
         WHEN ORDERS.INVOICESTATUS = '4' and ORDERS.status> = '55' 
           THEN 'Fim_Conferencia'
         WHEN (ORDERS.status < = '22') and WAVEDETAIL.wavekey is not null 
           THEN 'Incluido_Onda'
         WHEN (ORDERS.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0) 
           THEN 'Picking_Liberado'
         WHEN (ORDERS.status = '52') 
           THEN 'Inicio_Picking'
         WHEN (ORDERS.status = '55') 
           THEN 'Picking_Completo'
         ELSE 'Outros'  
     END                                   EVENTO,
 
    NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE),
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone 'America/Sao_Paulo') AS DATE))        
                                           DT_ULT_EVENTO,

    NVL(ORDERSTATUSHISTORY.ADDWHO,
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
    LNREF.T$IDCA$C                         CANAL,
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
  
    CASE WHEN SKU.SUSR2 = '2'
           THEN 'PESADO' 
         ELSE   'LEVE' 
     END                                   TP_TRANSPORTE,
  
    ORDERS.C_ZIP                           CEP,
    LNREF.t$fovn$c                         CNPJ,       
    ORDERS.C_COMPANY                       NOME,
    ORDERDETAIL.ORIGINALQTY                QTDE_TOTAL,
    
    -- CASE WHEN NVL(TDSLS400.T$OAMT, 0) != 0 THEN TDSLS400.T$OAMT
         -- WHEN NVL(LNREF.VALOR, 0)     != 0 THEN LNREF.VALOR
         -- WHEN NVL(maucLN.mauc, 0)     != 0 THEN maucLN.mauc
         -- ELSE 0 
     -- END                                   VL,
  
    ABS( CASE WHEN NVL(cisli941.t$pric$l, 0) != 0 THEN cisli941.t$pric$l
              WHEN NVL(TDSLS401.T$PRIC, 0)   != 0 THEN TDSLS401.T$PRIC
			  WHEN NVL(OPRIC.T$PRIC,0)		 != 0 THEN OPRIC.T$PRIC
              WHEN NVL(maucLN.mauc, 0)       != 0 THEN maucLN.mauc
              ELSE 0 
          END )                            VL,  
  
    ORDERS.type                            COD_TIPO_PEDIDO,
    TIPO_PEDIDO.                           DSC_TIPO_PEDIDO,
    CISLI940.T$BPID$L                      PARCEIRO_NEG,
    ORDERS.REFERENCEDOCUMENT               DOC_INICIAL

FROM       WMWHSE5.ORDERS

INNER JOIN WMWHSE5.ORDERDETAIL 
        ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY
        
INNER JOIN WMWHSE5.SKU
        ON SKU.SKU = ORDERDETAIL.SKU
        
INNER JOIN (select o1.orderkey,
                   ( select count(*) 
                       from WMWHSE5.orderdetail od1
                      where od1.orderkey = o1.orderkey
                        and od1.status = '29' ) Released,
                   ( select count(*) 
                       from WMWHSE5.orderdetail od1
                      where od1.orderkey = o1.orderkey
                        and od1.status = '51' ) InPicking,
                   ( select count(*) 
                       from WMWHSE5.orderdetail od1
                      where od1.orderkey = o1.orderkey
                        and od1.status = '52' ) PartPicked,
                   ( select count(*) 
                       from WMWHSE5.orderdetail od1
                      where od1.orderkey = o1.orderkey
                        and od1.status = '55' ) PickedComplete
              from WMWHSE5.orders o1 ) sq1 
        ON sq1.orderkey = orders.orderkey

 LEFT JOIN WMWHSE5.STORER 
        ON STORER.STORERKEY = sku.SUSR5 
       AND STORER.WHSEID = sku.WHSEID 

 LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART
        ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  
       AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2) 
        
 LEFT JOIN ENTERPRISE.CODELKUP cl  
        ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)
  
 LEFT JOIN ( select trim(whwmd217.t$item) item,                             
                    whwmd217.t$cwar cwar,                                   
                    case when sum(nvl(whwmd217.t$mauc$1,0)) = 0                             
                           then sum(whwmd217.t$ftpa$1)                                              
                         else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  
                    end mauc                                                
               from baandb.twhwmd217301@pln01 whwmd217                      
          left join baandb.twhinr140301@pln01 a                             
                 on a.t$cwar = whwmd217.t$cwar                              
                and a.t$item = whwmd217.t$item                              
           group by whwmd217.t$item,                                        
                    whwmd217.t$cwar ) maucLN                                
        ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)                         
       AND maucLN.item = ORDERDETAIL.SKU 
      
 LEFT JOIN WMWHSE5.WAVEDETAIL
        ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  
        
 LEFT JOIN (select distinct a.CAGEID,
                            a.ORDERID
            from WMWHSE5.CAGEIDDETAIL a) CAGEIDDETAIL
        ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY 
  
 LEFT JOIN ( select cd.orderid, 
                    max(cg.status) status
               from WMWHSE5.CAGEID cg
         inner join WMWHSE5.CAGEIDDETAIL cd
                 on cd.CAGEID = cg.CAGEID
           group by cd.orderid ) sq2
        ON sq2.orderid = ORDERS.orderkey
  
 LEFT JOIN WMWHSE5.WAVEDETAIL w 
        ON w.ORDERKEY = ORDERS.ORDERKEY
        
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
    
 LEFT JOIN ( select r.t$orno$c,
                    r.t$ncia$c,
                    r.t$uneg$c,
                    r.t$pecl$c,
                    r.t$sqpd$c,
                    r.t$entr$c,
                    o.t$tpes$c,
                    q.t$idca$c,
                    q.t$fovn$c,
                    t0.t$poco$c
               from BAANDB.TZNSLS004301@pln01 r
          left join BAANDB.TZNSLS401301@pln01 o 
                 on o.t$ncia$c = r.t$ncia$c
                and o.t$uneg$c = r.t$uneg$c 
                and o.t$pecl$c = r.t$pecl$c
                and o.t$sqpd$c = r.t$sqpd$c 
                and o.t$entr$c = r.t$entr$c
          left join BAANDB.TZNSLS400301@pln01 q 
                 on q.t$ncia$c = r.t$ncia$c
                and q.t$uneg$c = r.t$uneg$c
                and q.t$pecl$c = r.t$pecl$c
                and q.t$sqpd$c = r.t$sqpd$c
          left join ( select t1.t$poco$c,
                             t1.t$ncia$c,
                             t1.t$uneg$c, 
                             t1.t$pecl$c,
                             t1.t$sqpd$c,
                             t1.t$entr$c
                        from BAANDB.TZNSLS410301@pln01 t1
                       where t1.t$poco$c in ('NFT', 'WMS', 'CAN')
                         and t1.t$dtoc$c = ( select max(t2.t$dtoc$c)
                                               from BAANDB.TZNSLS410301@pln01 t2
                                              where t2.t$uneg$c = t1.t$uneg$c
                                                and t2.t$pecl$c = t1.t$pecl$c
                                                and t2.t$sqpd$c = t1.t$sqpd$c
                                                and t2.t$entr$c = t1.t$entr$c
                                                and t2.t$poco$c in ('NFT', 'WMS', 'CAN') ) ) t0
                 on  t0.t$ncia$c = r.t$ncia$c
                and t0.t$uneg$c = r.t$uneg$c
                and t0.t$pecl$c = r.t$pecl$c
                and t0.t$sqpd$c = r.t$sqpd$c
                and t0.t$entr$c = r.t$entr$c
           group by r.t$orno$c,
                    r.t$ncia$c,
                    r.t$uneg$c,
                    r.t$pecl$c,
                    r.t$sqpd$c,
                    r.t$entr$c,
                    o.t$tpes$c,
                    q.t$idca$c,
                    q.t$fovn$c,
                    t0.t$poco$c ) LNREF
        ON LNREF.t$orno$c = ORDERS.REFERENCEDOCUMENT

---------------------------------------------------------------------------------------------------------------------------------    
 LEFT JOIN BAANDB.TWHINH431301@PLN01 WHINH431 
        ON WHINH431.T$SHPM          = SUBSTR(ORDERDETAIL.EXTERNORDERKEY,5,9)
       AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(ORDERDETAIL.EXTERNLINENO)
               
 LEFT JOIN BAANDB.TCISLI245301@PLN01 CISLI245 
        ON CISLI245.T$SLCP = 301
       AND CISLI245.T$ORTP = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) IN ('34_', '36_')
                                    THEN 2 
                                  ELSE   1
                              END
       AND CISLI245.T$KOOR = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) = '34_'
                                    THEN 34
                                  WHEN  TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) = '36_'
                                    THEN 36
                                  ELSE   3
                              END
       AND CISLI245.T$OSET = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) IN ('34_', '36_')
                                    THEN WHINH431.T$WSET
                                  ELSE   0 
                              END                              
       AND CISLI245.T$SLSO = WHINH431.T$WORN
       AND CISLI245.T$PONO = WHINH431.T$WPON
       AND CISLI245.T$SQNB = WHINH431.T$WSEQ
       AND CISLI245.T$SHPM = WHINH431.T$SHPM
    
 LEFT JOIN BAANDB.TCISLI941301@PLN01 CISLI941 
        ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L
       AND CISLI941.T$LINE$L = CISLI245.T$LINE$L
    
 LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940 
        ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L
  
 LEFT JOIN BAANDB.TTDSLS401301@PLN01 TDSLS401
        ON TDSLS401.T$ORNO = WHINH431.T$WORN
       AND TDSLS401.T$PONO = WHINH431.T$PONO
       AND TDSLS401.T$SQNB = WHINH431.T$WSEQ
	   
 LEFT JOIN (SELECT 	MAX(A.T$PRIC) T$PRIC,
					TRIM(A.T$ITEM) T$ITEM,
					A.T$ORNO
			FROM BAANDB.TTDSLS401301@PLN01 A
			GROUP BY TRIM(A.T$ITEM),
			         A.T$ORNO) OPRIC
		ON	OPRIC.T$ITEM = SKU.SKU
		AND	OPRIC.T$ORNO = ORDERS.REFERENCEDOCUMENT
	   
	   
---------------------------------------------------------------------------------------------------------------------------------

 LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001 
        ON TRIM(TCIBD001.T$ITEM) = SKU.SKU
  
 LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060 
        ON TCMCS060.T$CMNF = TCIBD001.T$CMNF
  
 LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100 
        ON TCCOM100.T$BPID = STORER.STORERKEY
  
 LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130 
        ON TCCOM130.t$CADR = TCCOM100.T$CADR

 LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO, 
                    NVL(trans.description, 
                    clkp.description)  DSC_TIPO_PEDIDO
               from WMWHSE5.codelkup clkp
          left join WMWHSE5.translationlist trans 
                 on trans.code = clkp.code
                and trans.joinkey1 = clkp.listname
                and trans.locale = 'pt'
                and trans.tblname = 'CODELKUP' 
              where clkp.listname = 'ORDERTYPE'
                and Trim(clkp.code) is not null  ) TIPO_PEDIDO
        ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type
      
WHERE cl.listname = 'SCHEMA'
  AND STORER.TYPE = 5

  AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE),
                 CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE, 
                'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                  AT time zone 'America/Sao_Paulo') AS DATE))) 
      Between :DataUltimoEventoDe
          And :DataUltimoEventoAte
    
ORDER BY PLANTA, PEDIDO, Trunc(DT_REGISTRO), LPAD(ITEM, 10, '0')
    


	
" SELECT DISTINCT  " &
"     WMSADMIN.PL_DB.DB_ALIAS                PLANTA,  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.SCHEDULEDSHIPDATE,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                            DT_LIMITE,  " &
"     ORDERS.ORDERKEY                        PEDIDO,  " &
"     ORDERDETAIL.ORDERLINENUMBER            ORDERLINENUMBER,  " &
"     ORDERS.SUSR4                           UNINEG,  " &
"     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.ADDDATE,  " &
"       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"         AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                                            DT_REGISTRO,  " &
"     CASE WHEN ( ORDERS.status = '02' or  " &
"                 ORDERS.status = '09' or  " &
"                 ORDERS.status = '04' or  " &
"                 ORDERS.status = '00' ) and WAVEDETAIL.wavekey is null  " &
"            THEN 'Recebimento_host'  " &
"          WHEN ( ORDERS.INVOICESTATUS = '2' and ORDERS.status> = '55')      OR  " &
"               ( nvl(LNREF.t$poco$c, ' ') = 'NFT' and ORDERS.status = '95') OR  " &
"               ( nvl(LNREF.t$poco$c, ' ') = 'CAN' and ORDERS.status = '95') OR  " &
"               ORDERS.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%'  " &
"            THEN 'Estorno'  " &
"          WHEN ORDERS.status = '100'  " &
"            THEN 'Perda_Logistica'  " &
"          WHEN ( ORDERS.status> = '95' or sq2.status = 6 )  " &
"            THEN 'Expedicao_concluida'  " &
"          WHEN ( sq2.status = 3 or sq2.status = 4 ) and ORDERS.status> = '55'  " &
"            THEN 'Fechamento_Gaiola'  " &
"          WHEN sq2.status = 5 and ORDERS.status> = '55'  " &
"            THEN 'Entregue_Doca'  " &
"          WHEN sq2.orderid IS NULL and sq2.status = 2 and ORDERS.status> = '55'  " &
"            THEN 'Inclusao_Carga'  " &
"          WHEN ORDERS.INVOICESTATUS = '1' and ORDERS.status> = '55'  " &
"            THEN 'DANFE_Solicitada'  " &
"          WHEN ORDERS.INVOICESTATUS = '3' and ORDERS.status> = '55'  " &
"            THEN 'DANFE_Aprovada'  " &
"          WHEN ORDERS.INVOICESTATUS = '4' and ORDERS.status> = '55'  " &
"            THEN 'Fim_Conferencia'  " &
"          WHEN (ORDERS.status < = '22') and WAVEDETAIL.wavekey is not null  " &
"            THEN 'Incluido_Onda'  " &
"          WHEN (ORDERS.status = '29' and sq1.Released > 0 and sq1.InPicking = 0 and sq1.PartPicked = 0)  " &
"            THEN 'Picking_Liberado'  " &
"          WHEN (ORDERS.status = '52')  " &
"            THEN 'Inicio_Picking'  " &
"          WHEN (ORDERS.status = '55')  " &
"            THEN 'Picking_Completo'  " &
"          ELSE 'Outros'  " &
"      END                                   EVENTO,  " &
"     NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE),  " &
"         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,  " &
"           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"             AT time zone 'America/Sao_Paulo') AS DATE))  " &
"                                            DT_ULT_EVENTO,  " &
"     NVL(ORDERSTATUSHISTORY.ADDWHO,  " &
"         ORDERS.EDITWHO)                    OPERADOR,  " &
"     ORDERDETAIL.SKU                        ITEM,  " &
"     SKU.ACTIVE                             ST_ITEM,  " &
"     SKU.DESCR                              NOME_ST_ITEM,  " &
"     DEPART.DEPART_NAME                     DEPARTAMENTO,  " &
"     DEPART.SECTOR_NAME                     SETOR,  " &
"     ORDERDETAIL.PRODUCT_CUBE *  " &
"     ORDERDETAIL.ORIGINALQTY                M3,  " &
"     TCCOM130.T$FOVN$L                      CNPJF,  " &
"     TCMCS060.T$DSCA                        FABRICANTE,  " &
"     LNREF.T$IDCA$C                         CANAL,  " &
"     ORDERS.C_VAT                           MEGA_ROTA,  " &
"     ORDERSTATUSSETUP.DESCRIPTION           SITUACAO,  " &
"     TASKDETAIL.TASKDETAILKEY               PROGRAMA,  " &
"     WAVEDETAIL.WAVEKEY                     ONDA,  " &
"     ORDERS.CARRIERCODE                     ID_TRANSPORTADORA,  " &
"     ORDERS.CARRIERNAME                     NOME_TRANSP,  " &
"     SLS002.T$TPEN$C                        TIPO_ENTREGA,  " &
"     ORDERS.SUSR1                           NOME_TP_ENT,  " &
"     ORDERS.INVOICENUMBER                   NOTA,  " &
"     ORDERS.LANE                            SERIE,  " &
"     CAGEIDDETAIL.CAGEID                    CARGA,  " &
"     CISLI940.T$CCFO$L                      CFOP,  " &
"     CISLI940.T$OPOR$L                      CFOP_SR,  " &
"     CASE WHEN SKU.SUSR2 = '2'  " &
"            THEN 'PESADO'  " &
"          ELSE   'LEVE'  " &
"      END                                   TP_TRANSPORTE,  " &
"     ORDERS.C_ZIP                           CEP,  " &
"     LNREF.t$fovn$c                         CNPJ,  " &
"     ORDERS.C_COMPANY                       NOME,  " &
"     ORDERDETAIL.ORIGINALQTY                QTDE_TOTAL,  " &
"     ABS( CASE WHEN NVL(cisli941.t$pric$l, 0) != 0 THEN cisli941.t$pric$l  " &
"               WHEN NVL(TDSLS401.T$PRIC, 0)   != 0 THEN TDSLS401.T$PRIC  " &
"               WHEN NVL(maucLN.mauc, 0)       != 0 THEN maucLN.mauc  " &
"               ELSE 0  " &
"           END )                            VL,  " &
"     ORDERS.type                            COD_TIPO_PEDIDO,  " &
"     TIPO_PEDIDO.                           DSC_TIPO_PEDIDO,  " &
"     CISLI940.T$BPID$L                      PARCEIRO_NEG,  " &
"     ORDERS.REFERENCEDOCUMENT               DOC_INICIAL  " &
" FROM       " + Parameters!Table.Value + ".ORDERS  " &
"  " &
" INNER JOIN " + Parameters!Table.Value + ".ORDERDETAIL  " &
"         ON ORDERDETAIL.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" INNER JOIN " + Parameters!Table.Value + ".SKU  " &
"         ON SKU.SKU = ORDERDETAIL.SKU  " &
"  " &
" INNER JOIN (select o1.orderkey,  " &
"                    ( select count(*)  " &
"                        from " + Parameters!Table.Value + ".orderdetail od1  " &
"                       where od1.orderkey = o1.orderkey  " &
"                         and od1.status = '29' ) Released,  " &
"                    ( select count(*)  " &
"                        from " + Parameters!Table.Value + ".orderdetail od1  " &
"                       where od1.orderkey = o1.orderkey  " &
"                         and od1.status = '51' ) InPicking,  " &
"                    ( select count(*)  " &
"                        from " + Parameters!Table.Value + ".orderdetail od1  " &
"                       where od1.orderkey = o1.orderkey  " &
"                         and od1.status = '52' ) PartPicked,  " &
"                    ( select count(*)  " &
"                        from " + Parameters!Table.Value + ".orderdetail od1  " &
"                       where od1.orderkey = o1.orderkey  " &
"                         and od1.status = '55' ) PickedComplete  " &
"               from " + Parameters!Table.Value + ".orders o1 ) sq1  " &
"         ON sq1.orderkey = orders.orderkey  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".STORER  " &
"         ON STORER.STORERKEY = sku.SUSR5  " &
"        AND STORER.WHSEID = sku.WHSEID  " &
"  " &
"  LEFT JOIN ENTERPRISE.DEPARTSECTORSKU  DEPART  " &
"         ON TO_CHAR(DEPART.ID_DEPART) = TO_CHAR(SKU.SKUGROUP)  " &
"        AND TO_CHAR(DEPART.ID_SECTOR) = TO_CHAR(SKU.SKUGROUP2)  " &
"  " &
"  LEFT JOIN ENTERPRISE.CODELKUP cl  " &
"         ON UPPER(cl.UDF1) = UPPER(ORDERS.WHSEID)  " &
"  " &
"  LEFT JOIN ( select trim(whwmd217.t$item) item,  " &
"                     whwmd217.t$cwar cwar,  " &
"                     case when sum(nvl(whwmd217.t$mauc$1,0)) = 0  " &
"                            then sum(whwmd217.t$ftpa$1)  " &
"                          else   round(sum(whwmd217.t$mauc$1) / sum(a.t$qhnd), 4)  " &
"                     end mauc  " &
"                from baandb.twhwmd217301@pln01 whwmd217  " &
"           left join baandb.twhinr140301@pln01 a  " &
"                  on a.t$cwar = whwmd217.t$cwar  " &
"                 and a.t$item = whwmd217.t$item  " &
"            group by whwmd217.t$item,  " &
"                     whwmd217.t$cwar ) maucLN  " &
"         ON maucLN.cwar = subStr(CL.DESCRIPTION,3,6)  " &
"        AND maucLN.item = ORDERDETAIL.SKU  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL  " &
"         ON WAVEDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"  " &
"  LEFT JOIN (select distinct a.CAGEID,  " &
"                             a.ORDERID  " &
"             from " + Parameters!Table.Value + ".CAGEIDDETAIL a) CAGEIDDETAIL  " &
"         ON CAGEIDDETAIL.ORDERID = ORDERDETAIL.ORDERKEY  " &
"  " &
"  LEFT JOIN ( select cd.orderid,  " &
"                     max(cg.status) status  " &
"                from " + Parameters!Table.Value + ".CAGEID cg  " &
"          inner join " + Parameters!Table.Value + ".CAGEIDDETAIL cd  " &
"                  on cd.CAGEID = cg.CAGEID  " &
"            group by cd.orderid ) sq2  " &
"         ON sq2.orderid = ORDERS.orderkey  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".WAVEDETAIL w  " &
"         ON w.ORDERKEY = ORDERS.ORDERKEY  " &
"  " &
" INNER JOIN WMSADMIN.PL_DB  " &
"         ON UPPER(WMSADMIN.PL_DB.DB_LOGID) = ORDERS.WHSEID  " &
"  " &
"  LEFT JOIN BAANDB.TZNSLS002301@pln01 SLS002  " &
"         ON UPPER(TRIM(SLS002.t$dsca$c)) = UPPER(TRIM(ORDERS.SUSR1))  " &
"  " &
"  LEFT JOIN ( SELECT a.ORDERKEY,  " &
"                     a.ORDERLINENUMBER ,  " &
"                     max(a.STATUS) STATUS,  " &
"                     max(a.ADDDATE) ADDDATE,  " &
"                     max(a.ADDWHO) ADDWHO  " &
"                FROM " + Parameters!Table.Value + ".ORDERSTATUSHISTORY a  " &
"               WHERE a.ADDDATE = ( select max(b.adddate)  " &
"                                     from " + Parameters!Table.Value + ".ORDERSTATUSHISTORY b  " &
"                                    where b.ORDERKEY = a.ORDERKEY  " &
"                                      and b.ORDERLINENUMBER = a.ORDERLINENUMBER )  " &
"            GROUP BY a.ORDERKEY,  " &
"                     a.ORDERLINENUMBER ) ORDERSTATUSHISTORY  " &
"         ON ORDERSTATUSHISTORY.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"        AND ORDERSTATUSHISTORY.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
"  " &
"  LEFT JOIN " + Parameters!Table.Value + ".ORDERSTATUSSETUP  " &
"         ON ORDERSTATUSSETUP.CODE = ORDERS.STATUS  " &
" 			  " &
"  LEFT JOIN ( select max(a.TASKDETAILKEY) keep (dense_rank last order by a.ENDTIME) TASKDETAILKEY,  " &
"                     a.ORDERKEY,  " &
"                     a.ORDERLINENUMBER,  " &
"                     max(a.LOT) LOT,  " &
"                     max(a.FROMLOC) FROMLOC  " &
"                from " + Parameters!Table.Value + ".TASKDETAIL a  " &
"               where a.tasktype = 'PK'  " &
"            group by a.ORDERKEY,  " &
"                     a.ORDERLINENUMBER ) TASKDETAIL  " &
"         ON TASKDETAIL.ORDERKEY = ORDERDETAIL.ORDERKEY  " &
"        AND TASKDETAIL.ORDERLINENUMBER = ORDERDETAIL.ORDERLINENUMBER  " &
"  " &
"  LEFT JOIN ( select r.t$orno$c,  " &
"                     r.t$ncia$c,  " &
"                     r.t$uneg$c,  " &
"                     r.t$pecl$c,  " &
"                     r.t$sqpd$c,  " &
"                     r.t$entr$c,  " &
"                     o.t$tpes$c,  " &
"                     q.t$idca$c,  " &
"                     q.t$fovn$c,  " &
"                     t0.t$poco$c  " &
"                from BAANDB.TZNSLS004301@pln01 r  " &
"           left join BAANDB.TZNSLS401301@pln01 o  " &
"                  on o.t$ncia$c = r.t$ncia$c  " &
"                 and o.t$uneg$c = r.t$uneg$c  " &
"                 and o.t$pecl$c = r.t$pecl$c  " &
"                 and o.t$sqpd$c = r.t$sqpd$c  " &
"                 and o.t$entr$c = r.t$entr$c  " &
"           left join BAANDB.TZNSLS400301@pln01 q  " &
"                  on q.t$ncia$c = r.t$ncia$c  " &
"                 and q.t$uneg$c = r.t$uneg$c  " &
"                 and q.t$pecl$c = r.t$pecl$c  " &
"                 and q.t$sqpd$c = r.t$sqpd$c  " &
"           left join ( select t1.t$poco$c,  " &
"                              t1.t$ncia$c,  " &
"                              t1.t$uneg$c,  " &
"                              t1.t$pecl$c,  " &
"                              t1.t$sqpd$c,  " &
"                              t1.t$entr$c  " &
"                         from BAANDB.TZNSLS410301@pln01 t1  " &
"                        where t1.t$poco$c in ('NFT', 'WMS', 'CAN')  " &
"                          and t1.t$dtoc$c = ( select max(t2.t$dtoc$c)  " &
"                                                from BAANDB.TZNSLS410301@pln01 t2  " &
"                                               where t2.t$uneg$c = t1.t$uneg$c  " &
"                                                 and t2.t$pecl$c = t1.t$pecl$c  " &
"                                                 and t2.t$sqpd$c = t1.t$sqpd$c  " &
"                                                 and t2.t$entr$c = t1.t$entr$c  " &
"                                                 and t2.t$poco$c in ('NFT', 'WMS', 'CAN') ) ) t0  " &
"                  on  t0.t$ncia$c = r.t$ncia$c  " &
"                 and t0.t$uneg$c = r.t$uneg$c  " &
"                 and t0.t$pecl$c = r.t$pecl$c  " &
"                 and t0.t$sqpd$c = r.t$sqpd$c  " &
"                 and t0.t$entr$c = r.t$entr$c  " &
"            group by r.t$orno$c,  " &
"                     r.t$ncia$c,  " &
"                     r.t$uneg$c,  " &
"                     r.t$pecl$c,  " &
"                     r.t$sqpd$c,  " &
"                     r.t$entr$c,  " &
"                     o.t$tpes$c,  " &
"                     q.t$idca$c,  " &
"                     q.t$fovn$c,  " &
"                     t0.t$poco$c ) LNREF  " &
"         ON LNREF.t$orno$c = ORDERS.REFERENCEDOCUMENT  " &
"  " &
"  LEFT JOIN BAANDB.TWHINH431301@PLN01 WHINH431  " &
"         ON WHINH431.T$SHPM          = SUBSTR(ORDERDETAIL.EXTERNORDERKEY,5,9)  " &
"        AND TO_CHAR(WHINH431.T$PONO) = TO_CHAR(ORDERDETAIL.EXTERNLINENO)  " &
"  " &
" LEFT JOIN BAANDB.TCISLI245301@PLN01 CISLI245   " &
"        ON CISLI245.T$SLCP = 301  " &
"       AND CISLI245.T$ORTP = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) IN ('34_', '36_')  " &
"                                    THEN 2   " &
"                                  ELSE   1  " &
"                              END  " &
"       AND CISLI245.T$KOOR = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) = '34_'  " &
"                                    THEN 34  " &
"                                  WHEN  TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) = '36_'  " &
"                                    THEN 36  " &
"                                  ELSE   3  " &
"                              END  " &
"       AND CISLI245.T$OSET = CASE WHEN TO_CHAR(SUBSTR(ORDERS.REFERENCEDOCUMENT,0,3)) IN ('34_', '36_')  " &
"                                    THEN WHINH431.T$WSET  " &
"                                  ELSE   0   " &
"                              END  " &               
"       AND CISLI245.T$SLSO = WHINH431.T$WORN  " &
"        AND CISLI245.T$PONO = WHINH431.T$WPON  " &
"        AND CISLI245.T$SQNB = WHINH431.T$WSEQ  " &
"        AND CISLI245.T$SHPM = WHINH431.T$SHPM  " &
" 	  " &
"  LEFT JOIN BAANDB.TCISLI941301@PLN01 CISLI941  " &
"         ON CISLI941.T$FIRE$L = CISLI245.T$FIRE$L  " &
"        AND CISLI941.T$LINE$L = CISLI245.T$LINE$L  " &
" 	  " &
"  LEFT JOIN BAANDB.TCISLI940301@PLN01 CISLI940  " &
"         ON CISLI940.T$FIRE$L = CISLI941.T$FIRE$L  " &
" 		  " &
"  LEFT JOIN BAANDB.TTDSLS401301@PLN01 TDSLS401  " &
" 		ON	TDSLS401.T$ORNO = WHINH431.T$WORN  " &
" 		AND	TDSLS401.T$PONO = WHINH431.T$PONO  " &
" 		AND TDSLS401.T$SQNB	= WHINH431.T$WSEQ  " &
"  " &
"  LEFT JOIN BAANDB.ttcibd001301@pln01 TCIBD001  " &
"         ON TRIM(TCIBD001.T$ITEM) = SKU.SKU  " &
"  " &
"  LEFT JOIN BAANDB.ttcmcs060301@pln01 TCMCS060  " &
"         ON TCMCS060.T$CMNF = TCIBD001.T$CMNF  " &
"  " &
"  LEFT JOIN BAANDB.ttccom100301@pln01 TCCOM100  " &
"         ON TCCOM100.T$BPID = STORER.STORERKEY  " &
"  " &
"  LEFT JOIN BAANDB.ttccom130301@pln01 TCCOM130  " &
"         ON TCCOM130.t$CADR = TCCOM100.T$CADR  " &
"  " &
"  LEFT JOIN ( select clkp.code          COD_TIPO_PEDIDO,  " &
"                     NVL(trans.description,  " &
"                     clkp.description)  DSC_TIPO_PEDIDO  " &
"                from " + Parameters!Table.Value + ".codelkup clkp  " &
"           left join " + Parameters!Table.Value + ".translationlist trans  " &
"                  on trans.code = clkp.code  " &
"                 and trans.joinkey1 = clkp.listname  " &
"                 and trans.locale = 'pt'  " &
"                 and trans.tblname = 'CODELKUP'  " &
"               where clkp.listname = 'ORDERTYPE'  " &
"                 and Trim(clkp.code) is not null  ) TIPO_PEDIDO  " &
"         ON TIPO_PEDIDO.COD_TIPO_PEDIDO = ORDERS.type  " &
"  " &
" WHERE cl.listname = 'SCHEMA'  " &
"   AND STORER.TYPE = 5  " &
"  " &
"   AND Trunc(NVL(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERSTATUSHISTORY.ADDDATE,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE),  " &
"                  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(ORDERS.EDITDATE,  " &
"                 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                   AT time zone 'America/Sao_Paulo') AS DATE)))  " &
"       Between '"+ Parameters!DataUltEventoDe.Value + "'  " &
"           And '"+ Parameters!DataUltEventoAte.Value + "'  " &
"  " &
" ORDER BY PLANTA, PEDIDO, Trunc(DT_REGISTRO), LPAD(ITEM, 10, '0')  "