SELECT 
  DISTINCT
    tfcmg101.t$btno               LOTE_PAGTO,                               --01
    tfcmg101.t$plan               DT_PLANEJADO_PAGTO,                       --02
    regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')
                                  CNPJ_PN,                                  --03
    tfcmg101.t$ifbp               COD_PN,                                   --04
    Trim(tccom100.t$nama)         PARCEIRO_NEGOCIOS,                        --05
    tfcmg101.t$adty               COD_CATEGORIA,                            --06
    CATEGORIA.DESCR               DSC_CATEGORIA,                            --07
    ACONSELHAMENTO.               DESCR_TIPO_ACONSELHAMENTO,                --08
    tfcmg002.t$desc               MOTIVO_PAGTO,                             --09
    tfcmg101.t$basu               CODE_CONTA_BANCO_PN,                      --10
    tccom125.t$brch               FILIAL_BANCARIA_BANCO_PN,                 --11
    tccom125.t$bano               CONTA_BANCARIA_BANCO_PN,                  --12
    tccom125.t$dacc$d             DIGITO_CONTA_BANCARIA_BANCO_PN,           --13
    tfcmg101.t$paym               METODO_PAGTO,                             --14
    tfcmg001.t$desc               RELACAO_BANCARIA,                         --15
    tfcmg101.t$amnt               VALOR_ADIANTAMENTO,                       --16
    tfcmg101.t$ptyp ||
    TO_CHAR(tfcmg101.t$pdoc)      DOCUMENTO_PAGAMENTO,                      --17
    ADIANTAMENTO.                 DT_EMISSAO,                               --18
    ADIANTAMENTO.                 VL_ADIANTADO,                             --19
    ADIANTAMENTO.BALC -
    NVL(ADIANTAMENTO.BALA,0)      VL_ADIANTADO_SALDO,                       --20
    TIPO_DOC.DESCR                TIPO_DOCUMENTO,                           --21
    PREST_CONTAS.TRANS ||
    TO_CHAR(PREST_CONTAS.DOCTO)   LINK_ADIANTAMETNO,                        --22
    PREST_CONTAS.PN               COD_PN_PREST_CONTAS,                      --23
    tccom130pt.t$fovn$l           CNPJ_PN_PREST_CONTAS,                     --24
    tccom100pt.t$nama             PN_PREST_CONTAS,                          --25
    TRANS_PREST_CONTAS.TRANS ||
    TRANS_PREST_CONTAS.DOCTO      TRANS_PREST_CONTAS,                       --26
    PREST_CONTAS.TIPO_DOC         TIPO_DOC_PREST_CONTAS,                    --27
    TIPO_DOCTO.DESCR              DSC_TIPO_DOC_PREST_CONTAS,                --28
    PREST_CONTAS.VALOR            VALOR_TRANS_PREST_CONTAS,                 --29
    PREST_CONTAS.BALC -
    NVL(PREST_CONTAS.BALA,0)      SALDO_TRANS_PREST_CONTAS,                 --30
    tfcmg101.t$refr               REFERENCIA,                               --31
    TRANS_PREST_CONTAS.DT_LINK    EMISSAO_LINK,                             --32
    tfgld011_LINK.t$desc          DESCRICAO_LINK,                           --33

    CASE WHEN GLD102.USUARIO IS NULL 
           THEN GLD106.USUARIO
         ELSE  GLD102.USUARIO 
     END                          ULT_MODIF,                                --34
    
    CASE WHEN GLD102.DT_ALT IS NULL 
           THEN GLD106.DT_ALT
         ELSE  GLD102.DT_ALT 
     END                          DATA_ULT_MOD,                             --35

    CASE WHEN TRIM(GLD102.HR_ALT) IS NULL AND TRIM(GLD106.HR_ALT) IS NOT NULL
           THEN TO_CHAR(TRUNC(GLD106.HR_ALT/3600),'FM9900') || ':' ||
                TO_CHAR(TRUNC(MOD(GLD106.HR_ALT,3600)/60),'FM00') || ':' ||
                TO_CHAR(MOD(GLD106.HR_ALT,60),'FM00')
         WHEN TRIM(GLD102.HR_ALT) IS NOT NULL       
           THEN TO_CHAR(TRUNC(GLD102.HR_ALT/3600),'FM9900') || ':' ||
                TO_CHAR(TRUNC(MOD(GLD102.HR_ALT,3600)/60),'FM00') || ':' ||
                TO_CHAR(MOD(GLD102.HR_ALT,60),'FM00')
         ELSE NULL
     END                          HORA_ULT_MOD                              --36
 
FROM       baandb.ttccom100201  tccom100

 LEFT JOIN baandb.ttccom130201  tccom130
        ON tccom130.t$cadr = tccom100.t$cadr
 
 LEFT JOIN baandb.ttfcmg101201  tfcmg101  
        ON tccom100.T$BPID = tfcmg101.t$ifbp
 
 LEFT JOIN baandb.ttccom125201 tccom125
        ON tccom125.t$ptbp = tfcmg101.t$ifbp
       AND tccom125.t$cban = tfcmg101.t$basu
 
 LEFT JOIN baandb.ttfcmg001201 tfcmg001 
        ON tfcmg001.t$bank = tfcmg101.t$bank
        
 LEFT JOIN baandb.ttfcmg002201 tfcmg002
        ON tfcmg002.t$reas = tfcmg101.t$reas
   
 LEFT JOIN ( select a.t$docd DT_EMISSAO,
                    a.t$tpay TP_DOCTO,
                    a.t$amnt VL_ADIANTADO,
                    a.t$balc BALC,
                    a.t$bala BALA,
                    a.t$ttyp,
                    a.t$ninv
               from baandb.ttfacp200201 a
              where a.t$tpay = 9 ) ADIANTAMENTO
        ON ADIANTAMENTO.t$ttyp = tfcmg101.t$ptyp
       AND ADIANTAMENTO.t$ninv = tfcmg101.t$pdoc
   
 LEFT JOIN ( select a.t$tdoc TRANS,
                    a.t$docn DOCTO,
                    a.t$ifbp PN,
                    a.t$tpay TIPO_DOC,
                    a.t$amnt VALOR,
                    a.t$balc BALC,
                    a.t$bala BALA,
                    a.t$ttyp,
                    a.t$ninv
               from baandb.ttfacp200201 a
              where a.t$tpay = 14 
                and a.t$amnt != 0 ) PREST_CONTAS
        ON PREST_CONTAS.t$ttyp = tfcmg101.t$ptyp
       AND PREST_CONTAS.t$ninv = tfcmg101.t$pdoc
       
 LEFT JOIN baandb.ttfgld011201 tfgld011_LINK
        ON tfgld011_LINK.t$ttyp = PREST_CONTAS.TRANS
 
 LEFT JOIN baandb.ttccom100201 tccom100pt        --PN de Prestação de Contas
        ON tccom100pt.t$bpid = PREST_CONTAS.PN
        
 LEFT JOIN baandb.ttccom130201 tccom130pt    
        ON tccom130pt.t$cadr = tccom100pt.t$cadr 
 
 LEFT JOIN ( select a.t$ttyp TRANS,
                    a.t$ninv DOCTO,
                    a.t$docd DT_LINK,
                    a.t$tdoc,
                    a.t$docn
               from baandb.ttfacp200201 a
              where a.t$tpay = 14 ) TRANS_PREST_CONTAS
        ON TRANS_PREST_CONTAS.t$tdoc = PREST_CONTAS.TRANS
       AND TRANS_PREST_CONTAS.t$docn = PREST_CONTAS.DOCTO
       AND TRANS_PREST_CONTAS.TRANS != PREST_CONTAS.t$ttyp
       AND TRANS_PREST_CONTAS.DOCTO != PREST_CONTAS.t$ninv
 
 LEFT JOIN ( select a.t$user  USUARIO,
                    a.t$date  DT_ALT,
                    a.t$time  HR_ALT,
                    a.t$cono,
                    a.t$ttyp,
                    a.t$docn
              from  baandb.ttfgld102201 a
              where a.t$lino = 1 )  GLD102
        ON GLD102.t$cono = 201
       AND GLD102.t$ttyp = TRANS_PREST_CONTAS.t$tdoc
       AND GLD102.t$docn = TRANS_PREST_CONTAS.t$docn
       
 LEFT JOIN ( select a.t$user    USUARIO,
                    a.t$date    DT_ALT,
                    a.t$time    HR_ALT,
                    a.t$otyp,
                    a.t$odoc
               from baandb.ttfgld106201  a
              where a.t$olin = 1 )  GLD106
        ON GLD106.t$otyp = TRANS_PREST_CONTAS.t$tdoc
       AND GLD106.t$odoc = TRANS_PREST_CONTAS.t$docn
 
 LEFT JOIN ( select iDOMAIN.t$cnst CODE_MODAL, 
                    iLABEL.t$desc DESC_MODAL  
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'cmg.mopa.d'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE
        ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL
 
 LEFT JOIN ( select l.t$desc DESCR_TIPO_ACONSELHAMENTO,
                    d.t$cnst
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.tadv'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO
        ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv
 
 LEFT JOIN ( select iDOMAIN.t$cnst CODE, 
                    iLABEL.t$desc DESCR  
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'acp.tpay'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) TIPO_DOC
        ON TIPO_DOC.CODE = ADIANTAMENTO.TP_DOCTO
        
 LEFT JOIN ( select iDOMAIN.t$cnst CODE, 
                    iLABEL.t$desc    DESCR  
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'cmg.adty'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) CATEGORIA
        ON CATEGORIA.CODE = tfcmg101.t$adty
  
 LEFT JOIN ( select iDOMAIN.t$cnst   CODE, 
                    iLABEL.t$desc    DESCR  
               from baandb.tttadv401000 iDOMAIN, 
                    baandb.tttadv140000 iLABEL 
              where iDOMAIN.t$cpac = 'tf' 
                and iDOMAIN.t$cdom = 'acp.tpay'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4)) 
                                                 from baandb.tttadv401000 l1 
                                                where l1.t$cpac = iDOMAIN.t$cpac 
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4)) 
                                                from baandb.tttadv140000 l1 
                                               where l1.t$clab = iLABEL.t$clab 
                                                 and l1.t$clan = iLABEL.t$clan 
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) TIPO_DOCTO
        ON TIPO_DOCTO.CODE = PREST_CONTAS.TIPO_DOC
  
Where tfcmg101.t$tadv = 5   --Pagamento Adiantado
        
  and tfcmg101.t$plan Between :DataPlanejadoPagtoDe And :DataPlanejadoPagtoAte
  and tfcmg101.t$ifbp IN (:ParceiroNegocio)

  and ((Trim(:TransPConta) is null) OR (Concat(UPPER(TRANS_PREST_CONTAS.TRANS), TRANS_PREST_CONTAS.DOCTO) = UPPER(:TransPConta)))
  and ((Trim(:DoctoPagto) is null) OR (Concat(tfcmg101.t$ptyp, TO_CHAR(tfcmg101.t$pdoc)) = :DoctoPagto))
  

  =
"	SELECT  " &
"	  DISTINCT  " &
"		tfcmg101.t$btno               LOTE_PAGTO,   " &
"		tfcmg101.t$plan               DT_PLANEJADO_PAGTO,   " &
"		regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')   " &
"									  CNPJ_PN,  " &
"		tfcmg101.t$ifbp               COD_PN,   " &
"		Trim(tccom100.t$nama)         PARCEIRO_NEGOCIOS,  " &
"		tfcmg101.t$adty               COD_CATEGORIA,  " &
"		CATEGORIA.DESCR               DSC_CATEGORIA,  " &
"		ACONSELHAMENTO.               DESCR_TIPO_ACONSELHAMENTO,  " &
"		tfcmg002.t$desc               MOTIVO_PAGTO,   " &
"		tfcmg101.t$basu               CODE_CONTA_BANCO_PN,  " &
"		tccom125.t$brch               FILIAL_BANCARIA_BANCO_PN,   " &
"		tccom125.t$bano               CONTA_BANCARIA_BANCO_PN,  " &
"		tccom125.t$dacc$d             DIGITO_CONTA_BANCARIA_BANCO_PN,   " &
"		tfcmg101.t$paym               METODO_PAGTO,   " &
"		tfcmg001.t$desc               RELACAO_BANCARIA,   " &
"		tfcmg101.t$amnt               VALOR_ADIANTAMENTO,   " &
"		tfcmg101.t$ptyp ||  " &
"		TO_CHAR(tfcmg101.t$pdoc)      DOCUMENTO_PAGAMENTO,  " &
"		ADIANTAMENTO.                 DT_EMISSAO,   " &
"		ADIANTAMENTO.                 VL_ADIANTADO,   " &
"		ADIANTAMENTO.BALC -   " &
"		NVL(ADIANTAMENTO.BALA,0)      VL_ADIANTADO_SALDO,   " &
"		TIPO_DOC.DESCR                TIPO_DOCUMENTO,   " &
"		PREST_CONTAS.TRANS ||   " &
"		TO_CHAR(PREST_CONTAS.DOCTO)   LINK_ADIANTAMETNO,  " &
"		PREST_CONTAS.PN               COD_PN_PREST_CONTAS,  " &
"		tccom130pt.t$fovn$l           CNPJ_PN_PREST_CONTAS,   " &
"		tccom100pt.t$nama             PN_PREST_CONTAS,  " &
"		TRANS_PREST_CONTAS.TRANS ||   " &
"		TRANS_PREST_CONTAS.DOCTO      TRANS_PREST_CONTAS,   " &
"		PREST_CONTAS.TIPO_DOC         TIPO_DOC_PREST_CONTAS,  " &
"		TIPO_DOCTO.DESCR              DSC_TIPO_DOC_PREST_CONTAS,  " &
"		PREST_CONTAS.VALOR            VALOR_TRANS_PREST_CONTAS,   " &
"		PREST_CONTAS.BALC -   " &
"		NVL(PREST_CONTAS.BALA,0)      SALDO_TRANS_PREST_CONTAS,   " &
"		tfcmg101.t$refr               REFERENCIA,   " &
"		TRANS_PREST_CONTAS.DT_LINK    EMISSAO_LINK,   " &
"		tfgld011_LINK.t$desc          DESCRICAO_LINK,   " &
"   " &
"		CASE WHEN GLD102.USUARIO IS NULL  " &
"			   THEN GLD106.USUARIO  " &
"			 ELSE  GLD102.USUARIO   " &
"		 END                          ULT_MODIF,  " &
"		  " &
"		CASE WHEN GLD102.DT_ALT IS NULL   " &
"			   THEN GLD106.DT_ALT   " &
"			 ELSE  GLD102.DT_ALT  " &
"		 END                          DATA_ULT_MOD,   " &
"   " &
"		CASE WHEN TRIM(GLD102.HR_ALT) IS NULL AND TRIM(GLD106.HR_ALT) IS NOT NULL   " &
"			   THEN TO_CHAR(TRUNC(GLD106.HR_ALT/3600),'FM9900') || ':' ||   " &
"					TO_CHAR(TRUNC(MOD(GLD106.HR_ALT,3600)/60),'FM00') || ':' ||   " &
"					TO_CHAR(MOD(GLD106.HR_ALT,60),'FM00')   " &
"			 WHEN TRIM(GLD102.HR_ALT) IS NOT NULL   " &
"			   THEN TO_CHAR(TRUNC(GLD102.HR_ALT/3600),'FM9900') || ':' ||   " &
"					TO_CHAR(TRUNC(MOD(GLD102.HR_ALT,3600)/60),'FM00') || ':' ||   " &
"					TO_CHAR(MOD(GLD102.HR_ALT,60),'FM00')   " &
"			 ELSE NULL  " &
"		 END                          HORA_ULT_MOD  " &
"	  " &
"	FROM       baandb.ttccom100" + Parameters!Compania.Value +  "   tccom100  " &
"   " &
"	 LEFT JOIN baandb.ttccom130" + Parameters!Compania.Value +  "   tccom130  " &
"			ON tccom130.t$cadr = tccom100.t$cadr  " &
"	  " &
"	 LEFT JOIN baandb.ttfcmg101" + Parameters!Compania.Value +  "   tfcmg101  " &
"			ON tccom100.T$BPID = tfcmg101.t$ifbp  " &
"	  " &
"	 LEFT JOIN baandb.ttccom125" + Parameters!Compania.Value +  "   tccom125   " &
"			ON tccom125.t$ptbp = tfcmg101.t$ifbp  " &
"		   AND tccom125.t$cban = tfcmg101.t$basu  " &
"	  " &
"	 LEFT JOIN baandb.ttfcmg001" + Parameters!Compania.Value +  "   tfcmg001   " &
"			ON tfcmg001.t$bank = tfcmg101.t$bank  " &
"			  " &
"	 LEFT JOIN baandb.ttfcmg002301 tfcmg002   " &
"			ON tfcmg002.t$reas = tfcmg101.t$reas  " &
"	  " &
"	 LEFT JOIN ( select a.t$docd DT_EMISSAO,  " &
"						a.t$tpay TP_DOCTO,  " &
"						a.t$amnt VL_ADIANTADO,  " &
"						a.t$balc BALC,  " &
"						a.t$bala BALA,  " &
"						a.t$ttyp,   " &
"						a.t$ninv  " &
"				   from baandb.ttfacp200" + Parameters!Compania.Value +  "   a   " &
"				  where a.t$tpay = 9 ) ADIANTAMENTO   " &
"			ON ADIANTAMENTO.t$ttyp = tfcmg101.t$ptyp  " &
"		   AND ADIANTAMENTO.t$ninv = tfcmg101.t$pdoc  " &
"	  " &
"	 LEFT JOIN ( select a.t$tdoc TRANS,   " &
"						a.t$docn DOCTO,   " &
"						a.t$ifbp PN,  " &
"						a.t$tpay TIPO_DOC,  " &
"						a.t$amnt VALOR,   " &
"						a.t$balc BALC,  " &
"						a.t$bala BALA,  " &
"						a.t$ttyp,   " &
"						a.t$ninv  " &
"				   from baandb.ttfacp200" + Parameters!Compania.Value +  "   a   " &
"				  where a.t$tpay = 14   " &
"					and a.t$amnt != 0 ) PREST_CONTAS  " &
"			ON PREST_CONTAS.t$ttyp = tfcmg101.t$ptyp  " &
"		   AND PREST_CONTAS.t$ninv = tfcmg101.t$pdoc  " &
"		  " &
"	 LEFT JOIN baandb.ttfgld011" + Parameters!Compania.Value +  "   tfgld011_LINK  " &
"			ON tfgld011_LINK.t$ttyp = PREST_CONTAS.TRANS  " &
"	  " &
"	 LEFT JOIN baandb.ttccom100" + Parameters!Compania.Value +  "   tccom100pt   " &
"			ON tccom100pt.t$bpid = PREST_CONTAS.PN  " &
"			  " &
"	 LEFT JOIN baandb.ttccom130" + Parameters!Compania.Value +  "   tccom130pt   " &
"			ON tccom130pt.t$cadr = tccom100pt.t$cadr  " &
"	  " &
"	 LEFT JOIN ( select a.t$ttyp TRANS,   " &
"						a.t$ninv DOCTO,   " &
"						a.t$docd DT_LINK,   " &
"						a.t$tdoc,   " &
"						a.t$docn  " &
"				   from baandb.ttfacp200" + Parameters!Compania.Value +  "   a   " &
"				  where a.t$tpay = 14 ) TRANS_PREST_CONTAS  " &
"			ON TRANS_PREST_CONTAS.t$tdoc = PREST_CONTAS.TRANS   " &
"		   AND TRANS_PREST_CONTAS.t$docn = PREST_CONTAS.DOCTO   " &
"		   AND TRANS_PREST_CONTAS.TRANS != PREST_CONTAS.t$ttyp  " &
"		   AND TRANS_PREST_CONTAS.DOCTO != PREST_CONTAS.t$ninv  " &
"	  " &
"	 LEFT JOIN ( select a.t$user  USUARIO,  " &
"						a.t$date  DT_ALT,   " &
"						a.t$time  HR_ALT,   " &
"						a.t$cono,   " &
"						a.t$ttyp,   " &
"						a.t$docn  " &
"				  from  baandb.ttfgld102301   a   " &
"				  where a.t$lino = 1 )  GLD102  " &
"			ON GLD102.t$cono = 301  " &
"		   AND GLD102.t$ttyp = TRANS_PREST_CONTAS.t$tdoc  " &
"		   AND GLD102.t$docn = TRANS_PREST_CONTAS.t$docn  " &
"		  " &
"	 LEFT JOIN ( select a.t$user    USUARIO,  " &
"						a.t$date    DT_ALT,   " &
"						a.t$time    HR_ALT,   " &
"						a.t$otyp,   " &
"						a.t$odoc  " &
"				   from baandb.ttfgld106" + Parameters!Compania.Value +  "   a  " &
"				  where a.t$olin = 1 )  GLD106  " &
"			ON GLD106.t$otyp = TRANS_PREST_CONTAS.t$tdoc  " &
"		   AND GLD106.t$odoc = TRANS_PREST_CONTAS.t$docn  " &
"	  " &
"	 LEFT JOIN ( select iDOMAIN.t$cnst CODE_MODAL,  " &
"						iLABEL.t$desc DESC_MODAL  " &
"				   from baandb.tttadv401000 iDOMAIN,  " &
"						baandb.tttadv140000 iLABEL  " &
"				  where iDOMAIN.t$cpac = 'tf'   " &
"					and iDOMAIN.t$cdom = 'cmg.mopa.d'   " &
"					and iLABEL.t$clan = 'p'   " &
"					and iLABEL.t$cpac = 'tf'  " &
"					and iLABEL.t$clab = iDOMAIN.t$za_clab   " &
"					and rpad(iDOMAIN.t$vers,4) ||   " &
"						rpad(iDOMAIN.t$rele,2) ||   " &
"						rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"															  rpad(l1.t$rele,2) ||  " &
"															  rpad(l1.t$cust,4))  " &
"													 from baandb.tttadv401000 l1  " &
"													where l1.t$cpac = iDOMAIN.t$cpac  " &
"													  and l1.t$cdom = iDOMAIN.t$cdom )  " &
"					and rpad(iLABEL.t$vers,4) ||  " &
"						rpad(iLABEL.t$rele,2) ||  " &
"						rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   " &
"															 rpad(l1.t$rele,2) ||   " &
"															 rpad(l1.t$cust,4))   " &
"													from baandb.tttadv140000 l1   " &
"												   where l1.t$clab = iLABEL.t$clab  " &
"													 and l1.t$clan = iLABEL.t$clan  " &
"													 and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE   " &
"			ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL  " &
"	  " &
"	 LEFT JOIN ( select l.t$desc DESCR_TIPO_ACONSELHAMENTO,   " &
"						d.t$cnst  " &
"				   from baandb.tttadv401000 d,  " &
"						baandb.tttadv140000 l   " &
"				  where d.t$cpac = 'tf'   " &
"					and d.t$cdom = 'cmg.tadv'   " &
"					and l.t$clan = 'p'  " &
"					and l.t$cpac = 'tf'   " &
"					and l.t$clab = d.t$za_clab  " &
"					and rpad(d.t$vers,4) ||   " &
"						rpad(d.t$rele,2) ||   " &
"						rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"														rpad(l1.t$rele,2) ||  " &
"														rpad(l1.t$cust,4))  " &
"											   from baandb.tttadv401000 l1  " &
"											  where l1.t$cpac = d.t$cpac  " &
"												and l1.t$cdom = d.t$cdom )  " &
"					and rpad(l.t$vers,4) ||   " &
"						rpad(l.t$rele,2) ||   " &
"						rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"														rpad(l1.t$rele,2) ||  " &
"														rpad(l1.t$cust,4))  " &
"											   from baandb.tttadv140000 l1  " &
"											  where l1.t$clab = l.t$clab  " &
"												and l1.t$clan = l.t$clan  " &
"												and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO   " &
"			ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv  " &
"	  " &
"	 LEFT JOIN ( select iDOMAIN.t$cnst CODE,  " &
"						iLABEL.t$desc DESCR   " &
"				   from baandb.tttadv401000 iDOMAIN,  " &
"						baandb.tttadv140000 iLABEL  " &
"				  where iDOMAIN.t$cpac = 'tf'   " &
"					and iDOMAIN.t$cdom = 'acp.tpay'   " &
"					and iLABEL.t$clan = 'p'   " &
"					and iLABEL.t$cpac = 'tf'  " &
"					and iLABEL.t$clab = iDOMAIN.t$za_clab   " &
"					and rpad(iDOMAIN.t$vers,4) ||   " &
"						rpad(iDOMAIN.t$rele,2) ||   " &
"						rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"															  rpad(l1.t$rele,2) ||  " &
"															  rpad(l1.t$cust,4))  " &
"													 from baandb.tttadv401000 l1  " &
"													where l1.t$cpac = iDOMAIN.t$cpac  " &
"													  and l1.t$cdom = iDOMAIN.t$cdom )  " &
"					and rpad(iLABEL.t$vers,4) ||  " &
"						rpad(iLABEL.t$rele,2) ||  " &
"						rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   " &
"															 rpad(l1.t$rele,2) ||   " &
"															 rpad(l1.t$cust,4))   " &
"													from baandb.tttadv140000 l1   " &
"												   where l1.t$clab = iLABEL.t$clab  " &
"													 and l1.t$clan = iLABEL.t$clan  " &
"													 and l1.t$cpac = iLABEL.t$cpac ) ) TIPO_DOC   " &
"			ON TIPO_DOC.CODE = ADIANTAMENTO.TP_DOCTO  " &
"			  " &
"	 LEFT JOIN ( select iDOMAIN.t$cnst CODE,  " &
"						iLABEL.t$desc    DESCR  " &
"				   from baandb.tttadv401000 iDOMAIN,  " &
"						baandb.tttadv140000 iLABEL  " &
"				  where iDOMAIN.t$cpac = 'tf'   " &
"					and iDOMAIN.t$cdom = 'cmg.adty'   " &
"					and iLABEL.t$clan = 'p'   " &
"					and iLABEL.t$cpac = 'tf'  " &
"					and iLABEL.t$clab = iDOMAIN.t$za_clab   " &
"					and rpad(iDOMAIN.t$vers,4) ||   " &
"						rpad(iDOMAIN.t$rele,2) ||   " &
"						rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"															  rpad(l1.t$rele,2) ||  " &
"															  rpad(l1.t$cust,4))  " &
"													 from baandb.tttadv401000 l1  " &
"													where l1.t$cpac = iDOMAIN.t$cpac  " &
"													  and l1.t$cdom = iDOMAIN.t$cdom )  " &
"					and rpad(iLABEL.t$vers,4) ||  " &
"						rpad(iLABEL.t$rele,2) ||  " &
"						rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   " &
"															 rpad(l1.t$rele,2) ||   " &
"															 rpad(l1.t$cust,4))   " &
"													from baandb.tttadv140000 l1   " &
"												   where l1.t$clab = iLABEL.t$clab  " &
"													 and l1.t$clan = iLABEL.t$clan  " &
"													 and l1.t$cpac = iLABEL.t$cpac ) ) CATEGORIA  " &
"			ON CATEGORIA.CODE = tfcmg101.t$adty   " &
"	  " &
"	 LEFT JOIN ( select iDOMAIN.t$cnst   CODE,  " &
"						iLABEL.t$desc    DESCR  " &
"				   from baandb.tttadv401000 iDOMAIN,  " &
"						baandb.tttadv140000 iLABEL  " &
"				  where iDOMAIN.t$cpac = 'tf'   " &
"					and iDOMAIN.t$cdom = 'acp.tpay'   " &
"					and iLABEL.t$clan = 'p'   " &
"					and iLABEL.t$cpac = 'tf'  " &
"					and iLABEL.t$clab = iDOMAIN.t$za_clab   " &
"					and rpad(iDOMAIN.t$vers,4) ||   " &
"						rpad(iDOMAIN.t$rele,2) ||   " &
"						rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"															  rpad(l1.t$rele,2) ||  " &
"															  rpad(l1.t$cust,4))  " &
"													 from baandb.tttadv401000 l1  " &
"													where l1.t$cpac = iDOMAIN.t$cpac  " &
"													  and l1.t$cdom = iDOMAIN.t$cdom )  " &
"					and rpad(iLABEL.t$vers,4) ||  " &
"						rpad(iLABEL.t$rele,2) ||  " &
"						rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||   " &
"															 rpad(l1.t$rele,2) ||   " &
"															 rpad(l1.t$cust,4))   " &
"													from baandb.tttadv140000 l1   " &
"												   where l1.t$clab = iLABEL.t$clab  " &
"													 and l1.t$clan = iLABEL.t$clan  " &
"													 and l1.t$cpac = iLABEL.t$cpac ) ) TIPO_DOCTO   " &
"			ON TIPO_DOCTO.CODE = PREST_CONTAS.TIPO_DOC  " &
"	Where tfcmg101.t$tadv = 5  " &
"	  and tfcmg101.t$plan Between :DataPlanejadoPagtoDe And :DataPlanejadoPagtoAte  " &

"   AND ( (tfcmg101.t$ifbp IN  " &
"         ( " + IIF(Trim(Parameters!ParceiroNegocio.Value) = "", "''", "'" + Replace(Replace(Parameters!ParceiroNegocio.Value, " ", ""), ",", "','") + "'")  + " )  " &
"           AND (" + IIF(Parameters!ParceiroNegocio.Value Is Nothing, "1", "0") + " = 0))  " &
"            OR (" + IIF(Parameters!ParceiroNegocio.Value Is Nothing, "1", "0") + " = 1) ) " &

"	  and ((Trim(:TransPConta) is null) OR (Concat(UPPER(TRANS_PREST_CONTAS.TRANS), TRANS_PREST_CONTAS.DOCTO) = UPPER(:TransPConta))) "&
"	  and ((Trim(:DoctoPagto) is null) OR (Concat(tfcmg101.t$ptyp, TO_CHAR(tfcmg101.t$pdoc)) = :DoctoPagto))  "