select *
  from ( SELECT  NVL(TRIM(ID_ITEM), 0) AS  ID_ITEM,
                                           ID_CIA,
                                           ESTABELECIMENTO,
                 MAX(ULTIMAATUAL) AS       ULTIMAATUAL,
                 'WN' AS                   RESTRICAO,
                 0 AS                      PZ_DISP,
                 SUM(QTDE) AS              SALDO,
                 'NAO BLOQUEADO' AS        ORIGEM,
                 MAX(VL_CMV)              VL_CMV
                      
             FROM ( SELECT                 
                      est.T$ITEM AS        ID_ITEM,
                      int1.T$NCIA$C AS     ID_CIA,
                      fmd.T$FILI$C AS      ESTABELECIMENTO,
                      est.T$QHND,
                      - 
                      (   select nvl(sum(whwmd630.t$qbls), 0)
                          from baandb.twhwmd630201    whwmd630
                          where whwmd630.t$item = est.T$ITEM
                          and whwmd630.t$cwar = est.T$CWAR
                          and not exists(
                                          select  tcmcs095.t$parm
                                          from    baandb.ttcmcs095201 tcmcs095
                                          where   tcmcs095.t$modu = 'BOD'
                                          and     tcmcs095.t$sumd = 0
                                          and     tcmcs095.t$prcd = 9999
                                          and     tcmcs095.t$parm in ('tbex', 'tbin')
                                          and     trim(tcmcs095.t$koda) = trim(whwmd630.t$bloc)))
                      - 
                      ( select NVL(SUM(whinp100.t$qana),0)
                          from baandb.twhinp100201 whinp100
                    inner join baandb.ttdsls401201 tdsls401
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
                          from baandb.TTDSLS401201 sls2
                    inner join baandb.TTDSLS420201 sls3
                            on sls2.T$ORNO = sls3.T$ORNO
                    inner join baandb.TTDSLS090201 sls4
                            on sls3.T$HREA = sls4.T$HREA
                         where sls2.T$ITEM = est.T$ITEM
                           and sls2.T$CWAR = est.T$CWAR
                           and sls4.t$REST$C = 1 )   AS QTDE,
                   
                     -- TO_CHAR(est.T$RCD_UTC, 'YYYY-MM-DD HH24:MI:SS') AS ULTIMAATUAL
                     
                     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(est.t$rcd_utc, 
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone sessiontimezone) AS DATE) AS ULTIMAATUAL,
                      q1.mauc               VL_CMV 
                 FROM baandb.TWHWMD215201 est
                 
         LEFT JOIN (  SELECT 
                      whwmd217.t$item,
                      whwmd217.t$cwar,
                      case when (max(whwmd215.t$qhnd))=0 then 0
                      else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd)),4) 
                      end mauc
                      FROM baandb.twhwmd217201 whwmd217, baandb.twhwmd215201 whwmd215
                      WHERE whwmd215.t$cwar=whwmd217.t$cwar
                      AND whwmd215.t$item=whwmd217.t$item
                      group by  whwmd217.t$item, whwmd217.t$cwar) q1 
              ON q1.t$item = est.t$item AND q1.t$cwar = est.t$cwar
              
           INNER JOIN baandb.TTCIBD001201 item  
                   ON est.T$ITEM = item.T$item
            LEFT JOIN baandb.TZNISA002201 clas1 
                   ON item.T$NPCL$C = clas1.T$NPCL$C
            LEFT JOIN baandb.TZNISA001201 clas2 
                   ON clas1.T$NPTP$C = clas2.T$NPTP$C
           INNER JOIN baandb.TTCMCS003201 mcs   
                   ON est.T$CWAR = mcs.T$CWAR
           INNER JOIN baandb.TZNINT001201 int1  
                   ON mcs.T$COMP = int1.T$COMP$C
           INNER JOIN baandb.TTCCOM130201 com   
                   ON mcs.T$CADR = com.T$CADR
           INNER JOIN baandb.TZNFMD001201 fmd   
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
                 'BLOQUEADO' AS       ORIGEM,
                 MAX(VL_CMV)         VL_CMV
           
            FROM ( SELECT 
                     est.T$ITEM AS     ID_ITEM,
                     int1.T$NCIA$C AS  ID_CIA,
                     fmd.T$FILI$C AS   ESTABELECIMENTO,
                     EST.T$BLOC AS     RESTRICAO,
                     ( Sum(est.T$QBLS)
                       - 
                       ( SELECT NVL(SUM(sls.T$QOOR * sls.T$CVQS),0) AS qtdeReservado
                           FROM baandb.TWHINH220201 inh
                     INNER JOIN baandb.TTDSLS401201 sls
                             ON sls.T$ORNO = inh.T$ORNO
                            AND sls.T$PONO = inh.T$PONO
                            AND sls.T$SQNB = inh.T$SEQN
                          WHERE inh.T$OORG = 1
                            AND inh.T$LSTA <> 30
                            AND inh.T$ITEM = est.T$ITEM
                            AND sls.t$cdis$c = est.t$bloc ) ),
                 -
                 ( SELECT NVL(SUM(sls2.T$QOOR * sls2.T$CVQS),0)
                     FROM baandb.TTDSLS401201 sls2
               INNER JOIN baandb.TTDSLS420201 sls3
                       ON sls2.T$ORNO = sls3.T$ORNO
                      AND sls2.T$PONO = sls3.T$PONO
                      AND sls2.T$SQNB = sls3.T$SQNB
               INNER JOIN baandb.TTDSLS090201 sls4
                       ON sls3.T$HREA = sls4.T$HREA
                    WHERE sls2.T$ITEM = est.T$ITEM
                      AND sls4.t$REST$C = 1
                      AND sls2.t$cdis$c = est.t$bloc )   AS QTDE,
             
                     --MAX(TO_CHAR(est.T$RCD_UTC, 'YYYY-MM-DD HH24:MI:SS')) AS ULTIMAATUAL
                     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(est.t$rcd_utc), 
                       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                         AT time zone sessiontimezone) AS DATE) AS ULTIMAATUAL,
                  MAX(q1.mauc)        VL_CMV

         			 
                 FROM baandb.TWHWMD630201 est
                 
              LEFT JOIN (  SELECT 
                      whwmd217.t$item,
                      whwmd217.t$cwar,
                      case when (max(whwmd215.t$qhnd))=0 then 0
                      else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd)),4) 
                      end mauc
                      FROM baandb.twhwmd217201 whwmd217, baandb.twhwmd215201 whwmd215
                      WHERE whwmd215.t$cwar=whwmd217.t$cwar
                      AND whwmd215.t$item=whwmd217.t$item
                      group by  whwmd217.t$item, whwmd217.t$cwar) q1 
              ON q1.t$item = est.t$item AND q1.t$cwar = est.t$cwar                 
                 
           INNER JOIN baandb.TTCIBD001201 item 
                   ON est.T$ITEM = item.T$item
            LEFT JOIN baandb.TZNISA002201 clas1 
                   ON item.T$NPCL$C = clas1.T$NPCL$C
            LEFT JOIN baandb.TZNISA001201 clas2 
                   ON clas1.T$NPTP$C = clas2.T$NPTP$C
           INNER JOIN baandb.TTCMCS003201 mcs 
                   ON est.T$CWAR = mcs.T$CWAR
           INNER JOIN baandb.TZNINT001201 int1 
                   ON mcs.T$COMP = int1.T$COMP$C
           INNER JOIN baandb.TTCCOM130201 com 
                   ON mcs.T$CADR = com.T$CADR
           INNER JOIN baandb.TZNFMD001201 fmd 
                   ON com.T$FOVN$L = fmd.T$FOVN$C
         		  
                WHERE 1 = 1
                  AND Nvl(clas2.T$SIIT$C,0) <> 2   /* n?o carregar produtos de consumo */
                  AND item.t$kitm <> 2
                  AND fmd.T$FILI$C = 12
                  AND not exists(
                                  select  tcmcs095.t$parm
                                  from    baandb.ttcmcs095201 tcmcs095
                                  where   tcmcs095.t$modu = 'BOD'
                                  and     tcmcs095.t$sumd = 0
                                  and     tcmcs095.t$prcd = 9999
                                  and     tcmcs095.t$parm in ('tbex', 'tbin')
                                  and     trim(tcmcs095.t$koda) = trim(est.t$bloc))
         		 
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
    from baandb.ttcmcs005201 a
   where a.t$rstp = 65

UNION

  select 'WN'      CDOE,
         'WN - Normal'  DESCR
    from Dual
order by 1
