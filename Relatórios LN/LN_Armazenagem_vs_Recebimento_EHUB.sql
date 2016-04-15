SELECT trim(whinh312.t$item)                                          ITEM,
       SUM(tdrec941.t$qnty$l)                                         QUANTIDADE_PLANEJADA_NR,
       SUM(whinh312.t$qrec)                                           QUANTIDADE_FISICA_RECEBIDA,
       TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  DATA_RECEBIMENTO,
       TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  DATA_RECEBIMENTO_FISICO

FROM       baandb.twhinh312601 whinh312

INNER JOIN baandb.ttdpur406601 tdpur406
        ON whinh312.t$rcno = tdpur406.t$rcno
       AND whinh312.t$rcln = tdpur406.t$rseq
  
 LEFT JOIN baandb.ttdrec947601 tdrec947  
        ON tdrec947.t$oorg$l = whinh312.t$oorg
       AND tdrec947.t$orno$l = tdpur406.t$orno
       AND tdrec947.t$pono$l = tdpur406.t$pono
       AND tdrec947.t$seqn$l = tdpur406.t$sqnb  

 LEFT JOIN baandb.ttdrec941601 tdrec941  
        ON tdrec941.t$fire$l = tdrec947.t$fire$l
       AND tdrec941.t$line$l = tdrec947.t$line$l

WHERE TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy') 
      Between :DataRecDe
          And :DataRecAte
  AND TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
          AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')
      Between :DataArmDe
          And :DataArmAte
  AND ( trim(whinh312.t$item) = (trim(:Item)) or :Item is null )

GROUP BY trim(whinh312.t$item),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy'),
         TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')
           
ORDER BY 1, 4



=

" SELECT trim(whinh312.t$item)                                          ITEM,  " &
"        SUM(tdrec941.t$qnty$l)                                         QUANTIDADE_PLANEJADA_NR,  " &
"        SUM(whinh312.t$qrec)                                           QUANTIDADE_FISICA_RECEBIDA,  " &
"        TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  DATA_RECEBIMENTO,  " &
"        TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt,  " &
"          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"            AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  DATA_RECEBIMENTO_FISICO  " &
"  " &
" FROM       baandb.twhinh312" + Parameters!Compania.Value + " whinh312  " &
"  " &
" INNER JOIN baandb.ttdpur406" + Parameters!Compania.Value + " tdpur406  " &
"         ON whinh312.t$rcno = tdpur406.t$rcno  " &
"        AND whinh312.t$rcln = tdpur406.t$rseq  " &
"  " &
"  LEFT JOIN baandb.ttdrec947" + Parameters!Compania.Value + " tdrec947  " &
"         ON tdrec947.t$oorg$l = whinh312.t$oorg  " &
"        AND tdrec947.t$orno$l = tdpur406.t$orno  " &
"        AND tdrec947.t$pono$l = tdpur406.t$pono  " &
"        AND tdrec947.t$seqn$l = tdpur406.t$sqnb  " &
"  " &
"  LEFT JOIN baandb.ttdrec941" + Parameters!Compania.Value + " tdrec941  " &
"         ON tdrec941.t$fire$l = tdrec947.t$fire$l  " &
"        AND tdrec941.t$line$l = tdrec947.t$line$l  " &
"  " &
" WHERE TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  " &
"       Between :DataRecDe  " &
"           And :DataRecAte  " &
"   AND TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt,  " &
"         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"           AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  " &
"       Between :DataArmDe  " &
"           And :DataArmAte  " &
"  " &
" GROUP BY trim(whinh312.t$item),  " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec941.t$tdat$l,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy'),  " &
"          TO_CHAR(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whinh312.t$ardt,  " &
"            'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"              AT time zone 'America/Sao_Paulo') AS DATE), 'dd/MM/yyyy')  " &
"ORDER BY 1, 4  "