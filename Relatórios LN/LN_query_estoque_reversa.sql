select Q1.*
  from ( SELECT  NVL(TRIM(ID_ITEM), 0) AS  ID_ITEM,
                                           ID_CIA,
                                           ESTABELECIMENTO,
                 MAX(ULTIMAATUAL) AS       ULTIMAATUAL,
                 'WN' AS                   RESTRICAO,
                 0 AS                      PZ_DISP,
                 SUM(QTDE) AS              SALDO,
                 'NAO BLOQUEADO' AS        ORIGEM
                                     
             FROM ( SELECT                 
                      est.T$ITEM AS        ID_ITEM,
                      int1.T$NCIA$C AS     ID_CIA,
                      fmd.T$FILI$C AS      ESTABELECIMENTO,
                      est.T$QHND
                      - 
                      ( select nvl(sum(whwmd630.t$qbls), 0)
                          from baandb.twhwmd630301    whwmd630
                         where whwmd630.t$item = est.T$ITEM
                           and whwmd630.t$cwar = est.T$CWAR )
                      - 
                      ( select NVL(SUM(whinp100.t$qana),0)
                          from baandb.twhinp100301 whinp100
                    inner join baandb.ttdsls401301 tdsls401
                            on tdsls401.t$orno = whinp100.t$orno
                           and tdsls401.t$pono = whinp100.t$pono
                           and tdsls401.t$sqnb = whinp100.t$ponb
                           and tdsls401.t$clyn = 2        -- N?o cancelado
                           and tdsls401.t$bkyn = 2        -- N?o bloqueado
                         where whinp100.t$item = est.T$ITEM
                           and whinp100.t$cwar = est.T$CWAR
                           and whinp100.t$koor = 3        -- Ordem de venda
                           and whinp100.t$kotr = 2        -- Baixa
                           and whinp100.t$cdis$c = ' ' )  -- Sem restriç?o
                      - 
                      ( select NVL(SUM(sls2.T$QOOR * sls2.T$CVQS),0)
                          from baandb.TTDSLS401301 sls2
                    inner join baandb.TTDSLS420301 sls3
                            on sls2.T$ORNO = sls3.T$ORNO
                    inner join baandb.TTDSLS090301 sls4
                            on sls3.T$HREA = sls4.T$HREA
                         where sls2.T$ITEM = est.T$ITEM
                           and sls2.T$CWAR = est.T$CWAR
                           and sls4.t$REST$C = 1 )   AS QTDE,
                   
                      TO_CHAR(est.T$RCD_UTC, 'YYYY-MM-DD HH24:MI:SS') AS ULTIMAATUAL
             
                 FROM BAANDB.TWHWMD215301 est
           
           INNER JOIN BAANDB.TTCIBD001301 item  
                   ON est.T$ITEM = item.T$item
            LEFT JOIN BAANDB.TZNISA002301 clas1 
                   ON item.T$NPCL$C = clas1.T$NPCL$C
            LEFT JOIN BAANDB.TZNISA001301 clas2 
                   ON clas1.T$NPTP$C = clas2.T$NPTP$C
           INNER JOIN BAANDB.TTCMCS003301 mcs   
                   ON est.T$CWAR = mcs.T$CWAR
           INNER JOIN BAANDB.TZNINT001301 int1  
                   ON mcs.T$COMP = int1.T$COMP$C
           INNER JOIN BAANDB.TTCCOM130301 com   
                   ON mcs.T$CADR = com.T$CADR
           INNER JOIN BAANDB.TZNFMD001301 fmd   
                   ON com.T$FOVN$L = fmd.T$FOVN$C
         
                WHERE 1 = 1
                  AND Nvl(clas2.T$SIIT$C,0) <> 2
                  AND item.t$kitm <> 2
                  AND fmd.T$FILI$C = 12)
         		 
             GROUP BY ID_ITEM, 
                      ID_CIA, 
                      ESTABELECIMENTO
                 
         
         UNION
         /*
           --------------------------------------------------------------------
           bloqueados
           --------------------------------------------------------------------
         */
         SELECT  TRIM(ID_ITEM)  AS    ID_ITEM,
                                      ID_CIA,
                                      ESTABELECIMENTO,
                 MAX(ULTIMAATUAL) AS  ULTIMAATUAL,
                                      RESTRICAO,
                 0 AS                 PZ_DISP,
                 SUM(QTDE) AS         SALDO,
                 'BLOQUEADO' AS       ORIGEM
           
            FROM ( SELECT 
                     est.T$ITEM AS     ID_ITEM,
                     int1.T$NCIA$C AS  ID_CIA,
                     fmd.T$FILI$C AS   ESTABELECIMENTO,
                     EST.T$BLOC AS     RESTRICAO,
                     ( Sum(est.T$QBLS) 
                       - 
                       ( SELECT NVL(SUM(sls.T$QOOR * sls.T$CVQS),0) AS qtdeReservado
                           FROM baandb.TWHINH220301 inh
                     INNER JOIN baandb.TTDSLS401301 sls
                             ON sls.T$ORNO = inh.T$ORNO
                            AND sls.T$PONO = inh.T$PONO
                            AND sls.T$SQNB = inh.T$SEQN
                          WHERE inh.T$OORG = 1
                            AND inh.T$LSTA <> 30
                            AND inh.T$ITEM = est.T$ITEM
                            AND sls.t$cdis$c = est.t$bloc ) ) 
                 -
                 ( SELECT NVL(SUM(sls2.T$QOOR * sls2.T$CVQS),0)
                     FROM baandb.TTDSLS401301 sls2
               INNER JOIN baandb.TTDSLS420301 sls3
                       ON sls2.T$ORNO = sls3.T$ORNO
                      AND sls2.T$PONO = sls3.T$PONO
                      AND sls2.T$SQNB = sls3.T$SQNB
               INNER JOIN baandb.TTDSLS090301 sls4
                       ON sls3.T$HREA = sls4.T$HREA
                    WHERE sls2.T$ITEM = est.T$ITEM
                      AND sls4.t$REST$C = 1
                      AND sls2.t$cdis$c = est.t$bloc )   AS QTDE,
             
                      MAX(TO_CHAR(est.T$RCD_UTC, 'YYYY-MM-DD HH24:MI:SS')) AS ULTIMAATUAL
         			 
                 FROM BAANDB.TWHWMD630301 est
           INNER JOIN BAANDB.TTCIBD001301 item 
                   ON est.T$ITEM = item.T$item
            LEFT JOIN BAANDB.TZNISA002301 clas1 
                   ON item.T$NPCL$C = clas1.T$NPCL$C
            LEFT JOIN BAANDB.TZNISA001301 clas2 
                   ON clas1.T$NPTP$C = clas2.T$NPTP$C
           INNER JOIN BAANDB.TTCMCS003301 mcs 
                   ON est.T$CWAR = mcs.T$CWAR
           INNER JOIN BAANDB.TZNINT001301 int1 
                   ON mcs.T$COMP = int1.T$COMP$C
           INNER JOIN BAANDB.TTCCOM130301 com 
                   ON mcs.T$CADR = com.T$CADR
           INNER JOIN BAANDB.TZNFMD001301 fmd 
                   ON com.T$FOVN$L = fmd.T$FOVN$C
         		  
                WHERE 1 = 1
                  AND Nvl(clas2.T$SIIT$C,0) <> 2   /* n?o carregar produtos de consumo */
                  AND item.t$kitm <> 2
                  AND fmd.T$FILI$C = 12
         		 
             GROUP BY est.T$ITEM, 
                      fmd.T$FILI$C,
                      int1.T$NCIA$C, 
                      EST.T$BLOC )
         
         GROUP BY ID_ITEM, 
                  ID_CIA, 
                  ESTABELECIMENTO, 
                  RESTRICAO )

 WHERE SALDO > 0
   AND RESTRICAO IN (:Restricao)         
		 
		 
		 
  select a.t$cdis  CD_TIPO_BLOQUEIO,
         a.t$dsca  DS_TIPO_BLOQUEIO
    from baandb.ttcmcs005301 a
   where a.t$rstp = 65

UNION

  select 'WN'      CDOE,
         'WN - Normal'  DESCR
    from Dual
order by 1