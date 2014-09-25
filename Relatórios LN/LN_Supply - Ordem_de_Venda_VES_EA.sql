SELECT
   tcemm030.t$euca       NUME_FILIAL,
   tcemm030.T$EUNT       CHAVE_FILIAL,
   tccom130b.t$fovn$l    CNPJ_FILIAL,
   
   znsls401.t$entr$c     NUME_OV,
   znsls401.t$orno$c     NUME_OV_LN,
   znsls401.t$sequ$c     NUME_ITEM,
   znsls401.t$ufen$c     UF,
   znsls401.t$idor$c     ORIGEM,
   znsls401.t$dtap$c     DATA_APR, 
   tdsls400.t$ddat       DATA_PLANENT,   
   tdsls400.t$prdt       DATA_PLANREC,   
   
   CASE WHEN znsls401.t$tpes$c='X' THEN 'Crossdocking'
        WHEN znsls401.t$tpes$c='F' THEN 'Fingido'
        WHEN znsls401.t$tpes$c='P' THEN 'Pré-Venda'
        ELSE 'NORMAL' 
      END                TIPO_ESTOQ,
	  
   znsls400.t$dtem$c     DATA_ORDEM,
   Trim(tdsls401.t$item) CODE_ITEM,
   tcibd001.t$dsca       DECR_ITEM,
   tdipu001.t$suti       TEMP_REPOS,
   znsls401.t$qtve$c     QUAN_ORD,
   whinp200.t$qoqu       QUAN_ALOC,
   
   CASE WHEN whinp200.t$qoqu -(tcibd100.t$blck+tcibd100.t$allo)-tcibd100.t$stoc<=0 THEN 0
        ELSE whinp200.t$qoqu -(tcibd100.t$blck+tcibd100.t$allo)-tcibd100.t$stoc 
      END                QUAN_FALT,
	  
   tcibd100.t$ordr       QUAN_EMPED,
   tttxt010.t$text       TEXT_ORD,
   tccom130.t$fovn$l     CNPJ_FORN,
   tccom130.t$nama       NOME_FORNEC,
   
   ( select sum(a.t$tamt$l) 
       from baandb.tbrmcs941201 a, 
            baandb.tbrmcs940201 b 
      where a.t$txre$l=b.t$txre$l 
        and a.t$txre$l=tdsls401.t$txre$l 
        and a.t$line$l=tdsls401.t$txli$l 
        and b.t$txor$l=2 ) 
                         VALO_PREVIMP,

   ( select case when (max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd))=0 then 0
                 else round(sum(a.t$mauc$1) /(max(whwmd215.t$qhnd) - max(whwmd215.t$qchd) - max(whwmd215.t$qnhd)),4) 
             end mauc
       from baandb.twhwmd217201 a,
            baandb.ttcemm112201 tcemm112,
            baandb.twhwmd215201 whwmd215
      where tcemm112.t$waid=a.t$cwar
        AND tcemm112.t$loco=201
        AND whwmd215.t$cwar=a.t$cwar
        AND whwmd215.t$item=a.t$item
        AND a.t$item=tdsls401.t$item
        AND tcemm112.t$grid=tcemm124.t$grid
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
  
FROM      baandb.tznsls400201 znsls400,
          baandb.tznsls401201 znsls401,
          baandb.ttdsls400201 tdsls400 
          
LEFT JOIN baandb.ttttxt010101 tttxt010 
       ON tttxt010.t$ctxt = tdsls400.t$txta, 

          baandb.ttdsls401201 tdsls401

LEFT JOIN baandb.tznwmd200201 znwmd200
       ON znwmd200.t$item$c = tdsls401.t$item
      AND znwmd200.t$cwar$c = tdsls401.t$cwar          
      AND znwmd200.t$supl$c = tdsls401.T$ofbp
     
LEFT JOIN baandb.twhinp200201 whinp200
       ON whinp200.t$oorg = 3
      AND whinp200.t$orno = tdsls401.t$orno
      AND whinp200.t$pono = tdsls401.t$pono
      AND whinp200.t$serb = tdsls401.t$sqnb
      AND whinp200.t$item = tdsls401.t$item,

          baandb.ttcibd001201 tcibd001 

LEFT JOIN baandb.ttdipu001201 tdipu001
       ON tdipu001.t$item = tcibd001.t$item

LEFT JOIN baandb.ttccom130201 tccom130
       ON tccom130.t$cadr = tdipu001.t$otbp, 
       
          baandb.ttcibd100201 tcibd100,
          baandb.ttcmcs023201 tcmcs023,
          baandb.twhinp100201 whinp100,      
          baandb.tznsls004201 znsls004,
          baandb.ttcemm124201 tcemm124, 
          baandb.ttcemm122201 tcemm122,
          baandb.ttccom100201 tccom100b,
          baandb.ttccom130201 tccom130b,
          baandb.ttcemm030201 tcemm030,
          baandb.ttcmcs031201 tcmcs031,
          baandb.tznint002201 znint002,
          baandb.tznsls002201 znsls002,
  
( SELECT d.t$cnst CODE,
         l.t$desc DESCR
    FROM baandb.tttadv401000 d,
         baandb.tttadv140000 l
   WHERE d.t$cpac='zn'
     AND d.t$cdom='ipu.ixdn.c'
     AND d.t$vers='B61U'
     AND d.t$rele='a7'
     AND d.t$cust='npt0'
     AND l.t$clab=d.t$za_clab
     AND l.t$clan='p'
     AND l.t$cpac='zn'
     AND l.t$vers=( select max(l1.t$vers)
                      from baandb.tttadv140000 l1 
                     where l1.t$clab=l.t$clab 
                  AND l1.t$clan=l.t$clan 
                  AND l1.t$cpac=l.t$cpac)) iTIPOXD
    
WHERE znsls400.t$ncia$c = znsls401.t$ncia$c 
  AND znsls400.t$uneg$c = znsls401.T$UNEG$c 
  AND znsls400.t$pecl$c = znsls401.T$pecl$c 
  AND znsls400.t$sqpd$c = znsls401.T$sqpd$c
  AND znsls401.t$orno$c = tdsls401.t$orno 
  AND znsls401.t$pono$c = tdsls401.t$pono
  AND znsls401.t$orno$c = tdsls400.t$orno
  AND znsls004.t$ncia$c = znsls401.t$ncia$c 
  AND znsls004.t$uneg$c = znsls401.T$UNEG$c 
  AND znsls004.t$pecl$c = znsls401.T$pecl$c 
  AND znsls004.t$sqpd$c = znsls401.T$sqpd$c 
  AND znsls004.t$orno$c = znsls401.T$orno$c
  AND znsls004.t$pono$c = znsls401.T$pono$c
  AND tcibd001.t$item = tdsls401.t$item
  AND tcemm124.t$cwoc = tdsls400.t$cofc
  AND tcemm122.t$grid = tcemm124.t$grid
  AND tccom100b.t$bpid=tcemm122.t$bupa
  AND tccom130b.t$cadr=tccom100b.t$cadr
  AND tcemm124.t$dtyp = 1 
  AND tcemm030.t$eunt = tcemm124.t$grid
  AND tcibd100.t$item = tcibd001.t$item
  AND whinp100.t$koor = 3 
  AND whinp100.t$kotr = 2 
  AND whinp100.t$item = tdsls401.t$item 
  AND whinp100.t$orno = tdsls401.t$orno
  AND tcmcs023.t$citg = tcibd001.t$citg
  AND tcmcs031.t$cbrn = tdsls400.T$CBRN
  AND znsls002.t$tpen$c = znsls401.t$itpe$c
  AND iTIPOXD.CODE = tdipu001.t$ixdn$c
  AND znint002.t$uneg$c = znsls400.t$uneg$c
  AND znint002.t$ncia$c = znsls400.t$ncia$c
  
  
  AND Trunc(tdsls400.t$ddat) Between NVL(:DataEntregaDe, tdsls400.t$ddat) and  NVL(:DataEntregaAte, tdsls400.t$ddat)
  AND Trunc(tdsls400.t$prdt) Between NVL(:DataRecebeDe, tdsls400.t$prdt) and  NVL(:DataRecebeAte, tdsls400.t$prdt)
  AND tcemm030.T$EUNT IN (:Filial)
  AND Trim(tcmcs023.t$citg) IN (:Depto)