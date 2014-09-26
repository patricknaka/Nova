SELECT
   tcemm030.t$euca       NUME_FILIAL,
   tcemm030.T$EUNT       CHAVE_FILIAL,
   tccom130b.t$fovn$l    CNPJ_FILIAL,
   
   znsls401.t$entr$c     NUME_OV,
   znsls401.t$orno$c     NUME_OV_LN,
   znsls401.t$sequ$c     NUME_ITEM,
   znsls400.t$pecl$c     NUME_PEDIDO,
   znsls401.t$ufen$c     UF,
   znsls401.t$idor$c     ORIGEM,
   znsls401.t$dtap$c     DATA_APR, 
   tdsls400.t$ddat       DATA_PLANENT,   
   tdsls400.t$prdt       DATA_PLANREC,   
   
   CASE WHEN znsls401.t$tpes$c = 'X' THEN 'Crossdocking'
        WHEN znsls401.t$tpes$c = 'F' THEN 'Fingido'
        WHEN znsls401.t$tpes$c = 'P' THEN 'Pré-Venda'
        ELSE 'NORMAL' 
      END                TIPO_ESTOQ,
    
   znsls400.t$dtem$c     DATA_ORDEM,
   Trim(tdsls401.t$item) CODE_ITEM,
   tcibd001.t$dsca       DECR_ITEM,
   tdipu001.t$suti       TEMP_REPOS,
   znsls401.t$qtve$c     QUAN_ORD,
   whinp200.t$qoqu       QUAN_ALOC,
   
   CASE WHEN whinp200.t$qoqu -(tcibd100.t$blck+tcibd100.t$allo)-tcibd100.t$stoc< = 0 THEN 0
        ELSE whinp200.t$qoqu -(tcibd100.t$blck+tcibd100.t$allo)-tcibd100.t$stoc 
      END                QUAN_FALT,
    
   tcibd100.t$ordr       QUAN_EMPED,
   tttxt010.t$text       TEXT_ORD,
   tccom130.t$fovn$l     CNPJ_FORN,
   tccom130.t$nama       NOME_FORNEC,
   
   ( select sum(a.t$tamt$l) 
       from baandb.tbrmcs941301 a, 
            baandb.tbrmcs940301 b 
      where a.t$txre$l = b.t$txre$l 
        and a.t$txre$l = tdsls401.t$txre$l 
        and a.t$line$l = tdsls401.t$txli$l 
        and b.t$txor$l = 2 ) 
                         VALO_PREVIMP,

   ( select case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)) = 0 then 0
                 else round(sum(a.t$mauc$1) /(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
             end mauc
       from baandb.twhwmd217301 a,
            baandb.ttcemm112301 tcemm112,
            baandb.twhwmd215301 whwmd215
      where tcemm112.t$waid = a.t$cwar
        AND tcemm112.t$loco = 201
        AND whwmd215.t$cwar = a.t$cwar
        AND whwmd215.t$item = a.t$item
        AND a.t$item = tdsls401.t$item
        AND tcemm112.t$grid = tcemm124.t$grid
   group by a.t$item,
            tcemm112.t$grid) 
                         VALOR_CMV_UNITARIO,
                                   
   znsls400.t$idli$c     CODE_LISTA,
   tcmcs023.t$dsca       NOME_DEPART,
   znsls401.t$itpe$c     COD_TIPO_ENTREGA,
   znint002.t$uneg$c     CODE_UNIDADE_NEGOCIO,
   tcmcs031.t$dsca       NOME_RAMOATV,
   znsls400.t$nomf$c     NOME_COBR,
   znsls400.t$emaf$c     EMAIL,
   znsls002.t$dsca$c     DECR_TIPO_ENTREGA,
   iTIPOXD.DESCR         DESCR_XD
  
FROM      baandb.tznsls400301 znsls400

INNER JOIN baandb.tznsls401301 znsls401
        ON znsls400.t$ncia$c = znsls401.t$ncia$c 
       AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls400.t$pecl$c = znsls401.T$pecl$c 
       AND znsls400.t$sqpd$c = znsls401.T$sqpd$c
    
INNER JOIN baandb.ttdsls400301 tdsls400 
        ON znsls401.t$orno$c = tdsls400.t$orno

 LEFT JOIN baandb.ttttxt010301 tttxt010 
        ON tttxt010.t$ctxt = tdsls400.t$txta
       AND tttxt010.t$seqe = 1  

INNER JOIN baandb.ttdsls401301 tdsls401
        ON znsls401.t$orno$c = tdsls401.t$orno 
       AND znsls401.t$pono$c = tdsls401.t$pono

 LEFT JOIN baandb.tznwmd200301 znwmd200
        ON znwmd200.t$item$c = tdsls401.t$item
       AND znwmd200.t$cwar$c = tdsls401.t$cwar          
       AND znwmd200.t$supl$c = tdsls401.T$ofbp
      
 LEFT JOIN baandb.twhinp200301 whinp200
        ON whinp200.t$oorg = 3
       AND whinp200.t$orno = tdsls401.t$orno
       AND whinp200.t$pono = tdsls401.t$pono
       AND whinp200.t$serb = tdsls401.t$sqnb
       AND whinp200.t$item = tdsls401.t$item

INNER JOIN baandb.ttcibd001301 tcibd001
        ON tcibd001.t$item = tdsls401.t$item

 LEFT JOIN baandb.ttdipu001301 tdipu001
        ON tdipu001.t$item = tcibd001.t$item
 
 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tdipu001.t$otbp
       
INNER JOIN baandb.ttcibd100301 tcibd100
        ON tcibd100.t$item = tcibd001.t$item

INNER JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg

INNER JOIN baandb.twhinp100301 whinp100
        ON whinp100.t$item = tdsls401.t$item 
       AND whinp100.t$orno = tdsls401.t$orno

INNER JOIN baandb.tznsls004301 znsls004
        ON znsls004.t$ncia$c = znsls401.t$ncia$c 
       AND znsls004.t$uneg$c = znsls401.T$UNEG$c 
       AND znsls004.t$pecl$c = znsls401.T$pecl$c 
       AND znsls004.t$sqpd$c = znsls401.T$sqpd$c 
       AND znsls004.t$orno$c = znsls401.T$orno$c
       AND znsls004.t$pono$c = znsls401.T$pono$c
      
INNER JOIN baandb.ttcemm124301 tcemm124
        ON tcemm124.t$cwoc = tdsls400.t$cofc

INNER JOIN baandb.ttcemm122301 tcemm122
        ON tcemm122.t$grid = tcemm124.t$grid

INNER JOIN baandb.ttccom100301 tccom100b
        ON tccom100b.t$bpid = tcemm122.t$bupa
      
INNER JOIN baandb.ttccom130301 tccom130b
        ON tccom130b.t$cadr = tccom100b.t$cadr
      
INNER JOIN baandb.ttcemm030301 tcemm030
        ON tcemm030.t$eunt = tcemm124.t$grid
      
INNER JOIN baandb.ttcmcs031301 tcmcs031
        ON tcmcs031.t$cbrn = tdsls400.T$CBRN
      
INNER JOIN baandb.tznint002301 znint002
        ON znint002.t$uneg$c = znsls400.t$uneg$c
       AND znint002.t$ncia$c = znsls400.t$ncia$c
      
INNER JOIN baandb.tznsls002301 znsls002
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
    
WHERE tcemm124.t$dtyp = 1 
  AND whinp100.t$koor = 3 
  AND whinp100.t$kotr = 2 
  
  AND Trunc(tdsls400.t$ddat) Between NVL(:DataEntregaDe, tdsls400.t$ddat) and  NVL(:DataEntregaAte, tdsls400.t$ddat)
  AND Trunc(tdsls400.t$prdt) Between NVL(:DataRecebeDe, tdsls400.t$prdt) and  NVL(:DataRecebeAte, tdsls400.t$prdt)
  AND tcemm030.T$EUNT IN (:Filial)
  AND Trim(tcmcs023.t$citg) IN (:Depto)