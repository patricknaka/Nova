-- #FAF.221, 19-aug-2014, Fabio Ferreira, 	Corre��o sinal da transa��o
-- 21/08/2014    Atualiza��o do timezone
--*********************************************************************************************************************************************
SELECT  
        201                               CD_CIA,
        tcemm030.t$euca                   CD_FILIAL,
        tcemm112.t$grid                   CD_UNIDADE_EMPRESARIAL,
        ltrim(rtrim(whwmd215.t$item))     CD_ITEM,
        sum(whwmd215.t$qhnd - whwmd215.t$qblk)+ sum(nvl(whinr110.t$qstk,0)) QT_FISICA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(whwmd215.t$rcd_utc), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone sessiontimezone) AS DATE) DT_ULT_ATUALIZACAO,
        (SELECT sum(whina113.t$mauc$1)  VL_CMV
          FROM
            baandb.twhina112201 whina112,
            baandb.twhina113201 whina113,
            baandb.ttcemm030201 tcemm030q,
            baandb.ttcemm112201 tcemm112q
          WHERE 
            whina113.t$item = whina112.t$item AND
            whina113.t$cwar = whina112.t$cwar AND
            whina113.t$trdt = whina112.t$trdt AND
            whina113.t$seqn = whina112.t$seqn AND
            tcemm030q.t$eunt = tcemm112q.t$grid AND
            tcemm112q.t$waid = whina112.t$cwar AND
            whina113.t$trdt=( SELECT max(whina112a.t$trdt)
                              FROM
                                baandb.twhina112201 whina112a,
                                baandb.twhina113201 whina113a,
                                baandb.ttcemm030201 tcemm030qa,
                                baandb.ttcemm112201 tcemm112qa
                              WHERE 
                                whina113a.t$item = whina112a.t$item AND
                                whina113a.t$cwar = whina112a.t$cwar AND
                                whina113a.t$trdt = whina112a.t$trdt AND
                                whina113a.t$seqn = whina112a.t$seqn AND
                                tcemm030qa.t$eunt = tcemm112qa.t$grid AND
                                tcemm112qa.t$waid = whina112a.t$cwar AND
                                whina112a.t$item = whina112.t$item  AND
                                tcemm030qa.t$euca = tcemm030q.t$euca  AND
                                tcemm112qa.t$grid = tcemm112q.t$grid AND
                                whina112a.t$trdt <= TRUNC(sysdate, 'DD')) AND
                                whina113.t$seqn=( SELECT	max(whina112a.t$seqn)
                                                  FROM
                                                    baandb.twhina112201 whina112a,
                                                    baandb.twhina113201 whina113a,
                                                    baandb.ttcemm030201 tcemm030qa,
                                                    baandb.ttcemm112201 tcemm112qa
                                                  WHERE 
                                                    whina113a.t$item = whina112a.t$item AND
                                                    whina113a.t$cwar = whina112a.t$cwar AND
                                                    whina113a.t$trdt = whina112a.t$trdt AND
                                                    whina113a.t$seqn = whina112a.t$seqn AND
                                                    tcemm030qa.t$eunt = tcemm112qa.t$grid AND
                                                    tcemm112qa.t$waid = whina112a.t$cwar AND
                                                    whina112a.t$item = whina112.t$item  AND
                                                    tcemm030qa.t$euca = tcemm030q.t$euca  AND
                                                    tcemm112qa.t$grid = tcemm112q.t$grid  AND
                                                    whina112a.t$trdt = whina113.t$trdt) AND
            tcemm030q.t$euca=tcemm030.t$euca AND
            tcemm112q.t$grid=tcemm112.t$grid AND
            whina112.t$item=whwmd215.t$item
        GROUP BY whina112.t$item, tcemm030q.t$euca, tcemm112q.t$grid) VL_CMV
		
FROM    baandb.twhwmd215201 whwmd215

--		LEFT JOIN ( SELECT  sum(whinr110q.t$qstk * case when whinr110q.t$kost IN (5, 102) then -1 else 1 end)  t$qstk, 			--#FAF.221.o
		LEFT JOIN ( SELECT  sum(whinr110q.t$qstk * case when whinr110q.t$kost IN (5, 102) then 1 else -1 end)  t$qstk, 			--#FAF.221.n
							whinr110q.t$cwar,
							whinr110q.t$item,
							CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(whinr110q.t$trdt), 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
								AT time zone sessiontimezone) AS DATE)t$trdt
					FROM 	baandb.twhinr110201 whinr110q
					WHERE	whinr110q.t$trdt >= TRUNC(sysdate, 'DD')
GROUP BY 	    			whinr110q.t$cwar,
							whinr110q.t$item) 		whinr110
		ON     	whinr110.t$cwar = whwmd215.t$cwar
		AND     whinr110.t$item = whwmd215.t$item,

        baandb.ttcemm112201 tcemm112,
        baandb.ttcemm030201 tcemm030
        
WHERE   tcemm112.t$loco = 201
AND     tcemm112.t$waid = whwmd215.t$cwar
AND 	  tcemm030.t$eunt=tcemm112.t$grid
AND     (whwmd215.t$qhnd>0 or whwmd215.t$qall>0)
GROUP BY tcemm030.t$euca, tcemm112.t$grid, whwmd215.t$item