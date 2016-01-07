select l.loc, 
		   l.putawayzone,
		   CASE 
				WHEN sum(SL.QTY) > 0 THEN 'OCUPADO'
				ELSE 'VAZIO'
			  END AS STATUS
	  from  WMWHSE5.loc l

	left join  WMWHSE5.skuxloc sl
		   on sl.loc = l.loc
		   
	group by l.loc, L.PUTAWAYZONE
	order by l.loc 