SELECT 
-- O campo CD_CIA foi incluido para diferenciar NIKE(601) E BUNZL(602)
      602 CD_CIA,
			tcemm030.t$euca CD_FILIAL,
			whinr140.t$cwar CD_DEPOSITO,
			ltrim(rtrim(whinr140.t$item)) CD_ITEM,
			tcmcs003.t$tpar$l CD_MODALIDADE,
      whinr140.t$qhnd - nvl(Q2.bloc,0) QT_FISICA, 
      CASE WHEN tcmcs003.t$tpar$l = 2 
        THEN 0 ELSE nvl(Q3.roma,0) 
      END QT_ROMANEADA, 
      CASE WHEN tcmcs003.t$tpar$l = 2 
        THEN whinr140.t$qhnd - nvl(Q2.bloc,0)
        ELSE whinr140.t$qhnd - nvl(reserva.quan,0) - nvl(Q2.bloc,0)               
      END QT_SALDO,
      CASE WHEN tcmcs003.t$tpar$l = 2 
        THEN 0 ELSE nvl(reserva.quan,0)
      END QT_RESERVADA, 
      q1.mauc VL_CMV,
			CASE WHEN tcmcs003.t$tpar$l=2 THEN 'AT' ELSE 'WN' END CD_TIPO_BLOQUEIO,
			tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
      
FROM    baandb.twhinr140602 whinr140

         LEFT JOIN ( select a.t$item,
                    a.t$cwar,
                    sum(a.t$qana) quan
               from baandb.twhinp100602 a
              where a.t$koor = 3
                and a.t$kotr = 2
                and a.t$cdis$c = ' '
           group by a.t$item,
                    a.t$cwar ) reserva            --ok
        ON reserva.t$item = whinr140.t$item
       AND reserva.t$cwar = whinr140.t$cwar
       
        
        LEFT JOIN ( SELECT 
					 whwmd217.t$item,
					 whwmd217.t$cwar,
					 case when (max(whinr140.t$qhnd))=0 then 0
					 else round(sum(whwmd217.t$mauc$1)/(max(whinr140.t$qhnd)),4) 
					 end mauc
					 FROM baandb.twhwmd217602 whwmd217, baandb.twhinr140602 whinr140
					 WHERE whinr140.t$cwar=whwmd217.t$cwar
					 AND whinr140.t$item=whwmd217.t$item
					 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
        ON q1.t$item = whinr140.t$item AND q1.t$cwar = whinr140.t$cwar

        LEFT JOIN ( SELECT  whwmd630.t$item, 
                            whwmd630.t$cwar,
                            whwmd630.t$loca,                                  --ok
                            sum(whwmd630.t$qbls) bloc
					 FROM baandb.twhwmd630602 whwmd630, baandb.twhinr140602 whinr140
					 WHERE whinr140.t$cwar = whwmd630.t$cwar
					 AND   whinr140.t$item = whwmd630.t$item
           AND   whinr140.t$loca = whwmd630.t$loca                            --ok
					 AND NOT EXISTS (SELECT * FROM baandb.ttcmcs095602 tcmcs095
                           WHERE  tcmcs095.t$modu = 'BOD' 
                           AND    tcmcs095.t$sumd = 0 
                           AND    tcmcs095.t$prcd = 9999
                           AND    tcmcs095.t$koda = whwmd630.t$bloc)
					 group by whwmd630.t$item, whwmd630.t$cwar, whwmd630.t$loca) q2 
           ON  q2.t$item = whinr140.t$item 
           AND q2.t$cwar = whinr140.t$cwar
           AND q2.t$loca = whinr140.t$loca                                    --ok
           
          LEFT JOIN ( SELECT  whinh220.t$item, 
                              whinh220.t$cwar, 
                              sum(whinh220.t$qord) roma
                      FROM baandb.twhinh220602 whinh220, baandb.twhinr140602 whinr140
                      WHERE whinr140.t$cwar = whinh220.t$cwar
                      AND   whinr140.t$item = whinh220.t$item
                      AND   whinh220.t$wmss = 40
                      group by whinh220.t$item, whinh220.t$cwar) q3 
           ON   q3.t$item = whinr140.t$item 
           AND  q3.t$cwar = whinr140.t$cwar,

        baandb.ttcemm112602 tcemm112,
        baandb.ttcemm030602 tcemm030,
        baandb.ttcmcs003602 tcmcs003

WHERE   tcemm112.t$loco = 602
AND     tcemm112.t$waid = whinr140.t$cwar
AND 	  tcemm030.t$eunt=tcemm112.t$grid
AND     tcmcs003.t$cwar = whinr140.t$cwar
AND 	(whinr140.t$qhnd - nvl(Q2.bloc,0)) > 0
           
UNION

SELECT  3 CD_CIA,
        tcemm030.t$euca CD_FILIAL,
        whwmd630.t$cwar CD_DEPOSITO,
        ltrim(rtrim(whwmd630.t$item)) CD_ITEM,
        tcmcs003.t$tpar$l CD_MODALIDADE,
        whwmd630.t$qbls QT_FISICA,
        0 QT_ROMANEADA,
        whwmd630.t$qbls - nvl(reserva.quan,0)       QT_SALDO,             --ok
        nvl(reserva.quan,0)                         QT_RESERVADA,         --ok
        q1.mauc VL_CMV,
        whwmd630.t$bloc CD_TIPO_BLOQUEIO,
        tcemm112.t$grid CD_UNIDADE_EMPRESARIAL
FROM    baandb.twhwmd630602 whwmd630
         
         LEFT JOIN ( select a.t$item,
                    a.t$cwar,
                    a.t$cdis$c,
                    sum(a.t$qana) quan
               from baandb.twhinp100602 a
              where a.t$koor = 3
                and a.t$kotr = 2
           group by a.t$item,
                    a.t$cwar,
                    a.t$cdis$c ) reserva                                  --ok
        ON reserva.t$item = whwmd630.t$item
       AND reserva.t$cwar = whwmd630.t$cwar
       AND reserva.t$cdis$c = whwmd630.t$bloc
       
        LEFT JOIN ( SELECT 
					 whwmd217.t$item,
					 whwmd217.t$cwar,
					 case when (max(whinr140.t$qhnd))=0 then 0
					 else round(sum(whwmd217.t$mauc$1)/(max(whinr140.t$qhnd)),4) 
					 end mauc
					 FROM baandb.twhwmd217602 whwmd217, baandb.twhinr140602 whinr140
					 WHERE whinr140.t$cwar=whwmd217.t$cwar
					 AND whinr140.t$item=whwmd217.t$item
					 group by  whwmd217.t$item, whwmd217.t$cwar) q1 
        ON q1.t$item = whwmd630.t$item AND q1.t$cwar = whwmd630.t$cwar,
        baandb.ttcemm112602 tcemm112,
        baandb.ttcemm030602 tcemm030,
        baandb.ttcmcs003602 tcmcs003
WHERE   tcemm112.t$loco = 602
AND     tcemm112.t$waid = whwmd630.t$cwar
AND 	  tcemm030.t$eunt=tcemm112.t$grid
AND     tcmcs003.t$cwar = whwmd630.t$cwar
AND	 NOT EXISTS (SELECT * FROM baandb.ttcmcs095602 tcmcs095
                 WHERE  tcmcs095.t$modu = 'BOD' 
                 AND    tcmcs095.t$sumd = 0 
                 AND    tcmcs095.t$prcd = 9999
                 AND    tcmcs095.t$koda = whwmd630.t$bloc)