select tcibd001.t$item
      from baandb.ttcibd001301 tcibd001
inner join ( select distinct whinp100.t$item 
               from baandb.twhinp100301 whinp100 ) whinp100
        on tcibd001.t$item = whinp100.t$item 
     where ROWNUM <= 10
  order by tcibd001.t$item