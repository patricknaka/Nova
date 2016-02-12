Select distinct * 
  from 
    (select 
      cast(to_char(a.t$baoc$l) as varchar(3))	CD_BANCO,
    (select b.t$bnam 
          from baandb.ttfcmg011201 b
          where b.t$baoc$l=a.t$baoc$l
          and rownum=1)				DS_BANCO
    from baandb.ttfcmg011201 a

UNION 
    select 
      cast(to_char(c.t$idbc$c) as varchar(3))	CD_BANCO,
		(select d.t$desc$c 
        from baandb.tzncmg020201 d
        where d.t$idbc$c=c.t$idbc$c
        and rownum=1)				DS_BANCO
    from baandb.tzncmg020201 c)

UNION 
  Select '0'					CD_BANCO,  
  'Não Associado'				DS_BANCO 
  from dual
order by 1