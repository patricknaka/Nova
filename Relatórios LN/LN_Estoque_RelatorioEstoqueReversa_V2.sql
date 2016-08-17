SELECT NVL(TRIM(ID_ITEM), 0) AS ID_ITEM,
           ID_CIA,
           ESTABELECIMENTO,
           MAX(ULTIMAATUAL)      AS ULTIMAATUAL,
           ' '                   AS RESTRICAO,
           0                                   AS PZ_DISP,
           SUM(QTDE)                  AS SALDO,
           ARMAZEM,
           'NAO BLOQUEADO'    AS ORIGEM,
           ' '                                  AS TIPOPRODUTO,
           MAX(VL_CMV)              AS VL_CMV,
           DESC_COMPLETA         AS DESC_COMPLETA,    --CAMPO INCLUÍDO
           DEPARTAMENTO          AS DEPARTAMENTO,     --CAMPO INCLUÍDO
           SETOR                 AS SETOR             --CAMPO INCLUÍDO

      FROM ( SELECT whwmd215.T$ITEM                                    AS ID_ITEM,
                    znint001.T$NCIA$C                                  AS ID_CIA,
                    whwmd215.t$cwar                                    AS ARMAZEM,
                    znfmd001.T$FILI$C                                  AS ESTABELECIMENTO,
                    whwmd215.T$QHND - whwmd215.t$qblk
                    -
                    ( select NVL(SUM(whinp100.t$qana),0) -- Vendas não bloqueadas
                        from baandb.twhinp100301 whinp100
                  inner join baandb.ttdsls401301 tdsls401
                          on tdsls401.t$orno = whinp100.t$orno
                         and tdsls401.t$pono = whinp100.t$pono
                         and tdsls401.t$sqnb = whinp100.t$ponb
                         and tdsls401.t$clyn = 2       -- Não cancelado
                         and tdsls401.t$bkyn = 2       -- Não bloqueado
                       where whinp100.t$item = whwmd215.T$ITEM
                         and whinp100.t$cwar = whwmd215.T$CWAR
                         and whinp100.t$koor = 3       -- Ordem de venda
                         and whinp100.t$kotr = 2       -- Baixa
                         and whinp100.t$cdis$c = ' ' ) -- Sem restrição
                    -
                    ( select nvl(sum(tdsls401.t$qoor * tdsls401.t$cvqs), 0) -- Vendas bloquedas que reservam estoque
                        from baandb.ttdsls401301 tdsls401
                  inner join baandb.ttdsls400301 tdsls400 on tdsls400.t$orno = tdsls401.t$orno
                  inner join baandb.ttdsls094301 tdsls094 on tdsls094.t$sotp = tdsls400.t$sotp
                  inner join baandb.ttdsls420301 tdsls420 on tdsls420.t$orno = tdsls401.t$orno
                         and tdsls420.t$pono = 0
                  inner join baandb.ttdsls090301 tdsls090  on  tdsls090.t$hrea = tdsls420.t$hrea
                       where tdsls401.t$item = tcibd001.t$item
                         and tdsls401.t$cwar = whwmd215.t$cwar
                         and tdsls094.t$reto = 2               -- Retorno = Não
                         and tdsls090.t$rest$c = 1 )           -- Reserva estoque = Sim
                                                                        AS QTDE,
                    TO_CHAR(zninh005.t$data$c, 'YYYY-MM-DD HH24:MI:SS') AS ULTIMAATUAL,
                    Q1.mauc                                             AS VL_CMV,
                    tcibd001.t$dscb$c                                   AS DESC_COMPLETA,
                    tcmcs023.t$dsca                                     AS DEPARTAMENTO,
                   znmcs030.t$dsca$c                                    AS SETOR

           FROM BAANDB.TWHWMD215301 whwmd215
     INNER JOIN BAANDB.TTCIBD001301 tcibd001 ON whwmd215.T$ITEM   = tcibd001.T$item
     INNER JOIN BAANDB.ttcmcs023301 tcmcs023 ON tcibd001.T$CITG    = tcmcs023.T$CITG
     INNER JOIN BAANDB.TZNMCS030301 znmcs030 ON tcibd001.T$CITG    = znmcs030.T$CITG$C
     AND  tcibd001.T$SETO$C = znmcs030.t$seto$c
      LEFT JOIN BAANDB.TZNISA002301 znisa002 ON tcibd001.T$NPCL$C = znisa002.T$NPCL$C
      LEFT JOIN BAANDB.TZNISA001301 znisa001 ON znisa002.T$NPTP$C = znisa001.T$NPTP$C
     INNER JOIN BAANDB.TTCMCS003301 tcmcs003 ON whwmd215.T$CWAR   = tcmcs003.T$CWAR
     INNER JOIN BAANDB.TZNINT001301 znint001 ON tcmcs003.T$COMP   = znint001.T$COMP$C
     INNER JOIN BAANDB.TTCCOM130301 tccom130 ON tcmcs003.T$CADR   = tccom130.T$CADR
     INNER JOIN BAANDB.TZNFMD001301 znfmd001 ON tccom130.T$FOVN$L = znfmd001.T$FOVN$C
LEFT OUTER JOIN BAANDB.TZNINH005301 zninh005 ON zninh005.t$cwar$c = whwmd215.t$cwar
                                            AND zninh005.t$item$c = whwmd215.t$item
                                            AND zninh005.t$rest$c = ' '
LEFT OUTER JOIN ( select whwmd217.t$item,
                         whwmd217.t$cwar,
                         case when (max(whwmd215.t$qhnd)) = 0 then 0
                         else round(sum(whwmd217.t$mauc$1) / (max(whwmd215.t$qhnd)), 4)
                         end mauc
                    from baandb.twhwmd217301 whwmd217
              inner join baandb.twhwmd215301 whwmd215
                      on whwmd215.t$cwar = whwmd217.t$cwar
                     and whwmd215.t$item = whwmd217.t$item
                group by whwmd217.t$item, whwmd217.t$cwar ) Q1
             ON Q1.t$item = whwmd215.t$item
            AND Q1.t$cwar = whwmd215.t$cwar

          WHERE NVL(znisa001.T$SIIT$C,0) <> 2 
            --AND whwmd215.t$cwar in ('A01200')  --Campo foi comentado pois estava limitado para o Armazen A01200
            AND tcibd001.t$kitm <> 2 
            AND znfmd001.T$FILI$C in (:Estabelecimento))
       GROUP BY ID_ITEM,
                ID_CIA,
                ESTABELECIMENTO,
                ARMAZEM,
                DESC_COMPLETA,
                DEPARTAMENTO,
                SETOR

      UNION ALL

   -- Estoque CrossDocking
         SELECT NVL(TRIM(est.T$ITEM$C), 0)                           AS ID_ITEM,
                int1.T$NCIA$C                                        AS ID_CIA,
                TO_NUMBER(est.T$CWAR$C)                              AS ESTABELECIMENTO,
                TO_CHAR(max(est.T$RCD_UTC), 'YYYY-MM-DD HH24:MI:SS') AS ULTIMAATUAL,
                ' '                                                  AS RESTRICAO,
                CASE WHEN dipu.PRAZO_NEW > est.T$PRIT$C
                       THEN dipu.PRAZO_NEW
                     ELSE   est.T$PRIT$C
                END                                                  AS PZ_DISP,
                sum(est.T$SALD$C)                                    AS SALDO,
		            ' '                                                  AS ARMAZEM,
                'CROSSDOCKING'                                       AS ORIGEM,
                clas1.T$NPTP$C                                       AS TIPOPRODUTO,
                MAX(Q1.mauc)                                         AS VL_CMV,
                item.t$dscb$c                                        AS DESC_COMPLETA,
                tcmcs023.t$dsca                                      AS DEPARTAMENTO,
                znmcs030.t$dsca$c                                        AS SETOR
           FROM BAANDB.TZNWMD200301 est
     INNER JOIN BAANDB.TTCIBD001301 item  ON est.T$ITEM$C = item.T$item
     INNER JOIN BAANDB.ttcmcs023301 tcmcs023 ON item.T$CITG  = tcmcs023.T$CITG
     INNER JOIN BAANDB.TZNMCS030301 znmcs030 ON item.T$CITG    = znmcs030.T$CITG$C
     AND  item.T$SETO$C = znmcs030.t$seto$c
     LEFT JOIN BAANDB.TZNISA002301 clas1 ON item.T$NPCL$C = clas1.T$NPCL$C
     LEFT JOIN BAANDB.TZNISA001301 clas2 ON clas1.T$NPTP$C = clas2.T$NPTP$C
     INNER JOIN BAANDB.TTCMCS003301 mcs   ON est.T$CWAR$C = mcs.T$CWAR
     INNER JOIN BAANDB.TZNINT001301 int1  ON mcs.T$COMP = int1.T$COMP$C
     INNER JOIN BAANDB.TTCCOM130301 com   ON mcs.T$CADR = com.T$CADR
      LEFT JOIN BAANDB.TZNFMD001301 fmd   ON com.T$FOVN$L = fmd.T$FOVN$C
      LEFT JOIN (SELECT T$ITEM AS ID_ITEM,
                        CASE WHEN T$SUTU = 10
                               THEN T$SUTI
                             ELSE   CAST(T$SUTI/24 AS NUMERIC(3))
                        END    AS PRAZO_NEW
                   FROM BAANDB.TTDIPU001301) dipu
             ON est.T$ITEM$C = dipu.ID_ITEM
LEFT OUTER JOIN ( select whwmd217.t$item,
                         whwmd217.t$cwar,
                         case when (max(whwmd215.t$qhnd)) = 0 then 0
                         else round(sum(whwmd217.t$mauc$1) / (max(whwmd215.t$qhnd)), 4)
                         end mauc
                    from baandb.twhwmd217301 whwmd217
              inner join baandb.twhwmd215301 whwmd215
                      on whwmd215.t$cwar = whwmd217.t$cwar
                     and whwmd215.t$item = whwmd217.t$item
                group by whwmd217.t$item, whwmd217.t$cwar ) Q1
             ON Q1.t$item = est.t$item$c
            AND Q1.t$cwar = est.t$cwar$c

          WHERE Nvl(clas2.T$SIIT$C,0) <> 2
            AND item.t$kitm <> 2
    	    AND est.t$eina$c = 2
			AND TO_NUMBER(est.T$CWAR$C)  in (:Estabelecimento)

       GROUP BY NVL(TRIM(est.T$ITEM$C), 0),
                int1.T$NCIA$C,
                ITEM.t$dscb$c,
                tcmcs023.t$dsca,
                znmcs030.t$dsca$c,      
                TO_NUMBER(est.T$CWAR$C),
                CASE WHEN dipu.PRAZO_NEW > est.T$PRIT$C
                       THEN dipu.PRAZO_NEW
                	    ELSE  est.T$PRIT$C
                END,
                'CROSSDOCKING',
                clas1.T$NPTP$C
       ORDER BY ULTIMAATUAL DESC
