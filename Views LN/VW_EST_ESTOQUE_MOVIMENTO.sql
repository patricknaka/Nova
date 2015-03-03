SELECT 

	1													CD_CIA,
	tcemm030.t$euca 									CD_FILIAL,
	tcemm030.t$eunt										CD_UNIDADE_EMPRESARIAL,
	whinr110.t$cwar										CD_ARMAZEM,
	trim(whinr110.t$item)								CD_ITEM,
	whinh200.t$cdis$c									CD_RESTRICAO,
	CASE WHEN nvl(whina112.t$qstk,0) <> 0.00		
		THEN whinr110.t$qstk		
		ELSE whinr110.t$qstk*-1	END						QT_FISICA,
	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinr110.t$trdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)	DT_TRANSACAO,
	CASE WHEN nvl(whina112.t$qstk,0) <> 0.00 
          THEN nvl(whina113.mauc,0)
		  ELSE round(nvl(whina115.mauc,0)/
					 nvl(whina114.t$qstk,0),4) END		VL_CMV
	
FROM
				baandb.twhinr110301 whinr110
				
	INNER JOIN	baandb.ttcemm112301 tcemm112
			ON	tcemm112.t$loco = 301
			AND	tcemm112.t$waid = whinr110.t$cwar
			
	INNER JOIN	baandb.ttcemm030301 tcemm030
			ON	tcemm030.t$eunt=tcemm112.t$grid

	LEFT JOIN 	baandb.twhina112301 whina112 
			ON whina112.t$ocmp = whinr110.t$ocmp
		   AND whina112.t$koor = whinr110.t$koor
		   AND whina112.t$orno = whinr110.t$orno
		   AND whina112.t$pono = whinr110.t$pono
		   AND whina112.t$cwar = whinr110.t$cwar
		   AND whina112.t$item = whinr110.t$item
		   AND whina112.t$itid = whinr110.t$itid
		   
	LEFT JOIN (	select 	a.t$item,
						a.t$cwar,
						a.t$trdt,
						a.t$seqn,
						a.t$inwp,
						sum(a.t$mauc$1) mauc
				from baandb.twhina113301 a
				group by a.t$item,
			             a.t$cwar,
			             a.t$trdt,
			             a.t$seqn,
			             a.t$inwp) whina113
			ON whina113.t$item = whina112.t$item
		   AND whina113.t$cwar = whina112.t$cwar
		   AND whina113.t$trdt = whina112.t$trdt
		   AND whina113.t$seqn = whina112.t$seqn
		   AND whina113.t$inwp = whina112.t$inwp	

	LEFT JOIN baandb.twhina114301 whina114 
		ON whina114.t$ocmp = whinr110.t$ocmp
	   AND whina114.t$koor = whinr110.t$koor
	   AND whina114.t$orno = whinr110.t$orno
	   AND whina114.t$pono = whinr110.t$pono
	   AND whina114.t$item = whinr110.t$item
	   AND whina114.t$cwar = whinr110.t$cwar
	   AND whina114.t$ctdt = whinr110.t$trdt
	   AND whina114.t$itid = whinr110.t$itid
	   
	LEFT JOIN (select  a.t$item,
					   a.t$cwar,
					   a.t$trdt,
					   a.t$seqn,
					   a.t$inwp,
					   a.t$sern,
					   sum(a.t$amnt$1) mauc
				from baandb.twhina115301 a
				group by a.t$item,
			             a.t$cwar,
			             a.t$trdt,
			             a.t$seqn,
			             a.t$inwp,
			             a.t$sern) whina115 
        ON whina115.t$item = whina114.t$item
       AND whina115.t$cwar = whina114.t$cwar
       AND whina115.t$trdt = whina114.t$trdt
       AND whina115.t$seqn = whina114.t$seqn
       AND whina115.t$inwp = whina114.t$inwp
       AND whina115.t$sern = whina114.t$sern

	   
		   
	LEFT JOIN	(	Select 3 koor, 1 oorg From DUAL
					Union Select 7 koor, 2 oorg From DUAL
					Union Select 34 koor, 3 oorg From DUAL
					Union Select 2 koor, 80 oorg From DUAL
					Union Select 6 koor, 81 oorg From DUAL
					Union Select 33 koor, 82 oorg From DUAL
					Union Select 17 koor, 11 oorg From DUAL
					Union Select 35 koor, 12 oorg From DUAL
					Union Select 37 koor, 31 oorg From DUAL
					Union Select 39 koor, 32 oorg From DUAL
					Union Select 38 koor, 33 oorg From DUAL
					Union Select 42 koor, 34 oorg From DUAL
					Union Select 1 koor, 50 oorg From DUAL
					Union Select 32 koor, 51 oorg From DUAL
					Union Select 56 koor, 53 oorg From DUAL
					Union Select 9 koor, 55 oorg From DUAL
					Union Select 46 koor, 56 oorg From DUAL
					Union Select 57 koor, 58 oorg From DUAL
					Union Select 22 koor, 71 oorg From DUAL
					Union Select 36 koor, 72 oorg From DUAL
					Union Select 58 koor, 75 oorg From DUAL
					Union Select 59 koor, 76 oorg From DUAL
					Union Select 60 koor, 90 oorg From DUAL
					Union Select 21 koor, 61 oorg From DUAL) KOOR2OORG
			ON	KOOR2OORG.koor = whinr110.t$koor

	LEFT JOIN	baandb.twhinh200301 whinh200
			ON	whinh200.t$oorg	=	KOOR2OORG.oorg
			AND	whinh200.t$orno = 	whinr110.t$orno
WHERE 

	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinr110.t$trdt, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE)>TRUNC(SYSDATE, 'DD')

   
