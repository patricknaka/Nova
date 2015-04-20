SELECT
  TFACP200.T$DOCD            DT_EMISSAO_NFD,
  TFACP200.T$DUED            DT_VENCIMENTO_NFD,
  CISLI940.T$FIRE$L          REF_FISCAL_NFD,
  CISLI940.T$FDTC$L          COD_TIPO_DOC_FISCAL,
  TCMCS966.T$DSCA$L          DESCR_COD_DOC_FISCAL,
  CISLI951.T$SLSO$L          ORDEM_VENDA,
  CISLI940.T$FDTY$L          ID_TIPO_DOC_FISCAL,
  TP_DOCFIS.DSCA             DESCR_TIPO_DOC_FISCAL,
  ZNFMD001.T$FILI$C          FILIAL,
  TFACP200.T$IFBP            COD_PN,
  regexp_replace(TCCOM130.T$FOVN$L, '[^0-9]', '')
                             CNPJ,
  TCCOM100.T$NAMA            PN,
  TFACP200.T$TTYP            TRANSACAO,
  TFACP200.T$NINV            NUMERO_TRANSACAO,
  CISLI940.T$DOCN$L          NFD,
  CISLI940.T$SERI$L          SERIE_NFD,
  ST_PAGMT.DSCA              SITUACAO,
  TFACP200.T$BLOC            BLOQUEADO,
  TFACP200.T$AMNT            VL_TITULO_NFD,
  TFACP200.T$BALC            SALDO_TIT_NFD,
  CISLI951.T$RFIR$L          REF_FISCAL_ORIG,
  TFACP200o.T$TTYP  ||
  TFACP200o.T$NINV           TRANSAC_ORIG,  
  TDREC940.T$DOCN$L          NF_ORIG,
  TDREC940.T$SERI$L          SERIE_ORIG,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(TDREC940.T$DATE$L, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE) 
                             DT_EMISSAO_ORIG,
  TFACP200o.T$DUED           DT_VENCIMENTO_ORIG,
  TFACP200o.T$AMNT           VL_TITULO_ORIG,
  TFACP200o.T$BALC           SALDO_TIT_ORIG,
  ST_PAGMTo.DSCA             SITUACAO_NF_ORIG,
  
  CASE WHEN TFACP201o.T$PYST$L=3       
         THEN 'SIM'       
       ELSE   'NÃO'
   END                       PREP_PGTO_NF_ORIG,
  tfcmg101.t$plan            DT_PAGTO_NF_PAGTO,
  
  CASE WHEN tflcb230.t$send$d = 0 
         THEN NVL(iStatArq.DESCR,  'Arquivo não vinculado') 
       ELSE   NVL(iStatArq2.DESCR, 'Arquivo não vinculado') 
   END                       STATUS_PGTO_NF    

FROM       BAANDB.TTFACP200201 TFACP200

INNER JOIN BAANDB.TCISLI940201 CISLI940 
        ON CISLI940.T$SFCP$L = TFACP200.T$PCOM
       AND CISLI940.T$ITYP$L = TFACP200.T$TTYP
       AND CISLI940.T$IDOC$L = TFACP200.T$NINV
		   
INNER JOIN BAANDB.TTCMCS966201 TCMCS966 
        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L

INNER JOIN BAANDB.TTCMCS065201 TCMCS065 
        ON TCMCS065.T$CWOC  = CISLI940.T$COFC$L

INNER JOIN BAANDB.TTCCOM130201 TCCOM130F
        ON TCCOM130F.T$CADR = TCMCS065.T$CADR

INNER JOIN BAANDB.TZNFMD001201 ZNFMD001 
        ON ZNFMD001.T$FOVN$C = TCCOM130F.T$FOVN$L

INNER JOIN BAANDB.TTCCOM100201 TCCOM100 
        ON TCCOM100.T$BPID  = TFACP200.T$IFBP

INNER JOIN BAANDB.TTCCOM130201 TCCOM130 
        ON TCCOM130.T$CADR  = TCCOM100.T$CADR

INNER JOIN ( select A.T$TTYP,
                    A.T$NINV,
                    MAX(A.T$PYST$L) T$PYST$L
               from BAANDB.TTFACP201201 A
           group by A.T$TTYP,
                    A.T$NINV ) tfacp201
        ON tfacp201.T$TTYP  = TFACP200.T$TTYP
       AND tfacp201.T$NINV  = TFACP200.T$NINV

 LEFT JOIN ( select A.T$FIRE$L,
                    A.T$RFIR$L,
                    A.T$SLCP$L,
                    A.T$SLSO$L
               from BAANDB.TCISLI951201 A
           group by A.T$FIRE$L,
                    A.T$RFIR$L,
                    A.T$SLCP$L,
                    A.T$SLSO$L ) CISLI951 
        ON CISLI951.T$FIRE$L = CISLI940.T$FIRE$L
      
 LEFT JOIN BAANDB.TTDREC940201 TDREC940 
        ON TDREC940.T$FIRE$L = CISLI951.T$RFIR$L
		
 LEFT JOIN BAANDB.TTFACP200201 TFACP200o 
        ON TFACP200o.T$TTYP = TDREC940.T$TTYP$L
       AND TFACP200o.T$NINV = TDREC940.T$INVN$L

INNER JOIN ( select A.T$TTYP,
                    A.T$NINV,
                    MAX(A.T$PYST$L) T$PYST$L
               from BAANDB.TTFACP201201 A
           group by A.T$TTYP,
                    A.T$NINV ) TFACP201o 
        ON TFACP201o.T$TTYP = TFACP200o.T$TTYP
       AND TFACP201o.T$NINV = TFACP200o.T$NINV

 LEFT JOIN ( select a.t$ptyp$d,
                    a.t$docn$d,
                    a.t$ttyp$d, 
                    a.t$ninv$d,
                    a.t$lach$d,
                    max(a.t$stat$d) t$stat$d,
                    max(a.t$send$d) t$send$d
               from baandb.ttflcb230201 a
              where a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230201 b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d )
           group by a.t$ptyp$d,
                    a.t$docn$d,
                    a.t$ttyp$d, 
                    a.t$ninv$d, 
                    a.t$lach$d ) tflcb230
        ON tflcb230.t$ttyp$d = tfacp200o.t$ttyp
       AND tflcb230.t$ninv$d = tfacp200o.t$ninv

 LEFT JOIN baandb.ttfcmg101201 tfcmg101
        ON tfcmg101.t$ttyp = tfacp200o.t$ttyp
       AND tfcmg101.t$ninv = tfacp200o.t$ninv
       AND tfcmg101.t$ptyp = tflcb230.t$ptyp$d
       AND tfcmg101.t$pdoc = tflcb230.t$docn$d  
           
 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DSCA
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  TP_DOCFIS          
        ON TP_DOCFIS.CODE  = CISLI940.T$FDTY$L

 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DSCA
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'acp.pyst.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  ST_PAGMT
        ON ST_PAGMT.CODE  = TFACP201.T$PYST$L
             
 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DSCA
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'acp.pyst.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'tf'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) || 
                    rpad(d.t$rele,2) || 
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) || 
                    rpad(l.t$rele,2) || 
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) || 
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4) ) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) )  ST_PAGMTo
        ON ST_PAGMTo.CODE  = TFACP201o.T$PYST$L

 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DESCR
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.stat.l'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq
        ON iStatArq.CODE = tflcb230.t$stat$d
    
 LEFT JOIN ( select d.t$cnst CODE,
                    l.t$desc DESCR
               from baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              where d.t$cpac = 'tf'
                and d.t$cdom = 'cmg.stat.l'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq2
        ON iStatArq2.CODE = tflcb230.t$send$d
             
WHERE TFACP200.T$DOCN = 0
  AND TFACP200o.T$DOCN = 0

  AND TFACP200.T$DOCD Between :DataEmissaoNFD_De And :DataEmissaoNFD_Ate
  AND ZNFMD001.T$FILI$C IN (:Filial)
  AND TFACP200.T$IFBP IN (:ParceiroNegocio)
  AND TFACP201.T$PYST$L IN (:SituacaoNFD)
  AND TFACP200.T$TTYP IN (:Transacao)