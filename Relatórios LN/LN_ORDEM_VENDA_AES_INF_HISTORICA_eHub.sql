
 SELECT    
   DISTINCT    
     tcemm030.t$dsca                NUME_FILIAL,    
     tcemm030.T$EUNT                CHAVE_FILIAL,    
     tccom130b.t$fovn$l             CNPJ_FILIAL,    
     znsls401.t$entr$c              NUME_PEDIDO_ENTREGA,    
     znsls401.t$orno$c              NUME_OV_LN,    
 	CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                    DATA_INTEGRACAO_LN,    
     znsls401.t$pono$c              POSI_OV_LN,    
     znsls401.t$sequ$c              NUME_ITEM,    
     znsls400.t$pecl$c              NUME_PEDIDO,    
     znsls401.t$ufen$c              UF,    
     znsls401.t$idor$c              ORIGEM,    
    
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtap$c,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                    DATA_APROVACAO,    
    
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                    DATA_ENTR_PLANEJ,    
    
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                    DATA_PLANEJ_RECEB,    
                                    
    case when tdisa001.t$dtla$c > to_date('01-01-1970') and
              PONTO_AES.t$dtoc$c < tdisa001.t$dtla$c and
              BLOQUEIO_WA.t$bloc is null and
              BLOQUEIO_WR.t$bloc is null and 
              BLOQUEIO_WR.t$bloc is null then
      'Pre-venda'
    else 
        case when BLOQUEIO_WA.t$bloc is not null or 
                  BLOQUEIO_WR.t$bloc is not null or
                  BLOQUEIO_WT.t$bloc is not null then
            'BLOQUEIO POR ' || BLOQUEIO_WA.t$bloc || ', ' || BLOQUEIO_WR.t$bloc || ', ' || BLOQUEIO_WT.t$bloc
        end
    end
                                    TIPO_ESTOQUE,  
                                    
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,    
       'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
         AT time zone 'America/Sao_Paulo') AS DATE)    
                                    DATA_EMISSAO,    
    
     Trim(tdsls401.t$item)          CODE_ITEM,    
     tcibd001.t$dsca                DECR_ITEM,    
     znsls401.t$pzfo$c              TEMP_REPOS,    
     znsls401.t$qtve$c              QUAN_ORD,    
    
     case when tdsls420.t$orno is null then    
           znsls401.t$qtve$c    
     else  0.0 end                  QUAN_RESERVADO,    
    
     case when tdsls420.t$orno is null then    
           0.0    
     else  znsls401.t$qtve$c end    
                                    QUAN_FALT,     
    
     nvl(whwmd215.t$qord,0)         QUAN_EM_PED,    
    
     nvl(whwmd215.t$qhnd,0)         QUAN_DISPONIVEL,    
     nvl(whwmd215.t$qblk,0)         QUAN_BLOQUEADO,    
     nvl(whwmd215.t$qall,0)         QUAN_ALOCADO,    
     nvl(whwmd215.t$qlal,0)         QUAN_LOCAL_ALOCADO,    
    
     nvl(whwmd215.t$qhnd,0) - nvl(whwmd215.t$qblk,0) - nvl(whwmd215.t$qall,0)    
                                    SALDO,    
    
     tttxt010.t$text                TEXT_ORD,    
     tccom130.t$fovn$l              CNPJ_FORN,    
     tccom130.t$nama                NOME_FORNEC,    
    
     znsls401.t$vlun$c              PREÇO_UNIT,   
    
     ( select case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)) = 0    
                     then 0    
                   else   round(sum(a.t$mauc$1) /(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4)    
               end mauc    
         from baandb.twhwmd217601   a    
   inner join baandb.ttcemm112601   tcemm112    
           on tcemm112.t$waid = a.t$cwar    
   inner join baandb.twhwmd215601   whwmd215    
           on whwmd215.t$cwar = a.t$cwar    
          and whwmd215.t$item = a.t$item    
        where tcemm112.t$loco = 301    
          and a.t$item = tdsls401.t$item    
          and tcemm112.t$grid = tcemm124.t$grid    
     group by a.t$item,    
              tcemm112.t$grid)    
                                    VALOR_CMV_UNITARIO,    
    
     znsls400.t$idli$c              CODE_LISTA,    
     tcmcs023.t$dsca                NOME_DEPART,    
     znsls401.t$itpe$c              COD_TIPO_ENTREGA,    
     znint002.t$uneg$c              CODE_UNIDADE_NEGOCIO,    
     tcmcs031.t$dsca                NOME_UNIDADE_NEGOCIO,    
     znsls400.t$nomf$c              NOME_COBR,    
     znsls400.t$emaf$c              EMAIL,    
     znsls400.t$telf$c              TEL_RESIDENCIAL,    
     znsls400.t$te1f$c              TEL_CELULAR,    
     znsls400.t$te2f$c              TEL_COMERCIAL,
     znsls002.t$dsca$c              DECR_TIPO_ENTREGA,    
     iTIPOXD.DESCR                  DESCR_XD,    
     ULT_PONTO.t$poco$c             COD_ULT_PONTO,    
     znmcs002.t$desc$c              DESCR_ULT_PONTO,    
    
     (SELECT zncmg007.t$desc$c Pag    
             FROM baandb.tznsls402601   znsls402_S    
             INNER JOIN baandb.tzncmg007601   zncmg007    
               on zncmg007.t$mpgt$c = znsls402_S.T$IDMP$C    
             WHERE 	znsls402_S.t$ncia$c = znsls400.t$ncia$c    
             AND	znsls402_S.t$uneg$c = znsls400.t$uneg$c    
             AND 	znsls402_S.t$pecl$c = znsls400.t$pecl$c    
             AND znsls402_S.T$SQPD$C = 1    
             AND rownum = 1)        MEIO_PAG1,    
    
     (SELECT zncmg007.t$desc$c Pag    
             FROM baandb.tznsls402601   znsls402_S    
             INNER JOIN baandb.tzncmg007601   zncmg007    
               on zncmg007.t$mpgt$c = znsls402_S.T$IDMP$C    
             WHERE 	znsls402_S.t$ncia$c = znsls400.t$ncia$c    
             AND	znsls402_S.t$uneg$c = znsls400.t$uneg$c    
             AND 	znsls402_S.t$pecl$c = znsls400.t$pecl$c    
             AND znsls402_S.T$SQPD$C = 2    
             AND rownum = 1)        MEIO_PAG2,    
     PONTO_AES.t$poco$c             PONTO_AES,  
     CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(PONTO_AES.t$dtoc$c,      
     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')     
     AT time zone 'America/Sao_Paulo') AS DATE)  
                                    DATA_PONTO_AES  
    
 FROM       baandb.tznsls400601   znsls400    
    
 INNER JOIN baandb.tznsls401601   znsls401    
         ON znsls400.t$ncia$c = znsls401.t$ncia$c    
        AND znsls400.t$uneg$c = znsls401.T$UNEG$c    
        AND znsls400.t$pecl$c = znsls401.T$pecl$c    
        AND znsls400.t$sqpd$c = znsls401.T$sqpd$c    
    
 INNER JOIN baandb.ttdsls400601   tdsls400    
         ON znsls401.t$orno$c = tdsls400.t$orno    
    
	 LEFT JOIN ( select znsls410.t$ncia$c,  
                      znsls410.t$uneg$c,  
                      znsls410.t$pecl$c,  
                      znsls410.t$entr$c,  
                      znsls410.t$sqpd$c,  
                      max(znsls410.t$dtoc$c) t$dtoc$c,  
                      MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) t$poco$c  
                from BAANDB.tznsls410601   znsls410    
                group by znsls410.t$ncia$c,  
                         znsls410.t$uneg$c,  
                         znsls410.t$pecl$c,  
                         znsls410.t$entr$c,  
                         znsls410.t$sqpd$c ) ULT_PONTO  
            ON ULT_PONTO.t$ncia$c = znsls401.t$ncia$c  
           AND ULT_PONTO.t$uneg$c = znsls401.t$uneg$c  
           AND ULT_PONTO.t$pecl$c = znsls401.t$pecl$c  
           AND ULT_PONTO.t$sqpd$c = znsls401.t$sqpd$c  
           AND ULT_PONTO.t$entr$c = znsls401.t$entr$c  
    
  LEFT JOIN baandb.tznmcs002301 znmcs002    
         ON znmcs002.t$poco$c = ULT_PONTO.t$poco$c    
    
  LEFT JOIN baandb.ttttxt010301 tttxt010    
         ON tttxt010.t$ctxt = tdsls400.t$txta    
        AND tttxt010.t$seqe = 1    
    
 INNER JOIN baandb.ttdsls401601   tdsls401    
         ON tdsls401.t$orno = znsls401.t$orno$c    
        AND tdsls401.t$pono = znsls401.t$pono$c    
    
 LEFT JOIN (  select a.t$orno,    
                      a.t$pono    
               from baandb.ttdsls420601   a    
               where a.t$hrea = 'AES'    
               group by a.t$orno,    
                        a.t$pono ) tdsls420    
         ON tdsls420.t$orno = tdsls401.t$orno    
        AND tdsls420.t$pono = tdsls401.t$pono    
    
  LEFT JOIN baandb.twhwmd215601   whwmd215    
         ON whwmd215.t$cwar = tdsls401.t$cwar    
        AND whwmd215.t$item = tdsls401.t$item    
    
  LEFT JOIN ( SELECT sum(pur401.t$qoor-pur401.t$qidl) oqua,    
                     pur401.t$item,    
                     pur401.t$cwar    
                from baandb.ttdpur401601   pur401    
               where pur401.t$fire = 2    
            group by pur401.t$item,    
                     pur401.t$cwar ) tdpur401    
         ON tdpur401.t$item = tdsls401.t$item    
        AND tdpur401.t$cwar = tdsls401.t$cwar    
    
 INNER JOIN baandb.ttcibd001601   tcibd001    
         ON tcibd001.t$item = tdsls401.t$item    
    
  LEFT JOIN baandb.ttdipu001601   tdipu001    
         ON tdipu001.t$item = tcibd001.t$item    
    
 INNER JOIN baandb.ttccom100601   tccom100    
         ON tccom100.t$bpid = tdipu001.t$otbp    
    
  LEFT JOIN baandb.ttccom130601   tccom130    
         ON tccom130.t$cadr = tccom100.t$cadr    
    
 INNER JOIN baandb.ttcmcs023601   tcmcs023    
         ON tcmcs023.t$citg = tcibd001.t$citg    
    
 LEFT JOIN baandb.twhinp100601   whinp100         --era INNER
         ON whinp100.t$item = tdsls401.t$item    
        AND whinp100.t$orno = tdsls401.t$orno    
    
 INNER JOIN baandb.tznsls004601   znsls004    
         ON znsls004.t$ncia$c = znsls401.t$ncia$c    
        AND znsls004.t$uneg$c = znsls401.T$UNEG$c    
        AND znsls004.t$pecl$c = znsls401.T$pecl$c    
        AND znsls004.t$sqpd$c = znsls401.T$sqpd$c    
        AND znsls004.t$orno$c = znsls401.T$orno$c    
        AND znsls004.t$pono$c = znsls401.T$pono$c    
    
 INNER JOIN baandb.ttcemm124601   tcemm124    
         ON tcemm124.t$cwoc = tdsls400.t$cofc    
    
 INNER JOIN baandb.ttcemm122601   tcemm122    
         ON tcemm122.t$grid = tcemm124.t$grid    
    
 INNER JOIN baandb.ttccom100601   tccom100b    
         ON tccom100b.t$bpid = tcemm122.t$bupa    
    
 INNER JOIN baandb.ttccom130601   tccom130b    
         ON tccom130b.t$cadr = tccom100b.t$cadr    
    
 INNER JOIN baandb.ttcemm030601   tcemm030    
         ON tcemm030.t$eunt = tcemm124.t$grid    
    
 INNER JOIN baandb.ttcmcs031301 tcmcs031    
         ON tcmcs031.t$cbrn = tdsls400.T$CBRN    
    
 INNER JOIN baandb.tznint002601   znint002    
         ON znint002.t$uneg$c = znsls400.t$uneg$c    
        AND znint002.t$ncia$c = znsls400.t$ncia$c    
    
  LEFT JOIN baandb.tznsls002601   znsls002    
         ON znsls002.t$tpen$c = znsls401.t$itpe$c    
    
  LEFT JOIN( SELECT d.t$cnst CODE,    
                    l.t$desc DESCR    
               FROM baandb.tttadv401000 d,    
                    baandb.tttadv140000 l    
              WHERE d.t$cpac = 'zn'    
                AND d.t$cdom = 'ipu.ixdn.c'    
                AND l.t$clan = 'p'    
                AND l.t$cpac = 'zn'    
                AND l.t$clab = d.t$za_clab    
                AND rpad(d.t$vers,4) ||    
                    rpad(d.t$rele,2) ||    
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||    
                                                    rpad(l1.t$rele,2) ||    
                                                    rpad(l1.t$cust,4) )    
                                           from baandb.tttadv401000 l1    
                                          where l1.t$cpac = d.t$cpac    
                                            and l1.t$cdom = d.t$cdom )    
                AND rpad(l.t$vers,4) ||    
                    rpad(l.t$rele,2) ||    
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||    
                                                    rpad(l1.t$rele,2) ||    
                                                    rpad(l1.t$cust,4) )    
                                           from baandb.tttadv140000 l1    
                                          where l1.t$clab = l.t$clab    
                                            and l1.t$clan = l.t$clan    
                                            and l1.t$cpac = l.t$cpac ) ) iTIPOXD    
         ON iTIPOXD.CODE = tdipu001.t$ixdn$c    

 LEFT JOIN baandb.tznint410601 znint410
        ON znint410.t$tipe$c = znsls401.t$tpes$c

 INNER JOIN ( select    znsls410.t$ncia$c,  
                        znsls410.t$uneg$c,  
                        znsls410.t$pecl$c,  
                        znsls410.t$entr$c,  
                        znsls410.t$sqpd$c,  
                        znsls410.t$dtoc$c,   
                        znsls410.t$poco$c   
              from BAANDB.tznsls410601   znsls410    
              where znsls410.t$poco$c = 'AES'
              group by znsls410.t$ncia$c,  
                       znsls410.t$uneg$c,  
                       znsls410.t$pecl$c,  
                       znsls410.t$entr$c,  
                       znsls410.t$sqpd$c,
                       znsls410.t$dtoc$c,
                       znsls410.t$poco$c ) PONTO_AES  
            ON PONTO_AES.t$ncia$c = znsls401.t$ncia$c  
           AND PONTO_AES.t$uneg$c = znsls401.t$uneg$c  
           AND PONTO_AES.t$pecl$c = znsls401.t$pecl$c  
           AND PONTO_AES.t$sqpd$c = znsls401.t$sqpd$c  
           AND PONTO_AES.t$entr$c = znsls401.t$entr$c  

 LEFT JOIN baandb.ttdisa001601 tdisa001
        ON tdisa001.t$item = tcibd001.t$item
        
 LEFT JOIN (  select  distinct
                      a.t$cwar,
                      a.t$item,
                      a.t$bloc
              from baandb.twhwmd630601 a
              where a.t$bloc = 'WA') BLOQUEIO_WA
        ON BLOQUEIO_WA.t$cwar = tdsls401.t$cwar
       AND BLOQUEIO_WA.t$item = tdsls401.t$item

 LEFT JOIN (  select  distinct
                      a.t$cwar,
                      a.t$item,
                      a.t$bloc
              from baandb.twhwmd630601 a
              where a.t$bloc = 'WR') BLOQUEIO_WR
        ON BLOQUEIO_WR.t$cwar = tdsls401.t$cwar
       AND BLOQUEIO_WR.t$item = tdsls401.t$item

 LEFT JOIN (  select  distinct
                      a.t$cwar,
                      a.t$item,
                      a.t$bloc
              from baandb.twhwmd630601 a
              where a.t$bloc = 'WT') BLOQUEIO_WT
        ON BLOQUEIO_WT.t$cwar = tdsls401.t$cwar
       AND BLOQUEIO_WT.t$item = tdsls401.t$item       
       
 WHERE tcemm124.t$dtyp = 1    
   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat,    
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                 AT time zone 'America/Sao_Paulo') AS DATE))    
       Between NVL(:DataEntregaDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat,    
                                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                                        AT time zone 'America/Sao_Paulo') AS DATE))    
           And NVL(:DataEntregaAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$ddat,    
                                      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                                        AT time zone 'America/Sao_Paulo') AS DATE))    
   AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,    
               'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                 AT time zone 'America/Sao_Paulo') AS DATE))    
       Between NVL(:DataRecebeDe,  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,    
                                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                                       AT time zone 'America/Sao_Paulo') AS DATE))    
           And NVL(:DataRecebeAte, CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.t$prdt,    
                                     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')    
                                       AT time zone 'America/Sao_Paulo') AS DATE))    
   AND Trim(tcmcs023.t$citg) IN (:Depto)    
   AND PONTO_AES.t$poco$c IN (:Status) 


    
 ORDER BY NUME_OV_LN,    
          POSI_OV_LN 
