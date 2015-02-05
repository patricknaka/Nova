  select
    nvl(trim(ID_ITEM), 0)    as ID_ITEM,
    znint001.t$ncia$c        as ID_CIA,
    znfmd001.t$fili$c        as ESTABELECIMENTO,
    MAX(ULTIMAATUAL)         as ULTIMAATUAL,
    ' '                      as RESTRICAO,
    0                        as PZ_DISP,
    sum(SCE_QAVA - LN_QOOR)  as SALDO,
    'NAO BLOQUEADO'          as ORIGEM,
    MAX(VL_CMV)              as VL_CMV
  from
        ( select  
            whwmd215.t$cwar  as LN_CWAR,
            tcibd001.t$item  as LN_ITEM,
            sceinv.sku       as SCE_SKU,
            sceinv.status,
            case
              when tcibd001.t$espe$c in (2, 3) then tibom010_kit.t$sitm
              when tcibd001_tik.t$espe$c = 4 then tcibd001_tik.t$item  --Tik
              else tcibd001.t$item
            end              as ID_ITEM,
            case
              when tcibd001.t$espe$c in (2, 3) then nvl(sceinv.qtyavailable, 0) * tibom010_kit.t$qana
                else nvl(sceinv.qtyavailable, 0)
            end              as SCE_QAVA,
			
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(whwmd215.t$rcd_utc, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE) 
                             as ULTIMAATUAL,
			
         Q1.mauc             as VL_CMV,

         ( select nvl(sum(tdsls401.t$qoor * tdsls401.t$cvqs), 0)
            from baandb.ttdsls401301 tdsls401
      inner join baandb.ttdsls420301 tdsls420 on tdsls420.t$orno = tdsls401.t$orno
      inner join baandb.ttdsls090301 tdsls090 on tdsls090.t$hrea = tdsls420.t$hrea
           where tdsls401.t$item = tcibd001.t$item
             and tdsls401.t$cwar = whwmd215.t$cwar
             and tdsls090.t$rest$c = 1 )                           
                             as LN_QOOR
         
      from            baandb.twhwmd215301 whwmd215
      left outer join WMWHSE5.VNOVAWEBSITEINVENTORY@DL_LN_WMS sceinv
                   on sceinv.sku = trim(whwmd215.t$item)
                  and sceinv.status = 'OK'
      left outer join baandb.ttcibd001301 tcibd001            
                   on tcibd001.t$item = whwmd215.t$item
      left outer join baandb.tznisa002301 znisa002            
                   on znisa002.t$npcl$c = tcibd001.t$npcl$c
      left outer join baandb.tznisa001301 znisa001            
                   on znisa001.t$nptp$c = znisa002.t$nptp$c
      left outer join baandb.ttibom010301 tibom010_comp       
                   on tibom010_comp.t$sitm = tcibd001.t$item
      left outer join baandb.ttcibd001301 tcibd001_comp_pai   
                   on tcibd001_comp_pai.t$item = tibom010_comp.t$mitm
      left outer join baandb.ttibom010301 tibom010_kit        
                   on tibom010_kit.t$mitm = tcibd001.t$item
      left outer join baandb.ttcibd001301 tcibd001_tik        
                        on tcibd001_tik.t$item = '         ' || sceinv.parentsku
          
      left outer join ( SELECT whwmd217.t$item,
                               whwmd217.t$cwar,
                               case when (max(whwmd215.t$qhnd)) = 0 then 0
                                    else round(sum(whwmd217.t$mauc$1) / (max(whwmd215.t$qhnd)), 4) 
                               end mauc
                          FROM baandb.twhwmd217301 whwmd217
                    INNER JOIN baandb.twhwmd215301 whwmd215
                            ON whwmd215.t$cwar = whwmd217.t$cwar
                           AND whwmd215.t$item = whwmd217.t$item
                      GROUP BY whwmd217.t$item, whwmd217.t$cwar) Q1 
                   on Q1.t$item = whwmd215.t$item 
                  and Q1.t$cwar = whwmd215.t$cwar
    
	where whwmd215.t$cwar = 'A01200'
      and nvl(znisa001.t$siit$c, 0) <> 2
      and tcibd001.t$kitm <> 2
      and ((tcibd001.t$espe$c in (1, 2, 3))-- Não aplicável, Kit ou Kit com NF
       or (tcibd001.t$espe$c = 6 and tcibd001_comp_pai.t$espe$c = 5)-- Minucioso
       or (tcibd001_tik.t$espe$c = 4))) --  Tik   
        
     inner join baandb.ttcmcs003301 tcmcs003   
             on tcmcs003.t$cwar = 'A01200'
     inner join baandb.tznint001301 znint001
             on znint001.t$comp$c = tcmcs003.t$comp
     inner join baandb.ttccom130301 tccom130
             on tccom130.t$cadr = tcmcs003.t$cadr 
     inner join baandb.tznfmd001301 znfmd001
             on znfmd001.t$fovn$c = tccom130.t$fovn$l
  group by
        ID_ITEM,
        znint001.t$ncia$c,
        znfmd001.t$fili$c
     
UNION 
  --ESTOQUE CROSSDOCKING
  SELECT  
    NVL(TRIM(est.T$ITEM$C), 0) AS ID_ITEM,  
    int1.T$NCIA$C              AS ID_CIA,  
    TO_NUMBER(est.T$CWAR$C)    AS ESTABELECIMENTO,  
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(est.t$rcd_utc), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone sessiontimezone) AS DATE) 
		                       AS ULTIMAATUAL,
    ' '                        AS RESTRICAO,  
    CASE  
      WHEN dipu.PRAZO_NEW > est.T$PRIT$C THEN  dipu.PRAZO_NEW   
      ELSE est.T$PRIT$C 
    END                        AS PZ_DISP,  
    est.T$SALD$C               AS SALDO,   
    'CROSSDOCKING'             AS ORIGEM,
    MAX(Q1.mauc)               AS VL_CMV     
  
  FROM         BAANDB.TZNWMD200301 est  
    INNER JOIN BAANDB.TTCIBD001301 item  
	        ON est.T$ITEM$C = item.T$item  
    LEFT  JOIN BAANDB.TZNISA002301 clas1 
	        ON item.T$NPCL$C = clas1.T$NPCL$C  
    LEFT  JOIN BAANDB.TZNISA001301 clas2 
	        ON clas1.T$NPTP$C = clas2.T$NPTP$C  
    INNER JOIN BAANDB.TTCMCS003301 mcs   
	        ON est.T$CWAR$C = mcs.T$CWAR  
    INNER JOIN BAANDB.TZNINT001301 int1  
	        ON mcs.T$COMP = int1.T$COMP$C  
    INNER JOIN BAANDB.TTCCOM130301 com   
	        ON mcs.T$CADR = com.T$CADR  
    LEFT  JOIN BAANDB.TZNFMD001301 fmd   
	        ON com.T$FOVN$L = fmd.T$FOVN$C  
    LEFT  JOIN (SELECT T$ITEM AS ID_ITEM,  
                       CASE 
                         WHEN T$SUTU = 10 THEN T$SUTI  
                         ELSE CAST(T$SUTI/24 AS NUMERIC(3))  
                        END   AS PRAZO_NEW  
                  FROM BAANDB.TTDIPU001301) dipu 
            ON est.T$ITEM$C = dipu.ID_ITEM
    
    LEFT JOIN ( select whwmd217.t$item,
                       whwmd217.t$cwar,
                       case when (max(whwmd215.t$qhnd)) = 0 then 0
                            else round(sum(whwmd217.t$mauc$1)/(max(whwmd215.t$qhnd)), 4) 
                       end mauc
                  from baandb.twhwmd217301 whwmd217
            inner join baandb.twhwmd215301 whwmd215
                    on whwmd215.t$cwar = whwmd217.t$cwar
                   and whwmd215.t$item = whwmd217.t$item
              group by whwmd217.t$item, 
                       whwmd217.t$cwar ) Q1 
           ON Q1.t$item = est.T$ITEM$C 
          AND Q1.t$cwar = est.T$CWAR$C
  WHERE 1=1  
    AND Nvl(clas2.T$SIIT$C,0) <> 2  
    AND item.t$kitm <> 2  
  group by
    NVL(TRIM(est.T$ITEM$C), 0),
    int1.T$NCIA$C,
    TO_NUMBER(est.T$CWAR$C),
    CASE  
      WHEN dipu.PRAZO_NEW > est.T$PRIT$C THEN  dipu.PRAZO_NEW   
      ELSE est.T$PRIT$C 
	END,
      est.T$SALD$C
  ORDER BY 2,3,4,1