select 
  q1.WHSEID,
  q1.udf2,
  count(q1.orderkey), 
  q1.SCHEDULEDSHIPDATE,
  q1.ADDDATE,
  q1.ID_EVENTO,
  q1.DESCR_EVENTO


from
(SELECT
		A.WHSEID,
		CL.UDF2,
		A.ORDERKEY,
		trunc(A.SCHEDULEDSHIPDATE) SCHEDULEDSHIPDATE,
		trunc(A.ADDDATE) ADDDATE,

		CASE WHEN (a.status='02' or a.status='09' or a.status='04' or a.status='00') and
				  w.wavekey is null then
		  'C10'
		WHEN (a.INVOICESTATUS='2' and a.status>='55') OR
			 (nvl(LNREF.t$poco$c,' ')='NFT' and a.status='95') OR
			 (nvl(LNREF.t$poco$c,' ')='CAN' and a.status='95') OR
		   a.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%' THEN
		  'C41' 
		WHEN a.status='100' then
		  'C44' 
		WHEN (a.status>='95' or sq2.status=6) then
		  'C39'
		WHEN (sq2.status=3 or sq2.status=4) and a.status>='55' then
		  'C32'
		WHEN sq2.status=5 and a.status>='55' then
		  'C34'
		WHEN sq2.orderid IS NOT NULL and sq2.status=2 and a.status>='55' then
		  'C31'
		WHEN a.INVOICESTATUS='1' and a.status>='55' then
		  'C20'
		WHEN a.INVOICESTATUS='3' and a.status>='55' then
		  'C22'
		WHEN a.INVOICESTATUS='4' and a.status>='55' then
		  'C28'
		WHEN (a.status<='22') and
				  w.wavekey is not null then
		  'C12'
		WHEN (a.status='29' and sq1.Released>0 and sq1.InPicking=0 and sq1.PartPicked=0) then
		  'C14'
		WHEN (a.status='52') then
		  'C16'
		WHEN (a.status='55') then
		  'C18'
		ELSE
		  TO_CHAR(a.status)
		END ID_EVENTO,

		CASE WHEN (a.status='02' or a.status='09' or a.status='04' or a.status='00') and
				  w.wavekey is null then
		  'Recebimento no host'
		WHEN (a.INVOICESTATUS='2' and a.status>='55') OR
			 (nvl(LNREF.t$poco$c,' ')='NFT' and a.status='95') OR
			 (nvl(LNREF.t$poco$c,' ')='CAN' and a.status='95') OR
		   a.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%' THEN
		  'Estorno' 
		WHEN a.status='100' then
		  'Perda Logística' 
		WHEN (a.status>='95' or sq2.status=6) then
		  'Expedição concluida'
		WHEN (sq2.status=3 or sq2.status=4) and a.status>='55' then
		  'Fechamento da Gaiola'
		WHEN sq2.status=5 and a.status>='55' then
		  'Entregue na Doca'
		WHEN sq2.orderid IS NOT NULL and sq2.status=2 and a.status>='55' then
		  'Inclusão Carga'
		WHEN a.INVOICESTATUS='1' and a.status>='55' then
		  'DANFE Solicitada'
		WHEN a.INVOICESTATUS='3' and a.status>='55' then
		  'DANFE Aprovada'
		WHEN a.INVOICESTATUS='4' and a.status>='55' then
		  'Fim Conferencia'
		WHEN (a.status<='22') and
				  w.wavekey is not null then
		  'Incluido na Onda'
		WHEN (a.status='29' and sq1.Released>0 and sq1.InPicking=0 and sq1.PartPicked=0) then
		  'Picking Liberado'
		WHEN (a.status='52') then
		  'Inicio Picking'
		WHEN (a.status='55') then
		  'Picking Completo'
		ELSE
		  TO_CHAR(SS.DESCRIPTION) 
		END DESCR_EVENTO

From WMWHSE5.orders a
	INNER JOIN	WMWHSE5.ORDERSTATUSSETUP	SS	ON	SS.CODE			=	A.STATUS
	INNER JOIN	ENTERPRISE.CODELKUP 		CL	ON	UPPER(CL.UDF1)	=	A.WHSEID
												AND	CL.LISTNAME		=	'SCHEMA'

    LEFT JOIN  (select cd.orderid, max(cg.status) status
                from WMWHSE5.CAGEID cg, CAGEIDDETAIL cd
                where cd.CAGEID=cg.CAGEID
                group by cd.orderid) sq2
                                    ON sq2.orderid=a.orderkey
    LEFT JOIN WMWHSE5.WAVEDETAIL w ON w.ORDERKEY=a.ORDERKEY
	

	LEFT JOIN  (select  r.t$orno$c,
						r.t$ncia$c,
						r.t$uneg$c,
						r.t$pecl$c,
						r.t$sqpd$c,
						r.t$entr$c,
						o.t$tpes$c,
						t0.t$poco$c
				from 		BAANDB.TZNSLS004301@pln01 r
				left join	BAANDB.TZNSLS401301@pln01 o	on 	o.t$ncia$c = r.t$ncia$c
				                                        and o.t$uneg$c = r.t$uneg$c 
				                                        and o.t$pecl$c = r.t$pecl$c
				                                        and o.t$sqpd$c = r.t$sqpd$c 
				                                        and o.t$entr$c = r.t$entr$c 
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
						t0.t$poco$c) LNREF ON LNREF.t$orno$c=A.REFERENCEDOCUMENT,
	(select 
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
	from WMWHSE5.orders o1) sq1
where
			a.status NOT IN ('98', '99', '95', '100')
	and 	sq1.orderkey=a.orderkey 
	and 	 CASE WHEN (a.INVOICESTATUS='2' and a.status>='55') OR
			 (nvl(LNREF.t$poco$c,' ')='NFT' and a.status='95') OR
			 (nvl(LNREF.t$poco$c,' ')='CAN' and a.status='95') OR
			 a.fiscaldecision like 'CANCELADO DEVIDO A NÃO PROCESSAMENTO%' then 1 else 0 end = 0
       ) q1
group by
  q1.WHSEID,
  q1.udf2, 
  q1.SCHEDULEDSHIPDATE,
  q1.ADDDATE,
  q1.ID_EVENTO,
  q1.DESCR_EVENTO